import SwiftUI
import UserNotifications
import MapKit

// MARK: - 0. 多言語ローカライズ（日本語・英語・イタリア語・スペイン語・ドイツ語 完全対応）

enum AppLanguage: String, CaseIterable, Identifiable {
    case ja = "日本語"
    case en = "English"
    case it = "Italiano"
    case es = "Español"
    case de = "Deutsch"
    
    var id: String { self.rawValue }
}

struct L10n {
    let lang: AppLanguage
    
    func text(_ ja: String, _ en: String, _ it: String, _ es: String, _ de: String) -> String {
        switch lang {
        case .ja: return ja
        case .en: return en
        case .it: return it
        case .es: return es
        case .de: return de
        }
    }
    
    // オンボーディング
    var appTitle: String { text("みんなで旅しおり", "Travelum", "Travelum", "Travelum", "Travelum") }
    var appSubtitle: String {
        text("合言葉だけで家族や友人と安全・リアルタイムに旅行計画を作れるアプリです。",
             "Plan trips safely in real-time with family and friends using a shared room code.",
             "Pianifica viaggi in sicurezza e in tempo reale con amici e famiglia usando un codice stanza.",
             "Planifica viajes de forma segura y en tiempo real con familiares y amigos usando un código.",
             "Plane Reisen sicher und in Echtzeit mit Familie und Freunden über einen gemeinsamen Raumcode.")
    }
    var nicknameLabel: String {
        text("1. あなたの呼び名（ニックネーム）", "1. Your Nickname", "1. Il tuo nickname", "1. Tu apodo", "1. Dein Spitzname")
    }
    var nicknamePlaceholder: String {
        text("例：お母さん、たろう", "e.g., Mom, Alex", "es. Mamma, Marco", "ej. Mamá, Carlos", "z.B. Mama, Lukas")
    }
    var roomCodeLabel: String {
        text("2. 旅行ルームの合言葉", "2. Trip Room Code", "2. Codice stanza", "2. Código de sala", "2. Reise-Raumcode")
    }
    var roomCodePlaceholder: String {
        text("招待された合言葉、または新規入力", "Enter invited or new code", "Inserisci codice", "Ingresa el código", "Code eingeben")
    }
    var generateCodeBtn: String {
        text("安全な合言葉を自動生成", "Generate Secure Code", "Genera codice sicuro", "Generar código seguro", "Sicheren Code generieren")
    }
    var copyBtn: String { text("コピー", "Copy", "Copia", "Copiar", "Kopieren") }
    var copiedBtn: String { text("コピー済", "Copied", "Copiato", "Copiado", "Kopiert") }
    var shareBtn: String { text("共有", "Share", "Condividi", "Compartir", "Teilen") }
    var roomCodeHint: String {
        text("※他人のルームとの重複を防ぐため、新規作成時は「自動生成」がおすすめです。最初の作成者が「👑 リーダー」になります。",
             "* Use 'Generate Secure Code' when creating a new room. The first creator becomes the 👑 Leader.",
             "* Usa 'Genera codice sicuro' per creare una nuova stanza. Il primo creatore diventa 👑 Leader.",
             "* Usa 'Generar código seguro' al crear una nueva sala. El primer creador será el 👑 Líder.",
             "* Nutze 'Sicheren Code generieren' für neue Räume. Der Ersteller wird automatisch 👑 Leader.")
    }
    var termsAgreeToggle: String {
        text("利用規約およびプライバシーポリシーに同意する（不適切な投稿の禁止・通報およびブロック機能への同意）",
             "I agree to the Terms of Use & Privacy Policy (Zero tolerance for objectionable content, reporting & blocking)",
             "Accetto i Termini d'Uso e la Privacy Policy (Divieto di contenuti inappropriati, segnalazione e blocco)",
             "Acepto los Términos de Uso y Política de Privacidad (Prohibición de contenido inapropiado, reporte y bloqueo)",
             "Ich stimme den Nutzungsbedingungen & Datenschutzrichtlinien zu (Verbot ungeeigneter Inhalte, Melden & Blockieren)")
    }
    var termsReadLink: String {
        text("利用規約・プライバシーポリシーを読む", "Read Terms & Privacy Policy", "Leggi Termini e Privacy", "Leer Términos y Privacidad", "AGB & Datenschutz lesen")
    }
    var joinRoomBtn: String {
        text("旅行ルームに参加する", "Join Trip Room", "Entra nella stanza", "Unirse a la sala", "Reiseraum beitreten")
    }
    
    // タブ・共通
    var tabWishlist: String { text("行きたい！", "Wishlist", "Desideri", "Deseos", "Wünsche") }
    var tabItinerary: String { text("旅程表", "Itinerary", "Itinerario", "Itinerario", "Reiseplan") }
    var tabBudget: String { text("旅費・割り勘", "Budget", "Spese", "Gastos", "Budget") }
    var tabChat: String { text("連絡チャット", "Chat", "Chat", "Chat", "Chat") }
    var settingsBtn: String { text("ルーム設定", "Settings", "Impostazioni", "Ajustes", "Optionen") }
    var addBtn: String { text("追加する", "Add", "Aggiungi", "Añadir", "Hinzufügen") }
    var cancelBtn: String { text("キャンセル", "Cancel", "Annulla", "Cancelar", "Abbrechen") }
    var saveBtn: String { text("保存", "Save", "Salva", "Guardar", "Speichern") }
    var closeBtn: String { text("閉じる", "Close", "Chiudi", "Cerrar", "Schließen") }
    var deleteBtn: String { text("削除", "Delete", "Elimina", "Eliminar", "Löschen") }
    var detailEditBtn: String { text("詳細・編集", "Details / Edit", "Dettagli / Modifica", "Detalles / Editar", "Details / Bearbeiten") }
    var duplicateBtn: String { text("この予定を複製して追加", "Duplicate Item", "Duplica elemento", "Duplicar elemento", "Eintrag duplizieren") }
    var supportLinkLabel: String { text("サポートページを開く", "Open Support Page", "Apri pagina di supporto", "Abrir página de soporte", "Support-Seite öffnen") }
    
    // タイムゾーン・夏時間（DST）用テキスト
    var timeZonePickerLabel: String { text("タイムゾーン（現地時間）", "Time Zone", "Fuso orario", "Zona horaria", "Zeitzone") }
    var deviceDefaultTZLabel: String { text("端末の標準設定", "Device Default", "Predefinito dispositivo", "Predeterminado", "Gerätestandard") }
    var dstActiveBadge: String { text("夏時間(DST)適用中", "DST Active", "Ora legale attiva", "Horario de verano", "Sommerzeit aktiv") }
    var dstAutoHint: String {
        text("※夏時間（サマータイム）のある地域は、旅行開始日と日程から自動判定されます。",
             "* Daylight Saving Time (DST) is automatically adjusted when a trip start date is set.",
             "* L'ora legale viene calcolata automaticamente in base alla data del viaggio.",
             "* El horario de verano (DST) se ajusta automáticamente según la fecha del viaje.",
             "* Sommerzeit (DST) wird bei festgelegtem Reisedatum automatisch berücksichtigt.")
    }
    
    // チャット通信方式（2種類）＆ 送達確認（2値）バッジ用テキスト
    var meshToggleLabel: String {
        text("Bluetooth / Wi-Fi メッシュ中継チャットを有効化",
             "Enable Bluetooth / Wi-Fi Mesh Relay Chat",
             "Attiva Chat Mesh Bluetooth / Wi-Fi",
             "Activar Chat Mesh Bluetooth / Wi-Fi",
             "Bluetooth / Wi-Fi Mesh-Chat aktivieren")
    }
    func meshStatusText(_ peers: Int) -> String {
        if peers > 0 {
            return text("Mesh接続中 (\(peers)台) • 近距離P2P暗号化＋通常ネット同期",
                        "Mesh Active (\(peers) peers) • P2P Encrypted + Net Sync",
                        "Mesh Attivo (\(peers) dispositivi) • P2P + Sync Rete",
                        "Mesh Activo (\(peers) dispositivos) • P2P + Sincronización",
                        "Mesh Aktiv (\(peers) Geräte) • P2P + Netz-Sync")
        } else {
            return text("Mesh待機中（周囲の端末を探索中 • 通常ネット同期に対応）",
                        "Mesh Standby (Scanning nearby • Standard Net sync ready)",
                        "Mesh in attesa (Ricerca vicini • Sync Rete pronto)",
                        "Mesh en espera (Buscando cercanos • Red lista)",
                        "Mesh Standby (Suche in der Nähe • Netz-Sync bereit)")
        }
    }
    var badgeMethodMesh: String { text("Mesh", "Mesh", "Mesh", "Mesh", "Mesh") }
    var badgeMethodNet: String { text("Net", "Net", "Net", "Net", "Net") }
    var badgeStatusSent: String { text("送信済", "Sent", "Inviato", "Enviado", "Gesendet") }
    var badgeStatusPending: String { text("送信待ち", "Pending", "In attesa", "Pendiente", "Ausstehend") }
    
    // 移動ルート自動サジェスト用テキスト（電車・バス・タクシー・自転車・徒歩）
    func suggestTransitBetween(_ from: String, _ to: String) -> String {
        text("「\(from)」→「\(to)」の移動を提案（電車・車・自転車・徒歩）",
             "Suggest Transit: \(from) → \(to)",
             "Suggerisci spostamento: \(from) → \(to)",
             "Sugerir traslado: \(from) → \(to)",
             "Transfer: \(from) → \(to)")
    }
    var suggestTransitBtn: String { text("移動を提案（電車・車・自転車・徒歩）", "Suggest Transit (Train / Car / Bike / Walk)", "Suggerisci spostamento", "Sugerir traslado", "Transfer vorschlagen") }
    var transitSheetTitle: String { text("移動ルートの自動提案", "Smart Transit Suggestion", "Suggerimento percorso", "Sugerencia de ruta", "Routenvorschlag") }
    var calculatingRouteMsg: String { text("場所を検索し、電車・車・自転車・徒歩の所要時間を計算中...", "Finding places & calculating train, car, bike & walk times...", "Ricerca luoghi e calcolo tempi...", "Buscando lugares y calculando tiempo...", "Orte suchen & Fahrzeiten berechnen...") }
    var transitOptionTitle: String { text("電車・バスで移動", "By Train / Bus", "In Treno / Bus", "En Tren / Bus", "Mit Bahn / Bus") }
    var taxiOptionTitle: String { text("タクシー（車）で移動", "By Taxi / Car", "In Taxi / Auto", "En Taxi / Coche", "Mit Taxi / Auto") }
    var bikeOptionTitle: String { text("自転車で移動", "By Bicycle", "In Bicicletta", "En Bicicleta", "Mit dem Fahrrad") }
    var walkOptionTitle: String { text("徒歩で移動", "On Foot (Walk)", "A piedi", "A pie", "Zu Fuß") }
    var recommendedBadge: String { text("おすすめ", "Recommended", "Consigliato", "Recomendado", "Empfohlen") }
    var addTransitToPlanBtn: String { text("この移動を旅程表に追加する", "Add Transit to Itinerary", "Aggiungi all'itinerario", "Añadir al itinerario", "Zum Reiseplan hinzufügen") }
    var openRouteInGoogleMaps: String { text("設定時刻でGoogleマップ経路を開く", "Open Route in Google Maps (Scheduled Time)", "Vedi percorso su Google Maps", "Ver ruta en Google Maps", "Route in Google Maps öffnen") }
    var openRouteInAppleMaps: String { text("Appleマップで経路を開く", "Open Route in Apple Maps", "Apri percorso in Mappe Apple", "Abrir ruta en Mapas de Apple", "Route in Apple Karten öffnen") }
    var searchByDepartureMode: String { text("前の予定の時刻に出発", "Depart at Origin Time", "Partenza all'ora di inizio", "Salir a la hora de inicio", "Abfahrt zur Startzeit") }
    var searchByArrivalMode: String { text("次の予定の時刻に到着", "Arrive by Next Plan Time", "Arrivo entro il prossimo piano", "Llegar a la siguiente hora", "Ankunft zur nächsten Zeit") }
    var copyTimeBtn: String { text("日時をコピー", "Copy Time", "Copia ora", "Copiar hora", "Zeit kopieren") }
    var routeNotFoundMsg: String {
        text("片方または両方の場所の位置を特定できませんでした。下のボタンから直接Googleマップで経路を検索できます。",
             "Could not auto-calculate distance, but you can open the route directly in Google Maps below.",
             "Impossibile calcolare la distanza, ma puoi aprire il percorso su Google Maps qui sotto.",
             "No se pudo calcular la distancia, pero puedes abrir la ruta en Google Maps abajo.",
             "Distanz konnte nicht berechnet werden. Öffne die Route unten direkt in Google Maps.")
    }
    func minutesDuration(_ mins: Int) -> String {
        text("約\(mins)分", "~\(mins) min", "~\(mins) min", "~\(mins) min", "ca. \(mins) Min.")
    }
    func departAtLabel(_ depart: String, _ arrive: String) -> String {
        text("\(depart) 出発 → \(arrive) 頃着", "Depart \(depart) → Arrive ~\(arrive)", "Partenza \(depart) → Arrivo ~\(arrive)", "Salida \(depart) → Llegada ~\(arrive)", "Abfahrt \(depart) → Ankunft ~\(arrive)")
    }
    
    // 通知・ウィジェット設定
    var notifWidgetSec: String { text("通知（チャット・メンバー変動）＆ ウィジェット", "Notifications (Chat & Members) & Widget", "Notifiche e Widget", "Notificaciones y Widget", "Mitteilungen & Widget") }
    var chatNotifToggle: String { text("チャット新着・メンバー参加/退出の通知とバッジ", "Chat & Member Join/Leave Alerts & Badge", "Avvisi chat e ingresso/uscita membri", "Alertas de chat y miembros", "Chat- & Mitglieder-Mitteilungen") }
    var chatNotifHint: String {
        text("ONにすると、新着チャットやメンバーのルーム参加・退出/削除があった時に通知し、未読バッジを表示します。",
             "When ON, alerts trigger for new chat messages and when members join or leave/are removed from the room.",
             "Se attivo, invia notifiche per nuovi messaggi e quando i membri entrano o escono dalla stanza.",
             "Si está activo, notifica nuevos mensajes y cuando un miembro entra o sale de la sala.",
             "Wenn aktiv, wirst du bei neuen Nachrichten sowie beim Beitreten/Verlassen von Mitgliedern benachrichtigt.")
    }
    var showNextWidgetToggle: String { text("旅程表の上部に「NEXT予定ウィジェット」を表示", "Show 'Next Up Widget' on Itinerary", "Mostra 'Widget Prossimo Piano'", "Mostrar 'Widget Próximo Plan'", "'Nächster-Plan-Widget' anzeigen") }
    var nextUpBadge: String { text("NEXT 次の予定", "NEXT UP", "PROSSIMO", "PRÓXIMO", "ALS NÄCHSTES") }
    func newChatNotificationTitle(_ room: String) -> String {
        text("[\(room)] 新着チャット", "[\(room)] New Chat", "[\(room)] Nuovo messaggio", "[\(room)] Nuevo mensaje", "[\(room)] Neue Nachricht")
    }
    func memberEventNotificationTitle(_ room: String) -> String {
        text("[\(room)] メンバー更新", "[\(room)] Member Update", "[\(room)] Aggiornamento membri", "[\(room)] Actualización de miembros", "[\(room)] Mitglieder-Update")
    }
    func memberJoinedBody(_ name: String) -> String {
        text("\(name) さんが旅行ルームに参加しました！",
             "\(name) joined the trip room!",
             "\(name) è entrato nella stanza!",
             "¡\(name) se unió a la sala de viaje!",
             "\(name) ist dem Reiseraum beigetreten!")
    }
    func memberLeftBody(_ name: String) -> String {
        text("\(name) さんが旅行ルームから退出（または削除）されました。",
             "\(name) left (or was removed from) the trip room.",
             "\(name) ha lasciato (o è stato rimosso da) la stanza.",
             "\(name) salió (o fue eliminado) de la sala de viaje.",
             "\(name) hat den Reiseraum verlassen (oder wurde entfernt).")
    }
    
    // ステータス・権限
    var statusOpen: String { text("参加受付中", "Open", "Aperto", "Abierto", "Offen") }
    var statusLocked: String { text("参加ロック中", "Locked", "Bloccato", "Bloqueado", "Gesperrt") }
    var roomLockedError: String {
        text("このルームは現在リーダーによって新規メンバーの参加受付が締め切られています。",
             "This room is currently locked by the leader and not accepting new members.",
             "Questa stanza è bloccata dal leader e non accetta nuovi membri.",
             "Esta sala está bloqueada por el líder y no acepta nuevos miembros.",
             "Dieser Raum ist vom Leader gesperrt und nimmt keine neuen Mitglieder auf.")
    }
    
    // 行きたいリスト画面・並び替え
    var sortNewest: String { text("追加順", "Newest", "Recenti", "Recientes", "Neueste") }
    var sortSchedule: String { text("日程・時刻順", "Date & Time", "Data e Ora", "Fecha y Hora", "Datum & Zeit") }
    var sortLikes: String { text("いいね順", "Most Liked", "Più votati", "Más votados", "Beliebteste") }
    var sortUnscheduledOnly: String { text("未定のみ", "Unscheduled", "Non programmati", "Sin programar", "Ungeplant") }
    var emptyUnscheduledTitle: String {
        text("未定の候補はすべて日程に組み込まれました！", "All wishlist items are scheduled!", "Tutti i desideri sono programmati!", "¡Todos los deseos están programados!", "Alle Wünsche sind bereits eingeplant!")
    }
    
    var emptyWishlistTitle: String {
        text("まだ行きたい場所がありません", "No places in Wishlist yet", "Nessun luogo nella lista", "Aún no hay lugares", "Noch keine Orte auf der Liste")
    }
    var emptyWishlistSubWriter: String {
        text("右上の「＋追加する」から、食べたいものや観光地・移動手段を追加しよう！",
             "Tap '+' on the top right to add food, places, or transit info!",
             "Tocca '+' in alto a destra per aggiungere cibo, luoghi o trasporti!",
             "¡Toca '+' arriba a la derecha para añadir comida, lugares o transporte!",
             "Tippe oben rechts auf '+', um Essen, Orte oder Verbindungen hinzuzufügen!")
    }
    var emptyWishlistSubViewer: String {
        text("現在「🐣 閲覧のみ」の状態です。左上の「ルーム設定」からリーダーに編集メンバーへの変更をお願いしてください。",
             "You are in '🐣 Read-only' mode. Ask the Leader to promote you to Editor.",
             "Sei in modalità '🐣 Solo lettura'. Chiedi al Leader di promuoverti a Editore.",
             "Estás en modo '🐣 Solo lectura'. Pide al Líder que te cambie a Editor.",
             "Du bist im Modus '🐣 Nur Lesen'. Bitte den Leader, dich zum Bearbeiter zu machen.")
    }
    var likeBtn: String { text("行きたい！", "Like", "Mi piace", "Me gusta", "Gefällt mir") }
    var taxiCardBtn: String { text("タクシー表示", "Taxi Card", "Card Taxi", "Tarjeta Taxi", "Taxi-Karte") }
    var googleMapBtn: String { text("Googleマップ", "Google Maps", "Google Maps", "Google Maps", "Google Maps") }
    var openLinkBtn: String { text("参考リンク", "Open Link", "Apri Link", "Abrir Enlace", "Link öffnen") }
    var proposedBy: String { text("提案者", "By", "Da", "Por", "Von") }
    
    // カテゴリー
    var catFood: String { text("ごはん", "Food", "Cibo", "Comida", "Essen") }
    var catSightseeing: String { text("観光地", "Sightseeing", "Turismo", "Turismo", "Sehenswürdigkeit") }
    var catTransit: String { text("移動", "Transit", "Trasporto", "Transporte", "Transfer") }
    var catOther: String { text("その他", "Other", "Altro", "Otro", "Sonstiges") }
    
    func localizedCategory(_ raw: String) -> String {
        switch raw {
        case "ごはん", "Food", "Cibo", "Comida", "Essen": return catFood
        case "観光地", "Sightseeing", "Turismo", "Sehenswürdigkeit": return catSightseeing
        case "移動", "Transit", "Trasporto", "Transporte", "Transfer": return catTransit
        default: return raw
        }
    }
    
    // 追加・詳細編集シート
    var addSheetTitle: String { text("予定・行きたい場所を追加", "Add Place or Plan", "Aggiungi luogo o piano", "Añadir lugar o plan", "Ort oder Plan hinzufügen") }
    var editSheetTitle: String { text("予定の詳細・長文メモ編集", "Plan Details & Long Note", "Dettagli e Note", "Detalles y Notas", "Details & Notizen") }
    var selectCategorySec: String { text("カテゴリーを選択", "Category", "Categoria", "Categoría", "Kategorie") }
    var customTagPlaceholder: String { text("タグ名を入力（例：ホテル、お土産）", "Custom tag (e.g., Hotel, Cafe)", "Tag personalizzato (es. Hotel)", "Etiqueta (ej. Hotel, Compras)", "Eigener Tag (z.B. Hotel)") }
    var basicInfoSec: String { text("基本情報（必須）", "Basic Info (Required)", "Info di base (Obbligatorio)", "Info básica (Obligatorio)", "Basisinfos (Pflicht)") }
    var titlePlaceholder: String { text("場所や移動区間（例：金閣寺、東京駅 → 浅草）", "Place or route (e.g., Central Station -> Museum)", "Luogo o tratta (es. Stazione -> Museo)", "Lugar o ruta (ej. Estación -> Museo)", "Ort oder Strecke (z.B. Bahnhof -> Museum)") }
    var longNoteSec: String { text("詳細テキスト・長文メモ（乗り換え・予約番号・メモ等）", "Detailed Text / Long Note (Transit, Booking info, etc.)", "Testo dettagliato / Note lunghe", "Texto detallado / Notas largas", "Detaillierter Text / Lange Notizen") }
    var notePlaceholder: String { text("長文メモや乗り換え案内、営業時間などを自由に記入できます（最大2000文字）", "Write detailed notes, transit directions, or booking info...", "Scrivi note dettagliate, indicazioni o prenotazioni...", "Escribe notas detalladas, direcciones o reservas...", "Detaillierte Notizen, Verbindungen oder Buchungen...") }
    var mapLinkSec: String { text("参考URL / Googleマップリンク（任意）", "Reference URL / Google Maps Link (Optional)", "URL / Link Google Maps (Opzionale)", "URL / Enlace Google Maps (Opcional)", "URL / Google Maps Link (Optional)") }
    var mapLinkPlaceholder: String { text("https://maps.app.goo.gl/... またはWebサイトURL", "https://maps.app.goo.gl/... or Website URL", "https://maps.app.goo.gl/... o sito web", "https://maps.app.goo.gl/... o sitio web", "https://maps.app.goo.gl/... oder Webseite") }
    var mapLinkHint: String { text("※未入力の場合でも、場所名からGoogleマップ検索や移動ルート提案を自動利用できます。", "* Even if left blank, Google Maps search and transit suggestions work from the place name.", "* Anche se vuoto, puoi usare Google Maps e i suggerimenti percorso dal nome.", "* Incluso si está vacío, puedes buscar el lugar y sugerir rutas desde el nombre.", "* Auch ohne Link funktionieren Google Maps-Suche und Routenvorschläge.") }
    var budgetSec: String { text("費用・割り勘メモ（任意）", "Expense / Split Bill Memo (Optional)", "Spese / Divisione conti (Opzionale)", "Gasto / División de cuenta (Opcional)", "Kosten / Aufteilung (Optional)") }
    var amountPlaceholder: String { text("金額（数字のみ 例: 3500）", "Amount (numbers only, e.g., 3500)", "Importo (solo numeri, es. 3500)", "Importe (solo números, ej. 3500)", "Betrag (nur Zahlen, z.B. 3500)") }
    var paidByLabel: String { text("支払った人（立替者）", "Paid by", "Pagato da", "Pagado por", "Bezahlt von") }
    var paidByPlaceholder: String { text("名前（例：たろう）", "Name", "Nome", "Nombre", "Name") }
    var taxiInfoSec: String { text("タクシー・現地表示用（任意）", "For Taxi Driver (Optional)", "Per il tassista (Opzionale)", "Para el taxista (Opcional)", "Für Taxifahrer (Optional)") }
    var localNamePlaceholder: String { text("現地語や正式名称（例：Kinkaku-ji Temple）", "Local name", "Nome locale", "Nombre local", "Name in Landessprache") }
    var localAddrPlaceholder: String { text("現地の住所", "Local address", "Indirizzo locale", "Dirección local", "Lokale Adresse") }
    
