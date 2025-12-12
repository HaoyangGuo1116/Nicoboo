import SwiftUI

struct HandDrawnButtonStyle: ButtonStyle {
    var backgroundColor: Color = AppColors.accentYellow
    var foregroundColor: Color = AppColors.primaryText

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.title3)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, AppSpacing.large)
            .padding(.vertical, AppSpacing.small)
            .background(background(configuration: configuration))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: configuration.isPressed)
    }

    private func background(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(backgroundColor.opacity(configuration.isPressed ? 0.85 : 1.0))
            .modifier(HandDrawnShadowModifier(opacity: configuration.isPressed ? 0.08 : 0.16))
            .modifier(HandDrawnBorderModifier())
    }
}
