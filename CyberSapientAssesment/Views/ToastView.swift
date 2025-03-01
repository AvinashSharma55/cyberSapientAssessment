//
//  ToastView.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let actionLabel: String
    let action: () -> Void
    let accentColor: Color
    
    @Binding var isShowing: Bool
    
    var body: some View {
        HStack {
            Text(message)
                .foregroundColor(.white)
                .padding(.leading)
            
            Spacer()
            
            Button(action: {
                action()
                withAnimation {
                    isShowing = false
                }
            }) {
                Text(actionLabel)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(8)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.trailing)
        }
        .frame(minHeight: 50)
        .background(accentColor)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(message), \(actionLabel) button available")
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let actionLabel: String
    let action: () -> Void
    let accentColor: Color
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isShowing {
                VStack {
                    Spacer()
                    
                    ToastView(
                        message: message,
                        actionLabel: actionLabel,
                        action: action,
                        accentColor: accentColor,
                        isShowing: $isShowing
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        // Auto-dismiss after 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                .zIndex(100)
            }
        }
    }
}

extension View {
    func toast(
        isShowing: Binding<Bool>,
        message: String,
        actionLabel: String = "Undo",
        action: @escaping () -> Void,
        accentColor: Color
    ) -> some View {
        self.modifier(
            ToastModifier(
                isShowing: isShowing,
                message: message,
                actionLabel: actionLabel,
                action: action,
                accentColor: accentColor
            )
        )
    }
} 
