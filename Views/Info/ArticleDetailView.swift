//
//  ArticleDetailView.swift
//  Nicoboo
//
//  Created on 11/18/25.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: HealthArticle
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.large) {
                    Text(article.title)
                        .font(AppTypography.title1)
                        .foregroundStyle(AppColors.primaryText)
                        .padding(.horizontal, AppSpacing.large)
                        .padding(.top, AppSpacing.large)
                    
                    // 图片居中显示
                    HStack {
                        Spacer()
                        Image(article.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        Spacer()
                    }
                    .padding(.vertical, AppSpacing.medium)
                    
                    Text(article.content)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColors.primaryText)
                        .lineSpacing(4)
                        .padding(.horizontal, AppSpacing.large)
                        .padding(.bottom, AppSpacing.xxLarge)
                }
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("close") {
                        dismiss()
                    }
                    .foregroundStyle(AppColors.primaryText)
                }
            }
        }
    }
}

#Preview {
    ArticleDetailView(article: healthArticles[0])
}

