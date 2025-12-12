import Foundation

enum SmokingType: String, Codable, CaseIterable, Identifiable {
    case smoke
    case vape
    case both

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .smoke:
            return "I smoke"
        case .vape:
            return "I vape"
        case .both:
            return "Both"
        }
    }
}
