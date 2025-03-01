//
//  TaskManagerUITests.swift
//  CyberSapientAssesmentUITests
//
//  Created by Avinash Sharma on 27/02/25.
//


import XCTest

final class TaskManagerUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["UI-TESTING"]
        app.launch()
        
        XCTAssertTrue(app.navigationBars["Tasks"].waitForExistence(timeout: 5))
        
        sleep(2)
        
        clearAllTasks()
        
        sleep(2)
    }
    
    func testPrioritySorting() throws {
        addTask(title: "High Priority Task", description: "This is a high priority task", priority: "High")
        addTask(title: "Medium Priority Task", description: "This is a medium priority task", priority: "Medium")
        addTask(title: "Low Priority Task", description: "This is a low priority task", priority: "Low")
        
        sleep(2)
        
        let dueDateButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Due Date'")).firstMatch
        XCTAssertTrue(dueDateButton.waitForExistence(timeout: 2))
        dueDateButton.tap()
        
        sleep(1)
        
        XCTAssertTrue(app.buttons["Priority"].waitForExistence(timeout: 2))
        app.buttons["Priority"].tap()
        
        sleep(2)
        
        let taskTitles = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Priority Task'")).allElementsBoundByIndex
        
        if taskTitles.count >= 3 {
            XCTAssertTrue(taskTitles[0].label.contains("High"))
            XCTAssertTrue(taskTitles[1].label.contains("Medium"))
            XCTAssertTrue(taskTitles[2].label.contains("Low"))
        } else {
            XCTFail("Not all priority tasks are visible")
        }
        
        let ascendingButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'arrow.up'")).firstMatch
        XCTAssertTrue(ascendingButton.waitForExistence(timeout: 2))
        ascendingButton.tap()
        
        sleep(2)
        
        let taskTitlesDesc = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Priority Task'")).allElementsBoundByIndex
        
        if taskTitlesDesc.count >= 3 {
            XCTAssertTrue(taskTitlesDesc[0].label.contains("Low"))
            XCTAssertTrue(taskTitlesDesc[1].label.contains("Medium"))
            XCTAssertTrue(taskTitlesDesc[2].label.contains("High"))
        } else {
            XCTFail("Not all priority tasks are visible")
        }
    }
    
    func testEmptyStateViews() throws {
        sleep(2)
        
        let noTasksYetText = app.staticTexts["No Tasks Yet"]
        XCTAssertTrue(noTasksYetText.waitForExistence(timeout: 3), "No Tasks Yet text should be visible")
        
        sleep(1)
        
        let searchField = app.textFields["Search tasks"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search field should be visible")
        searchField.tap()
        
        sleep(1)
        
        "NonexistentTask".forEach { char in
            searchField.typeText(String(char))
            usleep(50000)
        }
        
        sleep(1)
        
        if app.keyboards.buttons["search"].waitForExistence(timeout: 3) {
            app.keyboards.buttons["search"].tap()
        } else if app.keyboards.buttons["Search"].waitForExistence(timeout: 1) {
            app.keyboards.buttons["Search"].tap()
        } else {
            app.tap()
        }
        
        sleep(2)
        
        let noSearchResultsText = app.staticTexts["No Search Results"]
        XCTAssertTrue(noSearchResultsText.waitForExistence(timeout: 3), "No Search Results text should be visible")
        
        sleep(1)
        
        let clearButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Clear search'")).firstMatch
        XCTAssertTrue(clearButton.waitForExistence(timeout: 3), "Clear search button should be visible")
        clearButton.tap()
        
        sleep(2)
        
        addTask(title: "Test Task", description: "Description", priority: "Medium")
        
        sleep(2)
        
        let allButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'All'")).firstMatch
        XCTAssertTrue(allButton.waitForExistence(timeout: 3), "All filter button should be visible")
        allButton.tap()
        
        sleep(1)
        
        let completedButton = app.buttons["Completed"]
        XCTAssertTrue(completedButton.waitForExistence(timeout: 3), "Completed button should be visible")
        completedButton.tap()
        
        sleep(2)
        
        let noCompletedTasksText = app.staticTexts["No Completed Tasks"]
        XCTAssertTrue(noCompletedTasksText.waitForExistence(timeout: 3), "No Completed Tasks text should be visible")
    }
    
    // MARK: - Helper Methods
    
    private func addTask(title: String, description: String, priority: String) {
        sleep(1)
        
        let addButton = app.navigationBars["Tasks"].buttons["Add Task"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 3), "Add Task button should be visible")
        addButton.tap()
        
        sleep(2)
        
        let titleTextField = app.textFields["Task title"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 3), "Title field should be visible")
        titleTextField.tap()
        
        title.forEach { char in
            titleTextField.typeText(String(char))
            usleep(50000)
        }
        sleep(1)
        
        let descriptionTextView = app.textViews.firstMatch
        XCTAssertTrue(descriptionTextView.waitForExistence(timeout: 3), "Description field should be visible")
        descriptionTextView.tap()
        
        description.forEach { char in
            descriptionTextView.typeText(String(char))
            usleep(50000)
        }
        
        sleep(1)
        
        let priorityButton = app.buttons["Priority"]
        XCTAssertTrue(priorityButton.waitForExistence(timeout: 3), "Priority button should be visible")
        priorityButton.tap()
        
        sleep(2)
        
        let priorityText = app.staticTexts[priority]
        XCTAssertTrue(priorityText.waitForExistence(timeout: 3), "Priority option should be visible")
        priorityText.tap()
        
        sleep(2)
        
        let addTaskButton = app.buttons["Add Task"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: 3), "Add Task button should be visible")
        addTaskButton.tap()
        
        sleep(2)
    }
    
    private func clearAllTasks() {
        if app.cells.count == 0 {
            return
        }
        
        var maxAttempts = 10
        while app.cells.firstMatch.exists && maxAttempts > 0 {
            
            sleep(1)
            
            let firstTask = app.cells.firstMatch
            XCTAssertTrue(firstTask.waitForExistence(timeout: 3), "Task cell should be visible")
            firstTask.swipeLeft()
            
            sleep(1)
            
            let deleteButton = app.buttons["Delete"]
            if deleteButton.waitForExistence(timeout: 3) {
                deleteButton.tap()
                
                sleep(2)
            } else {
                break
            }
            
            maxAttempts -= 1
        }
        
        sleep(2)
    }
} 
