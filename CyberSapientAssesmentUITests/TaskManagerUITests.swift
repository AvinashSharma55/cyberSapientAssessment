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
        
        // Set a launch argument that can be detected in the app to reset state
        app.launchArguments = ["UI-TESTING"]
        app.launch()
        
        // Wait for the app to fully load before proceeding
        XCTAssertTrue(app.navigationBars["Tasks"].waitForExistence(timeout: 5))
        
        // Give the app more time to fully initialize
        sleep(2)
        
        clearAllTasks()
        
        // Additional wait after clearing tasks
        sleep(2)
    }
    
    func testPrioritySorting() throws {
        // Add tasks with different priorities
        addTask(title: "High Priority Task", description: "This is a high priority task", priority: "High")
        addTask(title: "Medium Priority Task", description: "This is a medium priority task", priority: "Medium")
        addTask(title: "Low Priority Task", description: "This is a low priority task", priority: "Low")
        
        // Wait for tasks to be fully loaded
        sleep(2)
    
        // Sort by priority ascending
        let dueDateButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Due Date'")).firstMatch
        XCTAssertTrue(dueDateButton.waitForExistence(timeout: 2))
        dueDateButton.tap()
        
        // Wait for menu to appear
        sleep(1)
        
        XCTAssertTrue(app.buttons["Priority"].waitForExistence(timeout: 2))
        app.buttons["Priority"].tap()
        
        // Wait for sort to be applied
        sleep(2)
    
        // Verify tasks are sorted by priority (High -> Medium -> Low)
        let taskTitles = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Priority Task'")).allElementsBoundByIndex
        
        if taskTitles.count >= 3 {
            XCTAssertTrue(taskTitles[0].label.contains("High"))
            XCTAssertTrue(taskTitles[1].label.contains("Medium"))
            XCTAssertTrue(taskTitles[2].label.contains("Low"))
        } else {
            XCTFail("Not all priority tasks are visible")
        }
       
        // Toggle to descending order
        let ascendingButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'arrow.up'")).firstMatch
        XCTAssertTrue(ascendingButton.waitForExistence(timeout: 2))
        ascendingButton.tap()
        
        // Wait for the UI to update
        sleep(2)
        
        // Verify tasks are sorted by priority in reverse (Low -> Medium -> High)
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
        // Wait for the app to fully load and stabilize
        sleep(2)
        
        // Test no tasks empty state - use a more specific query
        let noTasksYetText = app.staticTexts["No Tasks Yet"]
        XCTAssertTrue(noTasksYetText.waitForExistence(timeout: 3), "No Tasks Yet text should be visible")
        
        // Wait before proceeding to next UI operation
        sleep(1)
         
        // Test search with no results - break this into smaller steps
        let searchField = app.textFields["Search tasks"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search field should be visible")
        searchField.tap()
        
        // Wait for keyboard to appear
        sleep(1)
        
        // Type slowly to avoid overwhelming the UI
        "NonexistentTask".forEach { char in
            searchField.typeText(String(char))
            // Small pause between characters
            usleep(50000) // 0.05 seconds
        }
        
        // Wait before tapping search
        sleep(1)
        
        // Check if search button exists and tap it
        if app.keyboards.buttons["search"].waitForExistence(timeout: 3) {
            app.keyboards.buttons["search"].tap()
        } else if app.keyboards.buttons["Search"].waitForExistence(timeout: 1) {
            app.keyboards.buttons["Search"].tap()
        } else {
            // Fallback - dismiss keyboard
            app.tap()
        }
        
        // Wait for search results to update
        sleep(2)
        
        // Check for No Search Results text
        let noSearchResultsText = app.staticTexts["No Search Results"]
        XCTAssertTrue(noSearchResultsText.waitForExistence(timeout: 3), "No Search Results text should be visible")
       
        // Wait before clearing search
        sleep(1)
        
        // Clear search
        let clearButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Clear search'")).firstMatch
        XCTAssertTrue(clearButton.waitForExistence(timeout: 3), "Clear search button should be visible")
        clearButton.tap()
        
        // Wait for search to clear
        sleep(2)
        
        // Add a task and test filter with no results
        addTask(title: "Test Task", description: "Description", priority: "Medium")
        
        // Wait for task to be added and UI to stabilize
        sleep(2)
        
        // Filter to completed (should show no results since our task is not completed)
        let allButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'All'")).firstMatch
        XCTAssertTrue(allButton.waitForExistence(timeout: 3), "All filter button should be visible")
        allButton.tap()
        
        // Wait for menu to appear
        sleep(1)
        
        let completedButton = app.buttons["Completed"]
        XCTAssertTrue(completedButton.waitForExistence(timeout: 3), "Completed button should be visible")
        completedButton.tap()
        
        // Wait for filter to be applied and UI to stabilize
        sleep(2)
        
        // Check for No Completed Tasks text
        let noCompletedTasksText = app.staticTexts["No Completed Tasks"]
        XCTAssertTrue(noCompletedTasksText.waitForExistence(timeout: 3), "No Completed Tasks text should be visible")
    }
    
    // MARK: - Helper Methods
    
    private func addTask(title: String, description: String, priority: String) {
        // Wait for UI to stabilize before adding task
        sleep(1)
        
        let addButton = app.navigationBars["Tasks"].buttons["Add Task"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 3), "Add Task button should be visible")
        addButton.tap()
        
        // Wait for form to appear and animate in
        sleep(2)
        
        let titleTextField = app.textFields["Task title"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 3), "Title field should be visible")
        titleTextField.tap()
        
        // Type slowly to avoid overwhelming the UI
        title.forEach { char in
            titleTextField.typeText(String(char))
            usleep(50000) // 0.05 seconds
        }
        
        // Wait before moving to next field
        sleep(1)
        
        let descriptionTextView = app.textViews.firstMatch
        XCTAssertTrue(descriptionTextView.waitForExistence(timeout: 3), "Description field should be visible")
        descriptionTextView.tap()
        
        // Type slowly to avoid overwhelming the UI
        description.forEach { char in
            descriptionTextView.typeText(String(char))
            usleep(50000) // 0.05 seconds
        }
        
        // Wait before tapping priority
        sleep(1)
        
        let priorityButton = app.buttons["Priority"]
        XCTAssertTrue(priorityButton.waitForExistence(timeout: 3), "Priority button should be visible")
        priorityButton.tap()
        
        // Wait for priority picker to appear and animate in
        sleep(2)
        
        let priorityText = app.staticTexts[priority]
        XCTAssertTrue(priorityText.waitForExistence(timeout: 3), "Priority option should be visible")
        priorityText.tap()
        
        // Wait for picker to dismiss and animate out
        sleep(2)
        
        let addTaskButton = app.buttons["Add Task"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: 3), "Add Task button should be visible")
        addTaskButton.tap()
        
        // Wait for task to be added and UI to update
        sleep(2)
    }
    
    private func clearAllTasks() {
        // First check if there are any tasks
        if app.cells.count == 0 {
            return
        }
        
        // Try to delete all tasks
        var maxAttempts = 10 // Prevent infinite loop
        while app.cells.firstMatch.exists && maxAttempts > 0 {
            // Wait for UI to stabilize before swiping
            sleep(1)
            
            let firstTask = app.cells.firstMatch
            XCTAssertTrue(firstTask.waitForExistence(timeout: 3), "Task cell should be visible")
            firstTask.swipeLeft()
            
            // Wait for swipe animation to complete
            sleep(1)
            
            // Wait for delete button to appear
            let deleteButton = app.buttons["Delete"]
            if deleteButton.waitForExistence(timeout: 3) {
                deleteButton.tap()
                
                // Wait for deletion to complete and UI to update
                sleep(2)
            } else {
                break
            }
            
            maxAttempts -= 1
        }
        
        // Final wait to ensure UI is stable
        sleep(2)
    }
} 
