//
//  ArticlesListView.swift
//  Nicoboo
//
//  Created on 11/18/25.
//

import SwiftUI

struct ArticlesListView: View {
    @State private var selectedArticle: HealthArticle?
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.large) {
                    ForEach(healthArticles) { article in
                        Button(action: {
                            selectedArticle = article
                        }) {
                            HandDrawnCard(
                                backgroundColor: AppColors.cardBackground,
                                cornerRadius: 8,
                                padding: AppSpacing.large
                            ) {
                                Text(article.title)
                                    .font(AppTypography.title3)
                                    .foregroundStyle(AppColors.primaryText)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, AppSpacing.large)
                .padding(.top, AppSpacing.xLarge)
                .padding(.bottom, AppSpacing.xxLarge)
                
                // 为底部图片预留空间
                Spacer()
                    .frame(height: 300)
            }
            
            // 底部图片
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image("image-a17")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    Spacer()
                }
                .padding(.bottom, AppSpacing.large)
            }
        }
        .sheet(item: $selectedArticle) { article in
            ArticleDetailView(article: article)
        }
    }
}

#Preview {
    ArticlesListView()
}

