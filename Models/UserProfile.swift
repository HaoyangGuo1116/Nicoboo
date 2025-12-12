import Foundation

struct UserProfile: Codable, Equatable {
    var smokingType: SmokingType
    var stopDate: Date

    // Smoking
    var cigarettesPerDay: Int?
    var cigarettesPerPack: Int?
    var pricePerPack: Double?

    // Vaping
    var puffsPerDay: Int?
    var podsPerDay: Int? // Pods per day (more reasonable than ml per pod)
    var millilitersPerPod: Double? // Kept for backward compatibility
    var pricePerPod: Double?

    var currencyCode: String

    static let storageKey = "com.nicoboo.userProfile"
}
