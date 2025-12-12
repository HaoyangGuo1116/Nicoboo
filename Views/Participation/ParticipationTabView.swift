//
//  ParticipationTabView.swift
//  Nicoboo
//
//  Created by Sabrina Jiang on 11/17/25.
//

import SwiftUI
import AVFoundation

struct ParticipationTabView: View {
    @State private var isOpen: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height * 0.6
            
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                // Firework GIF - only show when zippo is open, positioned around zippo
                if isOpen {
                    GIFView(gifName: "firework", isAnimating: isOpen)
                        .frame(width: 5, height: 5)
                        .position(x: 250, y: 500) // Fixed position coordinates
                        .transition(.opacity)
                }
                
                // Zippo lighter image - larger size, positioned in center-bottom
                Image(isOpen ? "zippo-open" : "zippo-close")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 800, height: 800)
                    .position(x: centerX, y: centerY)
                    .zIndex(1) // Ensure zippo is above the firework
                    .onTapGesture {
                        if isOpen {
                            // Close without animation
                            isOpen = false
                            SoundManager.shared.stopFirework()
                        } else {
                            // Open with animation
//                            withAnimation(.spring(response: 0.1, dampingFraction: 0.4)) {
                                isOpen = true
//                            }
                            SoundManager.shared.playOpenThenLoopFirework()
                        }
                    }
            }
        }
    }
}

#Preview {
    ParticipationTabView()
}

