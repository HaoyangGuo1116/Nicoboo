//
//  LoginView.swift
//  Nicoboo
//
//  Created on 11/30/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    let onSuccess: (() -> Void)?
    
    init(onSuccess: (() -> Void)? = nil) {
        self.onSuccess = onSuccess
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    // Header
                    VStack(spacing: AppSpacing.medium) {
                        Text("Welcome Back")
                            .font(AppTypography.title1)
                            .foregroundStyle(AppColors.primaryText)
                        
                        Text("Sign in to continue your journey")
                            .font(AppTypography.body)
                            .foregroundStyle(AppColors.secondaryText)
                    }
                    .padding(.top, AppSpacing.xxLarge)
                    
                    // Form
                    VStack(spacing: AppSpacing.large) {
                        // Email field
                        VStack(alignment: .leading, spacing: AppSpacing.small) {
                            Text("Email")
                                .font(AppTypography.callout)
                                .foregroundStyle(AppColors.primaryText)
                            
                            TextField("Enter your email", text: $viewModel.email)
                                .textFieldStyle(.plain)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(AppSpacing.medium)
                                .background(AppColors.cardBackground)
                                .modifier(HandDrawnBorderModifier(cornerRadius: 8, color: AppColors.primaryText))
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: AppSpacing.small) {
                            Text("Password")
                                .font(AppTypography.callout)
                                .foregroundStyle(AppColors.primaryText)
                            
                            SecureField("Enter your password", text: $viewModel.password)
                                .textFieldStyle(.plain)
                                .padding(AppSpacing.medium)
                                .background(AppColors.cardBackground)
                                .modifier(HandDrawnBorderModifier(cornerRadius: 8, color: AppColors.primaryText))
                        }
                        
                        // Error message
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(AppTypography.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal, AppSpacing.medium)
                        }
                        
                        // Sign in button
                        Button(action: {
                            Task {
                                await viewModel.signIn()
                                if viewModel.errorMessage == nil {
                                    appState.setGuestMode(false)
                                    // Try to load user profile from Firestore
                                    if let userId = FirebaseAuthService.shared.currentUser?.uid {
                                        if let profile = try? await FirebaseAuthService.shared.loadUserProfile(userId: userId) {
                                            appState.updateProfile(profile)
                                        }
                                        // Update achievement user ID after login
                                        // This will be handled by MainTabView's onChange
                                    }
                                    dismiss()
                                    onSuccess?()
                                }
                            }
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, AppSpacing.medium)
                            } else {
                                Text("Sign In")
                                    .font(AppTypography.callout)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, AppSpacing.medium)
                            }
                        }
                        .background(AppColors.primaryText)
                        .modifier(HandDrawnBorderModifier(cornerRadius: 8, color: AppColors.primaryText))
                        .disabled(viewModel.isLoading || !viewModel.isValidEmail || !viewModel.isValidPassword)
                        .opacity((viewModel.isLoading || !viewModel.isValidEmail || !viewModel.isValidPassword) ? 0.5 : 1.0)
                    }
                    .padding(.horizontal, AppSpacing.large)
                    
                    Spacer()
                }
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(AppColors.primaryText)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}

