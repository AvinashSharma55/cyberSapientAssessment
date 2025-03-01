//
//  TaskDetailView.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var task: TaskItem
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false
    @State private var showEditSheet = false
    
   
    @State private var animateContent = false
    
    private var priorityColor: Color {
        guard let priorityString = task.taskPriority,
              let priority = TaskPriority(rawValue: priorityString) else {
            return .gray
        }
        return priority.color
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(task.taskTitle ?? "Untitled Task")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(task.isCompleted ? .secondary : .primary)
                            .strikethrough(task.isCompleted)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.toggleTaskCompletion(task)
                        }
                    }) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 30))
                            .foregroundColor(task.isCompleted ? viewModel.accentColor : .gray)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .accessibilityLabel(task.isCompleted ? "Mark as incomplete" : "Mark as complete")
                }
                .padding(.bottom)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
                
                if let priorityString = task.taskPriority, let priority = TaskPriority(rawValue: priorityString) {
                    HStack {
                        Image(systemName: priority.icon)
                        Text(priority.displayName)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(priority.color)
                    .cornerRadius(20)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                }
                
                if let dueDate = task.taskDueDate {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Due Date")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(viewModel.accentColor)
                            
                            Text(dueDate, style: .date)
                                .font(.body)
                        }
                    }
                    .padding(.vertical)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                }
                
                if let description = task.taskDescription, !description.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(description)
                            .font(.body)
                            .padding(.top, 5)
                    }
                    .padding(.vertical)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                }
                
                if let createdAt = task.createdAt {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Created")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(viewModel.accentColor)
                            
                            Text(createdAt, style: .date)
                                .font(.body)
                        }
                    }
                    .padding(.vertical)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    Button(action: {
                        showEditSheet = true
                    }) {
                        Label("Edit Task", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .tint(viewModel.accentColor)
                    
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Label("Delete Task", systemImage: "trash")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .tint(.red)
                }
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showEditSheet = true
                }) {
                    Image(systemName: "pencil")
                }
            }
        }
        .onAppear {
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateContent = true
            }
        }
        .sheet(isPresented: $showEditSheet) {
            TaskFormView(viewModel: viewModel, editTask: task)
        }
        .alert("Delete Task", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteTask(task)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this task? This action cannot be undone.")
        }
        .accessibilityElement(children: .contain)
    }
} 
