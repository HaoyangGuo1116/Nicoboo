import SwiftUI
import SwiftData
import FirebaseAuth

struct SavingGoalsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject var appState: AppState
    @Query(sort: \SavingGoal.createdAt, order: .reverse) private var allGoals: [SavingGoal]
    
    @State private var showAddGoalSheet = false
    @State private var selectedPresetGoal: (name: String, amount: Double, imageName: String)?
    @State private var refreshTrigger = UUID()
    
    private var goals: [SavingGoal] {
        let currentUserId = appState.isAuthenticated ? FirebaseAuthService.shared.currentUser?.uid : nil
        return allGoals.filter { goal in
            goal.userId == currentUserId
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    header
                    
                    if goals.isEmpty {
                        emptyState
                    } else {
                        goalsList
                    }
                    
                    addPresetGoalsButton
                }
                .padding(.horizontal, AppSpacing.large)
                .padding(.vertical, AppSpacing.xLarge)
            }
            .id(refreshTrigger)
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Saving Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppTypography.callout)
                }
            }
            .sheet(isPresented: $showAddGoalSheet) {
                if let preset = selectedPresetGoal {
                    AddGoalView(presetGoal: preset, onSave: {
                        // Force refresh after save
                        refreshTrigger = UUID()
                    })
                        .environment(\.modelContext, context)
                        .environmentObject(appState)
                }
            }
            .onChange(of: allGoals.count) { oldCount, newCount in
                // Refresh when goals count changes
                if newCount > oldCount {
                    refreshTrigger = UUID()
                }
            }
            .onChange(of: showAddGoalSheet) { isPresented in
                // Refresh when sheet is dismissed
                if !isPresented {
                    refreshTrigger = UUID()
                }
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Your Saving Goals")
                .font(AppTypography.title1)
                .foregroundStyle(AppColors.primaryText)
            
            Text("Track how much you can save by staying smoke-free. Set goals and watch your progress!")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: AppSpacing.medium) {
            Image(systemName: "target")
                .font(.system(size: 60))
                .foregroundStyle(AppColors.secondaryText)
            
            Text("No goals yet")
                .font(AppTypography.title3)
                .foregroundStyle(AppColors.primaryText)
            
            Text("Add a goal to track your savings progress")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, AppSpacing.xxLarge)
    }
    
    private var goalsList: some View {
        VStack(spacing: AppSpacing.medium) {
            ForEach(goals) { goal in
                GoalCardView(goal: goal)
                    .environmentObject(appState)
            }
        }
    }
    
    private var addPresetGoalsButton: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Text("Add Preset Goal")
                .font(AppTypography.title3)
                .foregroundStyle(AppColors.primaryText)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.medium) {
                ForEach(SavingGoal.presetGoals, id: \.name) { preset in
                    PresetGoalButton(preset: preset) {
                        selectedPresetGoal = preset
                        showAddGoalSheet = true
                    }
                }
            }
        }
    }
}

// MARK: - Goal Card View
struct GoalCardView: View {
    let goal: SavingGoal
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    
    private var currentMoneySaved: Double {
        guard let profile = appState.userProfile,
              let pricePerPack = profile.pricePerPack,
              let cigarettesPerPack = profile.cigarettesPerPack,
              let cigarettesPerDay = profile.cigarettesPerDay,
              cigarettesPerPack > 0 else { return 0 }
        
        let elapsedDays = Date().timeIntervalSince(profile.stopDate) / 86_400
        let avoided = max(elapsedDays * Double(cigarettesPerDay), 0)
        let packsAvoided = avoided / Double(cigarettesPerPack)
        return max(packsAvoided * pricePerPack, 0)
    }
    
    private var progress: Double {
        min(currentMoneySaved / goal.targetAmount, 1.0)
    }
    
    private var daysNeeded: Int {
        guard let profile = appState.userProfile,
              let pricePerPack = profile.pricePerPack,
              let cigarettesPerPack = profile.cigarettesPerPack,
              let cigarettesPerDay = profile.cigarettesPerDay,
              cigarettesPerPack > 0,
              cigarettesPerDay > 0 else { return 0 }
        
        let dailySavings = (Double(cigarettesPerDay) / Double(cigarettesPerPack)) * pricePerPack
        guard dailySavings > 0 else { return 0 }
        
        let remaining = max(goal.targetAmount - currentMoneySaved, 0)
        return Int(ceil(remaining / dailySavings))
    }
    
