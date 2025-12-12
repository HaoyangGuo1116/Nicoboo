import SwiftUI

struct HandDrawnCard<Content: View>: View {
    var backgroundColor: Color = AppColors.cardBackground
    var cornerRadius: CGFloat = 8
    var padding: CGFloat = AppSpacing.medium
    @ViewBuilder var content: () -> Content

    init(
        backgroundColor: Color = AppColors.cardBackground,
        cornerRadius: CGFloat = 8,
        padding: CGFloat = AppSpacing.medium,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content
    }

    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor)
                    .modifier(HandDrawnShadowModifier())
            )
            .modifier(HandDrawnBorderModifier(cornerRadius: cornerRadius))
            
    }
}

#Preview {
    HandDrawnCard {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Money Saved")
                .font(AppTypography.title3)
            Text("$32.75")
                .font(AppTypography.largeTitle)
        }
    }
    .padding()
    .background(AppColors.background)
}
