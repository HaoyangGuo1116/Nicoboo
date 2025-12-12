//
//  InfoTabView.swift
//  Nicoboo
//
//  Created on 11/18/25.
//

import SwiftUI

struct InfoTabView: View {
    @State private var currentTip: String = ""
    @State private var currentPage: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                // 第一个页面：小贴士页面
                TipsPageView(currentTip: $currentTip)
                    .tag(0)
                
                // 第二个页面：文章列表
                ArticlesListView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onAppear {
                refreshTip()
            }
            
            // 分页指示器
            VStack {
                Spacer()
                HStack(spacing: AppSpacing.small) {
                    ForEach(0..<2, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? AppColors.accentYellow : AppColors.secondaryText.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, AppSpacing.large)
            }
        }
    }
    
    private func refreshTip() {
        if !quitSmokingTips.isEmpty {
            currentTip = quitSmokingTips.randomElement() ?? quitSmokingTips[0]
        }
    }
}

// MARK: - Tips Page View
struct TipsPageView: View {
    @Binding var currentTip: String
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            // 中央小贴士内容
            VStack(spacing: AppSpacing.medium) {
                Spacer()
                
                HandDrawnCard(
                    backgroundColor: AppColors.cardBackground,
                    cornerRadius: 8,
                    padding: AppSpacing.large
                ) {
                    Text(currentTip)
                        .font(AppTypography.title2)
                        .foregroundStyle(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
                .padding(.horizontal, AppSpacing.large)
                
                // 刷新按钮
                Button(action: {
                    refreshTip()
                }) {
                    Image("refresh")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, AppSpacing.small)
                
                Spacer()
                    .frame(height:350) // 为底部图片预留空间，避免重叠
            }
            
            // 右下角图片
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("image-a3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 400)
                        .padding(.trailing, AppSpacing.large)
                        .padding(.bottom, AppSpacing.large)
                }
            }
        }
    }
    
    private func refreshTip() {
        if !quitSmokingTips.isEmpty {
            currentTip = quitSmokingTips.randomElement() ?? quitSmokingTips[0]
        }
    }
}

#Preview {
    InfoTabView()
}

