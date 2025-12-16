import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseFirestore

struct SavingGoalsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @EnvironmentObject var appState: AppState
    @Query(sort: \SavingGoal.createdAt, order: .reverse) private var allGoals: [SavingGoal]
    
    @State private var showAddGoalSheet = false
    @State private var selectedPresetGoal: (name: String, amount: Double, imageName: String)?
    @State private var refreshTrigger = UUID()
    @State private var isLoading = false
    @State private var firebaseGoals: [SavingGoal] = [] // Fallback if SwiftData fails
    
    private var goals: [SavingGoal] {
        let currentUserId = appState.isAuthenticated ? FirebaseAuthService.shared.currentUser?.uid : nil
        
        // Try to use SwiftData goals first
        let localGoals = allGoals.filter { goal in
            goal.userId == currentUserId
        }
        
        // If we have Firebase fallback goals and local goals are empty, use Firebase goals
        if localGoals.isEmpty && !firebaseGoals.isEmpty {
            return firebaseGoals
        }
        
        return localGoals
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
                        // Force refresh after save by reloading from Firebase
                        Task {
                            await loadGoalsFromFirebase()
                        }
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
            .task {
                await loadGoalsFromFirebase()
            }
        }
    }
    
    private func loadGoalsFromFirebase() async {
        guard let userId = appState.isAuthenticated ? FirebaseAuthService.shared.currentUser?.uid : nil else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let firebaseGoals = try await FirebaseAuthService.shared.loadSavingGoals(userId: userId)
            print("Loaded \(firebaseGoals.count) goals from Firebase")
            
            // Get existing goal IDs from local storage (on main thread)
            let existingGoalIds = await MainActor.run {
                Set(allGoals.map { $0.id.uuidString })
            }
            
            // Sync Firebase goals to local storage
            await MainActor.run {
                var goalsToDisplay: [SavingGoal] = []
                var newGoalsCount = 0
                
                for firebaseGoal in firebaseGoals {
                    guard let goalIdString = firebaseGoal["id"] as? String,
                          let goalId = UUID(uuidString: goalIdString),
                          let name = firebaseGoal["name"] as? String,
                          let targetAmount = firebaseGoal["targetAmount"] as? Double else {
                        continue
                    }
                    
                    let createdAt = (firebaseGoal["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                    let imageName = firebaseGoal["imageName"] as? String
                    
                    let goal = SavingGoal(
                        id: goalId,
                        userId: userId,
                        name: name,
                        targetAmount: targetAmount,
                        imageName: imageName,
                        createdAt: createdAt
                    )
                    
                    goalsToDisplay.append(goal)
                    
                    // Try to save to SwiftData if not already exists
                    if !existingGoalIds.contains(goalIdString) {
                        do {
                            context.insert(goal)
                            try context.save()
                            newGoalsCount += 1
                        } catch {
                            print("Failed to save goal to SwiftData, will use Firebase fallback: \(error.localizedDescription)")
                            // Don't fail - we'll use the goals from Firebase directly
                        }
                    }
                }
                
                // Update Firebase fallback goals in case SwiftData is not working
                self.firebaseGoals = goalsToDisplay
                
                if newGoalsCount > 0 {
                    print("Synced \(newGoalsCount) new goals from Firebase to local storage")
                }
                
                // Force UI refresh
                refreshTrigger = UUID()
            }
        } catch {
            print("Failed to load goals from Firebase: \(error.localizedDescription)")
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
                GoalCardView(goal: goal, onDelete: { deletedGoalId in
                    // Immediately remove from firebaseGoals state for instant UI update
                    Task { @MainActor in
                        firebaseGoals.removeAll { $0.id.uuidString == deletedGoalId }
                        refreshTrigger = UUID()
                        
                        // Then reload from Firebase to ensure consistency
                        await loadGoalsFromFirebase()
                    }
                })
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
    let onDelete: ((String) -> Void)?
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var context
    
    init(goal: SavingGoal, onDelete: ((String) -> Void)? = nil) {
        self.goal = goal
        self.onDelete = onDelete
    }
    
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
                        deleteGoal()
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
    
    private func deleteGoal() {
        let goalId = goal.id.uuidString
        let userId = appState.isAuthenticated ? FirebaseAuthService.shared.currentUser?.uid : nil
        
        // Immediately notify parent to remove from UI (optimistic update)
        onDelete?(goalId)
        
        // Delete from local storage (SwiftData)
        do {
            context.delete(goal)
            try context.save()
            print("Successfully deleted goal from local storage")
        } catch {
            print("Failed to delete goal from local storage: \(error.localizedDescription)")
            // Continue to delete from Firebase anyway
        }
        
        // Delete from Firebase if authenticated
        if let userId = userId {
            Task {
                do {
                    try await FirebaseAuthService.shared.deleteSavingGoal(
                        userId: userId,
                        goalId: goalId
                    )
                    print("Successfully deleted goal from Firebase")
                } catch {
                    print("Failed to delete goal from Firebase: \(error.localizedDescription)")
                    // UI already updated, so we'll just log the error
                }
            }
        }
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
        
        // Create goal with a new UUID
        let goalId = UUID()
        let createdAt = Date()
        
        // Always save to Firebase first (this is the primary storage)
        if let userId = userId {
            Task {
                do {
                    try await FirebaseAuthService.shared.saveSavingGoal(
                        userId: userId,
                        goalId: goalId.uuidString,
                        name: goalName,
                        targetAmount: amount,
                        imageName: presetGoal?.imageName,
                        createdAt: createdAt
                    )
                    print("Successfully saved goal to Firebase")
                    
                    // Try to save to SwiftData (local storage) after Firebase succeeds
                    await MainActor.run {
                        let goal = SavingGoal(
                            id: goalId,
                            userId: userId,
                            name: goalName,
                            targetAmount: amount,
                            imageName: presetGoal?.imageName,
                            createdAt: createdAt
                        )
                        
                        do {
                            context.insert(goal)
                            try context.save()
                            print("Successfully saved goal to SwiftData")
                        } catch {
                            print("Failed to save goal to SwiftData (will sync from Firebase on reload): \(error.localizedDescription)")
                            // If SwiftData fails, we'll still load from Firebase
                        }
                        
                        // Trigger refresh callback and dismiss
                        onSave?()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dismiss()
                        }
                    }
                } catch {
                    print("Failed to save goal to Firebase: \(error.localizedDescription)")
                    // Even if Firebase fails, try to save locally
                    await MainActor.run {
                        let goal = SavingGoal(
                            id: goalId,
                            userId: userId,
                            name: goalName,
                            targetAmount: amount,
                            imageName: presetGoal?.imageName,
                            createdAt: createdAt
                        )
                        
                        do {
                            context.insert(goal)
                            try context.save()
                            print("Saved goal locally (Firebase save failed)")
                            onSave?()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                dismiss()
                            }
                        } catch {
                            print("Failed to save goal both locally and to Firebase: \(error.localizedDescription)")
                            // Still dismiss - user will see error in console but UI will close
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                dismiss()
                            }
                        }
                    }
                }
            }
        } else {
            // Not authenticated - only use local storage
            let goal = SavingGoal(
                id: goalId,
                userId: nil,
                name: goalName,
                targetAmount: amount,
                imageName: presetGoal?.imageName,
                createdAt: createdAt
            )
            
            do {
                context.insert(goal)
                try context.save()
                onSave?()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    dismiss()
                }
            } catch {
                print("Failed to save goal locally: \(error.localizedDescription)")
                // Still dismiss
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    dismiss()
                }
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

