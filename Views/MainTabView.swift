//import SwiftUI
//
//struct MainTabView: View {
//    var body: some View {
//        TabView {
//            HomeTabView()
//                .tabItem {
//                    Image("tab_home_active")
//                    Text("Home")
//                }
//
//            Text("Info coming soon")
//                .font(AppTypography.body)
//                .tabItem {
//                    Image("tab_info_inactive")
//                    Text("Info")
//                }
//
//            Text("Participation coming soon")
//                .font(AppTypography.body)
//                .tabItem {
//                    Image("tab_participation_inactive")
//                    Text("Participation")
//                }
//        }
//    }
//}
//
//#Preview {
//    MainTabView()
//        .environmentObject(AppState())
//}

import SwiftUI
import SwiftData
import FirebaseAuth

struct MainTabView: View {

    @Environment(\.modelContext) private var context
    @EnvironmentObject private var appState: AppState
    @StateObject private var achievementVM: AchievementViewModel
    
    init() {
        // Create a temporary container for initialization
        // This will be replaced with the real context in onAppear
        let tempContainer = try! ModelContainer(for: Achievement.self)
        _achievementVM = StateObject(wrappedValue: AchievementViewModel(context: tempContainer.mainContext))
    }

    var body: some View {
        TabView {
            HomeTabView()
                .environmentObject(achievementVM)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            InfoTabView()
                .tabItem {
                    Image(systemName:"info.bubble.fill")
                    Text("Info")
                }

            ParticipationTabView()
                .tabItem {
                    Image(systemName:"flame.fill")
                    Text("Lighter")
                }

            AchievementsGridView()
                .environmentObject(achievementVM)
                .environmentObject(appState)
                .tabItem {
                    Image(systemName:"star.square.on.square.fill")
                    Text("Achievements")
                }
                .badge(achievementVM.unlockedCount)

            ProfileView()
                .environment(\.modelContext, context)
                .environmentObject(appState)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .tint(AppColors.primaryText)
        .onAppear {
            // Update the context with the real app context
            achievementVM.context = context
            // Clear achievements first to ensure clean state
            achievementVM.clearAchievements()
            // Set current user ID for achievements
            updateAchievementUserId()
        }
        .onChange(of: appState.isAuthenticated) { _, _ in
            updateAchievementUserId()
        }
        .onChange(of: appState.userProfile) { _, _ in
            updateAchievementUserId()
        }
        .onChange(of: appState.isGuest) { _, _ in
            updateAchievementUserId()
        }
    }
    
    private func updateAchievementUserId() {
        // Clear achievements first to ensure clean state
        achievementVM.clearAchievements()
        
        // Set user ID from Firebase or use nil for guests
        if appState.isAuthenticated, let userId = FirebaseAuthService.shared.currentUser?.uid {
            // Authenticated user - use Firebase UID
            achievementVM.currentUserId = userId
        } else {
            // Guest user or not logged in - use nil as userId
            // This ensures guest achievements are isolated
            achievementVM.currentUserId = nil
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Achievement.self)
    return MainTabView()
        .environmentObject(AppState())
        .modelContainer(container)
}