    var body: some View {
        HandDrawnCard {
            VStack(alignment: .leading, spacing: AppSpacing.medium) {
                HStack {
                    if let imageName = goal.imageName {
                        Image(systemName: imageName)
                            .font(.title2)
                            .foregroundStyle(AppColors.accentPink)
                    }
                    
                    Text(goal.name)
                        .font(AppTypography.title3)
                        .foregroundStyle(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        context.delete(goal)
                        try? context.save()
                    }) {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    HStack {
                        Text(formattedCurrency(currentMoneySaved))
                            .font(AppTypography.title2)
                            .foregroundStyle(AppColors.primaryText)
                        
                        Text("/ \(formattedCurrency(goal.targetAmount))")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)
                    }
                    
                    HandDrawnProgressBar(value: progress)
                    
                    if daysNeeded > 0 {
                        Text("\(daysNeeded) more days to reach this goal")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.secondaryText)
                    } else {
                        Text("Goal achieved! 🎉")
                            .font(AppTypography.caption)
                            .foregroundStyle(AppColors.accentGreen)
                    }
                }
            }
        }
    }
    
    private func formattedCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = appState.userProfile?.currencyCode ?? "USD"
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
}

// MARK: - Preset Goal Button
struct PresetGoalButton: View {
    let preset: (name: String, amount: Double, imageName: String)
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.small) {
                Image(systemName: preset.imageName)
                    .font(.title2)
                    .foregroundStyle(AppColors.accentPink)
                
                Text(preset.name)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.medium)
            .background(AppColors.cardBackground)
            .modifier(HandDrawnBorderModifier(cornerRadius: 8))
        }
    }
}

// MARK: - Add Goal View
struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject var appState: AppState
    
    let presetGoal: (name: String, amount: Double, imageName: String)?
    let onSave: (() -> Void)?
    
    @State private var goalName: String
    @State private var targetAmount: String
    
    init(presetGoal: (name: String, amount: Double, imageName: String)? = nil, onSave: (() -> Void)? = nil) {
        self.presetGoal = presetGoal
        self.onSave = onSave
        _goalName = State(initialValue: presetGoal?.name ?? "")
        _targetAmount = State(initialValue: presetGoal != nil ? String(format: "%.2f", presetGoal!.amount) : "")
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    header
                    
                    formSection
                    
                    saveButton
                }
                .padding(.horizontal, AppSpacing.large)
                .padding(.vertical, AppSpacing.xLarge)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Add Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppTypography.callout)
                }
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Create Saving Goal")
                .font(AppTypography.title1)
                .foregroundStyle(AppColors.primaryText)
            
            Text("Set a financial goal to motivate yourself. Track your progress as you save money by staying smoke-free.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
        }
    }
    
    private var formSection: some View {
        HandDrawnCard {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                HandDrawnTextField(
                    title: "Goal Name",
                    text: $goalName,
                    keyboardType: .default,
                    systemImage: "target"
                )
                
                Divider()
                
                HandDrawnTextField(
                    title: "Target Amount",
                    text: $targetAmount,
                    keyboardType: .decimalPad,
                    systemImage: "dollarsign.circle"
                )
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveGoal) {
            Text("Save Goal")
                .font(AppTypography.callout)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.medium)
                .background(AppColors.accentPink)
                .modifier(HandDrawnBorderModifier(cornerRadius: 8, color: AppColors.accentPink))
        }
    }
    
    private func saveGoal() {
        guard !goalName.isEmpty,
              let amount = Double(targetAmount),
              amount > 0 else { return }
        
        let userId = appState.isAuthenticated ? FirebaseAuthService.shared.currentUser?.uid : nil
        
        let goal = SavingGoal(
            userId: userId,
            name: goalName,
            targetAmount: amount,
            imageName: presetGoal?.imageName
        )
        
        // Insert the goal
        context.insert(goal)
        
        // Save and handle result
        do {
            try context.save()
            // Trigger refresh callback
            onSave?()
            // Dismiss after a brief delay to ensure UI updates
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                dismiss()
            }
        } catch {
            print("Failed to save goal: \(error.localizedDescription)")
            // Try saving again
            do {
                try context.save()
                onSave?()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    dismiss()
                }
            } catch {
                print("Retry save also failed: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: SavingGoal.self)
    return SavingGoalsView()
        .environmentObject(AppState())
        .modelContainer(container)
}

