//
//  View+Extensions.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

extension View {
    func addTaskButtonStyle(color: Color) -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(10)
            .shadow(radius: 3)
    }
    
    func taskRowStyle() -> some View {
        self
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    func pulseAnimation() -> some View {
        self.modifier(PulseEffect())
    }
    
    func shimmerEffect() -> some View {
        self.modifier(ShimmerEffect())
    }
}

// Pulse animation effect
struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}

// Shimmer loading effect
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: phase - 0.2),
                            .init(color: .white.opacity(0.7), location: phase),
                            .init(color: .clear, location: phase + 0.2)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geometry.size.width * 3)
                    .offset(x: -2 * geometry.size.width + phase * 3 * geometry.size.width)
                    .mask(content)
                    .blendMode(.screen)
                }
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

// Accessibility extensions
extension View {
    func accessibilityLabel(_ label: String) -> some View {
        self.accessibility(label: Text(label))
    }
    
    func accessibilityHint(_ hint: String) -> some View {
        self.accessibility(hint: Text(hint))
    }
    
    func accessibilityAction(named name: String, action: @escaping () -> Void) -> some View {
        self.accessibilityAction(named: Text(name), action)
    }
} 