import SwiftUI

struct ProfileSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    
    @State private var stopDate: Date = Date()
    @State private var cigarettesPerDay: String = ""
    @State private var cigarettesPerPack: String = ""
    @State private var pricePerPack: String = ""
    
    @State private var showSaveAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    header
                    
                    settingsSection
                    
                    saveButton
                }
                .padding(.horizontal, AppSpacing.large)
                .padding(.vertical, AppSpacing.xLarge)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppTypography.callout)
                }
            }
            .alert("Settings Saved", isPresented: $showSaveAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your settings have been updated successfully.")
            }
            .onAppear {
                loadCurrentSettings()
            }
        }
    }
    
    private func loadCurrentSettings() {
        guard let profile = appState.userProfile else { return }
        
        stopDate = profile.stopDate
        cigarettesPerDay = profile.cigarettesPerDay.map { String($0) } ?? ""
        cigarettesPerPack = profile.cigarettesPerPack.map { String($0) } ?? ""
        pricePerPack = profile.pricePerPack.map { String($0) } ?? ""
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text("Edit Your Profile")
                .font(AppTypography.title1)
                .foregroundStyle(AppColors.primaryText)
            
            Text("Update your smoking habits and quit date. Changes will be reflected on your home screen.")
                .font(AppTypography.body)
                .foregroundStyle(AppColors.secondaryText)
        }
    }
    
    private var settingsSection: some View {
        HandDrawnCard {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                // Stop Date
                VStack(alignment: .leading, spacing: AppSpacing.small) {
                    Text("Stop Date")
                        .font(AppTypography.callout)
                        .foregroundStyle(AppColors.secondaryText)
                    
                    DatePicker(
                        "Stop Date",
                        selection: $stopDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
                
                Divider()
                
                // Cigarettes per day
                HandDrawnTextField(
                    title: "Cigarettes per day",
                    text: $cigarettesPerDay,
                    keyboardType: .numberPad,
                    systemImage: "sun.max"
                )
                
                Divider()
                
                // Cigarettes per pack
                HandDrawnTextField(
                    title: "Cigarettes per pack",
                    text: $cigarettesPerPack,
                    keyboardType: .numberPad,
                    systemImage: "cube.box"
                )
                
                Divider()
                
                // Price per pack
                HandDrawnTextField(
                    title: "Price per pack",
                    text: $pricePerPack,
                    keyboardType: .decimalPad,
                    systemImage: "dollarsign.circle"
                )
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveSettings) {
            Text("Save Changes")
                .font(AppTypography.callout)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.medium)
                .background(AppColors.accentPink)
                .modifier(HandDrawnBorderModifier(cornerRadius: 8, color: AppColors.accentPink))
        }
    }
    
    private func saveSettings() {
        guard var profile = appState.userProfile else { return }
        
        // Update profile with new values
        profile.stopDate = stopDate
        profile.cigarettesPerDay = Int(cigarettesPerDay)
        profile.cigarettesPerPack = Int(cigarettesPerPack)
        profile.pricePerPack = Double(pricePerPack)
        
        // Update app state
        appState.updateProfile(profile)
        
        showSaveAlert = true
    }
}

#Preview {
    ProfileSettingsView()
        .environmentObject(AppState())
}

