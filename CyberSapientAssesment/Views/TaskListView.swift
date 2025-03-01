//
//  TaskListView.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
   
    @State private var showAddTaskSheet = false
    @State private var showSettingsSheet = false
    @State private var showSortFilterMenu = false
    @State private var showDeletedToast = false
    @State private var lastDeletedTask: TaskItem?
    @State private var lastDeletedTaskIndex: Int?
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
   
    @State private var isLoading = true
    @State private var addButtonScale: CGFloat = 1.0
    
    
    @State private var refreshID = UUID()
    
   
    private var fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
    @FetchRequest private var tasks: FetchedResults<TaskItem>
    
    init(viewModel: TaskViewModel) {
        self.viewModel = viewModel
        
        _searchText = State(initialValue: viewModel.searchText)
        
        
        fetchRequest.sortDescriptors = viewModel.getNSSortDescriptors()
        fetchRequest.predicate = viewModel.getPredicate()
        
       
        _tasks = FetchRequest(fetchRequest: fetchRequest, animation: .default)
    }
    
    var body: some View {
        ZStack {
           
            if isSearchFocused {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isSearchFocused = false
                    }
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 12) {
                
                searchBar
                
                VStack(spacing: 12) {
                    
                    filterSortBar
                    
                    ZStack {
                       
                        if !tasks.isEmpty {
                            VStack {
                                CircularProgressView(
                                    progress: viewModel.getCompletionPercentage(tasks: tasks),
                                    color: viewModel.accentColor,
                                    size: 80
                                )
                                .padding(.vertical, 10)
                                
                                Spacer()
                            }
                        }
                        
                        VStack {
                            if isLoading {
                                loadingView
                            } else if tasks.isEmpty {
                                getEmptyStateView()
                                    .transition(.opacity)
                            } else {
                                taskListView
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
                .id(refreshID)
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettingsSheet = true
                    }) {
                        Image(systemName: "gear")
                    }
                    .accessibilityLabel("Settings")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            addButtonScale = 0.8
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    addButtonScale = 1.0
                                }
                            }
                        }
                        
                        showAddTaskSheet = true
                    }) {
                        Image(systemName: "plus")
                            .scaleEffect(addButtonScale)
                    }
                    .accessibilityLabel("Add Task")
                }
                
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            isSearchFocused = false
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddTaskSheet) {
                TaskFormView(viewModel: viewModel)
                    .onDisappear {
                        updateFetchRequest()
                    }
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView(viewModel: viewModel)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        isLoading = false
                    }
                }
                
                updateFetchRequest()
            }
            .onChange(of: viewModel.selectedSortOption) { _ in
                updateFetchRequest()
            }
            .onChange(of: viewModel.selectedFilterOption) { _ in
                updateFetchRequest()
            }
            .onChange(of: viewModel.isAscending) { _ in
                updateFetchRequest()
            }
            .onChange(of: viewModel.searchText) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    updateFetchRequest()
                }
            }
        }
        .toast(
            isShowing: $showDeletedToast,
            message: "Task deleted",
            action: undoDelete,
            accentColor: viewModel.accentColor
        )
    }
    
    // MARK: - Subviews
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search tasks", text: $searchText)
                .focused($isSearchFocused)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .onChange(of: searchText) { newValue in
                    viewModel.updateSearchText(newValue)
                }
                .submitLabel(.search)
                .onSubmit {
                    viewModel.setSearchTextImmediately(searchText)
                    updateFetchRequest()
                    isSearchFocused = false
                }
                .accessibilityLabel("Search tasks")
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    viewModel.setSearchTextImmediately("")
                    updateFetchRequest()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(BorderlessButtonStyle())
                .accessibilityLabel("Clear search")
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var filterSortBar: some View {
        HStack {
            Menu {
                ForEach(FilterOption.allCases) { option in
                    Button(action: {
                        viewModel.selectedFilterOption = option
                        updateFetchRequest()
                    }) {
                        Label(option.rawValue, systemImage: option == viewModel.selectedFilterOption ? "checkmark" : "")
                    }
                }
            } label: {
                Label(viewModel.selectedFilterOption.rawValue, systemImage: "line.3.horizontal.decrease.circle")
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .accessibilityLabel("Filter tasks by \(viewModel.selectedFilterOption.rawValue)")
            
            Spacer()
            
            Menu {
                ForEach(SortOption.allCases) { option in
                    Button(action: {
                        viewModel.selectedSortOption = option
                        updateFetchRequest()
                    }) {
                        Label(option.rawValue, systemImage: option == viewModel.selectedSortOption ? "checkmark" : "")
                    }
                }
                
                Divider()
                
                Button(action: {
                    viewModel.isAscending.toggle()
                    updateFetchRequest()
                }) {
                    Label(viewModel.isAscending ? "Ascending" : "Descending", 
                          systemImage: viewModel.isAscending ? "arrow.up" : "arrow.down")
                }
            } label: {
                HStack {
                    Label(viewModel.selectedSortOption.rawValue, systemImage: "arrow.up.arrow.down")
                    Image(systemName: viewModel.isAscending ? "arrow.up" : "arrow.down")
                        .font(.caption)
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .accessibilityLabel("Sort tasks by \(viewModel.selectedSortOption.rawValue), \(viewModel.isAscending ? "Ascending" : "Descending")")
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    private var loadingView: some View {
        VStack(spacing: 15) {
            ForEach(0..<5, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray5))
                    .frame(height: 80)
                    .modifier(ShimmerEffect())
            }
        }
        .padding()
    }
    
    private var taskListView: some View {
        List {
            ForEach(tasks) { task in
                NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                    TaskRowView(task: task, accentColor: viewModel.accentColor) {
                        viewModel.toggleTaskCompletion(task)
                    }
                    .padding(.vertical, 5)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteTask(task)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
                .swipeActions(edge: .leading) {
                    Button {
                        viewModel.toggleTaskCompletion(task)
                    } label: {
                        Label(
                            task.isCompleted ? "Mark Incomplete" : "Mark Complete",
                            systemImage: task.isCompleted ? "circle" : "checkmark.circle"
                        )
                    }
                    .tint(task.isCompleted ? .gray : viewModel.accentColor)
                }
                .transition(.opacity.combined(with: .slide))
            }
            .onMove { source, destination in
                viewModel.reorderTasks(from: source, to: destination, tasks: tasks)
            }
        }
        .listStyle(.plain)
        .animation(.spring(), value: tasks.count)
    }
    
    // MARK: - Helper Methods
    
    private func getEmptyStateView() -> some View {
        if !viewModel.hasAnyTasks() {
            return EmptyStateView(
                accentColor: viewModel.accentColor,
                emptyStateType: .noTasks
            )
        } else if !viewModel.searchText.isEmpty {
            return EmptyStateView(
                accentColor: viewModel.accentColor,
                emptyStateType: .noSearchResults(searchText: viewModel.searchText)
            )
        } else {
            return EmptyStateView(
                accentColor: viewModel.accentColor,
                emptyStateType: .noFilteredResults(filterName: viewModel.selectedFilterOption.rawValue)
            )
        }
    }
    
    private func updateFetchRequest() {
        fetchRequest.sortDescriptors = viewModel.getNSSortDescriptors()
        fetchRequest.predicate = viewModel.getPredicate()
        
        withAnimation {
            refreshID = UUID()
        }
    }
    
    private func deleteTask(_ task: TaskItem) {
        lastDeletedTask = task
        if let index = tasks.firstIndex(of: task) {
            lastDeletedTaskIndex = index
        }
        viewModel.deleteTask(task)
        
        withAnimation {
            showDeletedToast = true
        }
    }
    
    private func undoDelete() {
        guard let deletedTask = lastDeletedTask else { return }
        
        let newTask = TaskItem(context: viewContext)
        newTask.taskTitle = deletedTask.taskTitle
        newTask.taskDescription = deletedTask.taskDescription
        newTask.taskPriority = deletedTask.taskPriority
        newTask.taskDueDate = deletedTask.taskDueDate
        newTask.isCompleted = deletedTask.isCompleted
        newTask.createdAt = deletedTask.createdAt
        
        if let index = lastDeletedTaskIndex {
            newTask.order = Int32(index)
        } else {
            newTask.order = 0
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error undoing delete: \(error)")
        }
        
        lastDeletedTask = nil
        lastDeletedTaskIndex = nil
    }
} 
