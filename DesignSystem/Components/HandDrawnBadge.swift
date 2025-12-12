import SwiftUI

struct HandDrawnBadge: View {
    enum State {
        case locked
        case unlocked
        case highlighted
    }

    let title: String
    let subtitle: String
    let imageName: String
    let state: State

    var body: some View {
        VStack(spacing: AppSpacing.small) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 72)
                .grayscale(state == .locked ? 1.0 : 0.0)
                .opacity(state == .locked ? 0.5 : 1.0)
                .overlay(lockOverlay)

            VStack(spacing: AppSpacing.xxxSmall) {
                Text(title)
                    .font(AppTypography.title3)
                    .foregroundStyle(state == .locked ? AppColors.secondaryText.opacity(0.6) : AppColors.primaryText)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(state == .locked ? AppColors.secondaryText.opacity(0.5) : AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(AppSpacing.medium)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .modifier(HandDrawnBorderModifier(cornerRadius: 8, color: borderColor))
        .modifier(HandDrawnShadowModifier(opacity: state == .locked ? 0.04 : 0.12))
        .opacity(state == .locked ? 0.7 : 1.0)
        .scaleEffect(state == .highlighted ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: state)
    }

    private var backgroundColor: Color {
        return Color.white
    }

    private var borderColor: Color {
        switch state {
        case .locked:
            return AppColors.locked
        case .unlocked, .highlighted:
            return AppColors.primaryText
        }
    }

    @ViewBuilder
    private var lockOverlay: some View {
        if state == .locked {
            Image("lock_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .offset(x: 28, y: -28)
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.large) {
        HandDrawnBadge(title: "To Infinity and Beyond", subtitle: "5 cigarettes avoided", imageName: "achievement_infinity_beyond", state: .unlocked)
        HandDrawnBadge(title: "Superpowers", subtitle: "1 hour of life regained", imageName: "achievement_superpowers_locked", state: .locked)
    }
    .padding()
    .background(AppColors.background)
}
