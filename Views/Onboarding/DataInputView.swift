import SwiftUI

struct DataInputView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                header

                VStack(spacing: AppSpacing.medium) {
                    if requiresSmokingFields {
                        smokingSection
                    }

                    if requiresVapingFields {
                        vapingSection
                    }
                }
            }
            .padding(.horizontal, AppSpacing.large)
            .padding(.bottom, AppSpacing.xxLarge)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Customize your plan")
                .font(AppTypography.title1)

            Text("Enter your daily usage to personalize Nicoboo for you.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
        }
    }

    private var smokingSection: some View {
        HandDrawnCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Text("Smoking habits")
                    .font(AppTypography.title3)

                HandDrawnTextField(
                    title: "Cigarettes per day",
                    text: $viewModel.cigarettesPerDay,
                    keyboardType: .numberPad,
                    systemImage: "sun.max"
                )

                HandDrawnTextField(
                    title: "Cigarettes per pack",
                    text: $viewModel.cigarettesPerPack,
                    keyboardType: .numberPad,
                    systemImage: "cube.box"
                )

                HandDrawnTextField(
                    title: "Price per pack",
                    text: $viewModel.pricePerPack,
                    keyboardType: .decimalPad,
                    systemImage: "dollarsign.circle"
                )
            }
        }
    }

    private var vapingSection: some View {
        HandDrawnCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                Text("Vaping habits")
                    .font(AppTypography.title3)

                HandDrawnTextField(
                    title: "Puffs per day",
                    text: $viewModel.puffsPerDay,
                    keyboardType: .numberPad,
                    systemImage: "wind"
                )

                HandDrawnTextField(
                    title: "Pods per day",
                    text: $viewModel.podsPerDay,
                    keyboardType: .numberPad,
                    systemImage: "cube.box.fill"
                )

                HandDrawnTextField(
                    title: "Price per pod",
                    text: $viewModel.pricePerPod,
                    keyboardType: .decimalPad,
                    systemImage: "creditcard"
                )
            }
        }
    }

    private var requiresSmokingFields: Bool {
        viewModel.smokingType == .smoke || viewModel.smokingType == .both
    }

    private var requiresVapingFields: Bool {
        viewModel.smokingType == .vape || viewModel.smokingType == .both
    }
}

#Preview {
    let vm = OnboardingViewModel()
    vm.smokingType = .both
    return DataInputView(viewModel: vm)
        .background(AppColors.background)
}