    // 旅費・割り勘画面
    var totalBudgetTitle: String { text("登録された旅費の合計", "Total Recorded Expenses", "Totale spese registrate", "Total de gastos registrados", "Gesamte erfasste Ausgaben") }
    func perPersonTitle(_ count: Int) -> String {
        text("1人あたりの目安（\(count)人で割り勘）", "Per Person Estimate (\(count) members)", "Stima a persona (\(count) membri)", "Estimado por persona (\(count) miembros)", "Pro Person (bei \(count) Mitgliedern)")
    }
    var paidBySummarySec: String { text("メンバー別の支払（立替）合計", "Total Paid by Each Member", "Totale pagato per membro", "Total pagado por miembro", "Gezahlt pro Mitglied") }
    var expenseItemsSec: String { text("金額が記録された予定一覧", "Items with Recorded Expenses", "Elementi con spese", "Elementos con gastos", "Einträge mit Kosten") }
    var emptyBudgetText: String {
        text("まだ金額が入力された予定がありません。\n各予定の「追加」または「詳細・編集」から金額と支払った人を記録すると、ここで自動計算されます。",
             "No expenses recorded yet.\nAdd an amount and payer in any item's details to calculate automatically.",
             "Nessuna spesa registrata.\nAggiungi un importo nei dettagli di un elemento per il calcolo automatico.",
             "Aún no hay gastos.\nAñade un importe en los detalles de cualquier elemento para calcular automáticamente.",
             "Noch keine Ausgaben erfasst.\nFüge Betrag und Zahler in den Details eines Eintrags hinzu.")
    }
    
    // 日程・時刻（1分単位＆数字パッド対応）
    var scheduleSectionTitle: String { text("日程と時刻を設定（1分単位）", "Set Day & Time (1-min)", "Imposta giorno e ora", "Configurar día y hora", "Tag & Uhrzeit (Minutengenau)") }
    var dayPickerLabel: String { text("日程", "Day", "Giorno", "Día", "Tag") }
    var timePickerLabel: String { text("予定時刻", "Time", "Ora", "Hora", "Uhrzeit") }
    var keypadTimeLabel: String { text("数字入力（例: 0915 → 09:15）", "Keypad Input (e.g. 0915 → 09:15)", "Tastierino (es. 0915 → 09:15)", "Teclado numérico (ej. 0915)", "Zahleneingabe (z.B. 0915)") }
    var hourUnit: String { text("時", "h", "h", "h", "Std") }
    var minuteUnit: String { text("分", "m", "m", "m", "Min") }
    var unscheduledOption: String { text("未定（日程から外す）", "Unscheduled", "Non programmato", "Sin programar", "Nicht geplant") }
    var tapToViewDetailHint: String { text("※予定をタップすると長文メモの確認・編集ができます", "* Tap any plan to view or edit detailed notes", "* Tocca un piano per vedere o modificare le note", "* Toca un plan para ver o editar notas detalladas", "* Tippe auf einen Eintrag für detaillierte Notizen") }
    
    // 旅行開始日（任意）設定
    var tripDateSec: String { text("旅行の日付設定（任意）", "Trip Start Date (Optional)", "Data inizio viaggio (Opzionale)", "Fecha de inicio (Opcional)", "Reisedatum (Optional)") }
    var enableTripDateToggle: String { text("開始日を設定して日付を表示する", "Show Calendar Dates", "Mostra date del calendario", "Mostrar fechas del calendario", "Kalenderdaten anzeigen") }
    var startDatePickerLabel: String { text("1日目の日付（出発日）", "Day 1 Date (Start Date)", "Data Giorno 1", "Fecha del Día 1", "Datum Tag 1") }
    var tripDateHint: String {
        text("ONにすると「1日目 (11/20)」のように各日の日付が自動計算されて表示されます。未定の場合はOFFのまま使えます。",
             "When ON, dates like 'Day 1 (11/20)' appear automatically. Keep OFF if dates are undecided.",
             "Se attivo, mostra le date come 'Giorno 1 (11/20)'.",
             "Si está activado, muestra fechas como 'Día 1 (11/20)'.",
             "Wenn aktiv, werden Daten wie 'Tag 1 (11/20)' angezeigt.")
    }
    
    func dayLabel(_ day: Int, startDate: Date? = nil) -> String {
        let base: String
        switch lang {
        case .ja: base = "\(day)日目"
        case .en: base = "Day \(day)"
        case .it: base = "Giorno \(day)"
        case .es: base = "Día \(day)"
        case .de: base = "Tag \(day)"
        }
        guard let start = startDate,
              let targetDate = Calendar.current.date(byAdding: .day, value: day - 1, to: start) else {
            return base
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return "\(base) (\(formatter.string(from: targetDate)))"
    }
    
    func assignToDay(_ day: Int, startDate: Date? = nil) -> String {
        let dStr = dayLabel(day, startDate: startDate)
        return text("\(dStr) に追加・時間変更", "Assign to \(dStr)", "Assegna a \(dStr)", "Asignar a \(dStr)", "Zu \(dStr) hinzufügen")
    }
    func addNewDayAndAssign(_ day: Int, startDate: Date? = nil) -> String {
        let dStr = dayLabel(day, startDate: startDate)
        return text("＋ \(dStr) を新しく作って追加", "+ Create & Assign to \(dStr)", "+ Crea e assegna a \(dStr)", "+ Crear y asignar a \(dStr)", "+ \(dStr) erstellen & zuweisen")
    }
    var unscheduleBtn: String { text("日程から外す（未定に戻す）", "Unschedule (Back to Wishlist)", "Rimuovi dal programma", "Quitar del horario", "Aus Zeitplan entfernen") }
    var addDayBtn: String { text("日を追加", "Add Day", "Aggiungi giorno", "Añadir día", "Tag +") }
    var manageDayBtn: String { text("日程整理", "Manage Day", "Gestisci", "Gestionar", "Verwalten") }
    func emptyItineraryTitle(_ day: Int, startDate: Date? = nil) -> String {
        let dStr = dayLabel(day, startDate: startDate)
        return text("\(dStr) の予定はまだありません", "No plans for \(dStr) yet", "Nessun piano per \(dStr)", "Sin planes para \(dStr)", "Noch keine Pläne für \(dStr)")
    }
    var emptyItinerarySub: String {
        text("「行きたい！」タブの「…」メニューからこの日に予定を割り振ることができます。",
             "Use the '...' menu in Wishlist to assign items to this day.",
             "Usa il menu '...' nella lista desideri per assegnare elementi a questo giorno.",
             "Usa el menú '...' en Deseos para asignar elementos a este día.",
             "Nutze das '...'-Menü in der Wunschliste, um diesem Tag Orte zuzuweisen.")
    }
    func unscheduleAllInDay(_ day: Int, startDate: Date? = nil) -> String {
        let dStr = dayLabel(day, startDate: startDate)
        return text("\(dStr) の予定をすべて「未定」に戻す", "Return \(dStr) items to Wishlist", "Riporta elementi di \(dStr) ai desideri", "Devolver elementos de \(dStr) a Deseos", "Orte von \(dStr) zurück zur Liste")
    }
    func removeDayKeepItems(_ day: Int, startDate: Date? = nil) -> String {
        let dStr = dayLabel(day, startDate: startDate)
        return text("\(dStr) の予定を「未定」に戻し、タブを削除", "Keep items in Wishlist & delete \(dStr) tab", "Mantieni elementi ed elimina \(dStr)", "Mantener elementos y eliminar \(dStr)", "Orte behalten & \(dStr) löschen")
    }
    func removeDayDeleteItems(_ day: Int, startDate: Date? = nil) -> String {
        let dStr = dayLabel(day, startDate: startDate)
        return text("\(dStr) の予定を完全に削除し、タブも削除", "Delete all items & remove \(dStr) tab", "Elimina tutto e rimuovi \(dStr)", "Eliminar todo y quitar \(dStr)", "Alle Orte & \(dStr) komplett löschen")
    }
    func deleteAllInDay(_ day: Int, startDate: Date? = nil) -> String {
        let dStr = dayLabel(day, startDate: startDate)
        return text("\(dStr) の予定をすべて完全に削除する", "Delete all items on \(dStr)", "Elimina tutti gli elementi di \(dStr)", "Eliminar todos los elementos de \(dStr)", "Alle Orte an \(dStr) komplett löschen")
    }
    
    // タクシーカード
    var taxiHeader: String {
        text("運転手さん、ここまでお願いします / Please take me here:",
             "Please take me to this destination:",
             "Per favore, mi porti a questo indirizzo:",
             "Por favor, lléveme a esta dirección:",
             "Bitte bringen Sie mich zu dieser Adresse:")
    }
    var openMapsBtn: String {
        text("Appleマップで開く", "Open in Apple Maps", "Apri in Mappe Apple", "Abrir en Mapas de Apple", "In Apple Karten öffnen")
    }
    var openGoogleMapsBtn: String {
        text("Googleマップで開く", "Open in Google Maps", "Apri in Google Maps", "Abrir en Google Maps", "In Google Maps öffnen")
    }
    
    // チャット・通報
    var chatPlaceholder: String { text("メッセージやURLを入力（最大1000文字）...", "Type a message or URL...", "Scrivi un messaggio o URL...", "Escribe un mensaje o URL...", "Nachricht oder URL schreiben...") }
    var chatReadOnlyHint: String {
        text("🐣 閲覧のみ（初期状態）のため送信できません。リーダーに「編集メンバー」への変更をお願いしてください。",
             "🐣 Read-only mode. Ask the Leader to promote you to Editor to send messages.",
             "🐣 Modalità solo lettura. Chiedi al Leader di promuoverti a Editore per scrivere.",
             "🐣 Modo solo lectura. Pide al Líder que te cambie a Editor para enviar mensajes.",
             "🐣 Nur-Lesen-Modus. Bitte den Leader um Bearbeiter-Rechte, um zu schreiben.")
    }
    var reportBtn: String { text("不適切な投稿を通報", "Report Content", "Segnala contenuto", "Reportar contenido", "Inhalt melden") }
    var blockBtn: String { text("このユーザーをブロック", "Block User", "Blocca utente", "Bloquear usuario", "Nutzer blockieren") }
    var reportAlertTitle: String { text("通報を受け付けました", "Report Submitted", "Segnalazione inviata", "Reporte enviado", "Meldung gesendet") }
    var reportAlertMsg: String {
        text("運営チームが24時間以内に内容を確認し対処いたします。",
             "Our team will review the content within 24 hours and take action.",
             "Il nostro team esaminerà il contenuto entro 24 ore.",
             "Nuestro equipo revisará el contenido en un plazo de 24 horas.",
             "Unser Team prüft den Inhalt innerhalb von 24 Stunden.")
    }
    func shareMessage(_ code: String) -> String {
        text("旅行計画アプリ「Travelum」に参加してね！合言葉は【\(code)】です。",
             "Join our trip plan on Travelum! Room Code: [\(code)]",
             "Unisciti al nostro piano di viaggio su Travelum! Codice stanza: [\(code)]",
             "¡Únete a nuestro viaje en Travelum! Código de sala: [\(code)]",
             "Tritt unserer Reiseplanung in Travelum bei! Raumcode: [\(code)]")
    }
    
    // ルーム設定シート
    var languageSectionTitle: String { text("言語設定 / Language", "Language", "Lingua", "Idioma", "Sprache") }
    var roomCodeInviteSec: String { text("現在のルーム合言葉と招待", "Room Code & Invite", "Codice stanza e invito", "Código e invitación", "Raumcode & Einladung") }
    var acceptNewMembersToggle: String { text("新規メンバーの参加を受け付ける", "Accept New Members", "Accetta nuovi membri", "Aceptar nuevos miembros", "Neue Mitglieder zulassen") }
    var acceptNewMembersHint: String {
        text("全員が入室した後にOFFにすると、第三者の入室を完全にブロックできます。",
             "Turn off after everyone joins to block outsiders.",
             "Disattiva dopo che tutti sono entrati per bloccare gli estranei.",
             "Desactívalo cuando todos hayan entrado para bloquear a extraños.",
             "Deaktiviere dies, sobald alle da sind, um Fremde zu blockieren.")
    }
    var yourRoleSec: String { text("あなたの状態", "Your Status", "Il tuo stato", "Tu estado", "Dein Status") }
    func membersSec(_ count: Int) -> String {
        text("参加メンバーと権限設定 (\(count)人)", "Members & Roles (\(count))", "Membri e ruoli (\(count))", "Miembros y roles (\(count))", "Mitglieder & Rollen (\(count))")
    }
    var membersFooter: String {
        text("新しく入った人は安全のため最初は「🐣 閲覧のみ」になります。リーダーが「権限変更」から「🐧 編集メンバー」にすると一緒に書き込めます。",
             "Newcomers start as '🐣 Viewer' for safety. The Leader can promote them to '🐧 Editor' to allow posting and chatting.",
             "I nuovi arrivati iniziano come '🐣 Spettatore'. Il Leader può promuoverli a '🐧 Editore' per scrivere.",
             "Los nuevos miembros empiezan como '🐣 Espectador'. El Líder puede cambiarlos a '🐧 Editor' para escribir.",
             "Neue Mitglieder starten sicherheitshalber als '🐣 Betrachter'. Der Leader kann sie zu '🐧 Bearbeiter' ernennen.")
    }
    var changeRoleBtn: String { text("権限変更", "Role", "Ruolo", "Rol", "Rolle") }
    var makeEditorBtn: String { text("🐧 編集メンバー に変更", "Promote to 🐧 Editor", "Promuovi a 🐧 Editore", "Cambiar a 🐧 Editor", "Zu 🐧 Bearbeiter machen") }
    var makeViewerBtn: String { text("🐣 閲覧のみ に戻す", "Set to 🐣 Viewer", "Imposta 🐣 Spettatore", "Cambiar a 🐣 Espectador", "Auf 🐣 Betrachter setzen") }
    var makeLeaderBtn: String { text("👑 リーダー権限 を付与", "Make 👑 Leader", "Rendi 👑 Leader", "Hacer 👑 Líder", "Zum 👑 Leader machen") }
    var kickMemberBtn: String { text("ルームから削除（キック）", "Remove from Room", "Rimuovi dalla stanza", "Eliminar de la sala", "Aus Raum entfernen") }
    var kickConfirmTitle: String { text("メンバーを削除しますか？", "Remove Member?", "Rimuovere membro?", "¿Eliminar miembro?", "Mitglied entfernen?") }
    func kickConfirmMsg(_ name: String) -> String {
        text("「\(name)」をこのルームのメンバー一覧から削除します。（重複データの整理にも使えます）",
             "Remove '\(name)' from this room's member list.",
             "Rimuovere '\(name)' dall'elenco dei membri di questa stanza.",
             "Eliminar a '\(name)' de la lista de miembros de esta sala.",
             "'\(name)' aus der Mitgliederliste dieses Raums entfernen.")
    }
    
    var roomManageSec: String { text("ルームの切り替え・データ整理・退出", "Room Management & Cleanup", "Gestione stanza", "Gestión de sala", "Raumverwaltung") }
    var switchRoomBtn: String { text("別の合言葉のルームに切り替える", "Switch to Another Room Code", "Cambia codice stanza", "Cambiar de sala", "Raum wechseln") }
    var clearChatBtn: String { text("チャット履歴を一括消去（容量節約）", "Clear Chat History (Save Space)", "Cancella cronologia chat", "Borrar historial de chat", "Chatverlauf löschen") }
    var leaveRoomBtn: String { text("このルームから退出する", "Leave This Room", "Esci dalla stanza", "Salir de la sala", "Raum verlassen") }
    var closeRoomBtn: String { text("ルームを完全に閉鎖する（全データ削除）", "Close & Delete Room Completely", "Chiudi ed elimina stanza", "Cerrar y eliminar sala", "Raum komplett löschen") }
    var leaveConfirmTitle: String { text("ルームから退出しますか？", "Leave Room?", "Uscire dalla stanza?", "¿Salir de la sala?", "Raum verlassen?") }
    var leaveConfirmMsg: String {
        text("リーダーが退出する場合、残っているメンバーへ自動的にリーダー権限が引き継がれます。",
             "If you are the Leader, leadership will automatically transfer to the next member.",
             "Se sei il Leader, il ruolo passerà automaticamente a un altro membro.",
             "Si eres el Líder, el rol pasará automáticamente a otro miembro.",
             "Wenn du Leader bist, wird die Rolle automatisch übertragen.")
    }
    var closeConfirmTitle: String { text("ルームを完全に閉鎖しますか？", "Close & Delete Room?", "Chiudere ed eliminare?", "¿Cerrar y eliminar sala?", "Raum komplett löschen?") }
    var closeConfirmMsg: String {
        text("このルームの予定表・チャット履歴・メンバー情報がすべて削除され、データベースの容量が解放されます。",
             "All itinerary items, chat messages, and members in this room will be permanently deleted.",
             "Tutti i dati di questa stanza verranno eliminati definitivamente.",
             "Todos los datos de esta sala se eliminarán permanentemente.",
             "Alle Pläne, Chats und Mitglieder dieses Raums werden unwiderruflich gelöscht.")
    }
}

// MARK: - 0.3 タイムゾーン＆夏時間（DST）自動判定ヘルパー

struct TravelTimeZoneOption: Identifiable, Hashable {
    let identifier: String
    let labelJa: String
    let labelEn: String
    
    var id: String { identifier }
    
    var timeZone: TimeZone {
        if identifier.isEmpty {
            return TimeZone.current
        }
        return TimeZone(identifier: identifier) ?? TimeZone.current
    }
    
    func displayTitle(for lang: AppLanguage, referenceDate: Date?) -> String {
        let baseName = (lang == .ja) ? labelJa : labelEn
        let tz = timeZone
        let targetDate = referenceDate ?? Date()
        let seconds = tz.secondsFromGMT(for: targetDate)
        let hours = seconds / 3600
        let mins = abs((seconds % 3600) / 60)
        let sign = hours >= 0 ? "+" : ""
        let offsetStr = mins == 0 ? "UTC\(sign)\(hours)" : String(format: "UTC%@%d:%02d", sign, hours, mins)
        let isDST = tz.isDaylightSavingTime(for: targetDate)
        let dstMark = isDST ? (lang == .ja ? " ☀️夏時間" : " ☀️DST") : ""
        return "\(baseName) (\(offsetStr)\(dstMark))"
    }
    
    static func shortBadge(for identifier: String, referenceDate: Date?) -> String? {
        guard !identifier.isEmpty, let tz = TimeZone(identifier: identifier) else { return nil }
        let targetDate = referenceDate ?? Date()
        let seconds = tz.secondsFromGMT(for: targetDate)
        let hours = seconds / 3600
        let mins = abs((seconds % 3600) / 60)
        let sign = hours >= 0 ? "+" : ""
        let offsetStr = mins == 0 ? "UTC\(sign)\(hours)" : String(format: "UTC%@%d:%02d", sign, hours, mins)
        let abbr = tz.abbreviation(for: targetDate) ?? offsetStr
        let dstMark = tz.isDaylightSavingTime(for: targetDate) ? "☀️" : ""
        return "\(abbr)\(dstMark)"
    }
    
    static let presets: [TravelTimeZoneOption] = [
        TravelTimeZoneOption(identifier: "", labelJa: "端末の標準タイムゾーン", labelEn: "Device Default"),
        TravelTimeZoneOption(identifier: "Asia/Tokyo", labelJa: "日本（東京・大阪）", labelEn: "Japan (Tokyo)"),
        TravelTimeZoneOption(identifier: "Asia/Taipei", labelJa: "台湾（台北）", labelEn: "Taiwan (Taipei)"),
        TravelTimeZoneOption(identifier: "Asia/Seoul", labelJa: "韓国（ソウル）", labelEn: "South Korea (Seoul)"),
        TravelTimeZoneOption(identifier: "Asia/Hong_Kong", labelJa: "香港・マカオ", labelEn: "Hong Kong"),
        TravelTimeZoneOption(identifier: "Asia/Singapore", labelJa: "シンガポール・マレーシア", labelEn: "Singapore / Malaysia"),
        TravelTimeZoneOption(identifier: "Asia/Bangkok", labelJa: "タイ・ベトナム", labelEn: "Thailand / Vietnam"),
        TravelTimeZoneOption(identifier: "Pacific/Honolulu", labelJa: "ハワイ（ホノルル）", labelEn: "Hawaii (Honolulu)"),
        TravelTimeZoneOption(identifier: "America/Los_Angeles", labelJa: "米国西海岸（LA・サンフランシスコ）", labelEn: "US Pacific (LA / SF)"),
        TravelTimeZoneOption(identifier: "America/Denver", labelJa: "米国山岳部（デンバー）", labelEn: "US Mountain (Denver)"),
        TravelTimeZoneOption(identifier: "America/Chicago", labelJa: "米国中部（シカゴ・ダラス）", labelEn: "US Central (Chicago)"),
        TravelTimeZoneOption(identifier: "America/New_York", labelJa: "米国東海岸（NY・オーランド）", labelEn: "US Eastern (New York)"),
        TravelTimeZoneOption(identifier: "Europe/London", labelJa: "イギリス（ロンドン）", labelEn: "UK (London)"),
        TravelTimeZoneOption(identifier: "Europe/Paris", labelJa: "欧州中央（パリ・ローマ・ベルリン）", labelEn: "Central Europe (Paris / Rome)"),
        TravelTimeZoneOption(identifier: "Europe/Helsinki", labelJa: "東欧（ヘルシンキ・アテネ）", labelEn: "Eastern Europe (Helsinki)"),
        TravelTimeZoneOption(identifier: "Australia/Sydney", labelJa: "オーストラリア東部（シドニー）", labelEn: "Australia Eastern (Sydney)"),
        TravelTimeZoneOption(identifier: "Pacific/Auckland", labelJa: "ニュージーランド（オークランド）", labelEn: "New Zealand (Auckland)"),
        TravelTimeZoneOption(identifier: "UTC", labelJa: "協定世界時（UTC）", labelEn: "UTC")
    ]
}

// MARK: - 0.5 チャット専用通知＆アプリアイコンバッジ管理クラス

class ChatNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = ChatNotificationDelegate()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

// MARK: - 0.8 移動ルート・所要時間・タイムゾーン＆夏時間対応経路計算エンジン

enum TransitMode: String, CaseIterable {
    case transit
    case taxi
    case bicycle
    case walk
    
    func title(for s: L10n) -> String {
        switch self {
        case .transit: return s.transitOptionTitle
        case .taxi: return s.taxiOptionTitle
        case .bicycle: return s.bikeOptionTitle
        case .walk: return s.walkOptionTitle
        }
    }
    
