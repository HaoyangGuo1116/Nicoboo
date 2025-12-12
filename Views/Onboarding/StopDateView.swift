import SwiftUI

struct StopDateView: View {
    @Binding var stopDate: Date

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Text("Stop date")
                .font(AppTypography.title1)

            Text("Enter the date you stopped smoking. If you have not quit yet, choose the date you will quit.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.large)

            Image("hourglass_stars")
                .resizable()
                .scaledToFit()
                .frame(height: 180)
                .accessibilityHidden(true)

            HandDrawnCard {
                DatePicker(
                    "Quit date",
                    selection: $stopDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.wheel)
            }
            .padding(.horizontal, AppSpacing.large)

            Spacer()
        }
    }
}

#Preview {
    StatefulPreviewWrapper(Date()) { binding in
        StopDateView(stopDate: binding).background(AppColors.background)
    }
}
