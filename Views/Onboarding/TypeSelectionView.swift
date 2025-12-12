import SwiftUI

struct TypeSelectionView: View {
    @Binding var selectedType: SmokingType?

    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Text("Do you smoke or vape?")
                .font(AppTypography.title1)
                .multilineTextAlignment(.center)

            Text("Pick one to build your plan.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)

            VStack(spacing: AppSpacing.medium) {
                ForEach(SmokingType.allCases) { type in
                    selectableButton(for: type)
                }
            }
            .padding(.horizontal, AppSpacing.large)

            Spacer()
        }
    }

    private func selectableButton(for type: SmokingType) -> some View {
        HandDrawnButton(backgroundColor: background(for: type), foregroundColor: foregroundColor(for: type)) {
            selectedType = type
        } label: {
            Text(type.displayName)
                .font(AppTypography.title2)
        }
        .overlay(selectionIndicator(for: type))
    }
    
    private func foregroundColor(for type: SmokingType) -> Color {
        selectedType == type ? .white : AppColors.primaryText
    }

    private func background(for type: SmokingType) -> Color {
        selectedType == type ? AppColors.accentGreen.opacity(0.35) : AppColors.cardBackground
    }

    private func selectionIndicator(for type: SmokingType) -> some View {
        Group {
            if selectedType == type {
                Image(systemName: "star.fill")
                    .foregroundStyle(AppColors.accentYellow)
                    .offset(x: 140, y: -22)
            }
        }
    }
}

private struct TypeSelectionPreviewContainer: View {
    @State private var selection: SmokingType? = nil

    var body: some View {
        TypeSelectionView(selectedType: $selection)
            .padding()
            .background(AppColors.background)
    }
}

#Preview {
    TypeSelectionPreviewContainer()
}