    var iconName: String {
        switch self {
        case .transit: return "tram.fill"
        case .taxi: return "car.fill"
        case .bicycle: return "bicycle"
        case .walk: return "figure.walk"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .transit: return .blue
        case .taxi: return .orange
        case .bicycle: return .teal
        case .walk: return .green
        }
    }
    
    var googleTravelMode: String {
        switch self {
        case .transit: return "transit"
        case .taxi: return "driving"
        case .bicycle: return "bicycling"
        case .walk: return "walking"
        }
    }
    
    var appleDirFlag: String {
        switch self {
        case .transit: return "r"
        case .taxi: return "d"
        case .bicycle: return "c"
        case .walk: return "w"
        }
    }
}

struct TransitRouteOption: Identifiable {
    let id = UUID()
    let mode: TransitMode
    let durationMinutes: Int
    let distanceMeters: Double
    let suggestedDepartureTime: String
    let estimatedArrivalTime: String
    let isRecommended: Bool
    let originQuery: String
    let destinationQuery: String
    
    var formattedDistance: String {
        if distanceMeters <= 0 {
            return ""
        } else if distanceMeters >= 1000 {
            return String(format: "%.1f km", distanceMeters / 1000.0)
        } else {
            return "\(Int(distanceMeters.rounded())) m"
        }
    }
}

struct TransitSuggestionPair: Identifiable {
    let id = UUID()
    let fromItem: WishlistItem
    let toItem: WishlistItem
    let day: Int
}

class SmartTransitCalculator {
    static func splitArrowRoute(from text: String) -> (origin: String, destination: String)? {
        let separators = ["→", "➡", "➔", "->"]
        for sep in separators {
            if text.contains(sep) {
                let parts = text.components(separatedBy: sep)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                if parts.count >= 2 {
                    return (parts.first!, parts.last!)
                }
            }
        }
        return nil
    }
    
    static func shouldSuggestTransit(from current: WishlistItem, to next: WishlistItem) -> Bool {
        if splitArrowRoute(from: current.title) != nil ||
            splitArrowRoute(from: next.title) != nil {
            return false
        }
        
        let nameA = current.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let nameB = next.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if nameA.isEmpty || nameB.isEmpty || nameA == nameB || nameA.contains(nameB) || nameB.contains(nameA) {
            return false
        }
        
        let minsA = minutesSinceMidnight(current.scheduledTime)
        let minsB = minutesSinceMidnight(next.scheduledTime)
        let diff = minsB - minsA
        if diff < -180 || diff > 480 {
            return false
        }
        
        return true
    }
    
    static func minutesSinceMidnight(_ timeStr: String) -> Int {
        let parts = timeStr.split(separator: ":")
        guard parts.count == 2, let h = Int(parts[0]), let m = Int(parts[1]) else { return 0 }
        return h * 60 + m
    }
    
    static func resolveScheduledDate(tripStartDate: Date?, day: Int?, timeStr: String, timeZoneId: String = "") -> Date {
        let tz: TimeZone
        if !timeZoneId.isEmpty, let customTZ = TimeZone(identifier: timeZoneId) {
            tz = customTZ
        } else {
            tz = TimeZone.current
        }
        
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = tz
        
        let baseDay: Date
        if let start = tripStartDate, let d = day, d >= 1 {
            let localComps = Calendar.current.dateComponents([.year, .month, .day], from: start)
            let startInTZ = cal.date(from: localComps) ?? cal.startOfDay(for: Date())
            baseDay = cal.date(byAdding: .day, value: d - 1, to: startInTZ) ?? cal.startOfDay(for: Date())
        } else {
            baseDay = cal.startOfDay(for: Date())
        }
        
        let parts = timeStr.split(separator: ":")
        let h = parts.count == 2 ? (Int(parts[0]) ?? 12) : 12
        let m = parts.count == 2 ? (Int(parts[1]) ?? 0) : 0
        return cal.date(bySettingHour: h, minute: m, second: 0, of: baseDay) ?? Date()
    }
    
    static func formatTime(_ date: Date, in timeZoneId: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if !timeZoneId.isEmpty, let tz = TimeZone(identifier: timeZoneId) {
            formatter.timeZone = tz
        } else {
            formatter.timeZone = TimeZone.current
        }
        return formatter.string(from: date)
    }
    
    static func makeGoogleMapsDirectionsURL(
        origin: String,
        destination: String,
        mode: String = "transit",
        targetDate: Date? = nil,
        isArrivalTime: Bool = false,
        timeZoneId: String = ""
    ) -> URL? {
        if let targetDate = targetDate {
            let timestamp = Int(targetDate.timeIntervalSince1970)
            let modeCode: Int
            switch mode {
            case "driving": modeCode = 0
            case "bicycling": modeCode = 1
            case "walking": modeCode = 2
            default: modeCode = 3
            }
            let timeTypeCode = isArrivalTime ? 1 : 0
            let encOrigin = origin.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? origin
            let encDest = destination.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? destination
            
            let tz = (!timeZoneId.isEmpty ? TimeZone(identifier: timeZoneId) : nil) ?? TimeZone.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = tz
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            timeFormatter.timeZone = tz
            
            let datePart = dateFormatter.string(from: targetDate)
            let timePart = timeFormatter.string(from: targetDate)
            let ttype = isArrivalTime ? "arr" : "dep"
            
            let urlStr = "https://www.google.com/maps/dir/\(encOrigin)/\(encDest)/data=!4m6!4m5!2m3!6e\(timeTypeCode)!7e2!8j\(timestamp)!3e\(modeCode)?api=1&origin=\(encOrigin)&destination=\(encDest)&travelmode=\(mode)&ttype=\(ttype)&date=\(datePart)&time=\(timePart)"
            if let url = URL(string: urlStr) {
                return url
            }
        }
        
        var components = URLComponents(string: "https://www.google.com/maps/dir/")
        components?.queryItems = [
            URLQueryItem(name: "api", value: "1"),
            URLQueryItem(name: "origin", value: origin),
            URLQueryItem(name: "destination", value: destination),
            URLQueryItem(name: "travelmode", value: mode)
        ]
        return components?.url
    }
    
    static func makeAppleMapsDirectionsURL(origin: String, destination: String, dirFlag: String) -> URL? {
        var components = URLComponents(string: "http://maps.apple.com/")
        components?.queryItems = [
            URLQueryItem(name: "saddr", value: origin),
            URLQueryItem(name: "daddr", value: destination),
            URLQueryItem(name: "dirflg", value: dirFlag)
        ]
        return components?.url
    }
    
    static func calculateOptions(from originItem: WishlistItem, to destItem: WishlistItem, tripStartDate: Date?) async -> [TransitRouteOption] {
        let effectiveOriginName = splitArrowRoute(from: originItem.title)?.destination ?? originItem.title
        let effectiveDestName = splitArrowRoute(from: destItem.title)?.origin ?? destItem.title
        
        async let originPlacemark = resolvePlacemark(for: originItem, overrideQueryName: effectiveOriginName)
        async let destPlacemark = resolvePlacemark(for: destItem, overrideQueryName: effectiveDestName)
        
        guard let startPM = await originPlacemark,
              let endPM = await destPlacemark else {
            return []
        }
        
        let startMapItem = MKMapItem(placemark: startPM)
        let endMapItem = MKMapItem(placemark: endPM)
        
        let departDate = resolveScheduledDate(
            tripStartDate: tripStartDate,
            day: originItem.scheduledDay,
            timeStr: originItem.scheduledTime,
            timeZoneId: originItem.timeZoneIdentifier
        )
        let destArriveDate = resolveScheduledDate(
            tripStartDate: tripStartDate,
            day: destItem.scheduledDay ?? originItem.scheduledDay,
            timeStr: destItem.scheduledTime,
            timeZoneId: destItem.timeZoneIdentifier
        )
        
        async let transitETA = fetchTransitETA(from: startMapItem, to: endMapItem, departureDate: departDate)
        async let autoRoute = fetchRoute(from: startMapItem, to: endMapItem, transportType: .automobile, departureDate: departDate)
        async let walkRoute = fetchRoute(from: startMapItem, to: endMapItem, transportType: .walking, departureDate: departDate)
        
        let (transitRes, carRes, walkRes) = await (transitETA, autoRoute, walkRoute)
        
        let originQuery = buildSearchQuery(for: originItem, fallbackName: effectiveOriginName, coordinate: startPM.coordinate)
        let destQuery = buildSearchQuery(for: destItem, fallbackName: effectiveDestName, coordinate: endPM.coordinate)
        
        let walkMins = walkRes.map { max(1, Int(ceil($0.expectedTravelTime / 60.0))) }
        let carMins = carRes.map { max(1, Int(ceil($0.expectedTravelTime / 60.0))) }
        let transitMins = transitRes.map { max(1, Int(ceil($0.expectedTravelTime / 60.0))) }
        
        let recommendedMode: TransitMode
        if let w = walkMins, w <= 18 {
            recommendedMode = .walk
        } else if transitMins != nil {
            recommendedMode = .transit
        } else {
            recommendedMode = .taxi
        }
        
        let originTZ = originItem.timeZoneIdentifier
        let destTZ = destItem.timeZoneIdentifier
        
        var results: [TransitRouteOption] = []
        
        if let transit = transitRes, let mins = transitMins {
            let suggestedDepDate = destArriveDate.addingTimeInterval(-Double((mins + 5) * 60))
            let departTime = formatTime(suggestedDepDate, in: originTZ)
            let arriveTime = formatTime(suggestedDepDate.addingTimeInterval(Double(mins * 60)), in: destTZ)
            results.append(TransitRouteOption(
                mode: .transit,
                durationMinutes: mins,
                distanceMeters: transit.distance,
                suggestedDepartureTime: departTime,
                estimatedArrivalTime: arriveTime,
                isRecommended: recommendedMode == .transit,
                originQuery: originQuery,
                destinationQuery: destQuery
            ))
        }
        
        if let car = carRes, let mins = carMins {
            let suggestedDepDate = destArriveDate.addingTimeInterval(-Double((mins + 5) * 60))
            let departTime = formatTime(suggestedDepDate, in: originTZ)
            let arriveTime = formatTime(suggestedDepDate.addingTimeInterval(Double(mins * 60)), in: destTZ)
            results.append(TransitRouteOption(
                mode: .taxi,
                durationMinutes: mins,
                distanceMeters: car.distance,
                suggestedDepartureTime: departTime,
                estimatedArrivalTime: arriveTime,
                isRecommended: recommendedMode == .taxi,
                originQuery: originQuery,
                destinationQuery: destQuery
            ))
        }
        
        let bikeBaseDistance = walkRes?.distance ?? carRes?.distance ?? 0
        if bikeBaseDistance > 0 {
            let bikeMins = max(2, Int(ceil(bikeBaseDistance / 250.0)))
            let suggestedDepDate = destArriveDate.addingTimeInterval(-Double((bikeMins + 5) * 60))
            let departTime = formatTime(suggestedDepDate, in: originTZ)
            let arriveTime = formatTime(suggestedDepDate.addingTimeInterval(Double(bikeMins * 60)), in: destTZ)
            results.append(TransitRouteOption(
                mode: .bicycle,
                durationMinutes: bikeMins,
                distanceMeters: bikeBaseDistance,
                suggestedDepartureTime: departTime,
                estimatedArrivalTime: arriveTime,
                isRecommended: false,
                originQuery: originQuery,
                destinationQuery: destQuery
            ))
        }
        
        if let walk = walkRes, let mins = walkMins {
            let suggestedDepDate = destArriveDate.addingTimeInterval(-Double((mins + 3) * 60))
            let departTime = formatTime(suggestedDepDate, in: originTZ)
            let arriveTime = formatTime(suggestedDepDate.addingTimeInterval(Double(mins * 60)), in: destTZ)
            results.append(TransitRouteOption(
                mode: .walk,
                durationMinutes: mins,
                distanceMeters: walk.distance,
                suggestedDepartureTime: departTime,
                estimatedArrivalTime: arriveTime,
                isRecommended: recommendedMode == .walk,
                originQuery: originQuery,
                destinationQuery: destQuery
            ))
        }
        
        return results
    }
    
    private static func resolvePlacemark(for item: WishlistItem, overrideQueryName: String) async -> MKPlacemark? {
        let rawURLStr = item.referenceURLString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !rawURLStr.isEmpty {
            let resolvedURL = await expandShortURLIfNeeded(rawURLStr)
            if let url = resolvedURL {
                if let coord = extractCoordinate(from: url.absoluteString) {
                    return MKPlacemark(coordinate: coord)
                }
                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                   let q = components.queryItems?.first(where: { $0.name == "q" || $0.name == "query" || $0.name == "destination" })?.value,
                   !q.isEmpty,
                   let found = await searchMapItem(query: q) {
                    return found
                }
            }
        }
        
        var candidates: [String] = []
        let local = item.localName.trimmingCharacters(in: .whitespacesAndNewlines)
        let addr = item.localAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanOverride = overrideQueryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !local.isEmpty && SmartTransitCalculator.splitArrowRoute(from: local) == nil {
            if !addr.isEmpty {
                candidates.append("\(local) \(addr)")
            }
            candidates.append(local)
        }
        if !addr.isEmpty {
            candidates.append(addr)
        }
        if !cleanOverride.isEmpty {
            candidates.append(cleanOverride)
        }
        
        for query in candidates {
            if let found = await searchMapItem(query: query) {
                return found
            }
        }
        return nil
    }
    
    private static func expandShortURLIfNeeded(_ urlString: String) async -> URL? {
        let normalized = urlString.hasPrefix("http") ? urlString : "https://\(urlString)"
        guard let url = URL(string: normalized) else { return nil }
        let host = url.host?.lowercased() ?? ""
        if host.contains("goo.gl") || host.contains("g.co") {
            var req = URLRequest(url: url)
            req.httpMethod = "HEAD"
            req.timeoutInterval = 4.0
            if let (_, response) = try? await URLSession.shared.data(for: req),
               let finalURL = response.url {
                return finalURL
            }
        }
        return url
    }
    
