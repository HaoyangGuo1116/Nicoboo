import SwiftUI

extension View {
    func handDrawnShadow(opacity: Double = 0.16, radius: CGFloat = 8, x: CGFloat = 0, y: CGFloat = 4) -> some View {
        shadow(color: AppColors.shadowSecondary.opacity(opacity), radius: radius, x: x, y: y)
    }

    func handDrawnWiggle(amplitude: CGFloat = 1.0, speed: Double = 0.15) -> some View {
        modifier(WiggleAnimationModifier(amplitude: amplitude, speed: speed))
    }
}
