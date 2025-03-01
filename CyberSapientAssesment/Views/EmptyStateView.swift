//
//  EmptyStateView.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

struct EmptyStateView: View {
    var accentColor: Color
    var emptyStateType: EmptyStateType
    
    @State private var isAnimating = false
    
   // Using different empty states for zero tasks and in case search and/or filter returns zero value.
    enum EmptyStateType: Equatable {
        case noTasks
        case noSearchResults(searchText: String)
        case noFilteredResults(filterName: String)
        
        var title: String {
            switch self {
            case .noTasks:
                return "No Tasks Yet"
            case .noSearchResults:
                return "No Search Results"
            case .noFilteredResults(let filterName):
                return "No \(filterName) Tasks"
            }
        }
        
        var description: String {
            switch self {
            case .noTasks:
                return "Add your first task by tapping the + button"
            case .noSearchResults(let searchText):
                return "No tasks match '\(searchText)'. Try a different search term."
            case .noFilteredResults:
                return "Try changing your filter settings or add a new task"
            }
        }
        
        var iconName: String {
            switch self {
            case .noTasks:
                return "checklist"
            case .noSearchResults:
                return "magnifyingglass"
            case .noFilteredResults:
                return "line.3.horizontal.decrease.circle"
            }
        }
        
        var showArrow: Bool {
            if case .noTasks = self {
                return true
            }
            return false
        }
        
        static func == (lhs: EmptyStateType, rhs: EmptyStateType) -> Bool {
            switch (lhs, rhs) {
            case (.noTasks, .noTasks):
                return true
            case (.noSearchResults(let lhsText), .noSearchResults(let rhsText)):
                return lhsText == rhsText
            case (.noFilteredResults(let lhsFilter), .noFilteredResults(let rhsFilter)):
                return lhsFilter == rhsFilter
            default:
                return false
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: emptyStateType.iconName)
                .font(.system(size: 80))
                .foregroundColor(accentColor)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            Text(emptyStateType.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text(emptyStateType.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer().frame(height: 20)
            
            if emptyStateType.showArrow {
                Image(systemName: "arrow.down")
                    .font(.title)
                    .foregroundColor(accentColor)
                    .offset(y: isAnimating ? 10 : 0)
                    .animation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
        }
        .padding()
        .onAppear {
            isAnimating = true
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(getAccessibilityLabel())
    }
    
    private func getAccessibilityLabel() -> String {
        switch emptyStateType {
        case .noTasks:
            return "No tasks yet. Add your first task by tapping the plus button at the top right."
        case .noSearchResults(let searchText):
            return "No tasks match '\(searchText)'. Try a different search term."
        case .noFilteredResults(let filterName):
            return "No \(filterName) tasks. Try changing your filter settings or add a new task."
        }
    }
} 
