import SwiftUI

struct WiggleAnimationModifier: ViewModifier {
    let amplitude: CGFloat
    let speed: Double

    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(Double(sin(phase)) * Double(amplitude)))
            .offset(x: sin(phase * 1.3) * amplitude, y: cos(phase * 1.1) * amplitude)
            .onAppear {
                withAnimation(.easeInOut(duration: speed).repeatForever()) {
                    phase = .pi * 2
                }
            }
    }
}
