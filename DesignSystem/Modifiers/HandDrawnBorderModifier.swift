import SwiftUI

struct HandDrawnBorderModifier: ViewModifier {
    var lineWidth: CGFloat = 2
    var cornerRadius: CGFloat = 8
    var color: Color = AppColors.primaryText

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .inset(by: randomOffset())
                    .stroke(color.opacity(0.9), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .blendMode(.normal)
                    .offset(x: randomOffset(), y: randomOffset())
            )
    }

    private func randomOffset() -> CGFloat {
        .random(in: -0.8...0.8)
    }
}
