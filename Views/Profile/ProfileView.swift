import SwiftUI
import SwiftData
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var appState: AppState
    
    @State private var showSettings = false
    @State private var showSavingGoals = false
    @State private var showAbout = false
    @State private var showLogoutAlert = false
    @State private var showAvatarSelection = false
    @State private var currentAvatar: String = UserDefaults.standard.string(forKey: "userAvatar") ?? "image-a1"
    
    private var userAvatar: String {
        currentAvatar
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                profileHeader
                
                settingsCard
                
                savingGoalsCard
                
                aboutCard
                
                logoutButton
            }
            .padding(.horizontal, AppSpacing.large)
            .padding(.top, AppSpacing.xLarge)
            .padding(.bottom, AppSpacing.xxLarge)
        }
        .background(AppColors.background.ignoresSafeArea())
        .sheet(isPresented: $showSettings) {
            ProfileSettingsView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showSavingGoals) {
            SavingGoalsView()
                .environment(\.modelContext, context)
                .environmentObject(appState)
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                logout()
            }
        } message: {
            Text("Are you sure you want to logout? Your progress will be saved.")
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: AppSpacing.medium) {
            Button(action: {
                showAvatarSelection = true
            }) {
                Image(userAvatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(AppColors.accentPink, lineWidth: 2)
                    )
            }
            
            Text(userEmail)
                .font(AppTypography.title2)
                .foregroundStyle(AppColors.primaryText)
            
            if let profile = appState.userProfile {
                Text("Smoke-free since \(formattedDate(profile.stopDate))")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.large)
        .sheet(isPresented: $showAvatarSelection) {
            AvatarSelectionView(onAvatarSelected: { avatarName in
                currentAvatar = avatarName
            })
                .environmentObject(appState)
        }
        .onAppear {
            currentAvatar = UserDefaults.standard.string(forKey: "userAvatar") ?? "image-a1"
        }
    }
    
    // MARK: - Settings Card
    private var settingsCard: some View {
        Button(action: { showSettings = true }) {
            HandDrawnCard {
                HStack {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Settings")
                            .font(AppTypography.title3)
                            .foregroundStyle(AppColors.primaryText)
                        
                        Text("Edit stop time, daily habits, and prices")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
        }
    }
    
    // MARK: - Saving Goals Card
    private var savingGoalsCard: some View {
        Button(action: { showSavingGoals = true }) {
            HandDrawnCard {
                HStack {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("Saving Goals")
                            .font(AppTypography.title3)
                            .foregroundStyle(AppColors.primaryText)
                        
                        Text("Set goals and track your savings progress")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
        }
    }
    
    // MARK: - About Card
    private var aboutCard: some View {
        Button(action: { showAbout = true }) {
            HandDrawnCard {
                HStack {
                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                        Text("About")
                            .font(AppTypography.title3)
                            .foregroundStyle(AppColors.primaryText)
                        
                        Text("Medical Disclaimer & Privacy Policy")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
        }
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            showLogoutAlert = true
        }) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Logout")
            }
            .font(AppTypography.callout)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.medium)
            .background(AppColors.accentPink)
            .modifier(HandDrawnBorderModifier(cornerRadius: 8, color: AppColors.accentPink))
        }
        .padding(.top, AppSpacing.large)
    }
    
    // MARK: - Helper Properties
    private var userEmail: String {
        if let email = FirebaseAuthService.shared.currentUser?.email {
            return email
        } else if appState.isAuthenticated {
            return "Authenticated User"
        } else {
            return "Guest User"
        }
    }
    
    // MARK: - Helper Functions
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func logout() {
        // Sign out from Firebase if authenticated
        if appState.isAuthenticated {
            try? FirebaseAuthService.shared.signOut()
        }
        
        // Clear all global state
        appState.setGuestMode(false)
        appState.isAuthenticated = false
        
        // Clear user profile (this will trigger ContentView to show OnboardingContainerView)
        appState.userProfile = nil
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}

