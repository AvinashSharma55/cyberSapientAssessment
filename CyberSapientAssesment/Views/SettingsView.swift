//
//  SettingsView.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // Available accent colors
    private let accentColors: [Color] = [
        .blue, .purple, .pink, .red, .orange, .yellow, .green, .mint, .teal, .cyan, .indigo
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _ in
                            print("Dark mode toggled")
                        }
                        .accessibilityLabel("Dark Mode")
                        .accessibilityHint("Toggle to switch between light and dark mode")
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Accent Color")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                            ForEach(0..<accentColors.count, id: \.self) { index in
                                Circle()
                                    .fill(accentColors[index])
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: viewModel.accentColor == accentColors[index] ? 3 : 0)
                                            .padding(2)
                                    )
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.accentColor = accentColors[index]
                                        }
                                    }
                                    .accessibilityLabel("\(colorName(for: accentColors[index])) accent color")
                                    .accessibilityAddTraits(viewModel.accentColor == accentColors[index] ? .isSelected : [])
                                    .accessibilityHint("Double tap to select this accent color")
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Section(header: Text("About")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Task Manager")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Version 1.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("This app was created as part of the CyberSapient Assessment. It demonstrates advanced UI/UX skills with SwiftUI, including animations, accessibility support, and adherence to Apple's Human Interface Guidelines.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // Helper function to get color name for accessibility
    private func colorName(for color: Color) -> String {
        if color == .blue { return "Blue" }
        if color == .purple { return "Purple" }
        if color == .pink { return "Pink" }
        if color == .red { return "Red" }
        if color == .orange { return "Orange" }
        if color == .yellow { return "Yellow" }
        if color == .green { return "Green" }
        if color == .mint { return "Mint" }
        if color == .teal { return "Teal" }
        if color == .cyan { return "Cyan" }
        if color == .indigo { return "Indigo" }
        return "Unknown"
    }
} 