    private static func extractCoordinate(from urlStr: String) -> CLLocationCoordinate2D? {
        let pattern = #"[@=](-?\d{1,3}\.\d+),(-?\d{1,3}\.\d+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: urlStr, range: NSRange(urlStr.startIndex..., in: urlStr)),
              let latRange = Range(match.range(at: 1), in: urlStr),
              let lonRange = Range(match.range(at: 2), in: urlStr),
              let lat = Double(urlStr[latRange]),
              let lon = Double(urlStr[lonRange]),
              (-90...90).contains(lat), (-180...180).contains(lon) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    private static func searchMapItem(query: String) async -> MKPlacemark? {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        if let response = try? await search.start(),
           let first = response.mapItems.first {
            return first.placemark
        }
        return nil
    }
    
    private static func fetchRoute(from source: MKMapItem, to destination: MKMapItem, transportType: MKDirectionsTransportType, departureDate: Date) async -> MKRoute? {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = transportType
        request.departureDate = departureDate
        let directions = MKDirections(request: request)
        if let response = try? await directions.calculate() {
            return response.routes.first
        }
        return nil
    }
    
    private static func fetchTransitETA(from source: MKMapItem, to destination: MKMapItem, departureDate: Date) async -> MKDirections.ETAResponse? {
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.transportType = .transit
        request.departureDate = departureDate
        let directions = MKDirections(request: request)
        return try? await directions.calculateETA()
    }
    
    private static func buildSearchQuery(for item: WishlistItem, fallbackName: String, coordinate: CLLocationCoordinate2D) -> String {
        let local = item.localName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !local.isEmpty && SmartTransitCalculator.splitArrowRoute(from: local) == nil {
            return local
        }
        if !fallbackName.isEmpty {
            return fallbackName
        }
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
    
    static func subtractMinutes(from timeStr: String, minutes: Int) -> String {
        let parts = timeStr.split(separator: ":")
        guard parts.count == 2,
              let h = Int(parts[0]),
              let m = Int(parts[1]) else {
            return timeStr
        }
        var totalMins = h * 60 + m - minutes
        while totalMins < 0 { totalMins += 24 * 60 }
        let newH = (totalMins / 60) % 24
        let newM = totalMins % 60
        return String(format: "%02d:%02d", newH, newM)
    }
    
    static func addMinutes(to timeStr: String, minutes: Int) -> String {
        let parts = timeStr.split(separator: ":")
        guard parts.count == 2,
              let h = Int(parts[0]),
              let m = Int(parts[1]) else {
            return timeStr
        }
        let totalMins = (h * 60 + m + minutes) % (24 * 60)
        let newH = (totalMins / 60) % 24
        let newM = totalMins % 60
        return String(format: "%02d:%02d", newH, newM)
    }
}

// MARK: - Supabase 接続設定（機密情報は AppEnvironment.swift から取得 ＆ RLS用ヘッダー付与）

struct SupabaseConfig {
    static var projectURL: String { AppEnvironment.projectURL }
    static var apiKey: String { AppEnvironment.publishableKey }
    static var termsURL: URL { AppEnvironment.termsURL }
    static var supportURL: URL { AppEnvironment.supportURL }
    
    static func makeRequest(
        path: String,
        queryItems: [URLQueryItem] = [],
        method: String = "GET",
        roomCode: String? = nil,
        timeoutInterval: TimeInterval = 8.0
    ) -> URLRequest? {
        guard var components = URLComponents(string: "\(projectURL)/rest/v1/\(path)") else { return nil }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.httpMethod = method
        request.setValue(apiKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let activeRoom = (roomCode ?? UserDefaults.standard.string(forKey: "currentRoomCode") ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        if !activeRoom.isEmpty {
            request.setValue(activeRoom, forHTTPHeaderField: AppEnvironment.roomHeaderField)
        }
        return request
    }
    
    static func generateSecureRoomCode() -> String {
        let chars = Array("ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
        let part1 = String((0..<4).map { _ in chars.randomElement()! })
        let part2 = String((0..<4).map { _ in chars.randomElement()! })
        return "TRV-\(part1)-\(part2)"
    }
}

// MARK: - 1. メンバー権限（ロール）＆ データモデル

enum PenguinRole: String, Codable, CaseIterable {
    case leader = "Leader Penguin"
    case assistant = "Assistant Penguin"
    case viewer = "Viewer Penguin"
    
    func displayName(for lang: AppLanguage) -> String {
        switch self {
        case .leader:
            switch lang {
            case .ja: return "👑 リーダー（管理者）"
            case .en: return "👑 Leader (Admin)"
            case .it: return "👑 Leader (Admin)"
            case .es: return "👑 Líder (Admin)"
            case .de: return "👑 Leader (Admin)"
            }
        case .assistant:
            switch lang {
            case .ja: return "🐧 編集メンバー"
            case .en: return "🐧 Editor"
            case .it: return "🐧 Editore"
            case .es: return "🐧 Editor"
            case .de: return "🐧 Bearbeiter"
            }
        case .viewer:
            switch lang {
            case .ja: return "🐣 閲覧のみ"
            case .en: return "🐣 Viewer"
            case .it: return "🐣 Spettatore"
            case .es: return "🐣 Espectador"
            case .de: return "🐣 Betrachter"
            }
        }
    }
    
    var badgeColor: Color {
        switch self {
        case .leader: return .orange
        case .assistant: return .blue
        case .viewer: return .gray
        }
    }
    
    var canWrite: Bool {
        self == .leader || self == .assistant
    }
}

enum WishlistSortOption: String, CaseIterable, Identifiable {
    case newest
    case schedule
    case likes
    case unscheduledOnly
    
    var id: String { self.rawValue }
    
    func label(for l10n: L10n) -> String {
        switch self {
        case .newest: return l10n.sortNewest
        case .schedule: return l10n.sortSchedule
        case .likes: return l10n.sortLikes
        case .unscheduledOnly: return l10n.sortUnscheduledOnly
        }
    }
    
    var iconName: String {
        switch self {
        case .newest: return "clock.arrow.circlepath"
        case .schedule: return "calendar.badge.clock"
        case .likes: return "hand.thumbsup.fill"
        case .unscheduledOnly: return "tray.fill"
        }
    }
}

struct RoomSetting: Codable, Equatable {
    var roomCode: String
    var isAcceptingMembers: Bool
    var maxDays: Int?
    
    enum CodingKeys: String, CodingKey {
        case roomCode = "room_code"
        case isAcceptingMembers = "is_accepting_members"
        case maxDays = "max_days"
    }
}

struct RoomMember: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var roomCode: String
    var userId: String
    var userName: String
    var role: String
    
    var penguinRole: PenguinRole {
        PenguinRole(rawValue: role) ?? .viewer
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomCode = "room_code"
        case userId = "user_id"
        case userName = "user_name"
        case role
    }
}

struct NoteMetadataParser {
    static var separator: String { AppEnvironment.metaSeparator }
    
    static func sanitizeUserText(_ input: String, allowNewlines: Bool = true) -> String {
        let tokenCore = separator.trimmingCharacters(in: .whitespacesAndNewlines)
        var cleaned = input
            .replacingOccurrences(of: separator, with: " ")
            .replacingOccurrences(of: tokenCore, with: "")
            .replacingOccurrences(of: AppEnvironment.dateConfigPrefix, with: "")
        if !allowNewlines {
            cleaned = cleaned
                .replacingOccurrences(of: "\n", with: " ")
                .replacingOccurrences(of: "\r", with: " ")
        }
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func pack(cleanNote: String, referenceURL: String, expenseAmount: Double?, paidBy: String, timeZoneId: String = "") -> String {
        let safeNote = String(sanitizeUserText(cleanNote, allowNewlines: true).prefix(2000))
        let safeURL = String(sanitizeUserText(referenceURL, allowNewlines: false).prefix(300))
        let safePaidBy = String(sanitizeUserText(paidBy, allowNewlines: false).prefix(50))
        let safeTZ = String(sanitizeUserText(timeZoneId, allowNewlines: false).prefix(60))
        let hasAmount = (expenseAmount ?? 0) > 0
        
        if safeURL.isEmpty && !hasAmount && safePaidBy.isEmpty && safeTZ.isEmpty {
            return safeNote
        }
        
        var metaLines: [String] = []
        if !safeURL.isEmpty {
            metaLines.append("URL=\(safeURL)")
        }
        if let amt = expenseAmount, amt > 0, amt <= 100_000_000 {
            metaLines.append("COST=\(amt)")
        }
        if !safePaidBy.isEmpty {
            metaLines.append("BY=\(safePaidBy)")
        }
        if !safeTZ.isEmpty {
            metaLines.append("TZ=\(safeTZ)")
        }
        return safeNote + separator + metaLines.joined(separator: "\n")
    }
    
    static func unpack(rawNote: String) -> (cleanNote: String, url: String, cost: Double?, paidBy: String, timeZoneId: String) {
        let parts = rawNote.components(separatedBy: separator)
        let mainNote = parts.first ?? rawNote
        guard parts.count > 1 else {
            return (mainNote, "", nil, "", "")
        }
        let metaBlock = parts[1]
        var url = ""
        var cost: Double? = nil
        var paidBy = ""
        var tz = ""
        for line in metaBlock.components(separatedBy: "\n") {
            if line.hasPrefix("URL=") {
                url = String(line.dropFirst(4))
            } else if line.hasPrefix("COST=") {
                if let parsed = Double(String(line.dropFirst(5))), parsed >= 0 {
                    cost = parsed
                }
            } else if line.hasPrefix("BY=") {
                paidBy = String(line.dropFirst(3))
            } else if line.hasPrefix("TZ=") {
                tz = String(line.dropFirst(3))
            }
        }
        return (mainNote, url, cost, paidBy, tz)
    }
}

struct WishlistItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var roomCode: String
    var title: String
    var category: String?
    var localName: String
    var localAddress: String
    var note: String
    var authorName: String
    var authorId: String
    var likes: Int
    var scheduledDay: Int?
    var scheduledTime: String
    
    var displayCategory: String {
        let cat = (category ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        return cat.isEmpty ? "観光地" : cat
    }
    
    var cleanNote: String {
        NoteMetadataParser.unpack(rawNote: note).cleanNote
    }
    
    var referenceURLString: String {
        NoteMetadataParser.unpack(rawNote: note).url
    }
    
    var expenseAmount: Double? {
        NoteMetadataParser.unpack(rawNote: note).cost
    }
    
    var paidBy: String {
        let unpacked = NoteMetadataParser.unpack(rawNote: note).paidBy
        return unpacked.isEmpty ? authorName : unpacked
    }
    
    var timeZoneIdentifier: String {
        NoteMetadataParser.unpack(rawNote: note).timeZoneId
    }
    
    func resolvedGoogleMapsOrWebURL(tripStartDate: Date? = nil) -> URL? {
        let rawURL = referenceURLString.trimmingCharacters(in: .whitespacesAndNewlines)
        if !rawURL.isEmpty {
            if let validURL = URL(string: rawURL),
               let scheme = validURL.scheme?.lowercased(),
               (scheme == "https" || scheme == "http") {
                return validURL
            } else if let httpsURL = URL(string: "https://" + rawURL) {
                return httpsURL
            }
        }
        if let arrowPair = SmartTransitCalculator.splitArrowRoute(from: title) {
            let targetDate = SmartTransitCalculator.resolveScheduledDate(
                tripStartDate: tripStartDate,
                day: scheduledDay,
                timeStr: scheduledTime,
                timeZoneId: timeZoneIdentifier
            )
            return SmartTransitCalculator.makeGoogleMapsDirectionsURL(
                origin: arrowPair.origin,
                destination: arrowPair.destination,
                mode: "transit",
                targetDate: targetDate,
                isArrivalTime: false,
                timeZoneId: timeZoneIdentifier
            )
        }
        return autoGeneratedGoogleMapsURL
    }
    
    var autoGeneratedGoogleMapsURL: URL? {
        let querySource = localName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? title : localName
        let fullQuery = localAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? querySource : "\(querySource) \(localAddress)"
        guard let encoded = fullQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: "https://www.google.com/maps/search/?api=1&query=\(encoded)")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomCode = "room_code"
        case title
        case category
        case localName = "local_name"
        case localAddress = "local_address"
        case note
        case authorName = "author_name"
        case authorId = "author_id"
        case likes
        case scheduledDay = "scheduled_day"
        case scheduledTime = "scheduled_time"
    }
}

struct ChatMessage: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var roomCode: String
    var senderName: String
    var senderId: String
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomCode = "room_code"
        case senderName = "sender_name"
        case senderId = "sender_id"
        case text
    }
}

struct CategoryBadge: View {
    let rawCategory: String
    let l10n: L10n
    
    var badgeColor: Color {
        switch rawCategory {
        case "ごはん", "Food", "Cibo", "Comida", "Essen": return .orange
        case "観光地", "Sightseeing", "Turismo", "Sehenswürdigkeit": return .blue
        case "移動", "Transit", "Trasporto", "Transporte", "Transfer": return .green
        default: return .purple
        }
    }
    
    var iconName: String {
        switch rawCategory {
        case "ごはん", "Food", "Cibo", "Comida", "Essen": return "fork.knife"
        case "観光地", "Sightseeing", "Turismo", "Sehenswürdigkeit": return "camera.fill"
        case "移動", "Transit", "Trasporto", "Transporte", "Transfer": return "tram.fill"
        default: return "tag.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: iconName)
            Text(l10n.localizedCategory(rawCategory))
        }
        .font(.caption)
        .fontWeight(.bold)
        .lineLimit(1)
        .fixedSize(horizontal: true, vertical: false)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(badgeColor.opacity(0.18))
        .foregroundColor(badgeColor)
        .cornerRadius(6)
    }
}

// MARK: - 1.5 1分単位の時刻選択＋数字パッド＋タイムゾーン選択（夏時間自動判定）コンポーネント

struct MinuteTimeInputView: View {
    @Binding var timeString: String
    @Binding var timeZoneId: String
    let referenceDate: Date?
    let l10n: L10n
    
    @State private var selectedHour: Int = 10
    @State private var selectedMinute: Int = 0
    @State private var keypadDigits: String = ""
    @State private var isSyncingFromInternal: Bool = false
    
    var resolvedTimeZone: TimeZone {
        if !timeZoneId.isEmpty, let tz = TimeZone(identifier: timeZoneId) {
            return tz
        }
        return TimeZone.current
    }
    
    var isDaylightSavingActive: Bool {
        resolvedTimeZone.isDaylightSavingTime(for: referenceDate ?? Date())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "globe.americas.fill")
                        .foregroundColor(.blue)
                    Picker(l10n.timeZonePickerLabel, selection: $timeZoneId) {
                        ForEach(TravelTimeZoneOption.presets) { option in
                            Text(option.displayTitle(for: l10n.lang, referenceDate: referenceDate))
                                .tag(option.identifier)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                if isDaylightSavingActive {
                    HStack(spacing: 4) {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.orange)
                        Text(l10n.dstActiveBadge)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    .font(.caption2)
                    .padding(.leading, 26)
                }
                
                Text(l10n.dstAutoHint)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.leading, 26)
            }
            
            Divider()
            
            HStack(spacing: 10) {
                Image(systemName: "number.square.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                TextField(l10n.keypadTimeLabel, text: $keypadDigits)
                    .keyboardType(.numberPad)
                    .font(.headline)
                    .monospacedDigit()
                    .onChange(of: keypadDigits) { newValue in
                        let digits = newValue.filter { $0.isNumber }
                        let limited = String(digits.prefix(4))
                        if limited != newValue {
                            keypadDigits = limited
                            return
                        }
                        if limited.count == 4,
                           let h = Int(limited.prefix(2)),
                           let m = Int(limited.suffix(2)),
                           (0...23).contains(h), (0...59).contains(m) {
                            isSyncingFromInternal = true
                            selectedHour = h
                            selectedMinute = m
                            timeString = String(format: "%02d:%02d", h, m)
                            DispatchQueue.main.async { isSyncingFromInternal = false }
                        } else if limited.count == 3,
                                  let h = Int(limited.prefix(1)),
                                  let m = Int(limited.suffix(2)),
                                  (0...9).contains(h), (0...59).contains(m) {
                            isSyncingFromInternal = true
                            selectedHour = h
                            selectedMinute = m
                            timeString = String(format: "%02d:%02d", h, m)
                            DispatchQueue.main.async { isSyncingFromInternal = false }
                        }
                    }
                
                if !keypadDigits.isEmpty {
                    Button {
                        keypadDigits = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
            
            Divider()
            
            HStack(spacing: 0) {
                Picker("Hour", selection: $selectedHour) {
                    ForEach(0..<24, id: \.self) { h in
                        Text(String(format: "%02d %@", h, l10n.hourUnit)).tag(h)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .clipped()
                .onChange(of: selectedHour) { newH in
                    guard !isSyncingFromInternal else { return }
                    timeString = String(format: "%02d:%02d", newH, selectedMinute)
                }
                
                Text(":")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Picker("Minute", selection: $selectedMinute) {
                    ForEach(0..<60, id: \.self) { m in
                        Text(String(format: "%02d %@", m, l10n.minuteUnit)).tag(m)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .clipped()
                .onChange(of: selectedMinute) { newM in
                    guard !isSyncingFromInternal else { return }
                    timeString = String(format: "%02d:%02d", selectedHour, newM)
                }
            }
        }
        .onAppear {
            parseInitialTime()
        }
        .onChange(of: timeString) { _ in
            if !isSyncingFromInternal {
                parseInitialTime()
            }
        }
    }
    
    private func parseInitialTime() {
        let parts = timeString.split(separator: ":")
        if parts.count == 2,
           let h = Int(parts[0]), (0...23).contains(h),
           let m = Int(parts[1]), (0...59).contains(m) {
            selectedHour = h
            selectedMinute = m
        }
    }
}

// MARK: - 2. 省エネ自動同期＆オフライン送信待ちキュー（Outbox）対応ストア

@MainActor
class TripStore: ObservableObject {
    @Published var hasAcceptedEULA: Bool {
        didSet { UserDefaults.standard.set(hasAcceptedEULA, forKey: "hasAcceptedEULA") }
    }
    @Published var currentRoomCode: String {
        didSet { UserDefaults.standard.set(currentRoomCode, forKey: "currentRoomCode") }
    }
    @Published var userName: String {
        didSet { UserDefaults.standard.set(userName, forKey: "userName") }
    }
    @Published var myUserId: String {
        didSet { UserDefaults.standard.set(myUserId, forKey: "myUserId") }
    }
    @Published var blockedUsersRaw: String {
        didSet { UserDefaults.standard.set(blockedUsersRaw, forKey: "blockedUsersRaw") }
    }
    @Published var appLanguageRaw: String {
        didSet {
            UserDefaults.standard.set(appLanguageRaw, forKey: "appLanguageRaw")
            self.language = AppLanguage(rawValue: appLanguageRaw) ?? .ja
        }
    }
    @Published var chatNotificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(chatNotificationsEnabled, forKey: "chatNotificationsEnabled")
            if chatNotificationsEnabled {
                requestNotificationPermission()
            } else {
                clearUnreadChatBadge()
            }
        }
    }
    @Published var showNextUpWidget: Bool {
        didSet { UserDefaults.standard.set(showNextUpWidget, forKey: "showNextUpWidget") }
    }
    @Published var meshRelayEnabled: Bool {
        didSet {
            UserDefaults.standard.set(meshRelayEnabled, forKey: "meshRelayEnabled")
            mesh.toggleMesh(meshRelayEnabled, roomCode: cleanRoomKey)
        }
    }
    
    @Published var language: AppLanguage = .ja
    var s: L10n { L10n(lang: language) }
    
    let mesh = HybridMeshCoordinator.shared
    
    @Published var items: [WishlistItem] = []
    @Published var messages: [ChatMessage] = []
    @Published var members: [RoomMember] = []
    @Published var myRole: PenguinRole = .viewer
    @Published var isAcceptingMembers: Bool = true
    @Published var maxDays: Int = 3
    @Published var tripStartDate: Date? = nil
    @Published var roomAlertMessage: String? = nil
    
    // チャット通信経路・送達確認（2値）トラッキング
    @Published var netConfirmedIds: Set<UUID> = []  // Supabase（Net）での送受信が確認されたID
    @Published var pendingOutboxIds: Set<UUID> = [] // まだNet同期が完了していない自分の送信待ちID
    
    @Published var unreadChatCount: Int = 0
    @Published var isViewingChatTab: Bool = false {
        didSet {
            if isViewingChatTab {
                markAllChatMessagesAsRead()
            }
        }
    }
    
    private var syncTimer: Timer?
    private var isRegisteringRole = false
    private var knownMembersSnapshot: [String: String]? = nil
    
    private static var dateConfigPrefix: String { AppEnvironment.dateConfigPrefix }
    
    var blockedUserIds: Set<String> {
        Set(blockedUsersRaw.split(separator: ",").map { String($0) })
    }
    
    var filteredItems: [WishlistItem] {
        items.filter {
            !blockedUserIds.contains($0.authorId) && !$0.title.hasPrefix(Self.dateConfigPrefix)
        }
    }
    
    var filteredMessages: [ChatMessage] {
        messages.filter { !blockedUserIds.contains($0.senderId) }
    }
    
    /// 指定メッセージが「送信済（MeshまたはNetで送達確認済）」かどうか（2値判定）
    func isMessageDelivered(_ msg: ChatMessage) -> Bool {
        if netConfirmedIds.contains(msg.id) || mesh.meshDeliveredIds.contains(msg.id) {
            return true
        }
        return !pendingOutboxIds.contains(msg.id)
    }
    
    func targetDateForDay(_ day: Int?) -> Date? {
        guard let start = tripStartDate, let d = day, d >= 1 else { return nil }
        return Calendar.current.date(byAdding: .day, value: d - 1, to: start)
    }
    
    init() {
        UNUserNotificationCenter.current().delegate = ChatNotificationDelegate.shared
        
        self.hasAcceptedEULA = UserDefaults.standard.bool(forKey: "hasAcceptedEULA")
        self.currentRoomCode = UserDefaults.standard.string(forKey: "currentRoomCode") ?? ""
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        
        if let savedUserId = UserDefaults.standard.string(forKey: "myUserId") {
            self.myUserId = savedUserId
        } else {
            let newId = UUID().uuidString
            UserDefaults.standard.set(newId, forKey: "myUserId")
            self.myUserId = newId
        }
        
        self.blockedUsersRaw = UserDefaults.standard.string(forKey: "blockedUsersRaw") ?? ""
        
        if UserDefaults.standard.object(forKey: "chatNotificationsEnabled") == nil {
            self.chatNotificationsEnabled = true
        } else {
            self.chatNotificationsEnabled = UserDefaults.standard.bool(forKey: "chatNotificationsEnabled")
        }
        
        if UserDefaults.standard.object(forKey: "showNextUpWidget") == nil {
            self.showNextUpWidget = true
        } else {
            self.showNextUpWidget = UserDefaults.standard.bool(forKey: "showNextUpWidget")
        }
        
        if UserDefaults.standard.object(forKey: "meshRelayEnabled") == nil {
            self.meshRelayEnabled = true
        } else {
            self.meshRelayEnabled = UserDefaults.standard.bool(forKey: "meshRelayEnabled")
        }
        
        let savedLang = UserDefaults.standard.string(forKey: "appLanguageRaw") ?? AppLanguage.ja.rawValue
        self.appLanguageRaw = savedLang
        self.language = AppLanguage(rawValue: savedLang) ?? .ja
        
        setupMeshCallback()
        
        if !currentRoomCode.isEmpty {
            loadLocalCache()
            connectToRoom()
        }
    }
    
    private func setupMeshCallback() {
        mesh.onMessageReceivedFromMesh = { [weak self] incomingMsg in
            guard let self = self else { return }
            if !self.messages.contains(where: { $0.id == incomingMsg.id }) {
                self.messages.append(incomingMsg)
                self.saveLocalCache()
                self.evaluateNewChatMessagesAndNotify(with: self.messages)
            }
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    private var seenMsgIdsKey: String {
        "seen_chat_ids_\(cleanRoomKey)"
    }
    
    private func loadSeenMessageIds() -> Set<String> {
        guard !cleanRoomKey.isEmpty else { return [] }
        let raw = UserDefaults.standard.string(forKey: seenMsgIdsKey) ?? ""
        return Set(raw.split(separator: ",").map { String($0) })
    }
    
    private func saveSeenMessageIds(_ ids: Set<String>) {
        guard !cleanRoomKey.isEmpty else { return }
        let limited = Array(ids.prefix(300))
        UserDefaults.standard.set(limited.joined(separator: ","), forKey: seenMsgIdsKey)
    }
    
    func markAllChatMessagesAsRead() {
        let allIds = Set(messages.map { $0.id.uuidString })
        var currentSeen = loadSeenMessageIds()
        currentSeen.formUnion(allIds)
        saveSeenMessageIds(currentSeen)
        clearUnreadChatBadge()
    }
    
    func clearUnreadChatBadge() {
        unreadChatCount = 0
        updateSystemAppBadge(0)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    private func updateSystemAppBadge(_ count: Int) {
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(count) { _ in }
        } else {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
    
    private func evaluateNewChatMessagesAndNotify(with chronological: [ChatMessage]) {
        guard !cleanRoomKey.isEmpty else { return }
        var seenIds = loadSeenMessageIds()
        
        if seenIds.isEmpty || isViewingChatTab {
            for m in chronological {
                seenIds.insert(m.id.uuidString)
            }
            saveSeenMessageIds(seenIds)
            if isViewingChatTab {
                clearUnreadChatBadge()
            }
            return
        }
        
        for m in chronological where m.senderId == myUserId {
            seenIds.insert(m.id.uuidString)
        }
        
        let unseenFromOthers = chronological.filter {
            $0.senderId != myUserId &&
            !blockedUserIds.contains($0.senderId) &&
            !seenIds.contains($0.id.uuidString)
        }
        
        let previousUnread = unreadChatCount
        unreadChatCount = unseenFromOthers.count
        
        if chatNotificationsEnabled {
            updateSystemAppBadge(unreadChatCount)
            
            if unreadChatCount > previousUnread, let latest = unseenFromOthers.last {
                sendLocalChatNotification(for: latest, badgeCount: unreadChatCount)
            }
        }
    }
    
    private func sendLocalChatNotification(for msg: ChatMessage, badgeCount: Int) {
        let content = UNMutableNotificationContent()
        content.title = s.newChatNotificationTitle(cleanRoomKey)
        content.subtitle = msg.senderName
        content.body = msg.text
        content.sound = .default
        content.badge = NSNumber(value: badgeCount)
        
        let req = UNNotificationRequest(
            identifier: "chat_\(msg.id.uuidString)",
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(req)
    }
    
    private func evaluateMemberChangesAndNotify(newMembers: [RoomMember]) {
        let currentMap = Dictionary(uniqueKeysWithValues: newMembers.map { ($0.userId, $0.userName) })
        
        guard let previousMap = knownMembersSnapshot else {
            knownMembersSnapshot = currentMap
            return
        }
        
        knownMembersSnapshot = currentMap
        guard chatNotificationsEnabled, !cleanRoomKey.isEmpty else { return }
        
        for (uid, name) in currentMap where uid != myUserId && previousMap[uid] == nil {
            sendMemberEventNotification(id: "member_join_\(uid)_\(Int(Date().timeIntervalSince1970))", body: s.memberJoinedBody(name))
        }
        
        for (uid, oldName) in previousMap where uid != myUserId && currentMap[uid] == nil {
            sendMemberEventNotification(id: "member_leave_\(uid)_\(Int(Date().timeIntervalSince1970))", body: s.memberLeftBody(oldName))
        }
    }
    
    private func sendMemberEventNotification(id: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = s.memberEventNotificationTitle(cleanRoomKey)
        content.body = body
        content.sound = .default
        
        let req = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(req)
    }
    
    private var cleanRoomKey: String {
        currentRoomCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }
    
    private func saveLocalCache() {
        guard !cleanRoomKey.isEmpty else { return }
        if let encodedItems = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedItems, forKey: "cached_items_\(cleanRoomKey)")
        }
        if let encodedMsgs = try? JSONEncoder().encode(messages) {
            UserDefaults.standard.set(encodedMsgs, forKey: "cached_msgs_\(cleanRoomKey)")
        }
        let pendingStrings = pendingOutboxIds.map { $0.uuidString }
        UserDefaults.standard.set(pendingStrings, forKey: "cached_pending_outbox_\(cleanRoomKey)")
        UserDefaults.standard.set(myRole.rawValue, forKey: "cached_role_\(cleanRoomKey)")
        UserDefaults.standard.set(maxDays, forKey: "cached_days_\(cleanRoomKey)")
        
        if let d = tripStartDate {
            UserDefaults.standard.set(d.timeIntervalSince1970, forKey: "cached_startdate_\(cleanRoomKey)")
        } else {
            UserDefaults.standard.removeObject(forKey: "cached_startdate_\(cleanRoomKey)")
        }
    }
    
    private func loadLocalCache() {
        guard !cleanRoomKey.isEmpty else { return }
        if let itemData = UserDefaults.standard.data(forKey: "cached_items_\(cleanRoomKey)"),
           let decodedItems = try? JSONDecoder().decode([WishlistItem].self, from: itemData) {
            self.items = decodedItems
            extractStartDate(from: decodedItems)
        }
        if let msgData = UserDefaults.standard.data(forKey: "cached_msgs_\(cleanRoomKey)"),
           let decodedMsgs = try? JSONDecoder().decode([ChatMessage].self, from: msgData) {
            self.messages = decodedMsgs
        }
        if let pendingArr = UserDefaults.standard.stringArray(forKey: "cached_pending_outbox_\(cleanRoomKey)") {
            self.pendingOutboxIds = Set(pendingArr.compactMap { UUID(uuidString: $0) })
        }
        if let savedRole = UserDefaults.standard.string(forKey: "cached_role_\(cleanRoomKey)"),
           let role = PenguinRole(rawValue: savedRole) {
            self.myRole = role
        }
        let savedDays = UserDefaults.standard.integer(forKey: "cached_days_\(cleanRoomKey)")
        if savedDays > 0 {
            self.maxDays = savedDays
        }
        let savedTimestamp = UserDefaults.standard.double(forKey: "cached_startdate_\(cleanRoomKey)")
        if savedTimestamp > 0 {
            self.tripStartDate = Date(timeIntervalSince1970: savedTimestamp)
        }
    }
    
    private func extractStartDate(from list: [WishlistItem]) {
        if let configItem = list.first(where: { $0.title.hasPrefix(Self.dateConfigPrefix) }) {
            let dateStr = String(configItem.title.dropFirst(Self.dateConfigPrefix.count))
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            if let parsed = formatter.date(from: dateStr) {
                self.tripStartDate = parsed
            }
        } else {
            self.tripStartDate = nil
        }
    }
    
    func setTripStartDate(_ newDate: Date?) {
        guard myRole.canWrite else { return }
        let cleanRoom = cleanRoomKey
        let normalizedDate: Date?
        if let d = newDate {
            normalizedDate = Calendar.current.startOfDay(for: d)
        } else {
            normalizedDate = nil
        }
        self.tripStartDate = normalizedDate
        
        let existingConfig = items.first(where: { $0.title.hasPrefix(Self.dateConfigPrefix) })
        items.removeAll { $0.title.hasPrefix(Self.dateConfigPrefix) }
        
        if let d = normalizedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let dateStr = formatter.string(from: d)
            let configItem = WishlistItem(
                id: existingConfig?.id ?? UUID(),
                roomCode: cleanRoom,
                title: "\(Self.dateConfigPrefix)\(dateStr)",
                category: "system",
                localName: "",
                localAddress: "",
                note: "",
                authorName: userName.isEmpty ? "Member" : userName,
                authorId: myUserId,
                likes: 0,
                scheduledDay: nil,
                scheduledTime: "00:00"
            )
            items.append(configItem)
            saveLocalCache()
            
            Task {
                if let old = existingConfig {
                    let q = [URLQueryItem(name: "id", value: "eq.\(old.id.uuidString)")]
                    if var patchReq = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: q, method: "PATCH", roomCode: cleanRoom) {
                        patchReq.httpBody = try? JSONSerialization.data(withJSONObject: ["title": configItem.title])
                        _ = try? await URLSession.shared.data(for: patchReq)
                    }
                } else {
                    if var postReq = SupabaseConfig.makeRequest(path: "wishlist_items", method: "POST", roomCode: cleanRoom) {
                        postReq.httpBody = try? JSONEncoder().encode(configItem)
                        _ = try? await URLSession.shared.data(for: postReq)
                    }
                }
                await fetchAllData(room: cleanRoom)
            }
        } else {
            saveLocalCache()
            if let old = existingConfig {
                Task {
                    let q = [URLQueryItem(name: "id", value: "eq.\(old.id.uuidString)")]
                    if let delReq = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: q, method: "DELETE", roomCode: cleanRoom) {
                        _ = try? await URLSession.shared.data(for: delReq)
                    }
                    await fetchAllData(room: cleanRoom)
                }
            }
        }
    }
    
    func setAppActive(_ isActive: Bool) {
        if isActive {
            if !cleanRoomKey.isEmpty {
                mesh.toggleMesh(meshRelayEnabled, roomCode: cleanRoomKey)
                startSyncTimer()
                Task { await fetchAllData(room: cleanRoomKey) }
            }
        } else {
            syncTimer?.invalidate()
            syncTimer = nil
        }
    }
    
    private func startSyncTimer() {
        syncTimer?.invalidate()
        syncTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                let room = self.cleanRoomKey
                if !room.isEmpty {
                    await self.fetchAllData(room: room)
                }
            }
        }
    }
    
    func connectToRoom() {
        let cleanRoom = cleanRoomKey
        guard !cleanRoom.isEmpty else { return }
        knownMembersSnapshot = nil
        if chatNotificationsEnabled {
            requestNotificationPermission()
        }
        loadLocalCache()
        mesh.toggleMesh(meshRelayEnabled, roomCode: cleanRoom)
        Task {
            await ensureMemberRole(room: cleanRoom)
            if !self.currentRoomCode.isEmpty {
                await fetchAllData(room: cleanRoom)
            }
        }
        startSyncTimer()
    }
    
    func ensureMemberRole(room: String) async {
        guard !isRegisteringRole else { return }
        isRegisteringRole = true
        defer { isRegisteringRole = false }
        
        let settingQueries = [
            URLQueryItem(name: "room_code", value: "eq.\(room)"),
            URLQueryItem(name: "select", value: "*")
        ]
        var roomAccepting = true
        if let sReq = SupabaseConfig.makeRequest(path: "room_settings", queryItems: settingQueries, roomCode: room),
           let (sData, sRes) = try? await URLSession.shared.data(for: sReq),
           let httpRes = sRes as? HTTPURLResponse, (200...299).contains(httpRes.statusCode),
           let settings = try? JSONDecoder().decode([RoomSetting].self, from: sData),
           let firstSetting = settings.first {
            roomAccepting = firstSetting.isAcceptingMembers
            self.isAcceptingMembers = roomAccepting
            if let days = firstSetting.maxDays, days > 0 {
                self.maxDays = max(self.maxDays, days)
            }
        }
        
        let queries = [
            URLQueryItem(name: "room_code", value: "eq.\(room)"),
            URLQueryItem(name: "select", value: "*"),
            URLQueryItem(name: "order", value: "created_at.asc")
        ]
        guard let req = SupabaseConfig.makeRequest(path: "room_members", queryItems: queries, roomCode: room) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let httpRes = response as? HTTPURLResponse, (200...299).contains(httpRes.statusCode) else { return }
            var existingMembers = try JSONDecoder().decode([RoomMember].self, from: data)
            
            if !existingMembers.isEmpty && !existingMembers.contains(where: { $0.penguinRole == .leader }) {
                let nextLeader = existingMembers.first(where: { $0.penguinRole == .assistant }) ?? existingMembers[0]
                if let idx = existingMembers.firstIndex(where: { $0.id == nextLeader.id }) {
                    existingMembers[idx].role = PenguinRole.leader.rawValue
                }
                let patchQueries = [URLQueryItem(name: "id", value: "eq.\(nextLeader.id.uuidString)")]
                if var patchReq = SupabaseConfig.makeRequest(path: "room_members", queryItems: patchQueries, method: "PATCH", roomCode: room) {
                    patchReq.httpBody = try? JSONSerialization.data(withJSONObject: ["role": PenguinRole.leader.rawValue])
                    _ = try? await URLSession.shared.data(for: patchReq)
                }
            }
            
            if let me = existingMembers.first(where: { $0.userId == myUserId }) {
                self.myRole = me.penguinRole
                self.members = existingMembers
                self.knownMembersSnapshot = Dictionary(uniqueKeysWithValues: existingMembers.map { ($0.userId, $0.userName) })
                saveLocalCache()
            } else {
                if !existingMembers.isEmpty && !roomAccepting {
                    syncTimer?.invalidate()
                    self.currentRoomCode = ""
                    self.roomAlertMessage = s.roomLockedError
                    return
                }
                
                let initialRole: PenguinRole = existingMembers.isEmpty ? .leader : .viewer
                let safeUserName = NoteMetadataParser.sanitizeUserText(userName, allowNewlines: false)
                let newMember = RoomMember(
                    roomCode: room,
                    userId: myUserId,
                    userName: safeUserName.isEmpty ? "Member" : String(safeUserName.prefix(50)),
                    role: initialRole.rawValue
                )
                let updatedList = existingMembers + [newMember]
                self.myRole = initialRole
                self.members = updatedList
                self.knownMembersSnapshot = Dictionary(uniqueKeysWithValues: updatedList.map { ($0.userId, $0.userName) })
                saveLocalCache()
                
                if var postReq = SupabaseConfig.makeRequest(path: "room_members", method: "POST", roomCode: room) {
                    postReq.httpBody = try? JSONEncoder().encode(newMember)
                    _ = try? await URLSession.shared.data(for: postReq)
                }
                
                if existingMembers.isEmpty {
                    let newSetting = RoomSetting(roomCode: room, isAcceptingMembers: true, maxDays: 3)
                    self.isAcceptingMembers = true
                    self.maxDays = 3
                    if var sPost = SupabaseConfig.makeRequest(path: "room_settings", method: "POST", roomCode: room) {
                        sPost.httpBody = try? JSONEncoder().encode(newSetting)
                        _ = try? await URLSession.shared.data(for: sPost)
                    }
                }
            }
        } catch {}
    }
    
    func addNextDay() {
        guard myRole.canWrite else { return }
        maxDays += 1
        saveLocalCache()
        syncRoomSettings()
    }
    
    func clearOrDeleteDay(dayToClear: Int, deleteItemsCompletely: Bool, removeDayTab: Bool) {
        guard myRole.canWrite else { return }
        let cleanRoom = cleanRoomKey
        let targetItems = filteredItems.filter { $0.scheduledDay == dayToClear }
        let laterItems = filteredItems.filter { ($0.scheduledDay ?? 0) > dayToClear }
        
        if deleteItemsCompletely {
            items.removeAll { !$0.title.hasPrefix(Self.dateConfigPrefix) && $0.scheduledDay == dayToClear }
        } else {
            for idx in items.indices where !items[idx].title.hasPrefix(Self.dateConfigPrefix) && items[idx].scheduledDay == dayToClear {
                items[idx].scheduledDay = nil
            }
        }
        
        if removeDayTab && maxDays > 1 {
            for idx in items.indices where !items[idx].title.hasPrefix(Self.dateConfigPrefix) {
                if let d = items[idx].scheduledDay, d > dayToClear {
                    items[idx].scheduledDay = d - 1
                }
            }
            maxDays -= 1
        }
        saveLocalCache()
        
        Task {
            for item in targetItems {
                let q = [URLQueryItem(name: "id", value: "eq.\(item.id.uuidString)")]
                if deleteItemsCompletely {
                    if let req = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: q, method: "DELETE", roomCode: cleanRoom) {
                        _ = try? await URLSession.shared.data(for: req)
                    }
                } else {
                    if var req = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: q, method: "PATCH", roomCode: cleanRoom) {
                        req.httpBody = try? JSONSerialization.data(withJSONObject: ["scheduled_day": NSNull()])
                        _ = try? await URLSession.shared.data(for: req)
                    }
                }
            }
            if removeDayTab {
                for item in laterItems {
                    if let oldDay = item.scheduledDay {
                        let q = [URLQueryItem(name: "id", value: "eq.\(item.id.uuidString)")]
                        if var req = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: q, method: "PATCH", roomCode: cleanRoom) {
                            req.httpBody = try? JSONSerialization.data(withJSONObject: ["scheduled_day": oldDay - 1])
                            _ = try? await URLSession.shared.data(for: req)
                        }
                    }
                }
                syncRoomSettings()
            }
            await fetchAllData(room: cleanRoom)
        }
    }
    
