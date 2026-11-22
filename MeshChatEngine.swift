import Foundation
import SwiftUI
import MultipeerConnectivity
import CoreBluetooth
import CryptoKit

// MARK: - 1. メッシュ通信パケット定義（TTLバケツリレー ＆ すれ違い再送対応）

struct MeshEnvelope: Codable, Equatable {
    let messageId: UUID
    let roomHash: String
    let encryptedPayload: String // AES-GCM 256bit 暗号化済みの ChatMessage JSON
    var ttl: Int                 // 残りホップ数（バケツリレー上限）
    let timestamp: TimeInterval
}

// MARK: - 2. 合言葉ベースのメッシュ用暗号化（AES-GCM 256bit）

enum MeshCrypto {
    static func deriveKey(from roomCode: String) -> SymmetricKey {
        let clean = roomCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let hash = SHA256.hash(data: Data(("TRV_E2EE_SALT_" + clean).utf8))
        return SymmetricKey(data: hash)
    }
    
    static func roomHash(from roomCode: String) -> String {
        let clean = roomCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let digest = SHA256.hash(data: Data(("TRV_ROOM_ID_" + clean).utf8))
        return digest.compactMap { String(format: "%02x", $0) }.joined().prefix(16).description
    }
    
    static func encrypt<T: Encodable>(_ value: T, roomCode: String) -> String? {
        guard let plainData = try? JSONEncoder().encode(value) else { return nil }
        let key = deriveKey(from: roomCode)
        guard let sealedBox = try? AES.GCM.seal(plainData, using: key),
              let combined = sealedBox.combined else { return nil }
        return combined.base64EncodedString()
    }
    
    static func decrypt<T: Decodable>(_ base64String: String, as type: T.Type, roomCode: String) -> T? {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        let key = deriveKey(from: roomCode)
        guard let sealedBox = try? AES.GCM.SealedBox(combined: data),
              let plainData = try? AES.GCM.open(sealedBox, using: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: plainData)
    }
}

// MARK: - 3. ハイブリッド・メッシュ通信エンジン（フォアグラウンドMultipeer ＋ バックグラウンドBLE対応）

@MainActor
class HybridMeshCoordinator: NSObject, ObservableObject {
    static let shared = HybridMeshCoordinator()
    
    static let defaultHopTTL: Int = 5
    
    // バックグラウンドBLE用の固定UUID（同じTravelum同士のみをバックグラウンドで検知）
    nonisolated private static let bleServiceUUID = CBUUID(string: "7A4B1C2D-8E9F-4A1B-9C2D-3E4F5A6B7C8D")
    nonisolated private static let bleCharacteristicUUID = CBUUID(string: "8B5C2D3E-9F0A-4B2C-8D3E-4F5A6B7C8D9E")
    
    @Published var isMeshEnabled: Bool = true
    @Published var connectedPeersCount: Int = 0
    @Published var connectedPeerNames: [String] = []
    @Published var meshDeliveredIds: Set<UUID> = []
    
    // MultipeerConnectivity（フォアグラウンド高速通信用）
    private let serviceType = "trv-mesh-chat"
    private var myPeerID: MCPeerID!
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    private var browser: MCNearbyServiceBrowser!
    
    // CoreBluetooth（バックグラウンド＆初回権限リクエスト用）
    private var centralManager: CBCentralManager?
    private var peripheralManager: CBPeripheralManager?
    private var bleTransferCharacteristic: CBMutableCharacteristic?
    private var discoveredPeripherals: [UUID: CBPeripheral] = [:]
    private var connectedBLEPeripherals: Set<CBPeripheral> = []
    private var subscribedCentrals: [CBCentral] = []
    
    private var activeRoomCode: String = ""
    private var seenEnvelopeIds: Set<UUID> = []
    private var storeAndForwardBuffer: [MeshEnvelope] = []
    private var hasTriggeredInitialPermissions = false
    
    var onMessageReceivedFromMesh: ((ChatMessage) -> Void)?
    
    override init() {
        super.init()
        let deviceName = UIDevice.current.name
        let cleanName = deviceName.isEmpty ? "Traveler" : String(deviceName.prefix(20))
        self.myPeerID = MCPeerID(displayName: "\(cleanName)-\(Int.random(in: 100...999))")
        setupMultipeerSession()
    }
    
