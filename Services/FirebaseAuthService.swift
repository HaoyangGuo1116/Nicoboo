//
//  FirebaseAuthService.swift
//  Nicoboo
//
//  Created on 11/30/25.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthService: ObservableObject {
    static let shared = FirebaseAuthService()
    
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    
    private let db = Firestore.firestore()
    
    private init() {
        // Listen to auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
            self?.isAuthenticated = user != nil
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, displayName: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        
        // Update user profile
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
        
        // Save user data to Firestore
        try await saveUserData(userId: result.user.uid, email: email, displayName: displayName)
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
        currentUser = nil
        isAuthenticated = false
    }
    
    // MARK: - Anonymous Sign In (Firebase)
    func signInAnonymously() async throws {
        let result = try await Auth.auth().signInAnonymously()
        
        // Save anonymous user data to Firestore
        try await saveUserData(userId: result.user.uid, email: nil, displayName: "Guest User")
    }
    
    // MARK: - Guest Login (Local) - Deprecated, use signInAnonymously instead
    func signInAsGuest() {
        // Guest login doesn't require Firebase authentication
        // Just mark as guest user locally
        isAuthenticated = true
        currentUser = nil // No Firebase user for guests
    }
    
    // MARK: - Save User Data to Firestore
    private func saveUserData(userId: String, email: String?, displayName: String) async throws {
        var userData: [String: Any] = [
            "displayName": displayName,
            "createdAt": Timestamp(date: Date()),
            "lastLoginAt": Timestamp(date: Date()),
            "isAnonymous": email == nil
        ]
        
        if let email = email {
            userData["email"] = email
        }
        
        try await db.collection("users").document(userId).setData(userData, merge: true)
    }
    
    // MARK: - Update User Profile in Firestore
    func updateUserProfile(userId: String, profile: UserProfile) async throws {
        let profileData: [String: Any] = [
            "smokingType": profile.smokingType.rawValue,
            "stopDate": Timestamp(date: profile.stopDate),
            "cigarettesPerDay": profile.cigarettesPerDay as Any,
            "cigarettesPerPack": profile.cigarettesPerPack as Any,
            "pricePerPack": profile.pricePerPack as Any,
            "puffsPerDay": profile.puffsPerDay as Any,
            "podsPerDay": profile.podsPerDay as Any,
            "millilitersPerPod": profile.millilitersPerPod as Any,
            "pricePerPod": profile.pricePerPod as Any,
            "currencyCode": profile.currencyCode,
            "updatedAt": Timestamp(date: Date())
        ]
        
        try await db.collection("users").document(userId).collection("profile").document("data").setData(profileData, merge: true)
    }
    
    // MARK: - Load User Profile from Firestore
    func loadUserProfile(userId: String) async throws -> UserProfile? {
        let doc = try await db.collection("users").document(userId).collection("profile").document("data").getDocument()
        
        guard let data = doc.data() else { return nil }
        
        let smokingType = SmokingType(rawValue: data["smokingType"] as? String ?? "smoke") ?? .smoke
        let stopDate = (data["stopDate"] as? Timestamp)?.dateValue() ?? Date()
        let cigarettesPerDay = data["cigarettesPerDay"] as? Int
        let cigarettesPerPack = data["cigarettesPerPack"] as? Int
        let pricePerPack = data["pricePerPack"] as? Double
        let puffsPerDay = data["puffsPerDay"] as? Int
        let podsPerDay = data["podsPerDay"] as? Int
        let millilitersPerPod = data["millilitersPerPod"] as? Double
        let pricePerPod = data["pricePerPod"] as? Double
        let currencyCode = data["currencyCode"] as? String ?? "USD"
        
        return UserProfile(
            smokingType: smokingType,
            stopDate: stopDate,
            cigarettesPerDay: cigarettesPerDay,
            cigarettesPerPack: cigarettesPerPack,
            pricePerPack: pricePerPack,
            puffsPerDay: puffsPerDay,
            podsPerDay: podsPerDay,
            millilitersPerPod: millilitersPerPod,
            pricePerPod: pricePerPod,
            currencyCode: currencyCode
        )
    }
}

