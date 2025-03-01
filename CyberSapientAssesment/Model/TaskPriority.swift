//
//  TaskPriority.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

enum TaskPriority: String, CaseIterable, Identifiable {
    
    // adding number in the beggining is helping us make the sort functionality work correctly, where-in high is the highest and low is lowest.
    
    case low = "3-Low"
    case medium = "2-Medium"
    case high = "1-High"
    
    var id: String { self.rawValue }
    

    var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var sortOrder: Int {
        switch self {
        case .low:
            return 1
        case .medium:
            return 2
        case .high:
            return 3
        }
    }
    
    var color: Color {
        switch self {
        case .low:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
    
    var icon: String {
        switch self {
        case .low:
            return "arrow.down.circle.fill"
        case .medium:
            return "equal.circle.fill"
        case .high:
            return "exclamationmark.circle.fill"
        }
    }
} 
