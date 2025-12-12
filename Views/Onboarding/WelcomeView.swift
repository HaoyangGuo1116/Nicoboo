import SwiftUI

struct WelcomeView: View {
    let onNext: () -> Void
    @EnvironmentObject var appState: AppState
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showLogin = false
    @State private var showSignUp = false

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Spacer()

            Image("welcome_bear_thumbsup")
                .resizable()
                .scaledToFit()
                .frame(height: 220)
                .accessibilityHidden(true)

            VStack(spacing: AppSpacing.medium) {
                Text("Congratulations!!")
                    .font(AppTypography.handwritten)
                    .multilineTextAlignment(.center)

                Text("You decided to quit smoking. This is the best decision you have ever made.")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xLarge)

                Text("You can do this!!")
                    .font(AppTypography.title2)
                    .foregroundStyle(AppColors.accentOrange)
            }

            Spacer()

            // Three buttons: Login, Sign Up, Guest Login
            VStack(spacing: AppSpacing.medium) {
                // Login button
                HandDrawnButton(backgroundColor: AppColors.accentGreen, foregroundColor: .white) {
                    showLogin = true
                } label: {
                    Text("Login")
                }
                .padding(.horizontal, AppSpacing.large)
                
                // Sign Up button
                HandDrawnButton(backgroundColor: AppColors.accentBlue, foregroundColor: .white) {
                    showSignUp = true
                } label: {
                    Text("Sign Up")
                }
                .padding(.horizontal, AppSpacing.large)
                
                // Guest Login button (Anonymous Firebase)
                HandDrawnButton(backgroundColor: AppColors.accentYellow, foregroundColor: .white) {
                    Task {
                        await authViewModel.signInAnonymously()
                        if authViewModel.errorMessage == nil {
                            appState.setGuestMode(false)
                            appState.isAuthenticated = true
                            onNext()
                        }
                    }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Continue as Guest")
                    }
                }
                .padding(.horizontal, AppSpacing.large)
                .disabled(authViewModel.isLoading)
            }

            Spacer().frame(height: AppSpacing.large)
        }
        .sheet(isPresented: $showLogin) {
            LoginView(onSuccess: {
                onNext()
            })
            .environmentObject(appState)
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView(onSuccess: {
                onNext()
            })
            .environmentObject(appState)
        }
    }
}

#Preview {
    WelcomeView {}.background(AppColors.background)
}
