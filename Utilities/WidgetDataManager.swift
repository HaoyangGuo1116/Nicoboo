//
//  WidgetDataManager.swift
//  Nicoboo
//
//  Created for Widget data sharing
//

import Foundation

/// Manages data sharing between main app and widget using App Groups
enum WidgetDataManager {
    static let appGroupIdentifier = "group.com.nicoboo.app"
    
    private static var sharedUserDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }
    
    /// Save user profile to shared container for widget access
    static func saveProfile(_ profile: UserProfile) {
        guard let sharedDefaults = sharedUserDefaults,
              let encoded = try? JSONEncoder().encode(profile) else {
            return
        }
        sharedDefaults.set(encoded, forKey: UserProfile.storageKey)
        sharedDefaults.synchronize()
    }
    
    /// Load user profile from shared container
    static func loadProfile() -> UserProfile? {
        guard let sharedDefaults = sharedUserDefaults,
              let data = sharedDefaults.data(forKey: UserProfile.storageKey) else {
            return nil
        }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
    
    /// Calculate current timer breakdown
    static func calculateBreakdown(for profile: UserProfile) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let elapsed = max(Date().timeIntervalSince(profile.stopDate), 0)
        let days = Int(elapsed / 86_400)
        let hours = Int(elapsed.truncatingRemainder(dividingBy: 86_400) / 3_600)
        let minutes = Int(elapsed.truncatingRemainder(dividingBy: 3_600) / 60)
        let seconds = Int(elapsed.truncatingRemainder(dividingBy: 60))
        return (days, hours, minutes, seconds)
    }
    
    /// Calculate cigarettes avoided
    static func calculateCigarettesAvoided(for profile: UserProfile) -> Int {
        guard let cigsPerDay = profile.cigarettesPerDay else { return 0 }
        let elapsedDays = Date().timeIntervalSince(profile.stopDate) / 86_400
        return max(Int(elapsedDays * Double(cigsPerDay)), 0)
    }
    
    /// Calculate money saved
    static func calculateMoneySaved(for profile: UserProfile) -> Double {
        guard let pricePerPack = profile.pricePerPack,
              let cigarettesPerPack = profile.cigarettesPerPack,
              cigarettesPerPack > 0 else { return 0 }
        
        let avoided = calculateCigarettesAvoided(for: profile)
        let packsAvoided = Double(avoided) / Double(cigarettesPerPack)
        return max(packsAvoided * pricePerPack, 0)
    }
}

