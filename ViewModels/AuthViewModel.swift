//
//  AuthViewModel.swift
//  Nicoboo
//
//  Created on 11/30/25.
//

import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var displayName: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isGuest: Bool = false
    
    private let authService = FirebaseAuthService.shared
    
    var isValidEmail: Bool {
        !email.isEmpty && email.contains("@") && email.contains(".")
    }
    
    var isValidPassword: Bool {
        password.count >= 6
    }
    
    var passwordsMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }
    
    // MARK: - Sign Up
    func signUp() async {
        guard isValidEmail && isValidPassword && passwordsMatch else {
            errorMessage = "Please fill in all fields correctly"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.signUp(email: email, password: password, displayName: displayName)
            await MainActor.run {
                isLoading = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Sign In
    func signIn() async {
        guard isValidEmail && isValidPassword else {
            errorMessage = "Please enter a valid email and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.signIn(email: email, password: password)
            await MainActor.run {
                isLoading = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Anonymous Sign In (Firebase)
    func signInAnonymously() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.signInAnonymously()
            await MainActor.run {
                isLoading = false
                isGuest = false // Anonymous users are authenticated, not guests
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Guest Login (Local) - Deprecated
    func signInAsGuest() {
        authService.signInAsGuest()
        isGuest = true
        // Store guest status in AppState if needed
    }
    
    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
}

