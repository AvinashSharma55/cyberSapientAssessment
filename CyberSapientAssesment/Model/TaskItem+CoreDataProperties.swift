//
//  TaskItem+CoreDataProperties.swift
//  CyberSapientAssesment
//
//  Created by Avinash Sharma on 27/02/25.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var taskTitle: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskPriority: String?
    @NSManaged public var taskDueDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date?
    @NSManaged public var order: Int32

}

extension TaskItem : Identifiable {

}
