//
//  TaskViewModel.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import Foundation
import CoreData
import SwiftUI
import Combine

enum SortOption: String, CaseIterable, Identifiable {
    case dueDate = "Due Date"
    case priority = "Priority"
    case alphabetical = "Alphabetical"
    
    var id: String { self.rawValue }
}

enum FilterOption: String, CaseIterable, Identifiable {
    case all = "All"
    case completed = "Completed"
    case pending = "Pending"
    
    var id: String { self.rawValue }
}

class TaskViewModel: ObservableObject {
    @Published var selectedSortOption: SortOption = .dueDate
    @Published var selectedFilterOption: FilterOption = .all
    @Published var isAscending: Bool = true
    @Published var searchText: String = ""
    @Published var accentColor: Color = .blue
    @Published var isLoading: Bool = false
    @Published private var searchInput: String = ""
    
    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        
        // adding debounce in search for better user experience.
        $searchInput
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] debouncedText in
                guard let self = self else { return }
                if self.searchText != debouncedText {
                    DispatchQueue.main.async {
                        self.searchText = debouncedText
                        self.objectWillChange.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func updateSearchText(_ newText: String) {
        searchInput = newText
    }
    
    func setSearchTextImmediately(_ newText: String) {
        searchInput = newText
        searchText = newText
        objectWillChange.send()
    }
    
   
    func getSortDescriptors() -> [SortDescriptor<TaskItem>] {
        switch selectedSortOption {
        case .dueDate:
            return [SortDescriptor(\TaskItem.taskDueDate, order: isAscending ? .forward : .reverse)]
        case .priority:
            return [
                SortDescriptor(\.taskPriority, order: isAscending ? .forward : .reverse),
                SortDescriptor(\.order, order: .forward)
            ]
        case .alphabetical:
            return [SortDescriptor(\TaskItem.taskTitle, order: isAscending ? .forward : .reverse)]
        }
    }
    
    func getNSSortDescriptors() -> [NSSortDescriptor] {
        switch selectedSortOption {
        case .dueDate:
            return [NSSortDescriptor(keyPath: \TaskItem.taskDueDate, ascending: isAscending)]
        case .priority:
            return [
                NSSortDescriptor(key: "taskPriority", ascending: isAscending),
                NSSortDescriptor(key: "order", ascending: true)
            ]
        case .alphabetical:
            return [NSSortDescriptor(keyPath: \TaskItem.taskTitle, ascending: isAscending)]
        }
    }
    
    func getPredicate() -> NSPredicate? {
        var predicates: [NSPredicate] = []
        
        // check filters
        switch selectedFilterOption {
        case .all:
            break
        case .completed:
            predicates.append(NSPredicate(format: "isCompleted == %@", NSNumber(value: true)))
        case .pending:
            predicates.append(NSPredicate(format: "isCompleted == %@", NSNumber(value: false)))
        }
        
       // check search text
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "taskTitle CONTAINS[cd] %@ OR taskDescription CONTAINS[cd] %@", searchText, searchText))
        }
        
        if predicates.isEmpty {
            return nil
        } else if predicates.count == 1 {
            return predicates.first
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
    
    func addTask(title: String, description: String, priority: TaskPriority, dueDate: Date) {
        withAnimation {
            let newTask = TaskItem(context: viewContext)
            newTask.taskTitle = title
            newTask.taskDescription = description
            newTask.taskPriority = priority.rawValue
            newTask.taskDueDate = dueDate
            newTask.isCompleted = false
            newTask.createdAt = Date()
            
           
            let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TaskItem.order, ascending: false)]
            fetchRequest.fetchLimit = 1
            
            do {
                let results = try viewContext.fetch(fetchRequest)
                if let highestOrder = results.first?.order {
                    newTask.order = highestOrder + 1
                } else {
                    newTask.order = 0
                }
                
                try viewContext.save()
                objectWillChange.send()
            } catch {
                let nsError = error as NSError
                print("Error adding task: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func updateTask(_ task: TaskItem) {
        withAnimation {
            do {
                try viewContext.save()
                objectWillChange.send()
            } catch {
                let nsError = error as NSError
                print("Error updating task: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func toggleTaskCompletion(_ task: TaskItem) {
        withAnimation {
            task.isCompleted.toggle()
            updateTask(task)
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        withAnimation {
            viewContext.delete(task)
            do {
                try viewContext.save()
                objectWillChange.send()
            } catch {
                let nsError = error as NSError
                print("Error deleting task: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func reorderTasks(from source: IndexSet, to destination: Int, tasks: FetchedResults<TaskItem>) {
        var taskItems = tasks.map { $0 }
        taskItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, task) in taskItems.enumerated() {
            task.order = Int32(index)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error reordering tasks: \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getCompletionPercentage(tasks: FetchedResults<TaskItem>) -> Double {
        guard !tasks.isEmpty else { return 0.0 }
        
        let completedCount = tasks.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(tasks.count)
    }

    
    func hasAnyTasks() -> Bool {
        let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking for tasks: \(error)")
            return false
        }
    }
} 
