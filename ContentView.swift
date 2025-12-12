//
//  ContentView.swift
//  Nicoboo
//
//  Created by Tina Jiang on 11/6/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if appState.userProfile == nil {
                OnboardingContainerView()
            } else {
                MainTabView()
            }
        }
        .environmentObject(appState)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
