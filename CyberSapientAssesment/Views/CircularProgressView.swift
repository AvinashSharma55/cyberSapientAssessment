//
//  CircularProgressView.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

struct CircularProgressView: View {
    var progress: Double
    var color: Color
    var size: CGFloat = 100
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(color)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(animatedProgress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut(duration: 1.0), value: animatedProgress)
            
    
            VStack {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                
                Text("Completed")
                    .font(.system(size: size * 0.12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
        
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = newValue
            }
        }
        .accessibilityLabel("Task completion progress: \(Int(progress * 100)) percent")
    }
} 
