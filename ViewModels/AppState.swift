import Combine
import Foundation
import FirebaseAuth

final class AppState: ObservableObject {
    @Published var userProfile: UserProfile? {
        didSet { persistProfile() }
    }
    
    @Published var isAuthenticated: Bool = false
    @Published var isGuest: Bool = false

    private let storage = UserDefaults.standard
    private let authService = FirebaseAuthService.shared

    init() {
        userProfile = loadProfile()
        isAuthenticated = authService.isAuthenticated
        isGuest = storage.bool(forKey: "isGuest")
        
        // Listen to auth changes
        authService.$isAuthenticated
            .assign(to: &$isAuthenticated)
    }

    func updateProfile(_ profile: UserProfile) {
        userProfile = profile
        
        // Save to Firebase if authenticated
        if let userId = authService.currentUser?.uid {
            Task {
                try? await authService.updateUserProfile(userId: userId, profile: profile)
            }
        }
    }
    
    func setGuestMode(_ isGuest: Bool) {
        self.isGuest = isGuest
        storage.set(isGuest, forKey: "isGuest")
    }

    private func persistProfile() {
        guard let userProfile else {
            storage.removeObject(forKey: UserProfile.storageKey)
            // Also remove from shared container for widget
            if let sharedDefaults = UserDefaults(suiteName: WidgetDataManager.appGroupIdentifier) {
                sharedDefaults.removeObject(forKey: UserProfile.storageKey)
            }
            return
        }

        if let encoded = try? JSONEncoder().encode(userProfile) {
            storage.set(encoded, forKey: UserProfile.storageKey)
            // Also save to shared container for widget access
            WidgetDataManager.saveProfile(userProfile)
        }
    }

    private func loadProfile() -> UserProfile? {
        guard let data = storage.data(forKey: UserProfile.storageKey) else {
            return nil
        }

        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
}
