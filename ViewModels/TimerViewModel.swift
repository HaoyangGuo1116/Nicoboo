import Combine
import Foundation

final class TimerViewModel: ObservableObject {

    struct DurationBreakdown {
        let days: Int
        let hours: Int
        let minutes: Int
        let seconds: Int
    }

    @Published var breakdown: DurationBreakdown = .init(days: 0, hours: 0, minutes: 0, seconds: 0)
    @Published var cigarettesAvoided: Int = 0
    @Published var moneySaved: Double = 0

    weak var achievementVM: AchievementViewModel? {
        didSet {
            // When achievementVM is set, immediately check achievements
            checkAchievements()
        }
    }

    private var profile: UserProfile
    private var timer: AnyCancellable?

    init(profile: UserProfile) {
        self.profile = profile
        // Calculate initial values first
        updateBreakdown()
        updateStatistics()
        startTimer()
    }
    
    func updateProfile(_ newProfile: UserProfile) {
        self.profile = newProfile
        // Recalculate when profile changes
        updateBreakdown()
        updateStatistics()
    }

    deinit {
        timer?.cancel()
    }

    private func startTimer() {
        timer = Timer.publish(every: AppConstants.Timer.refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.recalculate()
            }
    }

    private func recalculate() {
        updateBreakdown()
        updateStatistics()
        checkAchievements()
    }
    
    /// Immediately check and unlock achievements based on current progress
    private func checkAchievements() {
        achievementVM?.updateProgress(
            cigarettesAvoided: Double(cigarettesAvoided),
            daysWithout: Double(breakdown.days),
            hoursOfLife: Double(breakdown.hours + breakdown.days * 24),
            moneySaved: moneySaved
        )
    }

    private func updateBreakdown() {
        let elapsed = max(Date().timeIntervalSince(profile.stopDate), 0)
        let days = Int(elapsed / 86_400)
        let hours = Int(elapsed.truncatingRemainder(dividingBy: 86_400) / 3_600)
        let minutes = Int(elapsed.truncatingRemainder(dividingBy: 3_600) / 60)
        let seconds = Int(elapsed.truncatingRemainder(dividingBy: 60))

        breakdown = .init(days: days, hours: hours, minutes: minutes, seconds: seconds)
    }

    private func updateStatistics() {
        cigarettesAvoided = calculateCigarettesAvoided()
        moneySaved = calculateMoneySaved()
    }

    private func calculateCigarettesAvoided() -> Int {
        guard let cigsPerDay = profile.cigarettesPerDay else { return 0 }
        let elapsedDays = Date().timeIntervalSince(profile.stopDate) / 86_400
        return max(Int(elapsedDays * Double(cigsPerDay)), 0)
    }

    private func calculateMoneySaved() -> Double {
        guard let pricePerPack = profile.pricePerPack,
              let cigarettesPerPack = profile.cigarettesPerPack,
              cigarettesPerPack > 0 else { return 0 }

        let avoided = calculateCigarettesAvoided()
        let packsAvoided = Double(avoided) / Double(cigarettesPerPack)
        return max(packsAvoided * pricePerPack, 0)
    }
}
