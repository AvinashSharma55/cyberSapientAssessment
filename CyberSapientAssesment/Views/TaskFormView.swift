//
//  TaskFormView.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI

struct TaskFormView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var priority: TaskPriority = .medium
    @State private var dueDate: Date = Date().addingTimeInterval(24 * 60 * 60) // defaults to tommorrow.
    
    
    @State private var isAnimating = false
    @State private var showValidationAlert = false
    
    
    var editTask: TaskItem?
    
    init(viewModel: TaskViewModel, editTask: TaskItem? = nil) {
        self.viewModel = viewModel
        self.editTask = editTask
        
        if let task = editTask {
            _title = State(initialValue: task.taskTitle ?? "")
            _description = State(initialValue: task.taskDescription ?? "")
            
            if let priorityString = task.taskPriority, let taskPriority = TaskPriority(rawValue: priorityString) {
                _priority = State(initialValue: taskPriority)
            }
            
            if let taskDueDate = task.taskDueDate {
                _dueDate = State(initialValue: taskDueDate)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                        .font(.headline)
                        .accessibilityLabel("Task title")
                    
                    ZStack(alignment: .topLeading) {
                        if description.isEmpty {
                            Text("Description (Optional)")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                        
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                            .accessibilityLabel("Task description")
                    }
                }
                
                Section(header: Text("Priority")) {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases) { priority in
                            Label {
                                Text(priority.displayName)
                            } icon: {
                                Image(systemName: priority.icon)
                                    .foregroundColor(priority.color)
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .accessibilityLabel("Task priority")
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .accessibilityLabel("Task due date")
                }
                
                Section {
                    Button(action: saveTask) {
                        HStack {
                            Spacer()
                            Text(editTask == nil ? "Add Task" : "Save Changes")
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    .listRowBackground(viewModel.accentColor)
                    .buttonStyle(BorderlessButtonStyle())
                    .accessibilityLabel(editTask == nil ? "Add Task" : "Save Changes")
                }
            }
            .navigationTitle(editTask == nil ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Missing Information", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a title for your task.")
            }
            .onAppear {
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isAnimating = true
                }
            }
        }
    }
    
    private func saveTask() {
        
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showValidationAlert = true
            return
        }
        
        if let task = editTask {
           
            task.taskTitle = title
            task.taskDescription = description
            task.taskPriority = priority.rawValue
            task.taskDueDate = dueDate
            
            viewModel.updateTask(task)
        } else {
           
            viewModel.addTask(
                title: title,
                description: description,
                priority: priority,
                dueDate: dueDate
            )
        }
        
       
        dismiss()
    }
} 