    private func setupMultipeerSession() {
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser.delegate = self
    }
    
    /// アプリ初回起動時に Bluetooth と ローカルネットワーク の許可ダイアログを自動表示させる
    func requestPermissionsOnLaunch() {
        guard !hasTriggeredInitialPermissions else { return }
        hasTriggeredInitialPermissions = true
        
        // 1. Bluetooth許可ダイアログのトリガー
        setupCoreBluetoothIfNeeded()
        
        // 2. ローカルネットワーク許可ダイアログのトリガー（短時間だけ探索を開始）
        if activeRoomCode.isEmpty {
            browser.startBrowsingForPeers()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self, self.activeRoomCode.isEmpty else { return }
                self.browser.stopBrowsingForPeers()
            }
        }
    }
    
    private func setupCoreBluetoothIfNeeded() {
        if centralManager == nil {
            centralManager = CBCentralManager(
                delegate: self,
                queue: nil,
                options: [
                    CBCentralManagerOptionShowPowerAlertKey: true,
                    CBCentralManagerOptionRestoreIdentifierKey: "com.travelum.mesh.central"
                ]
            )
        }
        if peripheralManager == nil {
            peripheralManager = CBPeripheralManager(
                delegate: self,
                queue: nil,
                options: [
                    CBPeripheralManagerOptionShowPowerAlertKey: true,
                    CBPeripheralManagerOptionRestoreIdentifierKey: "com.travelum.mesh.peripheral"
                ]
            )
        }
    }
    
    func startMesh(roomCode: String) {
        self.activeRoomCode = roomCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard isMeshEnabled, !activeRoomCode.isEmpty else { return }
        
        // 1. フォアグラウンド用 MultipeerConnectivity を開始
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
        
        // 2. バックグラウンド対応 CoreBluetooth (BLE) を開始
        setupCoreBluetoothIfNeeded()
        startBLEIfPoweredOn()
    }
    
    func stopMesh() {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
        session.disconnect()
        
        centralManager?.stopScan()
        peripheralManager?.stopAdvertising()
        for p in connectedBLEPeripherals {
            centralManager?.cancelPeripheralConnection(p)
        }
        connectedBLEPeripherals.removeAll()
        discoveredPeripherals.removeAll()
        subscribedCentrals.removeAll()
        updateConnectedCount()
    }
    
    func toggleMesh(_ enabled: Bool, roomCode: String) {
        isMeshEnabled = enabled
        if enabled {
            startMesh(roomCode: roomCode)
        } else {
            stopMesh()
        }
    }
    
    private func startBLEIfPoweredOn() {
        guard isMeshEnabled, !activeRoomCode.isEmpty else { return }
        
        if centralManager?.state == .poweredOn {
            centralManager?.scanForPeripherals(
                withServices: [Self.bleServiceUUID],
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: false]
            )
        }
        if peripheralManager?.state == .poweredOn {
            setupBLEServiceIfNeeded()
            if peripheralManager?.isAdvertising == false {
                peripheralManager?.startAdvertising([
                    CBAdvertisementDataServiceUUIDsKey: [Self.bleServiceUUID],
                    CBAdvertisementDataLocalNameKey: "Travelum"
                ])
            }
        }
    }
    
    private func setupBLEServiceIfNeeded() {
        guard bleTransferCharacteristic == nil, let pm = peripheralManager else { return }
        let characteristic = CBMutableCharacteristic(
            type: Self.bleCharacteristicUUID,
            properties: [.write, .writeWithoutResponse, .notify],
            value: nil,
            permissions: [.writeable, .readable]
        )
        let service = CBMutableService(type: Self.bleServiceUUID, primary: true)
        service.characteristics = [characteristic]
        pm.add(service)
        self.bleTransferCharacteristic = characteristic
    }
    
    private func updateConnectedCount() {
        let mcCount = session.connectedPeers.count
        let bleCount = max(connectedBLEPeripherals.count, subscribedCentrals.count)
        self.connectedPeersCount = max(mcCount, bleCount)
        self.connectedPeerNames = session.connectedPeers.map { $0.displayName }
    }
    
    // MARK: - 送信処理（Multipeer ＋ バックグラウンドBLEの両方へ配信）
    
    @discardableResult
    func broadcastMessageViaMesh(_ msg: ChatMessage) -> Bool {
        guard isMeshEnabled else { return false }
        seenEnvelopeIds.insert(msg.id)
        
        guard let encrypted = MeshCrypto.encrypt(msg, roomCode: msg.roomCode) else { return false }
        let envelope = MeshEnvelope(
            messageId: msg.id,
            roomHash: MeshCrypto.roomHash(from: msg.roomCode),
            encryptedPayload: encrypted,
            ttl: Self.defaultHopTTL,
            timestamp: Date().timeIntervalSince1970
        )
        appendStoreAndForward(envelope)
        
        let sentMC = broadcastEnvelopeViaMultipeer(envelope)
        let sentBLE = broadcastEnvelopeViaBLE(envelope)
        
        if sentMC || sentBLE {
            meshDeliveredIds.insert(msg.id)
            return true
        }
        return false
    }
    
    private func appendStoreAndForward(_ envelope: MeshEnvelope) {
        storeAndForwardBuffer.removeAll { $0.messageId == envelope.messageId }
        storeAndForwardBuffer.append(envelope)
        if storeAndForwardBuffer.count > 50 {
            storeAndForwardBuffer.removeFirst(storeAndForwardBuffer.count - 50)
        }
    }
    
    @discardableResult
    private func broadcastEnvelopeViaMultipeer(_ envelope: MeshEnvelope, excluding excludedPeer: MCPeerID? = nil) -> Bool {
        let targets = session.connectedPeers.filter { $0 != excludedPeer }
        guard !targets.isEmpty,
              let data = try? JSONEncoder().encode(envelope) else { return false }
        do {
            try session.send(data, toPeers: targets, with: .reliable)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    private func broadcastEnvelopeViaBLE(_ envelope: MeshEnvelope) -> Bool {
        guard let data = try? JSONEncoder().encode(envelope) else { return false }
        var sentAny = false
        
        // Peripheral側（購読中のCentralへNotify送信）
        if let char = bleTransferCharacteristic, !subscribedCentrals.isEmpty,
           let pm = peripheralManager, pm.state == .poweredOn {
            if pm.updateValue(data, for: char, onSubscribedCentrals: nil) {
                sentAny = true
            }
        }
        
        // Central側（接続中のPeripheralへWrite送信）
        for peripheral in connectedBLEPeripherals {
            if let services = peripheral.services {
                for service in services where service.uuid == Self.bleServiceUUID {
                    if let chars = service.characteristics {
                        for char in chars where char.uuid == Self.bleCharacteristicUUID {
                            peripheral.writeValue(data, for: char, type: .withResponse)
                            sentAny = true
                        }
                    }
                }
            }
        }
        return sentAny
    }
    
    private func handleIncomingEnvelope(_ envelope: MeshEnvelope, excludingMCPeer: MCPeerID? = nil) {
        guard !seenEnvelopeIds.contains(envelope.messageId) else { return }
        seenEnvelopeIds.insert(envelope.messageId)
        
        let myRoomHash = MeshCrypto.roomHash(from: activeRoomCode)
        if envelope.roomHash == myRoomHash,
           let decryptedMsg = MeshCrypto.decrypt(envelope.encryptedPayload, as: ChatMessage.self, roomCode: activeRoomCode) {
            meshDeliveredIds.insert(decryptedMsg.id)
            onMessageReceivedFromMesh?(decryptedMsg)
        }
        
        // マルチホップ中継（TTLが残っていれば再転送）
        if envelope.ttl > 1 {
            var relayed = envelope
            relayed.ttl -= 1
            appendStoreAndForward(relayed)
            broadcastEnvelopeViaMultipeer(relayed, excluding: excludingMCPeer)
            broadcastEnvelopeViaBLE(relayed)
        }
    }
}

// MARK: - 4. MultipeerConnectivity デリゲート（フォアグラウンド高速中継）

extension HybridMeshCoordinator: MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    nonisolated func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        Task { @MainActor in
            self.updateConnectedCount()
            if state == .connected {
                for env in self.storeAndForwardBuffer {
                    if let data = try? JSONEncoder().encode(env),
                       (try? session.send(data, toPeers: [peerID], with: .reliable)) != nil {
                        self.meshDeliveredIds.insert(env.messageId)
                    }
                }
            }
        }
    }
    
    nonisolated func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let envelope = try? JSONDecoder().decode(MeshEnvelope.self, from: data) else { return }
        Task { @MainActor in
            self.handleIncomingEnvelope(envelope, excludingMCPeer: peerID)
        }
    }
    
    nonisolated func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    nonisolated func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    nonisolated func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    
    nonisolated func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        Task { @MainActor in
            invitationHandler(true, self.session)
        }
    }
    
    nonisolated func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {}
    
    nonisolated func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        Task { @MainActor in
            browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
        }
    }
    
    nonisolated func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
    nonisolated func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {}
}

