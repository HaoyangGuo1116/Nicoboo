import SwiftUI

struct HandDrawnTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var systemImage: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
            Text(title)
                .font(AppTypography.callout)
                .foregroundStyle(AppColors.secondaryText)

            HStack(spacing: AppSpacing.small) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .foregroundStyle(AppColors.secondaryText)
                }

                TextField("", text: $text)
                    .keyboardType(keyboardType)
                    .textFieldStyle(HandDrawnTextFieldStyle())
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper("32.75") { binding in
        HandDrawnTextField(title: "Price per pack", text: binding, keyboardType: .decimalPad, systemImage: "dollarsign.circle")
            .padding()
            .background(AppColors.background)
    }
}
