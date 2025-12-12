//import SwiftUI
//
//struct HomeTabView: View {
//    @EnvironmentObject var appState: AppState
//
//    var body: some View {
//        if let profile = appState.userProfile {
//            HomeTimerSection(profile: profile)
//                .background(AppColors.background.ignoresSafeArea())
//        } else {
//            Text("No profile found")
//        }
//    }
//}
//
//private struct HomeTimerSection: View {
//    @StateObject private var timerViewModel: TimerViewModel
//
//    init(profile: UserProfile) {
//        _timerViewModel = StateObject(wrappedValue: TimerViewModel(profile: profile))
//    }
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: AppSpacing.large) {
//                timerHeader
//                statisticsSection
//            }
//            .padding(.horizontal, AppSpacing.large)
//            .padding(.top, AppSpacing.xLarge)
//            .padding(.bottom, AppSpacing.xxLarge)
//        }
//    }
//
//    private var timerHeader: some View {
//        HandDrawnCard(backgroundColor: AppColors.accentYellow.opacity(0.2), cornerRadius: 28, padding: AppSpacing.large) {
//            VStack(spacing: AppSpacing.medium) {
//                Text("Non-smoker for")
//                    .font(AppTypography.title2)
//                    .foregroundStyle(AppColors.primaryText)
//
//                Text(formatDuration(timerViewModel.breakdown))
//                    .font(AppTypography.largeTitle)
//                    .foregroundStyle(AppColors.primaryText)
//                    .monospacedDigit()
//
//                Image("timer_clock_illustration")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 120)
//                    .accessibilityHidden(true)
//            }
//        }
//    }
//
//    private var statisticsSection: some View {
//        VStack(spacing: AppSpacing.medium) {
//            StatisticsCardView(
//                title: "Cigarettes not smoked",
//                value: "\(timerViewModel.cigarettesAvoided)",
//                subtitle: "Since your quit date",
//                imageName: "cigarette_crossed"
//            )
//
//            StatisticsCardView(
//                title: "Money saved",
//                value: formattedCurrency(timerViewModel.moneySaved),
//                subtitle: "Based on your daily habits",
//                imageName: "money_bag"
//            )
//        }
//    }
//
//    private func formatDuration(_ breakdown: TimerViewModel.DurationBreakdown) -> String {
//        "\(breakdown.days) day \(pad(breakdown.hours)) hr \(pad(breakdown.minutes)) min \(pad(breakdown.seconds)) sec"
//    }
//
//    private func pad(_ value: Int) -> String {
//        String(format: "%02d", value)
//    }
//
//    private func formattedCurrency(_ value: Double) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.currencyCode = Locale.current.currency?.identifier ?? "USD"
//        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
//    }
//}
//
//#Preview {
//    let profile = UserProfile(
//        smokingType: .smoke,
//        stopDate: Date().addingTimeInterval(-86_400 * 5 - 3_600 * 7 - 120),
//        cigarettesPerDay: 15,
//        cigarettesPerPack: 20,
//        pricePerPack: 12.5,
//        puffsPerDay: nil,
//        millilitersPerPod: nil,
//        pricePerPod: nil,
//        currencyCode: "USD"
//    )
//
//    return HomeTimerSection(profile: profile)
//}

import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var achievementVM: AchievementViewModel     // ⭐ Needed for achievements

    var body: some View {
        if let profile = appState.userProfile {
            HomeTimerSection(profile: profile, achievementVM: achievementVM)
                .background(AppColors.background.ignoresSafeArea())
                .id(profile.stopDate) // Force view refresh when profile changes
        } else {
            Text("No profile found")
        }
    }
}

// MARK: - HOME TIMER SECTION
private struct HomeTimerSection: View {
    @StateObject private var timerViewModel: TimerViewModel
    let profile: UserProfile

    init(profile: UserProfile, achievementVM: AchievementViewModel) {
        self.profile = profile
        let timerVM = TimerViewModel(profile: profile)
        timerVM.achievementVM = achievementVM      // ⭐ Connect achievements
        _timerViewModel = StateObject(wrappedValue: timerVM)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.large) {
                timerHeader
                statisticsSection
            }
            .padding(.horizontal, AppSpacing.large)
            .padding(.top, AppSpacing.xLarge)
            .padding(.bottom, AppSpacing.xxLarge)
        }
        .onAppear {
            // Update timer with current profile
            timerViewModel.updateProfile(profile)
            // Ensure achievements are checked immediately when view appears
            // This handles cases where the timer hasn't ticked yet
            timerViewModel.achievementVM?.updateProgress(
                cigarettesAvoided: Double(timerViewModel.cigarettesAvoided),
                daysWithout: Double(timerViewModel.breakdown.days),
                hoursOfLife: Double(timerViewModel.breakdown.hours + timerViewModel.breakdown.days * 24),
                moneySaved: timerViewModel.moneySaved
            )
        }
        .onChange(of: profile.stopDate) { _, _ in
            timerViewModel.updateProfile(profile)
        }
        .onChange(of: profile.cigarettesPerDay) { _, _ in
            timerViewModel.updateProfile(profile)
        }
        .onChange(of: profile.pricePerPack) { _, _ in
            timerViewModel.updateProfile(profile)
        }
        .onChange(of: profile.cigarettesPerPack) { _, _ in
            timerViewModel.updateProfile(profile)
        }
    }

    // MARK: - TIMER HEADER
    private var timerHeader: some View {
        HandDrawnCard(
            backgroundColor: Color.white,
            cornerRadius: 8,
            padding: AppSpacing.large
        ) {
            VStack(spacing: AppSpacing.medium) {
                Text("Non-smoker for")
                    .font(AppTypography.title2)
                    .foregroundStyle(AppColors.primaryText)

                Text(formatDuration(timerViewModel.breakdown))
                    .font(AppTypography.largeTitle)
                    .foregroundStyle(AppColors.primaryText)
                    .monospacedDigit()

                Image("timer_clock_illustration")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .accessibilityHidden(true)
            }
        }
    }

    // MARK: - STATISTICS SECTION
    private var statisticsSection: some View {
        VStack(spacing: AppSpacing.medium) {
            StatisticsCardView(
                title: "Cigarettes not smoked",
                value: "\(timerViewModel.cigarettesAvoided)",
                subtitle: "Since your quit date",
                imageName: "cigarette_crossed"
            )

            StatisticsCardView(
                title: "Money saved",
                value: formattedCurrency(timerViewModel.moneySaved),
                subtitle: "Based on your daily habits",
                imageName: "money_bag"
            )
        }
    }
}

// MARK: - Helper Formatters
private func formatDuration(_ breakdown: TimerViewModel.DurationBreakdown) -> String {
    "\(breakdown.days) day \(breakdown.hours) hr \(breakdown.minutes) min \(breakdown.seconds) sec"
}

private func formattedCurrency(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
}
