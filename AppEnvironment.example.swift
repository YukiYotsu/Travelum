import Foundation

enum AppEnvironment {
    static let projectURL = "https://YOUR_PROJECT_ID.supabase.co"
    static let publishableKey = "YOUR_SUPABASE_ANON_KEY"
    static let termsURL = URL(string: "https://example.com/terms")!
    static let supportURL = URL(string: "https://example.com/support")!
    static let roomHeaderField = "x-room-code"
    static let metaSeparator = "\n---TRV_META---\n"
    static let dateConfigPrefix = "__TRV_START_DATE__:"
}
