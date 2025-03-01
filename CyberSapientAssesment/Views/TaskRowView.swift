//
//  TaskRowView.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

struct TaskRowView: View {
    @ObservedObject var task: TaskItem
    var accentColor: Color
    var onToggle: () -> Void
    
    private var priorityColor: Color {
        guard let priorityString = task.taskPriority,
              let priority = TaskPriority(rawValue: priorityString) else {
            return .gray
        }
        return priority.color
    }
    
    private var priorityIcon: String {
        guard let priorityString = task.taskPriority,
              let priority = TaskPriority(rawValue: priorityString) else {
            return "questionmark.circle.fill"
        }
        return priority.icon
    }
    
    private var formattedDate: String {
        guard let date = task.taskDueDate else { return "No due date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? accentColor : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
            .accessibilityLabel(task.isCompleted ? "Completed" : "Not completed")
            .accessibilityHint("Double tap to mark as \(task.isCompleted ? "not completed" : "completed")")
            
            VStack(alignment: .leading, spacing: 5) {
                Text(task.taskTitle ?? "Untitled Task")
                    .font(.headline)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                    .strikethrough(task.isCompleted)
                
                if let description = task.taskDescription, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    
                    Label {
                        Text(getPriorityDisplayName())
                            .font(.caption)
                    } icon: {
                        Image(systemName: priorityIcon)
                            .foregroundColor(priorityColor)
                    }
                    
                    Spacer()
                    
                    Label {
                        Text(formattedDate)
                            .font(.caption)
                    } icon: {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .opacity(task.isCompleted ? 0.8 : 1.0)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(task.taskTitle ?? "Untitled Task"), \(task.taskPriority ?? "No priority"), Due \(formattedDate), \(task.isCompleted ? "Completed" : "Not completed")")
    }
    
    private func getPriorityDisplayName() -> String {
        guard let priorityString = task.taskPriority,
              let priority = TaskPriority(rawValue: priorityString) else {
            return "None"
        }
        return priority.displayName
    }
} 