// MARK: - 5. CoreBluetooth デリゲート（バックグラウンドBLE送受信＆状態復元）

extension HybridMeshCoordinator: CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate {
    nonisolated func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Task { @MainActor in
            if central.state == .poweredOn {
                self.startBLEIfPoweredOn()
            }
        }
    }
    
    nonisolated func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        // バックグラウンドからのOS自動復帰時に接続中ペリフェラルを復元
        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
            Task { @MainActor in
                for p in peripherals {
                    p.delegate = self
                    self.connectedBLEPeripherals.insert(p)
                }
                self.updateConnectedCount()
            }
        }
    }
    
    nonisolated func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        Task { @MainActor in
            guard self.isMeshEnabled else { return }
            self.discoveredPeripherals[peripheral.identifier] = peripheral
            peripheral.delegate = self
            central.connect(peripheral, options: nil)
        }
    }
    
    nonisolated func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Task { @MainActor in
            self.connectedBLEPeripherals.insert(peripheral)
            self.updateConnectedCount()
            peripheral.discoverServices([Self.bleServiceUUID])
        }
    }
    
    nonisolated func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Task { @MainActor in
            self.connectedBLEPeripherals.remove(peripheral)
            self.updateConnectedCount()
        }
    }
    
    nonisolated func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == Self.bleServiceUUID {
            peripheral.discoverCharacteristics([Self.bleCharacteristicUUID], for: service)
        }
    }
    
    nonisolated func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let chars = service.characteristics else { return }
        for char in chars where char.uuid == Self.bleCharacteristicUUID {
            peripheral.setNotifyValue(true, for: char)
            Task { @MainActor in
                // すれ違い接続時に一時預かりバッファをBLE経由で流し込む
                for env in self.storeAndForwardBuffer {
                    if let data = try? JSONEncoder().encode(env) {
                        peripheral.writeValue(data, for: char, type: .withResponse)
                        self.meshDeliveredIds.insert(env.messageId)
                    }
                }
            }
        }
    }
    
    nonisolated func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value,
              let envelope = try? JSONDecoder().decode(MeshEnvelope.self, from: data) else { return }
        Task { @MainActor in
            self.handleIncomingEnvelope(envelope)
        }
    }
    
    nonisolated func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        Task { @MainActor in
            if peripheral.state == .poweredOn {
                self.startBLEIfPoweredOn()
            }
        }
    }
    
    nonisolated func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any]) {}
    
    nonisolated func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        Task { @MainActor in
            if !self.subscribedCentrals.contains(where: { $0.identifier == central.identifier }) {
                self.subscribedCentrals.append(central)
            }
            self.updateConnectedCount()
            // 購読開始した相手へバッファ内のメッセージを配信
            for env in self.storeAndForwardBuffer {
                if let data = try? JSONEncoder().encode(env) {
                    _ = peripheral.updateValue(data, for: self.bleTransferCharacteristic!, onSubscribedCentrals: [central])
                    self.meshDeliveredIds.insert(env.messageId)
                }
            }
        }
    }
    
    nonisolated func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        Task { @MainActor in
            self.subscribedCentrals.removeAll { $0.identifier == central.identifier }
            self.updateConnectedCount()
        }
    }
    
    nonisolated func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for req in requests {
            if let data = req.value,
               let envelope = try? JSONDecoder().decode(MeshEnvelope.self, from: data) {
                Task { @MainActor in
                    self.handleIncomingEnvelope(envelope)
                }
            }
            peripheral.respond(to: req, withResult: .success)
        }
    }
}

