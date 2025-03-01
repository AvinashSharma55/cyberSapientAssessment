//
//  Persistence.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let priorities = ["3-Low", "2-Medium", "1-High"]
        
        let titles = [
            "Complete project documentation",
            "Prepare presentation slides",
            "Schedule team meeting",
            "Review code changes",
            "Submit expense report",
            "Call client about requirements",
            "Update project timeline",
            "Research new technologies",
            "Fix UI bugs in the app",
            "Respond to emails"
        ]
        
        for i in 0..<10 {
            let newItem = TaskItem(context: viewContext)
            newItem.taskTitle = titles[i]
            newItem.taskDescription = "This is a sample task description for task #\(i+1). It provides more details about what needs to be done."
            newItem.taskPriority = priorities[i % 3]
            newItem.taskDueDate = Date().addingTimeInterval(Double(i * 24 * 60 * 60)) // Each task due one day later
            newItem.isCompleted = i % 3 == 0 // Every third task is completed
            newItem.createdAt = Date().addingTimeInterval(-Double(i * 12 * 60 * 60)) // Created at different times
            newItem.order = Int32(i)
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CyberSapientAssesment")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
