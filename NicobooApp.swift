//
//  NicobooApp.swift
//  Nicoboo
//
//  Created by Tina Jiang on 11/6/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

extension Font {
    static let myFont = Font.custom("MyFont-Regular", size: 17)
}


@main
struct NicobooApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        // Initialize Firebase
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .modelContainer(for: [Achievement.self, SavingGoal.self])
    }
}
