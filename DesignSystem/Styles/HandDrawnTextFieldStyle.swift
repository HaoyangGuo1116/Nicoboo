import SwiftUI

struct HandDrawnTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .font(AppTypography.body)
            .padding(.vertical, AppSpacing.small)
            .padding(.horizontal, AppSpacing.medium)
            .background(AppColors.cardBackground)
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(AppColors.primaryText.opacity(0.85))
                    .offset(y: 12)
            )
            .modifier(HandDrawnShadowModifier(opacity: 0.06, radius: 4))
    }
}
