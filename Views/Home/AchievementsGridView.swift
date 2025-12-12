//
//  AchievementsGridView.swift
//  Nicoboo
//
//  Created by Sabrina Jiang on 11/17/25.
//

import SwiftUI

struct AchievementsGridView: View {

    @EnvironmentObject var achievementVM: AchievementViewModel
    @EnvironmentObject var appState: AppState
    @State private var selectedAchievement: Achievement?

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Completion counter
                    Text("\(achievementVM.unlockedCount) / 64 Achievements Completed")
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.secondaryText)
                        .padding(.top, AppSpacing.medium)
                        .padding(.bottom, AppSpacing.large)
                    
                    // Achievement grid
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(achievementVM.achievements) { ach in
                            HandDrawnBadge(
                                title: ach.title,
                                subtitle: ach.details,
                                imageName: ach.imageName,
                                state: ach.isUnlocked ? .unlocked : .locked
                            )
                            .onTapGesture {
                                selectedAchievement = ach
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.large)
                    .padding(.bottom, AppSpacing.medium)
                }
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Achievements")
        }
        .sheet(item: $selectedAchievement) { achievement in
            AchievementDetailView(achievement: achievement, profile: appState.userProfile)
                .environmentObject(achievementVM)
        }
    }
    
}

