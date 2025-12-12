import Combine
import Foundation

final class OnboardingViewModel: ObservableObject {
    enum Step: Int, CaseIterable {
        case welcome
        case typeSelection
        case dataInput
        case stopDate
    }

    @Published var currentStep: Step = .welcome

    // Shared fields
    @Published var smokingType: SmokingType? = nil
    @Published var stopDate: Date = Date()

    // Smoking fields
    @Published var cigarettesPerDay: String = ""
    @Published var cigarettesPerPack: String = "20"
    @Published var pricePerPack: String = ""

    // Vaping fields
    @Published var puffsPerDay: String = ""
    @Published var podsPerDay: String = ""
    @Published var millilitersPerPod: String = "" // Kept for backward compatibility, but not used in UI
    @Published var pricePerPod: String = ""

    @Published var currencyCode: String = "USD"

    var canContinue: Bool {
        switch currentStep {
        case .welcome:
            return true
        case .typeSelection:
            return smokingType != nil
        case .dataInput:
            return validateDataInput()
        case .stopDate:
            return true
        }
    }

    func advance() {
        guard let nextStep = Step(rawValue: currentStep.rawValue + 1) else { return }
        currentStep = nextStep
    }

    func goBack() {
        guard let previousStep = Step(rawValue: currentStep.rawValue - 1) else { return }
        currentStep = previousStep
    }

    func buildProfile() -> UserProfile? {
        guard let smokingType else { return nil }

        return UserProfile(
            smokingType: smokingType,
            stopDate: stopDate,
            cigarettesPerDay: Int(cigarettesPerDay),
            cigarettesPerPack: Int(cigarettesPerPack),
            pricePerPack: Double(pricePerPack),
            puffsPerDay: Int(puffsPerDay),
            podsPerDay: Int(podsPerDay),
            millilitersPerPod: nil, // No longer used
            pricePerPod: Double(pricePerPod),
            currencyCode: currencyCode
        )
    }

    private func validateDataInput() -> Bool {
        guard let smokingType else { return false }

        switch smokingType {
        case .smoke:
            return Int(cigarettesPerDay) ?? 0 > 0 && Int(cigarettesPerPack) ?? 0 > 0 && Double(pricePerPack) ?? 0 > 0
        case .vape:
            return Int(puffsPerDay) ?? 0 > 0 && Int(podsPerDay) ?? 0 > 0 && Double(pricePerPod) ?? 0 > 0
        case .both:
            let smokingValid = Int(cigarettesPerDay) ?? 0 > 0 && Int(cigarettesPerPack) ?? 0 > 0 && Double(pricePerPack) ?? 0 > 0
            let vapingValid = Int(puffsPerDay) ?? 0 > 0 && Int(podsPerDay) ?? 0 > 0 && Double(pricePerPod) ?? 0 > 0
            return smokingValid && vapingValid
        }
    }
}
