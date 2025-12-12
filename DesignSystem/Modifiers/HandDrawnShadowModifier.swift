import SwiftUI

struct HandDrawnShadowModifier: ViewModifier {
    var opacity: Double = 0.16
    var radius: CGFloat = 8

    func body(content: Content) -> some View {
        content
            .shadow(color: AppColors.shadowPrimary.opacity(opacity), radius: radius, x: 0, y: 4)
            .shadow(color: AppColors.shadowSecondary.opacity(opacity / 2), radius: radius / 2, x: 0, y: 2)
    }
}
