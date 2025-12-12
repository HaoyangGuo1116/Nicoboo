import SwiftUI

struct HandDrawnButton<Label: View>: View {
    let action: () -> Void
    let backgroundColor: Color
    let foregroundColor: Color
    @ViewBuilder var label: () -> Label

    init(
        backgroundColor: Color = AppColors.accentYellow,
        foregroundColor: Color = AppColors.primaryText,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.action = action
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.label = label
    }

    var body: some View {
        Button(action: action) {
            label()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(HandDrawnButtonStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}

#Preview {
    HandDrawnButton {
        print("Tapped")
    } label: {
        Text("Let's Go")
    }
    .padding()
    .background(AppColors.background)
}