    private func syncRoomSettings() {
        let cleanRoom = cleanRoomKey
        let currentAccept = isAcceptingMembers
        let currentMaxDays = maxDays
        Task {
            let queries = [URLQueryItem(name: "room_code", value: "eq.\(cleanRoom)")]
            if var patchReq = SupabaseConfig.makeRequest(path: "room_settings", queryItems: queries, method: "PATCH", roomCode: cleanRoom) {
                patchReq.setValue("return=representation", forHTTPHeaderField: "Prefer")
                let body: [String: Any] = [
                    "is_accepting_members": currentAccept,
                    "max_days": currentMaxDays
                ]
                patchReq.httpBody = try? JSONSerialization.data(withJSONObject: body)
                if let (data, _) = try? await URLSession.shared.data(for: patchReq),
                   let updated = try? JSONDecoder().decode([RoomSetting].self, from: data),
                   updated.isEmpty {
                    let newSetting = RoomSetting(roomCode: cleanRoom, isAcceptingMembers: currentAccept, maxDays: currentMaxDays)
                    if var postReq = SupabaseConfig.makeRequest(path: "room_settings", method: "POST", roomCode: cleanRoom) {
                        postReq.httpBody = try? JSONEncoder().encode(newSetting)
                        _ = try? await URLSession.shared.data(for: postReq)
                    }
                }
            }
        }
    }
    
    func toggleAcceptingMembers(_ accept: Bool) {
        guard myRole == .leader else { return }
        self.isAcceptingMembers = accept
        syncRoomSettings()
    }
    
    func updateMemberRole(member: RoomMember, newRole: PenguinRole) {
        guard myRole == .leader else { return }
        if let idx = members.firstIndex(where: { $0.id == member.id }) {
            members[idx].role = newRole.rawValue
        }
        let cleanRoom = cleanRoomKey
        Task {
            let queries = [URLQueryItem(name: "id", value: "eq.\(member.id.uuidString)")]
            guard var req = SupabaseConfig.makeRequest(path: "room_members", queryItems: queries, method: "PATCH", roomCode: cleanRoom) else { return }
            let body: [String: String] = ["role": newRole.rawValue]
            req.httpBody = try? JSONSerialization.data(withJSONObject: body)
            _ = try? await URLSession.shared.data(for: req)
            await fetchAllData(room: cleanRoom)
        }
    }
    
    func kickMember(_ member: RoomMember) {
        guard myRole == .leader, member.userId != myUserId else { return }
        members.removeAll { $0.id == member.id }
        knownMembersSnapshot?.removeValue(forKey: member.userId)
        let cleanRoom = cleanRoomKey
        Task {
            let queries = [URLQueryItem(name: "id", value: "eq.\(member.id.uuidString)")]
            if let req = SupabaseConfig.makeRequest(path: "room_members", queryItems: queries, method: "DELETE", roomCode: cleanRoom) {
                _ = try? await URLSession.shared.data(for: req)
            }
            await fetchAllData(room: cleanRoom)
        }
    }
    
    func clearRoomChatHistory() {
        guard myRole == .leader else { return }
        let cleanRoom = cleanRoomKey
        messages = []
        netConfirmedIds = []
        pendingOutboxIds = []
        clearUnreadChatBadge()
        saveLocalCache()
        Task {
            let q = [URLQueryItem(name: "room_code", value: "eq.\(cleanRoom)")]
            if let req = SupabaseConfig.makeRequest(path: "chat_messages", queryItems: q, method: "DELETE", roomCode: cleanRoom) {
                _ = try? await URLSession.shared.data(for: req)
            }
        }
    }
    
    func leaveCurrentRoom() {
        let cleanRoom = cleanRoomKey
        guard !cleanRoom.isEmpty else { return }
        syncTimer?.invalidate()
        mesh.stopMesh()
        let remainingMembers = members.filter { $0.userId != myUserId }
        let wasLeader = (myRole == .leader)
        Task {
            let delQueries = [
                URLQueryItem(name: "room_code", value: "eq.\(cleanRoom)"),
                URLQueryItem(name: "user_id", value: "eq.\(myUserId)")
            ]
            if let delReq = SupabaseConfig.makeRequest(path: "room_members", queryItems: delQueries, method: "DELETE", roomCode: cleanRoom) {
                _ = try? await URLSession.shared.data(for: delReq)
            }
            if !remainingMembers.isEmpty {
                let hasAnotherLeader = remainingMembers.contains { $0.penguinRole == .leader }
                if wasLeader && !hasAnotherLeader {
                    let nextLeader = remainingMembers.first(where: { $0.penguinRole == .assistant }) ?? remainingMembers[0]
                    let patchQueries = [URLQueryItem(name: "id", value: "eq.\(nextLeader.id.uuidString)")]
                    if var patchReq = SupabaseConfig.makeRequest(path: "room_members", queryItems: patchQueries, method: "PATCH", roomCode: cleanRoom) {
                        patchReq.httpBody = try? JSONSerialization.data(withJSONObject: ["role": PenguinRole.leader.rawValue])
                        _ = try? await URLSession.shared.data(for: patchReq)
                    }
                }
            } else {
                await deleteEntireRoomData(room: cleanRoom)
            }
        }
        resetLocalRoomState()
    }
    
    func closeAndDeleteRoom() {
        guard myRole == .leader else { return }
        let cleanRoom = cleanRoomKey
        guard !cleanRoom.isEmpty else { return }
        syncTimer?.invalidate()
        mesh.stopMesh()
        Task {
            await deleteEntireRoomData(room: cleanRoom)
        }
        resetLocalRoomState()
    }
    
    private func deleteEntireRoomData(room: String) async {
        let roomQuery = [URLQueryItem(name: "room_code", value: "eq.\(room)")]
        for table in ["wishlist_items", "chat_messages", "room_members", "room_settings"] {
            if let req = SupabaseConfig.makeRequest(path: table, queryItems: roomQuery, method: "DELETE", roomCode: room) {
                _ = try? await URLSession.shared.data(for: req)
            }
        }
    }
    
    private func resetLocalRoomState() {
        let oldKey = cleanRoomKey
        UserDefaults.standard.removeObject(forKey: "cached_items_\(oldKey)")
        UserDefaults.standard.removeObject(forKey: "cached_msgs_\(oldKey)")
        UserDefaults.standard.removeObject(forKey: "cached_pending_outbox_\(oldKey)")
        UserDefaults.standard.removeObject(forKey: "cached_role_\(oldKey)")
        UserDefaults.standard.removeObject(forKey: "cached_days_\(oldKey)")
        UserDefaults.standard.removeObject(forKey: "cached_startdate_\(oldKey)")
        UserDefaults.standard.removeObject(forKey: "seen_chat_ids_\(oldKey)")
        items = []
        messages = []
        members = []
        netConfirmedIds = []
        pendingOutboxIds = []
        knownMembersSnapshot = nil
        myRole = .viewer
        maxDays = 3
        tripStartDate = nil
        clearUnreadChatBadge()
        currentRoomCode = ""
    }
    
    /// オフライン時に溜まった未送信メッセージ（Outbox）をネット復帰時に自動でSupabaseへ再送
    private func flushPendingOutbox(room: String) async {
        guard !pendingOutboxIds.isEmpty else { return }
        let pendingMessages = messages.filter { pendingOutboxIds.contains($0.id) && $0.roomCode == room }
        for msg in pendingMessages {
            if await postMessageToSupabase(msg, room: room) {
                pendingOutboxIds.remove(msg.id)
                netConfirmedIds.insert(msg.id)
                saveLocalCache()
            }
        }
    }
    
    private func postMessageToSupabase(_ msg: ChatMessage, room: String) async -> Bool {
        guard var req = SupabaseConfig.makeRequest(path: "chat_messages", method: "POST", roomCode: room, timeoutInterval: 8.0) else {
            return false
        }
        req.httpBody = try? JSONEncoder().encode(msg)
        do {
            let (_, response) = try await URLSession.shared.data(for: req)
            if let httpRes = response as? HTTPURLResponse, (200...299).contains(httpRes.statusCode) {
                return true
            }
            // 重複挿入(409 Conflict)の場合もすでにサーバーに存在するため完了扱い
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 409 {
                return true
            }
        } catch {
            return false
        }
        return false
    }
    
    func fetchAllData(room: String) async {
        // 1. まず未送信キューがあれば自動再送を試みる
        await flushPendingOutbox(room: room)
        
        let settingQueries = [
            URLQueryItem(name: "room_code", value: "eq.\(room)"),
            URLQueryItem(name: "select", value: "*")
        ]
        if let sReq = SupabaseConfig.makeRequest(path: "room_settings", queryItems: settingQueries, roomCode: room),
           let (sData, sRes) = try? await URLSession.shared.data(for: sReq),
           let httpRes = sRes as? HTTPURLResponse, (200...299).contains(httpRes.statusCode),
           let settings = try? JSONDecoder().decode([RoomSetting].self, from: sData),
           let first = settings.first {
            if self.isAcceptingMembers != first.isAcceptingMembers {
                self.isAcceptingMembers = first.isAcceptingMembers
            }
            if let days = first.maxDays, days > self.maxDays {
                self.maxDays = days
                self.saveLocalCache()
            }
        }
        
        let memberQueries = [
            URLQueryItem(name: "room_code", value: "eq.\(room)"),
            URLQueryItem(name: "select", value: "*"),
            URLQueryItem(name: "order", value: "created_at.asc")
        ]
        if let req = SupabaseConfig.makeRequest(path: "room_members", queryItems: memberQueries, roomCode: room) {
            if let (data, response) = try? await URLSession.shared.data(for: req),
               let httpRes = response as? HTTPURLResponse, (200...299).contains(httpRes.statusCode),
               var decoded = try? JSONDecoder().decode([RoomMember].self, from: data) {
                
                if !decoded.isEmpty && !decoded.contains(where: { $0.penguinRole == .leader }) {
                    let nextLeader = decoded.first(where: { $0.penguinRole == .assistant }) ?? decoded[0]
                    if let idx = decoded.firstIndex(where: { $0.id == nextLeader.id }) {
                        decoded[idx].role = PenguinRole.leader.rawValue
                    }
                    let patchQueries = [URLQueryItem(name: "id", value: "eq.\(nextLeader.id.uuidString)")]
                    if var patchReq = SupabaseConfig.makeRequest(path: "room_members", queryItems: patchQueries, method: "PATCH", roomCode: room) {
                        patchReq.httpBody = try? JSONSerialization.data(withJSONObject: ["role": PenguinRole.leader.rawValue])
                        _ = try? await URLSession.shared.data(for: patchReq)
                    }
                }
                self.members = decoded
                evaluateMemberChangesAndNotify(newMembers: decoded)
                
                if let me = decoded.first(where: { $0.userId == myUserId }) {
                    if self.myRole != me.penguinRole {
                        self.myRole = me.penguinRole
                        self.saveLocalCache()
                    }
                } else {
                    await ensureMemberRole(room: room)
                }
            }
        }
        
        let itemQueries = [
            URLQueryItem(name: "room_code", value: "eq.\(room)"),
            URLQueryItem(name: "select", value: "*"),
            URLQueryItem(name: "order", value: "created_at.desc"),
            URLQueryItem(name: "limit", value: "200")
        ]
        if let req = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: itemQueries, roomCode: room) {
            if let (data, response) = try? await URLSession.shared.data(for: req),
               let httpRes = response as? HTTPURLResponse, (200...299).contains(httpRes.statusCode),
               let decoded = try? JSONDecoder().decode([WishlistItem].self, from: data) {
                if self.items != decoded {
                    self.items = decoded
                    extractStartDate(from: decoded)
                    let highestScheduled = decoded.compactMap { $0.scheduledDay }.max() ?? 1
                    if highestScheduled > self.maxDays {
                        self.maxDays = highestScheduled
                    }
                    self.saveLocalCache()
                }
            }
        }
        
        // チャット同期：Supabaseの平文メッセージを取得し、ローカル（Mesh受信分・送信待ち分）と統合
        let msgQueries = [
            URLQueryItem(name: "room_code", value: "eq.\(room)"),
            URLQueryItem(name: "select", value: "*"),
            URLQueryItem(name: "order", value: "created_at.desc"),
            URLQueryItem(name: "limit", value: "150")
        ]
        if let req = SupabaseConfig.makeRequest(path: "chat_messages", queryItems: msgQueries, roomCode: room) {
            if let (data, response) = try? await URLSession.shared.data(for: req),
               let httpRes = response as? HTTPURLResponse, (200...299).contains(httpRes.statusCode),
               let decoded = try? JSONDecoder().decode([ChatMessage].self, from: data) {
                let serverChronological = Array(decoded.reversed())
                
                for serverMsg in serverChronological {
                    netConfirmedIds.insert(serverMsg.id)
                    pendingOutboxIds.remove(serverMsg.id)
                }
                
                // サーバーにまだ上がっていないローカル分（Meshのみ受信分・送信待ち分）を保持してマージ
                let serverIdSet = Set(serverChronological.map { $0.id })
                let localOnly = self.messages.filter { !serverIdSet.contains($0.id) }
                let merged = serverChronological + localOnly
                
                if self.messages != merged {
                    self.messages = merged
                    self.saveLocalCache()
                }
                evaluateNewChatMessagesAndNotify(with: self.messages)
            }
        }
    }
    
    // MARK: - データ書き込みアクション
    
    func addItem(title: String, category: String, localName: String, localAddress: String, cleanNote: String, referenceURL: String, expenseAmount: Double?, paidBy: String, scheduledDay: Int? = nil, scheduledTime: String = "10:00", timeZoneId: String = "") {
        guard myRole.canWrite else { return }
        let cleanRoom = cleanRoomKey
        
        let safeTitle = String(NoteMetadataParser.sanitizeUserText(title, allowNewlines: false).prefix(150))
        let safeCategory = String(NoteMetadataParser.sanitizeUserText(category, allowNewlines: false).prefix(40))
        let safeLocalName = String(NoteMetadataParser.sanitizeUserText(localName, allowNewlines: false).prefix(150))
        let safeLocalAddr = String(NoteMetadataParser.sanitizeUserText(localAddress, allowNewlines: false).prefix(200))
        let safeAuthor = String(NoteMetadataParser.sanitizeUserText(userName, allowNewlines: false).prefix(50))
        
        guard !safeTitle.isEmpty else { return }
        
        let packedNote = NoteMetadataParser.pack(
            cleanNote: cleanNote,
            referenceURL: referenceURL,
            expenseAmount: expenseAmount,
            paidBy: paidBy,
            timeZoneId: timeZoneId
        )
        let newItem = WishlistItem(
            roomCode: cleanRoom,
            title: safeTitle,
            category: safeCategory,
            localName: safeLocalName.isEmpty ? safeTitle : safeLocalName,
            localAddress: safeLocalAddr,
            note: packedNote,
            authorName: safeAuthor.isEmpty ? "Member" : safeAuthor,
            authorId: myUserId,
            likes: 1,
            scheduledDay: scheduledDay,
            scheduledTime: scheduledTime
        )
        if let d = scheduledDay, d > maxDays {
            maxDays = d
            syncRoomSettings()
        }
        items.insert(newItem, at: 0)
        saveLocalCache()
        Task {
            guard var req = SupabaseConfig.makeRequest(path: "wishlist_items", method: "POST", roomCode: cleanRoom) else { return }
            req.httpBody = try? JSONEncoder().encode(newItem)
            _ = try? await URLSession.shared.data(for: req)
            await fetchAllData(room: cleanRoom)
        }
    }
    
    func duplicateItem(_ item: WishlistItem) {
        guard myRole.canWrite else { return }
        let unpacked = NoteMetadataParser.unpack(rawNote: item.note)
        addItem(
            title: item.title,
            category: item.displayCategory,
            localName: item.localName,
            localAddress: item.localAddress,
            cleanNote: unpacked.cleanNote,
            referenceURL: unpacked.url,
            expenseAmount: unpacked.cost,
            paidBy: unpacked.paidBy,
            scheduledDay: item.scheduledDay,
            scheduledTime: item.scheduledTime,
            timeZoneId: unpacked.timeZoneId
        )
    }
    
