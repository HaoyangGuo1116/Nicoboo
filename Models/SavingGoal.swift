import Foundation
import SwiftData

@Model
final class SavingGoal: Identifiable {
    var id: UUID
    var userId: String?
    var name: String
    var targetAmount: Double
    var imageName: String?
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        userId: String? = nil,
        name: String,
        targetAmount: Double,
        imageName: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.targetAmount = targetAmount
        self.imageName = imageName
        self.createdAt = createdAt
    }
}

// MARK: - Preset Goals
extension SavingGoal {
    static let presetGoals: [(name: String, amount: Double, imageName: String)] = [
        ("MacBook Pro", 2000.0, "laptopcomputer"),
        ("iPhone 15 Pro", 999.0, "iphone"),
        ("Tesla Model 3", 40000.0, "car.fill"),
        ("iPad Pro", 1099.0, "ipad"),
        ("AirPods Pro", 249.0, "airpods"),
        ("Apple Watch", 399.0, "applewatch"),
        ("Gaming PC", 1500.0, "desktopcomputer"),
        ("Vacation Trip", 3000.0, "airplane"),
        ("New Car", 25000.0, "car.fill"),
        ("Designer Bag", 2000.0, "handbag.fill")
    ]
}

