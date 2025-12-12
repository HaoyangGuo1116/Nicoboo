import SwiftUI

struct AvatarSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    
    let onAvatarSelected: ((String) -> Void)?
    
    @State private var selectedImageName: String?
    
    init(onAvatarSelected: ((String) -> Void)? = nil) {
        self.onAvatarSelected = onAvatarSelected
    }
    
    private let availableImages: [String] = {
        (1...60).map { "image-a\($0)" }
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: AppSpacing.medium) {
                    ForEach(availableImages, id: \.self) { imageName in
                        Button(action: {
                            selectedImageName = imageName
                            saveAvatar()
                        }) {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(selectedImageName == imageName ? AppColors.accentPink : Color.clear, lineWidth: 3)
                                )
                                .padding(4)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.large)
                .padding(.vertical, AppSpacing.xLarge)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle("Choose Avatar")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(AppTypography.callout)
                }
            }
            .onAppear {
                loadCurrentAvatar()
            }
        }
    }
    
    private func loadCurrentAvatar() {
        // Load saved avatar from UserDefaults
        if let savedAvatar = UserDefaults.standard.string(forKey: "userAvatar") {
            selectedImageName = savedAvatar
        }
    }
    
    private func saveAvatar() {
        guard let imageName = selectedImageName else { return }
        UserDefaults.standard.set(imageName, forKey: "userAvatar")
        onAvatarSelected?(imageName)
        dismiss()
    }
}

#Preview {
    AvatarSelectionView()
        .environmentObject(AppState())
}