    func updateItemDetails(item: WishlistItem, title: String, category: String, localName: String, localAddress: String, cleanNote: String, referenceURL: String, expenseAmount: Double?, paidBy: String, scheduledDay: Int?, scheduledTime: String, timeZoneId: String) {
        guard myRole.canWrite else { return }
        let packedNote = NoteMetadataParser.pack(
            cleanNote: cleanNote,
            referenceURL: referenceURL,
            expenseAmount: expenseAmount,
            paidBy: paidBy,
            timeZoneId: timeZoneId
        )
        let safeTitle = String(NoteMetadataParser.sanitizeUserText(title, allowNewlines: false).prefix(150))
        let safeCategory = String(NoteMetadataParser.sanitizeUserText(category, allowNewlines: false).prefix(40))
        let rawLocal = NoteMetadataParser.sanitizeUserText(localName, allowNewlines: false)
        let safeLocalName = rawLocal.isEmpty ? safeTitle : String(rawLocal.prefix(150))
        let safeLocalAddr = String(NoteMetadataParser.sanitizeUserText(localAddress, allowNewlines: false).prefix(200))
        
        guard !safeTitle.isEmpty else { return }
        
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx].title = safeTitle
            items[idx].category = safeCategory
            items[idx].localName = safeLocalName
            items[idx].localAddress = safeLocalAddr
            items[idx].note = packedNote
            items[idx].scheduledDay = scheduledDay
            items[idx].scheduledTime = scheduledTime
            if let d = scheduledDay, d > maxDays {
                maxDays = d
                syncRoomSettings()
            }
            saveLocalCache()
        }
        let cleanRoom = cleanRoomKey
        Task {
            let queries = [URLQueryItem(name: "id", value: "eq.\(item.id.uuidString)")]
            guard var req = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: queries, method: "PATCH", roomCode: cleanRoom) else { return }
            var body: [String: Any] = [
                "title": safeTitle,
                "category": safeCategory,
                "local_name": safeLocalName,
                "local_address": safeLocalAddr,
                "note": packedNote,
                "scheduled_time": scheduledTime
            ]
            if let d = scheduledDay {
                body["scheduled_day"] = d
            } else {
                body["scheduled_day"] = NSNull()
            }
            req.httpBody = try? JSONSerialization.data(withJSONObject: body)
            _ = try? await URLSession.shared.data(for: req)
            await fetchAllData(room: cleanRoom)
        }
    }
    
    func addLike(to item: WishlistItem) {
        guard myRole.canWrite else { return }
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx].likes += 1
            saveLocalCache()
        }
        let cleanRoom = cleanRoomKey
        Task {
            let queries = [URLQueryItem(name: "id", value: "eq.\(item.id.uuidString)")]
            guard var req = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: queries, method: "PATCH", roomCode: cleanRoom) else { return }
            let body: [String: Int] = ["likes": item.likes + 1]
            req.httpBody = try? JSONSerialization.data(withJSONObject: body)
            _ = try? await URLSession.shared.data(for: req)
            await fetchAllData(room: cleanRoom)
        }
    }
    
    func assignDay(item: WishlistItem, day: Int?, time: String, timeZoneId: String? = nil) {
        guard myRole.canWrite else { return }
        let unpacked = NoteMetadataParser.unpack(rawNote: item.note)
        let effectiveTZ = timeZoneId ?? unpacked.timeZoneId
        let updatedPackedNote = NoteMetadataParser.pack(
            cleanNote: unpacked.cleanNote,
            referenceURL: unpacked.url,
            expenseAmount: unpacked.cost,
            paidBy: unpacked.paidBy,
            timeZoneId: effectiveTZ
        )
        
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx].scheduledDay = day
            items[idx].scheduledTime = time
            items[idx].note = updatedPackedNote
            if let d = day, d > maxDays {
                maxDays = d
                syncRoomSettings()
            }
            saveLocalCache()
        }
        let cleanRoom = cleanRoomKey
        Task {
            let queries = [URLQueryItem(name: "id", value: "eq.\(item.id.uuidString)")]
            guard var req = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: queries, method: "PATCH", roomCode: cleanRoom) else { return }
            var body: [String: Any] = [
                "scheduled_time": time,
                "note": updatedPackedNote
            ]
            if let day = day {
                body["scheduled_day"] = day
            } else {
                body["scheduled_day"] = NSNull()
            }
            req.httpBody = try? JSONSerialization.data(withJSONObject: body)
            _ = try? await URLSession.shared.data(for: req)
            await fetchAllData(room: cleanRoom)
        }
    }
    
    func deleteItem(_ item: WishlistItem) {
        guard myRole.canWrite else { return }
        items.removeAll { $0.id == item.id }
        saveLocalCache()
        let cleanRoom = cleanRoomKey
        Task {
            let queries = [URLQueryItem(name: "id", value: "eq.\(item.id.uuidString)")]
            guard let req = SupabaseConfig.makeRequest(path: "wishlist_items", queryItems: queries, method: "DELETE", roomCode: cleanRoom) else { return }
            _ = try? await URLSession.shared.data(for: req)
            await fetchAllData(room: cleanRoom)
        }
    }
    
    /// チャット送信：Mesh有効時は暗号化P2P配信を試みつつ、Supabaseへ平文で通常送信（失敗時はOutboxで自動再送待ち）
    func sendMessage(text: String) {
        guard myRole.canWrite else { return }
        let cleanRoom = cleanRoomKey
        let safeText = String(NoteMetadataParser.sanitizeUserText(text, allowNewlines: true).prefix(1000))
        let safeSender = String(NoteMetadataParser.sanitizeUserText(userName, allowNewlines: false).prefix(50))
        guard !safeText.isEmpty else { return }
        
        let plainMsg = ChatMessage(
            roomCode: cleanRoom,
            senderName: safeSender.isEmpty ? "Member" : safeSender,
            senderId: myUserId,
            text: safeText
        )
        messages.append(plainMsg)
        pendingOutboxIds.insert(plainMsg.id)
        
        var seen = loadSeenMessageIds()
        seen.insert(plainMsg.id.uuidString)
        saveSeenMessageIds(seen)
        
        // 1. MeshがONなら暗号化して近距離P2P網へ即時送信
        if meshRelayEnabled {
            mesh.broadcastMessageViaMesh(plainMsg)
        }
        saveLocalCache()
        
        // 2. Supabase（Net）へ平文で通常送信（通報確認対応）。失敗時は pendingOutboxIds に残り自動再送される
        Task {
            let success = await postMessageToSupabase(plainMsg, room: cleanRoom)
            if success {
                self.pendingOutboxIds.remove(plainMsg.id)
                self.netConfirmedIds.insert(plainMsg.id)
                self.saveLocalCache()
                await fetchAllData(room: cleanRoom)
            }
        }
    }
    
    func reportContent(targetId: String, reason: String) {
        let cleanRoom = cleanRoomKey
        Task {
            guard var req = SupabaseConfig.makeRequest(path: "reports", method: "POST", roomCode: cleanRoom) else { return }
            let body: [String: String] = [
                "target_id": String(targetId.prefix(80)),
                "reporter_id": myUserId,
                "reason": String(reason.prefix(200))
            ]
            req.httpBody = try? JSONSerialization.data(withJSONObject: body)
            _ = try? await URLSession.shared.data(for: req)
        }
    }
    
    func blockUser(userId: String) {
        var current = blockedUserIds
        current.insert(userId)
        blockedUsersRaw = current.joined(separator: ",")
        objectWillChange.send()
    }
    
    func switchRoom(to newRoomCode: String) {
        items = []
        messages = []
        members = []
        netConfirmedIds = []
        pendingOutboxIds = []
        knownMembersSnapshot = nil
        myRole = .viewer
        isAcceptingMembers = true
        maxDays = 3
        tripStartDate = nil
        clearUnreadChatBadge()
        let sanitizedRoom = NoteMetadataParser.sanitizeUserText(newRoomCode, allowNewlines: false)
            .uppercased()
        currentRoomCode = String(sanitizedRoom.prefix(40))
        connectToRoom()
    }
}

// MARK: - 3. ルート画面（ver2.0以降 App Store 自動アップデート通知搭載）

struct ContentView: View {
    @StateObject private var store = TripStore()
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var showingUpdateAlert = false
    @State private var latestStoreVersion = ""
    @State private var appStorePageURL: URL? = nil
    
    var body: some View {
        Group {
            if !store.hasAcceptedEULA || store.currentRoomCode.isEmpty {
                OnboardingView(store: store)
            } else {
                MainTabView(store: store)
            }
        }
        .task {
            store.mesh.requestPermissionsOnLaunch()
            await checkForAppStoreUpdate()
        }
        .onChange(of: scenePhase) { newPhase in
            store.setAppActive(newPhase == .active)
            if newPhase == .active {
                Task { await checkForAppStoreUpdate() }
            }
        }
        .onOpenURL { url in
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
               let room = components.queryItems?.first(where: { $0.name == "room" })?.value {
                store.switchRoom(to: room)
            }
        }
        .alert("Alert", isPresented: Binding(
            get: { store.roomAlertMessage != nil },
            set: { if !$0 { store.roomAlertMessage = nil } }
        )) {
            Button("OK", role: .cancel) { store.roomAlertMessage = nil }
        } message: {
            Text(store.roomAlertMessage ?? "")
        }
        .alert(
            store.s.text(
                "新しいバージョン (\(latestStoreVersion)) が公開されています",
                "New Version (\(latestStoreVersion)) Available",
                "Nuova versione (\(latestStoreVersion)) disponibile",
                "Nueva versión (\(latestStoreVersion)) disponible",
                "Neue Version (\(latestStoreVersion)) verfügbar"
            ),
            isPresented: $showingUpdateAlert
        ) {
            if let url = appStorePageURL {
                Link(
                    store.s.text("App Storeで更新する", "Update on App Store", "Aggiorna su App Store", "Actualizar en App Store", "Im App Store aktualisieren"),
                    destination: url
                )
            }
            Button(store.s.text("あとで", "Later", "Più tardi", "Más tarde", "Später"), role: .cancel) { }
        } message: {
            Text(store.s.text(
                "新機能や改善が含まれた最新版のTravelumが利用可能です。全員で快適に使うためアップデートをおすすめします。",
                "A newer version of Travelum with new features and improvements is available on the App Store.",
                "È disponibile una nuova versione di Travelum con nuove funzionalità.",
                "Hay una nueva versión de Travelum disponible con mejoras.",
                "Eine neue Version von Travelum mit Verbesserungen ist verfügbar."
            ))
        }
    }
    
    // App Store の公開バージョンを自動チェック（Bundle ID から自動照会）
    private func checkForAppStoreUpdate() async {
        guard let bundleId = Bundle.main.bundleIdentifier,
              let lookupURL = URL(string: "https://itunes.apple.com/jp/lookup?bundleId=\(bundleId)") else {
            return
        }
        
        // App Settings に設定されたバージョンを取得（未設定時のフォールバックは "2.0"）
        let currentVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "2.0"
        
        // 同じバージョンに対して何度もアラートが出続けないよう記録を確認
        let dismissedVersion = UserDefaults.standard.string(forKey: "dismissed_update_version") ?? ""
        
        do {
            var request = URLRequest(url: lookupURL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 8.0)
            request.httpMethod = "GET"
            
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let results = json["results"] as? [[String: Any]],
               let firstResult = results.first,
               let storeVersion = firstResult["version"] as? String,
               let trackViewUrlStr = firstResult["trackViewUrl"] as? String,
               let trackURL = URL(string: trackViewUrlStr) {
                
                if storeVersion.compare(currentVersion, options: .numeric) == .orderedDescending,
                   storeVersion != dismissedVersion {
                    await MainActor.run {
                        self.latestStoreVersion = storeVersion
                        self.appStorePageURL = trackURL
                        self.showingUpdateAlert = true
                        UserDefaults.standard.set(storeVersion, forKey: "dismissed_update_version")
                    }
                }
            }
        } catch {
            // オフライン時や公開前は静かにスキップ
        }
    }
}


// MARK: - 4. オンボーディング画面

struct OnboardingView: View {
    @ObservedObject var store: TripStore
    @State private var inputRoomCode: String = ""
    @State private var inputName: String = ""
    @State private var agreedToTerms: Bool = false
    @State private var copiedToast: Bool = false
    
