//
//  AchievementViewModel.swift
//  Nicoboo
//
//  Created by Sabrina Jiang on 11/17/25.
//

import Foundation
import SwiftData
import Combine

class AchievementViewModel: ObservableObject {

    @Published var achievements: [Achievement] = []

    // ⚠️ NOT private — so MainTabView can update it
    var context: ModelContext
    
    // Current user ID to filter achievements
    var currentUserId: String? = nil {
        didSet {
            // Always reload when userId changes (even if same value, to ensure clean state)
            if context != nil {
                // Clear achievements array first
                achievements = []
                // Then load achievements for the new user
                loadOrCreateAchievements()
            }
        }
    }

    init(context: ModelContext) {
        self.context = context
        // Don't load achievements in init - wait for userId to be set in MainTabView
    }

    // MARK: - Load Achievements
    func loadOrCreateAchievements() {
        // Filter achievements by current user ID
        var predicate: Predicate<Achievement>?
        if let userId = currentUserId {
            predicate = #Predicate<Achievement> { achievement in
                achievement.userId == userId
            }
        } else {
            // For guest users or when userId is nil, use nil userId
            predicate = #Predicate<Achievement> { achievement in
                achievement.userId == nil
            }
        }
        
        var descriptor = FetchDescriptor<Achievement>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.order)]
        )
        
        if let saved = try? context.fetch(descriptor), !saved.isEmpty {
            // We have existing achievements for this user - merge with defaults to add any new ones
            // Create a set of existing achievement keys (title + requirement + type) to check for duplicates
            let existingKeys = Set(saved.map { "\($0.title)|\($0.requirement)|\($0.requirementType.rawValue)" })
            let defaults = AchievementDefaults.list
            
            // Add any new achievements that don't exist yet (check by title + requirement + type)
            var hasNewAchievements = false
            for defaultAchievement in defaults {
                let key = "\(defaultAchievement.title)|\(defaultAchievement.requirement)|\(defaultAchievement.requirementType.rawValue)"
                if !existingKeys.contains(key) {
                    // Create a copy with the current user ID
                    let userAchievement = Achievement(
                        id: UUID().uuidString, // Use new UUID to avoid conflicts
                        userId: currentUserId,
                        title: defaultAchievement.title,
                        details: defaultAchievement.details,
                        requirement: defaultAchievement.requirement,
                        requirementType: defaultAchievement.requirementType,
                        imageName: defaultAchievement.imageName,
                        isUnlocked: false,
                        unlockedAt: nil,
                        order: defaultAchievement.order
                    )
                    context.insert(userAchievement)
                    hasNewAchievements = true
                }
            }
            
            if hasNewAchievements {
                try? context.save()
            }
            
            // Reload all achievements (including newly added ones)
            if let allAchievements = try? context.fetch(descriptor) {
                self.achievements = allAchievements
            } else {
                self.achievements = saved
            }
        } else {
            // No existing achievements for this user - create all defaults
            let defaults = AchievementDefaults.list
            defaults.forEach { defaultAchievement in
                let userAchievement = Achievement(
                    id: UUID().uuidString, // Use new UUID to avoid conflicts
                    userId: currentUserId,
                    title: defaultAchievement.title,
                    details: defaultAchievement.details,
                    requirement: defaultAchievement.requirement,
                    requirementType: defaultAchievement.requirementType,
                    imageName: defaultAchievement.imageName,
                    isUnlocked: false,
                    unlockedAt: nil,
                    order: defaultAchievement.order
                )
                context.insert(userAchievement)
            }
            try? context.save()
            
            // Reload to get the inserted achievements
            if let allAchievements = try? context.fetch(descriptor) {
                self.achievements = allAchievements
            }
        }
    }

    // MARK: - Update Logic
    func updateProgress(
        cigarettesAvoided: Double,
        daysWithout: Double,
        hoursOfLife: Double,
        moneySaved: Double
    ) {
        var hasChanges = false
        
        for ach in achievements where !ach.isUnlocked {
            let progress: Double

            switch ach.requirementType {
            case .cigarettesAvoided: progress = cigarettesAvoided
            case .daysWithout:       progress = daysWithout
            case .hoursOfLife:       progress = hoursOfLife
            case .moneySaved:        progress = moneySaved
            case .daysSmokeFree:     progress = daysWithout  // Map to daysWithout
            case .lifeRegained:      progress = hoursOfLife   // Map to hoursOfLife (convert minutes to hours in requirement)
            }

            if progress >= ach.requirement {
                ach.isUnlocked = true
                ach.unlockedAt = Date()
                hasChanges = true
            }
        }

        if hasChanges {
            // Save to persistent storage
            try? context.save()
            
            // Force SwiftUI to detect the change by updating the array reference
            // This ensures the UI updates immediately when achievements unlock
            achievements = achievements
        }
    }

    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }
    
    var totalCount: Int {
        achievements.count
    }
    
    // MARK: - Clear Achievements
    func clearAchievements() {
        achievements = []
        currentUserId = nil
    }
}
