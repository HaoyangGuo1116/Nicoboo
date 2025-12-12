import Foundation

enum AppConstants {
    static let appName = "Nicoboo"
    static let maxAchievements = 82
    static let baseCurrency = "USD"

    enum Animation {
        static let defaultDuration: TimeInterval = 0.3
        static let springResponse: Double = 0.4
        static let springDamping: Double = 0.8
    }

    enum Timer {
        static let refreshInterval: TimeInterval = 1
    }
}
