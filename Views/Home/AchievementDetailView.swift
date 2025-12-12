//
//  AchievementDetailView.swift
//  Nicoboo
//
//  Created on 11/30/25.
//

import SwiftUI
import SwiftData

struct AchievementDetailView: View {
    let achievement: Achievement
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var achievementVM: AchievementViewModel
    @State private var timerViewModel: TimerViewModel?
    @State private var shareItems: [Any] = []
    @State private var showShareSheet = false
    
    init(achievement: Achievement, profile: UserProfile?) {
        self.achievement = achievement
        if let profile = profile {
            _timerViewModel = State(initialValue: TimerViewModel(profile: profile))
        } else {
            _timerViewModel = State(initialValue: nil)
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    // Large badge illustration
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .grayscale(achievement.isUnlocked ? 0.0 : 1.0)
                        .opacity(achievement.isUnlocked ? 1.0 : 0.5)
                        .padding(.top, AppSpacing.large)
                    
                    // Achievement title
                    Text(achievement.title)
                        .font(AppTypography.title1)
                        .foregroundStyle(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.large)
                    
                    // Description
                    Text(achievement.details)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.large)
                    
                    // Status section
                    if achievement.isUnlocked {
                        unlockedStatusView
                    } else {
                        lockedStatusView
                    }
                    
                    // Share button (only for unlocked achievements)
                    if achievement.isUnlocked {
                        shareButton
                            .padding(.horizontal, AppSpacing.large)
                            .padding(.bottom, AppSpacing.xxLarge)
                    }
                }
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(AppColors.primaryText)
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if !shareItems.isEmpty {
                ShareSheet(activityItems: shareItems)
            }
        }
    }
    
    private var imageName: String {
        achievement.imageName
    }
    
    // MARK: - Unlocked Status View
    private var unlockedStatusView: some View {
        VStack(spacing: AppSpacing.medium) {
            Text("You did it!")
                .font(AppTypography.title2)
                .foregroundStyle(AppColors.primaryText)
            
            Text(encouragementMessage(for: achievement))
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.large)
            
            if let unlockedAt = achievement.unlockedAt {
                Text("Unlocked at: \(formatDate(unlockedAt))")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
        .padding(.vertical, AppSpacing.medium)
    }
    
    // MARK: - Encouragement Message
    private func encouragementMessage(for achievement: Achievement) -> String {
        switch achievement.requirementType {
        case .cigarettesAvoided:
            return "Every cigarette you skip is a powerful choice for your future."
        case .daysWithout, .daysSmokeFree:
            return "Every smoke-free day rewires your story toward strength and freedom."
        case .hoursOfLife, .lifeRegained:
            return "You are literally adding more time to your life—one choice at a time."
        case .moneySaved:
            return "You are turning your willpower into real savings and new possibilities."
        }
    }
    
    // MARK: - Locked Status View
    private var lockedStatusView: some View {
        VStack(spacing: AppSpacing.medium) {
            Text("It's just a matter of time")
                .font(AppTypography.title2)
                .foregroundStyle(AppColors.primaryText)
            
            if let timerVM = timerViewModel {
                CountdownTimerView(
                    achievement: achievement,
                    timerViewModel: timerVM
                )
            } else {
                Text("Keep going!")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
        .padding(.vertical, AppSpacing.medium)
        .onAppear {
            // Connect timer to achievement VM if available
            timerViewModel?.achievementVM = achievementVM
        }
    }
    
    // MARK: - Share Button
    private var shareButton: some View {
        Button(action: {
            generateShareImage()
        }) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Share Achievement")
            }
            .font(AppTypography.callout)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.medium)
            .background(AppColors.primaryText)
            .modifier(HandDrawnBorderModifier(cornerRadius: 8, color: AppColors.primaryText))
        }
    }
    
    // MARK: - Share Image Generation
    private func generateShareImage() {
        // Create the share view
        let shareView = AchievementShareView(achievement: achievement, imageName: imageName)
            .frame(width: 1200, height: 1200)
            .background(AppColors.background)
        
        // Use ImageRenderer to convert view to image
        let renderer = ImageRenderer(content: shareView)
        renderer.scale = 2.0 // High resolution for sharing
        
        // ImageRenderer needs the view to be rendered first
        // We need to give it a moment to render the view
        // Using Task to handle async rendering
        Task { @MainActor in
            // Small delay to ensure view is ready
            try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
            
            var items: [Any] = []
            
            // Try to generate image
            if let uiImage = renderer.uiImage {
                items.append(uiImage)
            }
            
            // Always include text as fallback
            let shareText = """
            🎉 Achievement Unlocked! 🎉
            
            \(achievement.title)
            \(achievement.details)
            
            Shared from Nicoboo
            """
            items.append(shareText)
            
            // Set share items and show sheet
            self.shareItems = items
            self.showShareSheet = true
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

// MARK: - Countdown Timer View
private struct CountdownTimerView: View {
    let achievement: Achievement
    @ObservedObject var timerViewModel: TimerViewModel
    @State private var currentProgress: (cigarettesAvoided: Double, daysWithout: Double, hoursOfLife: Double, moneySaved: Double) = (0, 0, 0, 0)
    
    var body: some View {
        VStack(spacing: AppSpacing.small) {
            let remaining = calculateRemaining()
            if remaining.total > 0 {
                Text(formatCountdown(remaining))
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText)
            } else {
                Text("Keep going!")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
        .onAppear {
            updateProgress()
        }
        .onReceive(timerViewModel.$breakdown) { _ in
            updateProgress()
        }
    }
    
    private func updateProgress() {
        currentProgress = (
            cigarettesAvoided: Double(timerViewModel.cigarettesAvoided),
            daysWithout: Double(timerViewModel.breakdown.days),
            hoursOfLife: Double(timerViewModel.breakdown.hours + timerViewModel.breakdown.days * 24),
            moneySaved: timerViewModel.moneySaved
        )
    }
    
    private func calculateRemaining() -> (days: Int, hours: Int, minutes: Int, seconds: Int, total: TimeInterval) {
        let progress: Double
        
        switch achievement.requirementType {
        case .cigarettesAvoided: progress = currentProgress.cigarettesAvoided
        case .daysWithout, .daysSmokeFree: progress = currentProgress.daysWithout
        case .hoursOfLife, .lifeRegained: progress = currentProgress.hoursOfLife
        case .moneySaved: progress = currentProgress.moneySaved
        }
        
        let remaining = max(achievement.requirement - progress, 0)
        
        // Convert remaining to time based on requirement type
        switch achievement.requirementType {
        case .daysWithout, .daysSmokeFree:
            let days = Int(remaining)
            let hours = Int((remaining - Double(days)) * 24)
            return (days, hours, 0, 0, remaining * 86400)
        case .hoursOfLife, .lifeRegained:
            let hours = Int(remaining)
            let minutes = Int((remaining - Double(hours)) * 60)
            return (0, hours, minutes, 0, remaining * 3600)
        default:
            // For cigarettes and money, we can't calculate exact time
            // Just show a generic message
            return (0, 0, 0, 0, 0)
        }
    }
    
    private func formatCountdown(_ remaining: (days: Int, hours: Int, minutes: Int, seconds: Int, total: TimeInterval)) -> String {
        if remaining.days > 0 {
            return "\(remaining.days) days \(remaining.hours) hrs"
        } else if remaining.hours > 0 {
            return "\(remaining.hours) hrs \(remaining.minutes) min"
        } else if remaining.minutes > 0 {
            return "\(remaining.minutes) min"
        } else {
            return "Unlocking soon..."
        }
    }
}

// MARK: - Achievement Share View (for image generation)
private struct AchievementShareView: View {
    let achievement: Achievement
    let imageName: String
    
    var body: some View {
        VStack(spacing: AppSpacing.xLarge) {
            Spacer()
            
            // Large badge
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 400)
            
            // Title
            Text(achievement.title)
                .font(AppTypography.title1)
                .foregroundStyle(AppColors.primaryText)
                .multilineTextAlignment(.center)
            
            // Description
            Text(achievement.details)
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            // Unlock date
            if let unlockedAt = achievement.unlockedAt {
                Text("Unlocked on \(formatDate(unlockedAt))")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
            }
            
            // App branding
            Text("Nicoboo")
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText)
                .padding(.top, AppSpacing.large)
            
            Spacer()
        }
        .padding(AppSpacing.xxLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        // For iPad support
        if let popover = controller.popoverPresentationController {
            popover.sourceView = UIView()
            popover.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        // Handle completion
        controller.completionWithItemsHandler = { _, _, _, _ in
            // Dismiss is handled automatically by SwiftUI
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    let container = try! ModelContainer(for: Achievement.self)
    let context = container.mainContext
    let achievement = Achievement(
        title: "To Infinity and Beyond",
        details: "5 cigarettes avoided",
        requirement: 5,
        requirementType: .cigarettesAvoided,
        imageName: "image-a1",
        isUnlocked: true,
        unlockedAt: Date(),
        order: 1
    )
    
    return AchievementDetailView(achievement: achievement, profile: nil)
        .environmentObject(AchievementViewModel(context: context))
}
