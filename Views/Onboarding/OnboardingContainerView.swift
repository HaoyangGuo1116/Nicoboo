import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack {
            Spacer().frame(height: AppSpacing.large)

            progressIndicator

            Spacer().frame(height: AppSpacing.large)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity.animation(.easeInOut(duration: 0.3)))

            Spacer().frame(height: AppSpacing.large)

            
            actionButtons
                .padding(.horizontal, AppSpacing.large)
                .padding(.bottom, AppSpacing.xLarge)
            
        }
        .background(AppColors.background.ignoresSafeArea())
        .animation(.easeInOut, value: viewModel.currentStep)
    }

    private var progressIndicator: some View {
        HStack(spacing: AppSpacing.small) {
            ForEach(OnboardingViewModel.Step.allCases, id: \.self) { step in
                Circle()
                    .fill(step == viewModel.currentStep ? AppColors.accentYellow : AppColors.secondaryText.opacity(0.2))
                    .frame(width: 12, height: 12)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.currentStep {
        case .welcome:
            WelcomeView(onNext: viewModel.advance)
        case .typeSelection:
            TypeSelectionView(selectedType: $viewModel.smokingType)
        case .dataInput:
            DataInputView(viewModel: viewModel)
        case .stopDate:
            StopDateView(stopDate: $viewModel.stopDate)
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        // Hide buttons on welcome page
        if viewModel.currentStep != .welcome {
            HStack(spacing: AppSpacing.medium) {
                // Back button (shown on all pages except welcome)
                HandDrawnButton(backgroundColor: AppColors.accentPink, foregroundColor: .white) {
                    viewModel.goBack()
                } label: {
                    Text("Back")
                }
                .frame(maxWidth: .infinity)
                
                // Next button
                HandDrawnButton(backgroundColor: AppColors.accentGreen, foregroundColor: .white) {
                    if viewModel.currentStep == .stopDate {
                        completeOnboarding()
                    } else {
                        viewModel.advance()
                    }
                } label: {
                    Text(viewModel.currentStep == .stopDate ? "Start" : "Next")
                }
                .frame(maxWidth: .infinity)
                .disabled(!viewModel.canContinue)
                .opacity(viewModel.canContinue ? 1 : 0.5)
            }
        }
    }

    private func completeOnboarding() {
        guard let profile = viewModel.buildProfile() else { return }
        
        // If user is not authenticated, set as guest
        if !appState.isAuthenticated {
            appState.setGuestMode(true)
            appState.isAuthenticated = false
        }
        
        appState.updateProfile(profile)
    }
}

#Preview {
    OnboardingContainerView()
        .environmentObject(AppState())
}
