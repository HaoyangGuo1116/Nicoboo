import SwiftUI

struct StatisticsCardView: View {
    let title: String
    let value: String
    let subtitle: String
    let imageName: String

    var body: some View {
        HandDrawnCard {
            HStack(spacing: AppSpacing.medium) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text(title)
                        .font(AppTypography.title3)
                        .foregroundStyle(AppColors.secondaryText)

                    Text(value)
                        .font(AppTypography.title1)
                        .foregroundStyle(AppColors.primaryText)
                        .monospacedDigit()

                    Text(subtitle)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColors.secondaryText)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    StatisticsCardView(
        title: "Money saved",
        value: "$32.75",
        subtitle: "Based on your daily habits",
        imageName: "money_bag"
    )
    .padding()
    .background(AppColors.background)
}
