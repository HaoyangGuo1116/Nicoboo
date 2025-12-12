import SwiftUI

struct HandDrawnProgressBar: View {
    var value: Double
    var height: CGFloat = 12
    var trackColor: Color = AppColors.secondaryText.opacity(0.15)
    var fillColor: Color = AppColors.accentGreen

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(trackColor)
                    .modifier(HandDrawnBorderModifier(lineWidth: 1.5, cornerRadius: 8, color: AppColors.secondaryText.opacity(0.4)))

                RoundedRectangle(cornerRadius: 8)
                    .fill(fillColor)
                    .frame(width: max(min(CGFloat(value) * geometry.size.width, geometry.size.width), 0))
                    .animation(.easeInOut(duration: 0.6), value: value)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    VStack(spacing: AppSpacing.large) {
        HandDrawnProgressBar(value: 0.68)
        HandDrawnProgressBar(value: 0.24, fillColor: AppColors.accentOrange)
    }
    .padding()
    .background(AppColors.background)
}
