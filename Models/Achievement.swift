//
//  Achievement.swift
//  Nicoboo
//
//  Created by Sabrina Jiang on 11/17/25.
//


import Foundation
import SwiftData

@Model
final class Achievement: Identifiable {
    @Attribute(.unique) var id: String
    var userId: String?  // Associate achievement with user
    var title: String
    var details: String        // description → details
    var requirement: Double
    var requirementType: RequirementType
    var imageName: String
    var isUnlocked: Bool
    var unlockedAt: Date?
    var order: Int

    init(
        id: String = UUID().uuidString,
        userId: String? = nil,
        title: String,
        details: String,
        requirement: Double,
        requirementType: RequirementType,
        imageName: String,
        isUnlocked: Bool = false,
        unlockedAt: Date? = nil,
        order: Int
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.details = details
        self.requirement = requirement
        self.requirementType = requirementType
        self.imageName = imageName
        self.isUnlocked = isUnlocked
        self.unlockedAt = unlockedAt
        self.order = order
    }
}

enum RequirementType: String, Codable {
    case cigarettesAvoided
    case daysWithout
    case hoursOfLife
    case moneySaved
    case daysSmokeFree  // Alias for daysWithout
    case lifeRegained   // Alias for hoursOfLife (stored in hours, converted from minutes)
}