    var body: some View {
        let s = store.s
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(s.appTitle)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(s.appSubtitle)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(s.nicknameLabel)
                            .font(.headline)
                        TextField(s.nicknamePlaceholder, text: $inputName)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(s.roomCodeLabel)
                            .font(.headline)
                        TextField(s.roomCodePlaceholder, text: $inputRoomCode)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .textInputAutocapitalization(.characters)
                        
                        HStack(spacing: 12) {
                            Button {
                                inputRoomCode = SupabaseConfig.generateSecureRoomCode()
                            } label: {
                                Label(s.generateCodeBtn, systemImage: "dice.fill")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.blue.opacity(0.15))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            
                            if !inputRoomCode.isEmpty {
                                Button {
                                    UIPasteboard.general.string = inputRoomCode
                                    copiedToast = true
                                } label: {
                                    Label(copiedToast ? s.copiedBtn : s.copyBtn, systemImage: copiedToast ? "checkmark.circle.fill" : "doc.on.doc")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color(.systemGray5))
                                        .foregroundColor(.primary)
                                        .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        Text(s.roomCodeHint)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Toggle(isOn: $agreedToTerms) {
                            Text(s.termsAgreeToggle)
                                .font(.subheadline)
                        }
                        
                        Link(destination: SupabaseConfig.termsURL) {
                            HStack(spacing: 6) {
                                Image(systemName: "doc.text.fill")
                                Text(s.termsReadLink)
                                Image(systemName: "arrow.up.right.square")
                            }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Button(action: {
                        let safeName = NoteMetadataParser.sanitizeUserText(inputName, allowNewlines: false)
                        store.userName = safeName.isEmpty ? "Member" : String(safeName.prefix(50))
                        store.hasAcceptedEULA = true
                        store.switchRoom(to: inputRoomCode)
                    }) {
                        Text(s.joinRoomBtn)
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(agreedToTerms && !inputRoomCode.trimmingCharacters(in: .whitespaces).isEmpty ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    .disabled(!agreedToTerms || inputRoomCode.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(24)
            }
            .onAppear {
                if inputName.isEmpty && !store.userName.isEmpty {
                    inputName = store.userName
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(AppLanguage.allCases) { lang in
                            Button {
                                store.appLanguageRaw = lang.rawValue
                            } label: {
                                HStack {
                                    Text(lang.rawValue)
                                    if store.language == lang {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

// MARK: - 5. メイン4画面タブ

struct MainTabView: View {
    @ObservedObject var store: TripStore
    @State private var showingRoomSettings = false
    @State private var selectedTab: Int = 1
    
    var body: some View {
        let s = store.s
        TabView(selection: $selectedTab) {
            WishlistView(store: store, showingRoomSettings: $showingRoomSettings)
                .tabItem {
                    Label(s.tabWishlist, systemImage: "heart.text.square.fill")
                }
                .tag(0)
            
            ItineraryView(store: store, showingRoomSettings: $showingRoomSettings)
                .tabItem {
                    Label(s.tabItinerary, systemImage: "calendar.day.timeline.left")
                }
                .tag(1)
            
            BudgetTrackerView(store: store, showingRoomSettings: $showingRoomSettings)
                .tabItem {
                    Label(s.tabBudget, systemImage: "yensign.circle.fill")
                }
                .tag(2)
            
            ChatBoardView(store: store, showingRoomSettings: $showingRoomSettings)
                .tabItem {
                    Label(s.tabChat, systemImage: "bubble.left.and.bubble.right.fill")
                }
                .badge(store.unreadChatCount)
                .tag(3)
        }
        .onChange(of: selectedTab) { newTab in
            store.isViewingChatTab = (newTab == 3)
        }
        .sheet(isPresented: $showingRoomSettings) {
            RoomSettingsSheet(store: store)
        }
    }
}

// MARK: - 6. 行きたいリスト画面

struct WishlistView: View {
    @ObservedObject var store: TripStore
    @Binding var showingRoomSettings: Bool
    @State private var showingAddSheet = false
    @State private var selectedTaxiItem: WishlistItem?
    @State private var showingReportAlert = false
    @State private var editingTimeItem: WishlistItem?
    @State private var selectedDetailItem: WishlistItem?
    @State private var sortOption: WishlistSortOption = .newest
    @State private var activeTransitPair: TransitSuggestionPair? = nil
    
    var displayedItems: [WishlistItem] {
        let base = store.filteredItems
        switch sortOption {
        case .newest:
            return base
        case .schedule:
            return base.sorted { a, b in
                switch (a.scheduledDay, b.scheduledDay) {
                case let (dayA?, dayB?):
                    if dayA != dayB { return dayA < dayB }
                    return a.scheduledTime < b.scheduledTime
                case (_?, nil):
                    return true
                case (nil, _?):
                    return false
                case (nil, nil):
                    return false
                }
            }
        case .likes:
            return base.sorted { $0.likes > $1.likes }
        case .unscheduledOnly:
            return base.filter { $0.scheduledDay == nil }
        }
    }
    
    var body: some View {
        let s = store.s
        NavigationStack {
            VStack(spacing: 0) {
                statusBarView(s: s)
                
                if !store.filteredItems.isEmpty {
                    sortFilterBar(s: s)
                }
                
                if store.filteredItems.isEmpty {
                    emptyStateView(s: s)
                } else if displayedItems.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.green)
                        Text(s.emptyUnscheduledTitle)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(Array(displayedItems.enumerated()), id: \.element.id) { index, item in
                            wishlistRow(for: item, s: s)
                            
                            if store.myRole.canWrite,
                               sortOption == .schedule,
                               index < displayedItems.count - 1,
                               let dayA = item.scheduledDay,
                               let dayB = displayedItems[index + 1].scheduledDay,
                               dayA == dayB {
                                let nextItem = displayedItems[index + 1]
                                if SmartTransitCalculator.shouldSuggestTransit(from: item, to: nextItem) {
                                    Button {
                                        activeTransitPair = TransitSuggestionPair(fromItem: item, toItem: nextItem, day: dayA)
                                    } label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "tram.fill")
                                                .font(.caption)
                                                .foregroundColor(.green)
                                            Text(s.suggestTransitBetween(item.title, nextItem.title))
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.green)
                                                .lineLimit(1)
                                            Spacer()
                                            Image(systemName: "sparkles")
                                                .font(.caption2)
                                                .foregroundColor(.green)
                                            Image(systemName: "chevron.right")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.green.opacity(0.12))
                                        .cornerRadius(10)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .refreshable {
                        await store.fetchAllData(room: store.currentRoomCode)
                    }
                }
            }
            .navigationTitle("\(s.tabWishlist) (\(store.currentRoomCode))")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingRoomSettings = true
                    } label: {
                        Label(s.settingsBtn, systemImage: "gearshape.fill")
                            .font(.subheadline)
                    }
                }
                if store.myRole.canWrite {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Label(s.addBtn, systemImage: "plus.circle.fill")
                                .font(.headline)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddWishlistSheet(store: store)
            }
            .sheet(item: $editingTimeItem) { item in
                ScheduleTimeSheet(store: store, item: item)
            }
            .sheet(item: $selectedDetailItem) { item in
                ItemDetailEditSheet(store: store, item: item)
            }
            .sheet(item: $activeTransitPair) { pair in
                TransitSuggestionSheet(store: store, pair: pair)
            }
            .fullScreenCover(item: $selectedTaxiItem) { item in
                TaxiCardView(item: item, tripStartDate: store.tripStartDate, l10n: s)
            }
            .alert(s.reportAlertTitle, isPresented: $showingReportAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(s.reportAlertMsg)
            }
        }
    }
    
    @ViewBuilder
    private func sortFilterBar(s: L10n) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(WishlistSortOption.allCases) { option in
                    let isSelected = (sortOption == option)
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            sortOption = option
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: option.iconName)
                                .font(.caption2)
                            Text(option.label(for: s))
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isSelected ? Color.blue : Color(.systemGray5))
                        .foregroundColor(isSelected ? .white : .primary)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        Divider()
    }
    
    @ViewBuilder
    private func statusBarView(s: L10n) -> some View {
        Button {
            showingRoomSettings = true
        } label: {
            HStack {
                Text(store.myRole.displayName(for: store.language))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(store.myRole.badgeColor)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: store.isAcceptingMembers ? "person.badge.plus" : "lock.fill")
                    Text(store.isAcceptingMembers ? s.statusOpen : s.statusLocked)
                    Image(systemName: "chevron.right")
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func emptyStateView(s: L10n) -> some View {
        Spacer()
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text(s.emptyWishlistTitle)
                .font(.title3)
                .fontWeight(.bold)
            Text(store.myRole.canWrite ? s.emptyWishlistSubWriter : s.emptyWishlistSubViewer)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        Spacer()
    }
    
    @ViewBuilder
    private func wishlistRow(for item: WishlistItem, s: L10n) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                CategoryBadge(rawCategory: item.displayCategory, l10n: s)
                
                if let cost = item.expenseAmount, cost > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "banknote")
                        Text("\(Int(cost)) (\(item.paidBy))")
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.teal.opacity(0.15))
                    .foregroundColor(.teal)
                    .cornerRadius(6)
                }
                
                Spacer()
                
                if let day = item.scheduledDay {
                    let refDate = store.targetDateForDay(day)
                    let tzBadge = TravelTimeZoneOption.shortBadge(for: item.timeZoneIdentifier, referenceDate: refDate)
                    Button {
                        if store.myRole.canWrite {
                            editingTimeItem = item
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text("\(s.dayLabel(day, startDate: store.tripStartDate)) \(item.scheduledTime)")
                            if let tzStr = tzBadge {
                                Text("[\(tzStr)]")
                                    .font(.caption2)
                            }
                            if store.myRole.canWrite {
                                Image(systemName: "clock")
                            }
                        }
                        .font(.caption)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Button {
                selectedDetailItem = item
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    if !item.cleanNote.isEmpty {
                        Text(item.cleanNote)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    Button {
                        store.addLike(to: item)
                    } label: {
                        Label("\(s.likeBtn) (\(item.likes))", systemImage: "hand.thumbsup.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.orange.opacity(0.15))
                            .foregroundColor(.orange)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .disabled(!store.myRole.canWrite)
                    
                    if let mapURL = item.resolvedGoogleMapsOrWebURL(tripStartDate: store.tripStartDate) {
                        Link(destination: mapURL) {
                            Label(item.referenceURLString.isEmpty ? s.googleMapBtn : s.openLinkBtn, systemImage: "map.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Button {
                        selectedTaxiItem = item
                    } label: {
                        Label(s.taxiCardBtn, systemImage: "car.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.yellow.opacity(0.3))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        selectedDetailItem = item
                    } label: {
                        Label(s.detailEditBtn, systemImage: "doc.text.magnifyingglass")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray5))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            HStack {
                Text("\(s.proposedBy): \(item.authorName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Menu {
                    Button {
                        selectedDetailItem = item
                    } label: {
                        Label(s.detailEditBtn, systemImage: "pencil.and.outline")
                    }
                    
                    if store.myRole.canWrite {
                        Button {
                            store.duplicateItem(item)
                        } label: {
                            Label(s.duplicateBtn, systemImage: "plus.square.on.square")
                        }
                        
                        Section(s.tabItinerary) {
                            ForEach(1...store.maxDays, id: \.self) { day in
                                Button(s.assignToDay(day, startDate: store.tripStartDate)) {
                                    store.assignDay(item: item, day: day, time: item.scheduledTime)
                                    var updated = item
                                    updated.scheduledDay = day
                                    editingTimeItem = updated
                                }
                            }
                            Button(s.addNewDayAndAssign(store.maxDays + 1, startDate: store.tripStartDate)) {
                                let newDay = store.maxDays + 1
                                store.assignDay(item: item, day: newDay, time: item.scheduledTime)
                                var updated = item
                                updated.scheduledDay = newDay
                                editingTimeItem = updated
                            }
                            if item.scheduledDay != nil {
                                Button(s.unscheduleBtn) {
                                    store.assignDay(item: item, day: nil, time: item.scheduledTime)
                                }
                            }
                        }
                    }
                    Section {
                        if store.myRole.canWrite {
                            Button(role: .destructive) {
                                store.deleteItem(item)
                            } label: {
                                Label(s.deleteBtn, systemImage: "trash")
                            }
                        }
                        Button(role: .destructive) {
                            store.reportContent(targetId: item.id.uuidString, reason: "Wishlist Report")
                            showingReportAlert = true
                        } label: {
                            Label(s.reportBtn, systemImage: "exclamationmark.bubble")
                        }
                        Button(role: .destructive) {
                            store.blockUser(userId: item.authorId)
                        } label: {
                            Label(s.blockBtn, systemImage: "hand.raised.fill")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - 7. 予定時刻＆タイムゾーンピッカーシート
struct ScheduleTimeSheet: View {
    @ObservedObject var store: TripStore
    let item: WishlistItem
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDay: Int
    @State private var selectedTime: String
    @State private var selectedTimeZoneId: String
    
    init(store: TripStore, item: WishlistItem) {
        self.store = store
        self.item = item
        _selectedDay = State(initialValue: item.scheduledDay ?? 1)
        _selectedTime = State(initialValue: item.scheduledTime)
        _selectedTimeZoneId = State(initialValue: item.timeZoneIdentifier)
    }
    
    var body: some View {
        let s = store.s
        let refDate = store.targetDateForDay(selectedDay)
        NavigationStack {
            Form {
                Section(s.scheduleSectionTitle) {
                    Picker(s.dayPickerLabel, selection: $selectedDay) {
                        ForEach(1...max(store.maxDays, selectedDay), id: \.self) { day in
                            Text(s.dayLabel(day, startDate: store.tripStartDate)).tag(day)
                        }
                    }
                    
                    MinuteTimeInputView(
                        timeString: $selectedTime,
                        timeZoneId: $selectedTimeZoneId,
                        referenceDate: refDate,
                        l10n: s
                    )
                }
            }
            .navigationTitle(item.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(s.cancelBtn) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(s.saveBtn) {
                        store.assignDay(item: item, day: selectedDay, time: selectedTime, timeZoneId: selectedTimeZoneId)
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

// MARK: - 7.5 移動ルート自動サジェスト確認シート（電車・バス・タクシー・自転車・徒歩・時差対応）
struct TransitSuggestionSheet: View {
    @ObservedObject var store: TripStore
    let pair: TransitSuggestionPair
    @Environment(\.dismiss) var dismiss
    
    @State private var isLoading = true
    @State private var options: [TransitRouteOption] = []
    @State private var useArrivalTimeMode: Bool = true
    @State private var copiedTimeToast: Bool = false
    
    var targetTimeStr: String {
        useArrivalTimeMode ? pair.toItem.scheduledTime : pair.fromItem.scheduledTime
    }
    
    var activeTimeZoneId: String {
        useArrivalTimeMode ? pair.toItem.timeZoneIdentifier : pair.fromItem.timeZoneIdentifier
    }
    
    var targetScheduledDate: Date {
        SmartTransitCalculator.resolveScheduledDate(
            tripStartDate: store.tripStartDate,
            day: pair.day,
            timeStr: targetTimeStr,
            timeZoneId: activeTimeZoneId
        )
    }
    
    var fallbackOriginName: String {
        SmartTransitCalculator.splitArrowRoute(from: pair.fromItem.title)?.destination ?? pair.fromItem.title
    }
    
    var fallbackDestName: String {
        SmartTransitCalculator.splitArrowRoute(from: pair.toItem.title)?.origin ?? pair.toItem.title
    }
    
    var body: some View {
        let s = store.s
        let refDate = store.targetDateForDay(pair.day)
        let fromTZBadge = TravelTimeZoneOption.shortBadge(for: pair.fromItem.timeZoneIdentifier, referenceDate: refDate)
        let toTZBadge = TravelTimeZoneOption.shortBadge(for: pair.toItem.timeZoneIdentifier, referenceDate: refDate)
        
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "circle.fill")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text("\(pair.fromItem.scheduledTime)\(fromTZBadge.map { " [\($0)]" } ?? "")  \(pair.fromItem.title)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                    Image(systemName: "arrow.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 3)
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.red)
                        Text("\(pair.toItem.scheduledTime)\(toTZBadge.map { " [\($0)]" } ?? "")  \(pair.toItem.title)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 8) {
                        Picker("TimeMode", selection: $useArrivalTimeMode) {
                            Text("\(s.searchByDepartureMode) (\(pair.fromItem.scheduledTime))").tag(false)
                            Text("\(s.searchByArrivalMode) (\(pair.toItem.scheduledTime))").tag(true)
                        }
                        .pickerStyle(.segmented)
                        
                        Button {
                            let dayText = s.dayLabel(pair.day, startDate: store.tripStartDate)
                            UIPasteboard.general.string = "\(dayText) \(targetTimeStr)"
                            copiedTimeToast = true
                        } label: {
                            Label(copiedTimeToast ? s.copiedBtn : s.copyTimeBtn, systemImage: copiedTimeToast ? "checkmark.circle.fill" : "clock.badge.checkmark")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 4)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                
                if isLoading {
                    Spacer()
                    VStack(spacing: 14) {
                        ProgressView()
                            .scaleEffect(1.3)
                        Text(s.calculatingRouteMsg)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else if options.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "map.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.orange)
                        Text(s.routeNotFoundMsg)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                        if let gURL = SmartTransitCalculator.makeGoogleMapsDirectionsURL(
                            origin: fallbackOriginName,
                            destination: fallbackDestName,
                            mode: "transit",
                            targetDate: targetScheduledDate,
                            isArrivalTime: useArrivalTimeMode,
                            timeZoneId: activeTimeZoneId
                        ) {
                            Link(destination: gURL) {
                                Label("\(s.openRouteInGoogleMaps) (\(targetTimeStr))", systemImage: "map.fill")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(options) { option in
                                optionCard(option, s: s)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(s.transitSheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(s.closeBtn) { dismiss() }
                }
            }
            .task {
                isLoading = true
                options = await SmartTransitCalculator.calculateOptions(
                    from: pair.fromItem,
                    to: pair.toItem,
                    tripStartDate: store.tripStartDate
                )
                isLoading = false
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    @ViewBuilder
    private func optionCard(_ option: TransitRouteOption, s: L10n) -> some View {
        let scheduledStartTime = useArrivalTimeMode ? option.suggestedDepartureTime : pair.fromItem.scheduledTime
        let scheduledEndTime: String = {
            if useArrivalTimeMode {
                return pair.toItem.scheduledTime
            } else {
                let depDate = SmartTransitCalculator.resolveScheduledDate(
                    tripStartDate: store.tripStartDate,
                    day: pair.day,
                    timeStr: pair.fromItem.scheduledTime,
                    timeZoneId: pair.fromItem.timeZoneIdentifier
                )
                let arrDate = depDate.addingTimeInterval(Double(option.durationMinutes * 60))
                return SmartTransitCalculator.formatTime(arrDate, in: pair.toItem.timeZoneIdentifier)
            }
        }()
        
        let gMapURL = SmartTransitCalculator.makeGoogleMapsDirectionsURL(
            origin: option.originQuery,
            destination: option.destinationQuery,
            mode: option.mode.googleTravelMode,
            targetDate: targetScheduledDate,
            isArrivalTime: useArrivalTimeMode,
            timeZoneId: activeTimeZoneId
        )
        let appleMapURL = SmartTransitCalculator.makeAppleMapsDirectionsURL(
            origin: option.originQuery,
            destination: option.destinationQuery,
            dirFlag: option.mode.appleDirFlag
        )
        let distancePart = option.formattedDistance.isEmpty ? "" : " • \(option.formattedDistance)"
        
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(
                    option.mode.title(for: s),
                    systemImage: option.mode.iconName
                )
                .font(.headline)
                .foregroundColor(option.mode.accentColor)
                
                Spacer()
                
                if option.isRecommended {
                    Text(s.recommendedBadge)
                        .font(.caption2)
                        .fontWeight(.heavy)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(s.departAtLabel(scheduledStartTime, scheduledEndTime))
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    Text("\(s.minutesDuration(option.durationMinutes))\(distancePart)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            HStack(spacing: 12) {
                if let dirURL = gMapURL {
                    Link(destination: dirURL) {
                        Label("\(s.openRouteInGoogleMaps) (\(targetTimeStr))", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                if let aURL = appleMapURL {
                    Link(destination: aURL) {
                        Label(s.openRouteInAppleMaps, systemImage: "map")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Button {
                let modeLabel = option.mode.title(for: s)
                let originDisplay = fallbackOriginName
                let destDisplay = fallbackDestName
                let transitTitle = "\(originDisplay) → \(destDisplay)（\(modeLabel)）"
                let distNote = option.formattedDistance.isEmpty ? "" : " (\(option.formattedDistance))"
                let transitNote = "\(modeLabel) / \(s.minutesDuration(option.durationMinutes))\(distNote)\n\(s.departAtLabel(scheduledStartTime, scheduledEndTime))"
                
                store.addItem(
                    title: transitTitle,
                    category: "移動",
                    localName: destDisplay,
                    localAddress: pair.toItem.localAddress,
                    cleanNote: transitNote,
                    referenceURL: gMapURL?.absoluteString ?? "",
                    expenseAmount: nil,
                    paidBy: store.userName.isEmpty ? "Member" : store.userName,
                    scheduledDay: pair.day,
                    scheduledTime: scheduledStartTime,
                    timeZoneId: pair.fromItem.timeZoneIdentifier
                )
                dismiss()
            } label: {
                Label(s.addTransitToPlanBtn, systemImage: "plus.circle.fill")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(option.isRecommended ? Color.blue.opacity(0.4) : Color.gray.opacity(0.2), lineWidth: 1.5)
        )
    }
}

// MARK: - 8. タクシーカード
struct TaxiCardView: View {
    let item: WishlistItem
    var tripStartDate: Date? = nil
    let l10n: L10n
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("✕ \(l10n.closeBtn)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                    }
                }
                .padding()
                Spacer()
                Text(l10n.taxiHeader)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Text(item.localName)
                    .font(.system(size: 42, weight: .heavy))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                if !item.localAddress.isEmpty {
                    Text(item.localAddress)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                Spacer()
                
                VStack(spacing: 12) {
                    if let gMapURL = item.resolvedGoogleMapsOrWebURL(tripStartDate: tripStartDate) {
                        Link(destination: gMapURL) {
                            Label(l10n.openGoogleMapsBtn, systemImage: "globe.asia.australia.fill")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }
                    }
                    
                    if let encoded = item.localName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                       let mapURL = URL(string: "http://maps.apple.com/?q=\(encoded)") {
                        Link(destination: mapURL) {
                            Label(l10n.openMapsBtn, systemImage: "map.fill")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(14)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

// MARK: - 9. 新規追加シート
struct AddWishlistSheet: View {
    @ObservedObject var store: TripStore
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var selectedCategory = "ごはん"
    @State private var customCategory = ""
    @State private var localName = ""
    @State private var localAddress = ""
    @State private var cleanNote = ""
    @State private var referenceURL = ""
    @State private var expenseText = ""
    @State private var paidBy = ""
    @State private var selectedTimeZoneId = ""
    
    var finalCategory: String {
        if selectedCategory == "その他" {
            let trimmed = customCategory.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? store.s.catOther : trimmed
        }
        return selectedCategory
    }
    
    var body: some View {
        let s = store.s
        NavigationStack {
            Form {
                Section(s.selectCategorySec) {
                    Picker("Category", selection: $selectedCategory) {
                        Text(s.catFood).tag("ごはん")
                        Text(s.catSightseeing).tag("観光地")
                        Text(s.catTransit).tag("移動")
                        Text(s.catOther).tag("その他")
                    }
                    .pickerStyle(.segmented)
                    
                    if selectedCategory == "その他" {
                        TextField(s.customTagPlaceholder, text: $customCategory)
                    }
                }
                
                Section(s.basicInfoSec) {
                    TextField(s.titlePlaceholder, text: $title)
                    
                    Picker(s.timeZonePickerLabel, selection: $selectedTimeZoneId) {
                        ForEach(TravelTimeZoneOption.presets) { option in
                            Text(option.displayTitle(for: s.lang, referenceDate: store.tripStartDate))
                                .tag(option.identifier)
                        }
                    }
                }
                
                Section(s.longNoteSec) {
                    ZStack(alignment: .topLeading) {
                        if cleanNote.isEmpty {
                            Text(s.notePlaceholder)
                                .foregroundColor(.secondary.opacity(0.6))
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $cleanNote)
                            .frame(minHeight: 110)
                    }
                }
                
                Section {
                    TextField(s.mapLinkPlaceholder, text: $referenceURL)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } header: {
                    Text(s.mapLinkSec)
                } footer: {
                    Text(s.mapLinkHint)
                }
                
                Section(s.budgetSec) {
                    TextField(s.amountPlaceholder, text: $expenseText)
                        .keyboardType(.decimalPad)
                    
                    HStack {
                        Text(s.paidByLabel)
                        Spacer()
                        TextField(s.paidByPlaceholder, text: $paidBy)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    if !store.members.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(store.members) { member in
                                    Button {
                                        paidBy = member.userName
                                    } label: {
                                        Text(member.userName)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(paidBy == member.userName ? Color.blue : Color(.systemGray5))
                                            .foregroundColor(paidBy == member.userName ? .white : .primary)
                                            .cornerRadius(12)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                
                Section(s.taxiInfoSec) {
                    TextField(s.localNamePlaceholder, text: $localName)
                    TextField(s.localAddrPlaceholder, text: $localAddress)
                }
            }
            .navigationTitle(s.addSheetTitle)
            .onAppear {
                if paidBy.isEmpty {
                    paidBy = store.userName.isEmpty ? "Member" : store.userName
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(s.cancelBtn) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(s.addBtn) {
                        let parsedCost = Double(expenseText.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces))
                        store.addItem(
                            title: title,
                            category: finalCategory,
                            localName: localName,
                            localAddress: localAddress,
                            cleanNote: cleanNote,
                            referenceURL: referenceURL,
                            expenseAmount: parsedCost,
                            paidBy: paidBy,
                            timeZoneId: selectedTimeZoneId
                        )
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

// MARK: - 9.5 予定の詳細・長文メモ編集シート（タイムゾーン＆夏時間自動対応）
struct ItemDetailEditSheet: View {
    @ObservedObject var store: TripStore
    let item: WishlistItem
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var selectedCategory = "観光地"
    @State private var customCategory = ""
    @State private var localName = ""
    @State private var localAddress = ""
    @State private var cleanNote = ""
    @State private var referenceURL = ""
    @State private var expenseText = ""
    @State private var paidBy = ""
    @State private var scheduledDay: Int = 0
    @State private var scheduledTime: String = "10:00"
    @State private var selectedTimeZoneId: String = ""
    
    var finalCategory: String {
        if selectedCategory == "その他" {
            let trimmed = customCategory.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? store.s.catOther : trimmed
        }
        return selectedCategory
    }
    
    var body: some View {
        let s = store.s
        let refDate = scheduledDay > 0 ? store.targetDateForDay(scheduledDay) : store.tripStartDate
        NavigationStack {
            Form {
                if let url = item.resolvedGoogleMapsOrWebURL(tripStartDate: store.tripStartDate) {
                    Section {
                        Link(destination: url) {
                            HStack {
                                Image(systemName: "map.fill")
                                    .foregroundColor(.blue)
                                Text(referenceURL.isEmpty ? s.openGoogleMapsBtn : s.openLinkBtn)
                                    .fontWeight(.bold)
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section(s.longNoteSec) {
                    if store.myRole.canWrite {
                        ZStack(alignment: .topLeading) {
                            if cleanNote.isEmpty {
                                Text(s.notePlaceholder)
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }
                            TextEditor(text: $cleanNote)
                                .frame(minHeight: 160)
                        }
                    } else {
                        Text(cleanNote.isEmpty ? "-" : cleanNote)
                            .font(.body)
                            .padding(.vertical, 4)
                    }
                }
                
                Section(s.basicInfoSec) {
                    TextField(s.titlePlaceholder, text: $title)
                        .disabled(!store.myRole.canWrite)
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text(s.catFood).tag("ごはん")
                        Text(s.catSightseeing).tag("観光地")
                        Text(s.catTransit).tag("移動")
                        Text(s.catOther).tag("その他")
                    }
                    .pickerStyle(.segmented)
                    .disabled(!store.myRole.canWrite)
                    
                    if selectedCategory == "その他" {
                        TextField(s.customTagPlaceholder, text: $customCategory)
                            .disabled(!store.myRole.canWrite)
                    }
                }
                
                Section(s.scheduleSectionTitle) {
                    Picker(s.dayPickerLabel, selection: $scheduledDay) {
                        Text(s.unscheduledOption).tag(0)
                        ForEach(1...max(store.maxDays, scheduledDay), id: \.self) { day in
                            Text(s.dayLabel(day, startDate: store.tripStartDate)).tag(day)
                        }
                    }
                    .disabled(!store.myRole.canWrite)
                    
                    if scheduledDay > 0 {
                        if store.myRole.canWrite {
                            MinuteTimeInputView(
                                timeString: $scheduledTime,
                                timeZoneId: $selectedTimeZoneId,
                                referenceDate: refDate,
                                l10n: s
                            )
                        } else {
                            HStack {
                                Text(s.timePickerLabel)
                                Spacer()
                                Text("\(scheduledTime) \(TravelTimeZoneOption.shortBadge(for: selectedTimeZoneId, referenceDate: refDate).map { "[\($0)]" } ?? "")")
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else if store.myRole.canWrite {
                        Picker(s.timeZonePickerLabel, selection: $selectedTimeZoneId) {
                            ForEach(TravelTimeZoneOption.presets) { option in
                                Text(option.displayTitle(for: s.lang, referenceDate: refDate))
                                    .tag(option.identifier)
                            }
                        }
                    }
                }
                
                Section(s.mapLinkSec) {
                    TextField(s.mapLinkPlaceholder, text: $referenceURL)
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .disabled(!store.myRole.canWrite)
                }
                
                Section(s.budgetSec) {
                    TextField(s.amountPlaceholder, text: $expenseText)
                        .keyboardType(.decimalPad)
                        .disabled(!store.myRole.canWrite)
                    
                    HStack {
                        Text(s.paidByLabel)
                        Spacer()
                        TextField(s.paidByPlaceholder, text: $paidBy)
                            .multilineTextAlignment(.trailing)
                            .disabled(!store.myRole.canWrite)
                    }
                    
                    if store.myRole.canWrite && !store.members.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(store.members) { member in
                                    Button {
                                        paidBy = member.userName
                                    } label: {
                                        Text(member.userName)
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(paidBy == member.userName ? Color.blue : Color(.systemGray5))
                                            .foregroundColor(paidBy == member.userName ? .white : .primary)
                                            .cornerRadius(12)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                
                Section(s.taxiInfoSec) {
                    TextField(s.localNamePlaceholder, text: $localName)
                        .disabled(!store.myRole.canWrite)
                    TextField(s.localAddrPlaceholder, text: $localAddress)
                        .disabled(!store.myRole.canWrite)
                }
            }
            .navigationTitle(s.editSheetTitle)
            .onAppear {
                title = item.title
                let rawCat = item.displayCategory
                if ["ごはん", "観光地", "移動"].contains(rawCat) {
                    selectedCategory = rawCat
                } else {
                    selectedCategory = "その他"
                    customCategory = rawCat
                }
                localName = item.localName
                localAddress = item.localAddress
                let unpacked = NoteMetadataParser.unpack(rawNote: item.note)
                cleanNote = unpacked.cleanNote
                referenceURL = unpacked.url
                if let c = unpacked.cost, c > 0 {
                    expenseText = String(Int(c))
                }
                paidBy = unpacked.paidBy.isEmpty ? item.authorName : unpacked.paidBy
                scheduledDay = item.scheduledDay ?? 0
                scheduledTime = item.scheduledTime
                selectedTimeZoneId = unpacked.timeZoneId
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(s.closeBtn) { dismiss() }
                }
                if store.myRole.canWrite {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(s.saveBtn) {
                            let parsedCost = Double(expenseText.replacingOccurrences(of: ",", with: "").trimmingCharacters(in: .whitespaces))
                            store.updateItemDetails(
                                item: item,
                                title: title,
                                category: finalCategory,
                                localName: localName,
                                localAddress: localAddress,
                                cleanNote: cleanNote,
                                referenceURL: referenceURL,
                                expenseAmount: parsedCost,
                                paidBy: paidBy,
                                scheduledDay: scheduledDay == 0 ? nil : scheduledDay,
                                scheduledTime: scheduledTime,
                                timeZoneId: selectedTimeZoneId
                            )
                            dismiss()
                        }
                        .fontWeight(.bold)
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
            }
        }
    }
}

// MARK: - 10. 旅程表画面
struct ItineraryView: View {
    @ObservedObject var store: TripStore
    @Binding var showingRoomSettings: Bool
    @State private var selectedDay: Int = 1
    @State private var selectedTaxiItem: WishlistItem?
    @State private var editingTimeItem: WishlistItem?
    @State private var selectedDetailItem: WishlistItem?
    @State private var showingDeleteDaySheet = false
    @State private var didAutoSelectToday = false
    @State private var activeTransitPair: TransitSuggestionPair? = nil
    
    var dayItems: [WishlistItem] {
        store.filteredItems
            .filter { $0.scheduledDay == selectedDay }
            .sorted { a, b in
                if a.timeZoneIdentifier != b.timeZoneIdentifier {
                    let dateA = SmartTransitCalculator.resolveScheduledDate(
                        tripStartDate: store.tripStartDate,
                        day: selectedDay,
                        timeStr: a.scheduledTime,
                        timeZoneId: a.timeZoneIdentifier
                    )
                    let dateB = SmartTransitCalculator.resolveScheduledDate(
                        tripStartDate: store.tripStartDate,
                        day: selectedDay,
                        timeStr: b.scheduledTime,
                        timeZoneId: b.timeZoneIdentifier
                    )
                    if dateA != dateB {
                        return dateA < dateB
                    }
                }
                return a.scheduledTime < b.scheduledTime
            }
    }
    
    var realNextUpItem: WishlistItem? {
        guard let startDate = store.tripStartDate else { return nil }
        let cal = Calendar.current
        let todayStart = cal.startOfDay(for: Date())
        let tripStart = cal.startOfDay(for: startDate)
        
        let diffDays = cal.dateComponents([.day], from: tripStart, to: todayStart).day ?? 0
        let currentTripDay = diffDays + 1
        
        if currentTripDay > store.maxDays {
            return nil
        }
        
        let allScheduled = store.filteredItems
            .filter { $0.scheduledDay != nil }
            .sorted { a, b in
                if a.scheduledDay != b.scheduledDay {
                    return (a.scheduledDay ?? 999) < (b.scheduledDay ?? 999)
                }
                return a.scheduledTime < b.scheduledTime
            }
        
        if currentTripDay < 1 {
            return allScheduled.first
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let nowStr = formatter.string(from: Date())
        
        return allScheduled.first { item in
            guard let d = item.scheduledDay else { return false }
            if d > currentTripDay { return true }
            if d == currentTripDay { return item.scheduledTime >= nowStr }
            return false
        }
    }
    
    var body: some View {
        let s = store.s
        NavigationStack {
            VStack(spacing: 0) {
                daySelectorBar(s: s)
                Divider()
                
                if store.showNextUpWidget, let next = realNextUpItem, let nextDay = next.scheduledDay {
                    nextUpQuickWidget(for: next, targetDay: nextDay, s: s)
                }
                
                if dayItems.isEmpty {
                    emptyItineraryView(s: s)
                } else {
                    Text(s.tapToViewDetailHint)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                    
                    List {
                        ForEach(Array(dayItems.enumerated()), id: \.element.id) { index, item in
                            itineraryRow(for: item, s: s)
                            
                            if store.myRole.canWrite,
                               index < dayItems.count - 1 {
                                let nextItem = dayItems[index + 1]
                                if SmartTransitCalculator.shouldSuggestTransit(from: item, to: nextItem) {
                                    transitSuggestionBanner(from: item, to: nextItem, s: s)
                                }
                            }
                        }
                    }
                    .refreshable {
                        await store.fetchAllData(room: store.currentRoomCode)
                    }
                }
            }
            .navigationTitle(s.tabItinerary)
            .onAppear {
                if store.tripStartDate != nil && !didAutoSelectToday {
                    autoSelectTodayIfNeeded()
                }
            }
            .onChange(of: store.tripStartDate) { newDate in
                if newDate != nil {
                    didAutoSelectToday = false
                    autoSelectTodayIfNeeded()
                }
            }
            .onChange(of: store.maxDays) { newMax in
                if selectedDay > newMax {
                    selectedDay = max(1, newMax)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingRoomSettings = true
                    } label: {
                        Label(s.settingsBtn, systemImage: "gearshape.fill")
                            .font(.subheadline)
                    }
                }
                if store.myRole.canWrite {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(role: .destructive) {
                            showingDeleteDaySheet = true
                        } label: {
                            Label(s.manageDayBtn, systemImage: "trash")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .confirmationDialog(
                s.dayLabel(selectedDay, startDate: store.tripStartDate),
                isPresented: $showingDeleteDaySheet,
                titleVisibility: .visible
            ) {
                Button(s.unscheduleAllInDay(selectedDay, startDate: store.tripStartDate)) {
                    store.clearOrDeleteDay(dayToClear: selectedDay, deleteItemsCompletely: false, removeDayTab: false)
                }
                if store.maxDays > 1 {
                    Button(s.removeDayKeepItems(selectedDay, startDate: store.tripStartDate), role: .destructive) {
                        let target = selectedDay
                        if selectedDay == store.maxDays { selectedDay -= 1 }
                        store.clearOrDeleteDay(dayToClear: target, deleteItemsCompletely: false, removeDayTab: true)
                    }
                    Button(s.removeDayDeleteItems(selectedDay, startDate: store.tripStartDate), role: .destructive) {
                        let target = selectedDay
                        if selectedDay == store.maxDays { selectedDay -= 1 }
                        store.clearOrDeleteDay(dayToClear: target, deleteItemsCompletely: true, removeDayTab: true)
                    }
                } else {
                    Button(s.deleteAllInDay(selectedDay, startDate: store.tripStartDate), role: .destructive) {
                        store.clearOrDeleteDay(dayToClear: selectedDay, deleteItemsCompletely: true, removeDayTab: false)
                    }
                }
                Button(s.cancelBtn, role: .cancel) { }
            }
            .fullScreenCover(item: $selectedTaxiItem) { item in
                TaxiCardView(item: item, tripStartDate: store.tripStartDate, l10n: s)
            }
            .sheet(item: $editingTimeItem) { item in
                ScheduleTimeSheet(store: store, item: item)
            }
            .sheet(item: $selectedDetailItem) { item in
                ItemDetailEditSheet(store: store, item: item)
            }
            .sheet(item: $activeTransitPair) { pair in
                TransitSuggestionSheet(store: store, pair: pair)
            }
        }
    }
    
    @ViewBuilder
    private func transitSuggestionBanner(from origin: WishlistItem, to destination: WishlistItem, s: L10n) -> some View {
        Button {
            activeTransitPair = TransitSuggestionPair(fromItem: origin, toItem: destination, day: selectedDay)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "tram.fill")
                    .font(.caption)
                    .foregroundColor(.green)
                Text(s.suggestTransitBetween(origin.title, destination.title))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .lineLimit(1)
                Spacer()
                Image(systemName: "sparkles")
                    .font(.caption2)
                    .foregroundColor(.green)
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.green.opacity(0.14))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
    
    private func autoSelectTodayIfNeeded() {
        guard !didAutoSelectToday, let startDate = store.tripStartDate else { return }
        didAutoSelectToday = true
        let cal = Calendar.current
        let diff = cal.dateComponents([.day], from: cal.startOfDay(for: startDate), to: cal.startOfDay(for: Date())).day ?? 0
        let todayTripDay = diff + 1
        if (1...store.maxDays).contains(todayTripDay) {
            selectedDay = todayTripDay
        }
    }
    
    @ViewBuilder
    private func nextUpQuickWidget(for item: WishlistItem, targetDay: Int, s: L10n) -> some View {
        let refDate = store.targetDateForDay(targetDay)
        let tzBadge = TravelTimeZoneOption.shortBadge(for: item.timeZoneIdentifier, referenceDate: refDate)
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(s.nextUpBadge)
                    .font(.caption2)
                    .fontWeight(.heavy)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                
                Text("\(s.dayLabel(targetDay, startDate: store.tripStartDate)) • \(item.scheduledTime)\(tzBadge.map { " [\($0)]" } ?? "")")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button {
                    withAnimation { store.showNextUpWidget = false }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            
            HStack(alignment: .center, spacing: 10) {
                Button {
                    withAnimation {
                        selectedDay = targetDay
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        if !item.localName.isEmpty && item.localName != item.title {
                            Text(item.localName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                if let mapURL = item.resolvedGoogleMapsOrWebURL(tripStartDate: store.tripStartDate) {
                    Link(destination: mapURL) {
                        Image(systemName: "map.fill")
                            .font(.subheadline)
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                
                Button {
                    selectedTaxiItem = item
                } label: {
                    Image(systemName: "car.fill")
                        .font(.subheadline)
                        .padding(8)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.blue.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.blue.opacity(0.25), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private func daySelectorBar(s: L10n) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(1...store.maxDays, id: \.self) { day in
                    Button {
                        selectedDay = day
                    } label: {
                        Text(s.dayLabel(day, startDate: store.tripStartDate))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedDay == day ? Color.blue : Color(.systemGray5))
                            .foregroundColor(selectedDay == day ? .white : .primary)
                            .cornerRadius(20)
                    }
                    .buttonStyle(.plain)
                }
                
                if store.myRole.canWrite {
                    Button {
                        store.addNextDay()
                        selectedDay = store.maxDays
                    } label: {
                        Label(s.addDayBtn, systemImage: "plus")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.15))
                            .foregroundColor(.blue)
                            .cornerRadius(20)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
    
    @ViewBuilder
    private func emptyItineraryView(s: L10n) -> some View {
        Spacer()
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text(s.emptyItineraryTitle(selectedDay, startDate: store.tripStartDate))
                .font(.title3)
                .fontWeight(.semibold)
            Text(s.emptyItinerarySub)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if store.myRole.canWrite && store.maxDays > 1 {
                Button(role: .destructive) {
                    showingDeleteDaySheet = true
                } label: {
                    Label(s.removeDayKeepItems(selectedDay, startDate: store.tripStartDate), systemImage: "trash")
                        .font(.subheadline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        Spacer()
    }
    
    @ViewBuilder
    private func itineraryRow(for item: WishlistItem, s: L10n) -> some View {
        let refDate = store.targetDateForDay(selectedDay)
        let tzBadge = TravelTimeZoneOption.shortBadge(for: item.timeZoneIdentifier, referenceDate: refDate)
        
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Button {
                    if store.myRole.canWrite {
                        editingTimeItem = item
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(item.scheduledTime)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundColor(.blue)
                        if let tzStr = tzBadge {
                            Text(tzStr)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue.opacity(0.85))
                        }
                        if store.myRole.canWrite {
                            Image(systemName: "clock")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.blue.opacity(0.12))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
                
                CategoryBadge(rawCategory: item.displayCategory, l10n: s)
                
                if let cost = item.expenseAmount, cost > 0 {
                    Text("¥\(Int(cost))")
                        .font(.caption)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .foregroundColor(.teal)
                }
                
                Spacer()
            }
            
            Button {
                selectedDetailItem = item
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    if !item.cleanNote.isEmpty {
                        Text(item.cleanNote)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    if let mapURL = item.resolvedGoogleMapsOrWebURL(tripStartDate: store.tripStartDate) {
                        Link(destination: mapURL) {
                            Label(item.referenceURLString.isEmpty ? s.googleMapBtn : s.openLinkBtn, systemImage: "map.fill")
                                .font(.caption)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Button {
                        selectedTaxiItem = item
                    } label: {
                        Label(s.taxiCardBtn, systemImage: "car.fill")
                            .font(.caption)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Color.yellow.opacity(0.35))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        selectedDetailItem = item
                    } label: {
                        Label(s.detailEditBtn, systemImage: "square.and.pencil")
                            .font(.caption)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Color(.systemGray5))
                            .foregroundColor(.primary)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    if store.myRole.canWrite,
                       let currentIdx = dayItems.firstIndex(where: { $0.id == item.id }),
                       currentIdx < dayItems.count - 1 {
                        let nextItem = dayItems[currentIdx + 1]
                        Button {
                            activeTransitPair = TransitSuggestionPair(fromItem: item, toItem: nextItem, day: selectedDay)
                        } label: {
                            Label(s.catTransit, systemImage: "arrow.triangle.turn.up.right.diamond")
                                .font(.caption)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 7)
                                .background(Color.green.opacity(0.15))
                                .foregroundColor(.green)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - 10.5 旅費・割り勘トラッカー画面
struct BudgetTrackerView: View {
    @ObservedObject var store: TripStore
    @Binding var showingRoomSettings: Bool
    @State private var selectedDetailItem: WishlistItem?
    
    var expenseItems: [WishlistItem] {
        store.filteredItems.filter { ($0.expenseAmount ?? 0) > 0 }
    }
    
    var totalExpense: Double {
        expenseItems.compactMap { $0.expenseAmount }.reduce(0, +)
    }
    
    var participantNames: [String] {
        var names = Set(store.members.map { $0.userName })
        for item in expenseItems {
            if !item.paidBy.isEmpty {
                names.insert(item.paidBy)
            }
        }
        if names.isEmpty {
            names.insert(store.userName.isEmpty ? "Member" : store.userName)
        }
        return Array(names).sorted()
    }
    
    var perPersonShare: Double {
        let count = max(1, participantNames.count)
        return totalExpense / Double(count)
    }
    
    func paidTotal(for person: String) -> Double {
        expenseItems
            .filter { $0.paidBy == person }
            .compactMap { $0.expenseAmount }
            .reduce(0, +)
    }
    
    var body: some View {
        let s = store.s
        NavigationStack {
            Group {
                if expenseItems.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "yensign.circle")
                            .font(.system(size: 52))
                            .foregroundColor(.teal)
                        Text(s.emptyBudgetText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }
                } else {
                    List {
                        Section {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(s.totalBudgetTitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(Int(totalExpense))")
                                    .font(.system(size: 34, weight: .heavy))
                                    .foregroundColor(.primary)
                                Divider()
                                HStack {
                                    Text(s.perPersonTitle(participantNames.count))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("\(Int(perPersonShare.rounded()))")
                                        .font(.headline)
                                        .foregroundColor(.teal)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        
                        Section(s.paidBySummarySec) {
                            ForEach(participantNames, id: \.self) { name in
                                let paid = paidTotal(for: name)
                                let diff = paid - perPersonShare
                                HStack {
                                    Text(name)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(Int(paid))")
                                            .font(.headline)
                                        Text(diff >= 0 ? "+\(Int(diff.rounded()))" : "\(Int(diff.rounded()))")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(diff >= 0 ? .green : .orange)
                                    }
                                }
                            }
                        }
                        
                        Section(s.expenseItemsSec) {
                            ForEach(expenseItems) { item in
                                Button {
                                    selectedDetailItem = item
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(item.title)
                                                .font(.body)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.primary)
                                            Text("\(s.paidByLabel): \(item.paidBy)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Text("\(Int(item.expenseAmount ?? 0))")
                                            .font(.headline)
                                            .foregroundColor(.teal)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .navigationTitle(s.tabBudget)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingRoomSettings = true
                    } label: {
                        Label(s.settingsBtn, systemImage: "gearshape.fill")
                            .font(.subheadline)
                    }
                }
            }
            .sheet(item: $selectedDetailItem) { item in
                ItemDetailEditSheet(store: store, item: item)
            }
        }
    }
}

// MARK: - 11. チャット画面（2種類の通信方式バッジ ＆ 2値の送達確認バッジ表示）
struct ChatBoardView: View {
    @ObservedObject var store: TripStore
    @ObservedObject var mesh = HybridMeshCoordinator.shared
    @Binding var showingRoomSettings: Bool
    @State private var inputText: String = ""
    
    var body: some View {
        let s = store.s
        NavigationStack {
            VStack(spacing: 0) {
                if store.meshRelayEnabled {
                    HStack(spacing: 8) {
                        Image(systemName: mesh.connectedPeersCount > 0 ? "antenna.radiowaves.left.and.right" : "dot.radiowaves.left.and.right")
                            .font(.caption)
                            .foregroundColor(mesh.connectedPeersCount > 0 ? .green : .blue)
                        Text(s.meshStatusText(mesh.connectedPeersCount))
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    Divider()
                }
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 14) {
                            ForEach(store.filteredMessages) { msg in
                                chatRow(for: msg, s: s)
                                    .id(msg.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: store.filteredMessages.count) { _ in
                        if let lastId = store.filteredMessages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                        if store.isViewingChatTab {
                            store.markAllChatMessagesAsRead()
                        }
                    }
                }
                
                Divider()
                
                if store.myRole.canWrite {
                    HStack(spacing: 12) {
                        TextField(s.chatPlaceholder, text: $inputText)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                        
                        Button {
                            store.sendMessage(text: inputText)
                            inputText = ""
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .font(.title2)
                                .padding(10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding()
                } else {
                    Text(s.chatReadOnlyHint)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .navigationTitle(s.tabChat)
            .onAppear {
                store.isViewingChatTab = true
                store.markAllChatMessagesAsRead()
            }
            .onDisappear {
                store.isViewingChatTab = false
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingRoomSettings = true
                    } label: {
                        Label(s.settingsBtn, systemImage: "gearshape.fill")
                            .font(.subheadline)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShareLink(item: s.shareMessage(store.currentRoomCode)) {
                        Label(s.shareBtn, systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func chatRow(for msg: ChatMessage, s: L10n) -> some View {
        let isMesh = mesh.meshDeliveredIds.contains(msg.id)
        let isNet = store.netConfirmedIds.contains(msg.id)
        let isDelivered = store.isMessageDelivered(msg)
        
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(msg.senderName)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                // 1. 通信方式バッジ（2種類：Mesh / Net）
                if isMesh {
                    Label(s.badgeMethodMesh, systemImage: "antenna.radiowaves.left.and.right")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.15))
                        .foregroundColor(.green)
                        .clipShape(Capsule())
                } else if isNet {
                    Label(s.badgeMethodNet, systemImage: "globe")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.15))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                }
                
                // 2. 送達確認バッジ（2値：送信済 / 送信待ち）※自分の送信メッセージに表示
                if msg.senderId == store.myUserId {
                    if isDelivered {
                        Label(s.badgeStatusSent, systemImage: "checkmark.circle.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                    } else {
                        Label(s.badgeStatusPending, systemImage: "clock.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
                
                Spacer()
                Menu {
                    Button(role: .destructive) {
                        store.reportContent(targetId: msg.id.uuidString, reason: "Chat Report")
                    } label: {
                        Label(s.reportBtn, systemImage: "exclamationmark.bubble")
                    }
                    Button(role: .destructive) {
                        store.blockUser(userId: msg.senderId)
                    } label: {
                        Label(s.blockBtn, systemImage: "hand.raised.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }
            }
            Text(LocalizedStringKey(msg.text))
                .font(.title3)
                .tint(.blue)
                .padding(12)
                .background(msg.senderId == store.myUserId ? Color.blue.opacity(0.15) : Color(.systemGray6))
                .cornerRadius(12)
        }
    }
}

// MARK: - 12. ルーム設定画面
struct RoomSettingsSheet: View {
    @ObservedObject var store: TripStore
    @Environment(\.dismiss) var dismiss
    @State private var copiedRoomCode = false
    @State private var showingLeaveConfirm = false
    @State private var showingCloseConfirm = false
    @State private var memberToKick: RoomMember? = nil
    
    var body: some View {
        let s = store.s
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $store.chatNotificationsEnabled) {
                        Text(s.chatNotifToggle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    Toggle(isOn: $store.meshRelayEnabled) {
                        Text(s.meshToggleLabel)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    
                    Toggle(isOn: $store.showNextUpWidget) {
                        Text(s.showNextWidgetToggle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                } header: {
                    Text(s.notifWidgetSec)
                } footer: {
                    Text(s.chatNotifHint)
                }
                
                Section {
                    if store.myRole.canWrite {
                        Toggle(isOn: Binding(
                            get: { store.tripStartDate != nil },
                            set: { isOn in
                                if isOn {
                                    store.setTripStartDate(store.tripStartDate ?? Date())
                                } else {
                                    store.setTripStartDate(nil)
                                }
                            }
                        )) {
                            Text(s.enableTripDateToggle)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        if let currentStart = store.tripStartDate {
                            DatePicker(
                                s.startDatePickerLabel,
                                selection: Binding(
                                    get: { currentStart },
                                    set: { store.setTripStartDate($0) }
                                ),
                                displayedComponents: .date
                            )
                        }
                    } else {
                        HStack {
                            Text(s.startDatePickerLabel)
                                .font(.subheadline)
                            Spacer()
                            if let d = store.tripStartDate {
                                Text(d, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                Text(s.unscheduledOption)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text(s.tripDateSec)
                } footer: {
                    Text(s.tripDateHint)
                }
                
                Section(s.languageSectionTitle) {
                    Picker("Language", selection: Binding(
                        get: { store.language },
                        set: { store.appLanguageRaw = $0.rawValue }
                    )) {
                        ForEach(AppLanguage.allCases) { lang in
                            Text(lang.rawValue).tag(lang)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(s.roomCodeInviteSec) {
                    HStack {
                        Text(store.currentRoomCode)
                            .font(.title3)
                            .fontWeight(.heavy)
                            .monospaced()
                        Spacer()
                        Button {
                            UIPasteboard.general.string = store.currentRoomCode
                            copiedRoomCode = true
                        } label: {
                            Label(copiedRoomCode ? s.copiedBtn : s.copyBtn, systemImage: copiedRoomCode ? "checkmark.circle.fill" : "doc.on.doc")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                        
                        ShareLink(item: s.shareMessage(store.currentRoomCode)) {
                            Label(s.shareBtn, systemImage: "square.and.arrow.up")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.green.opacity(0.15))
                                .foregroundColor(.green)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    if store.myRole == .leader {
                        Toggle(isOn: Binding(
                            get: { store.isAcceptingMembers },
                            set: { store.toggleAcceptingMembers($0) }
                        )) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(s.acceptNewMembersToggle)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(s.acceptNewMembersHint)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        HStack {
                            Text(s.acceptNewMembersToggle)
                                .font(.subheadline)
                            Spacer()
                            Text(store.isAcceptingMembers ? s.statusOpen : s.statusLocked)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(store.isAcceptingMembers ? .green : .red)
                        }
                    }
                }
                
                Section(s.yourRoleSec) {
                    HStack {
                        Text(store.userName.isEmpty ? "Member" : store.userName)
                            .font(.headline)
                        Spacer()
                        Text(store.myRole.displayName(for: store.language))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(store.myRole.badgeColor)
                    }
                }
                
                Section {
                    ForEach(store.members) { member in
                        memberRow(for: member, s: s)
                    }
                } header: {
                    Text(s.membersSec(store.members.count))
                } footer: {
                    Text(s.membersFooter)
                }
                
                Section(s.roomManageSec) {
                    Button {
                        dismiss()
                        store.currentRoomCode = ""
                    } label: {
                        Label(s.switchRoomBtn, systemImage: "arrow.left.arrow.right")
                    }
                    
                    if store.myRole == .leader {
                        Button(role: .destructive) {
                            store.clearRoomChatHistory()
                        } label: {
                            Label(s.clearChatBtn, systemImage: "eraser.line.dashed")
                        }
                    }
                    
                    Button(role: .destructive) {
                        showingLeaveConfirm = true
                    } label: {
                        Label(s.leaveRoomBtn, systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    
                    if store.myRole == .leader {
                        Button(role: .destructive) {
                            showingCloseConfirm = true
                        } label: {
                            Label(s.closeRoomBtn, systemImage: "trash.fill")
                        }
                    }
                }
                
                Section {
                    Link(destination: SupabaseConfig.termsURL) {
                        Label(s.termsReadLink, systemImage: "doc.text")
                    }
                    Link(destination: SupabaseConfig.supportURL) {
                        Label(s.supportLinkLabel, systemImage: "questionmark.circle")
                    }
                }
            }
            .navigationTitle(s.settingsBtn)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(s.closeBtn) { dismiss() }
                        .fontWeight(.bold)
                }
            }
            .alert(s.leaveConfirmTitle, isPresented: $showingLeaveConfirm) {
                Button(s.cancelBtn, role: .cancel) { }
                Button(s.leaveRoomBtn, role: .destructive) {
                    dismiss()
                    store.leaveCurrentRoom()
                }
            } message: {
                Text(s.leaveConfirmMsg)
            }
            .alert(s.closeConfirmTitle, isPresented: $showingCloseConfirm) {
                Button(s.cancelBtn, role: .cancel) { }
                Button(s.deleteBtn, role: .destructive) {
                    dismiss()
                    store.closeAndDeleteRoom()
                }
            } message: {
                Text(s.closeConfirmMsg)
            }
            .alert(s.kickConfirmTitle, isPresented: Binding(
                get: { memberToKick != nil },
                set: { if !$0 { memberToKick = nil } }
            )) {
                Button(s.cancelBtn, role: .cancel) { memberToKick = nil }
                Button(s.kickMemberBtn, role: .destructive) {
                    if let target = memberToKick {
                        store.kickMember(target)
                    }
                    memberToKick = nil
                }
            } message: {
                Text(s.kickConfirmMsg(memberToKick?.userName ?? ""))
            }
        }
    }
    
    @ViewBuilder
    private func memberRow(for member: RoomMember, s: L10n) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(member.userName)
                    .font(.body)
                    .fontWeight(.semibold)
                Text(member.penguinRole.displayName(for: store.language))
                    .font(.caption)
                    .foregroundColor(member.penguinRole.badgeColor)
            }
            Spacer()
            if store.myRole == .leader && member.userId != store.myUserId {
                Menu {
                    Button {
                        store.updateMemberRole(member: member, newRole: .assistant)
                    } label: {
                        Label(s.makeEditorBtn, systemImage: "pencil")
                    }
                    Button {
                        store.updateMemberRole(member: member, newRole: .viewer)
                    } label: {
                        Label(s.makeViewerBtn, systemImage: "eye")
                    }
                    Button {
                        store.updateMemberRole(member: member, newRole: .leader)
                    } label: {
                        Label(s.makeLeaderBtn, systemImage: "crown")
                    }
                    Divider()
                    Button(role: .destructive) {
                        memberToKick = member
                    } label: {
                        Label(s.kickMemberBtn, systemImage: "person.badge.minus")
                    }
                } label: {
                    Text(s.changeRoleBtn)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.15))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
        }
    }
}

