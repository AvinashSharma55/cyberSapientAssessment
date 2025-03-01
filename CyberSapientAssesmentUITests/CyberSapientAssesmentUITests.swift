//
//  CyberSapientAssesmentUITests.swift
//  CyberSapientAssesmentUITests
//
//  Created by Avinash Sharma on 27/02/25.
//

import XCTest

final class CyberSapientAssesmentUITests: XCTestCase {
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
        
        // Clear any existing tasks for clean testing
        clearAllTasks()
        
        // Additional wait after clearing tasks
        sleep(2)
    }
    
    func testTaskCreationFlow() throws {
        // Test adding a new task
        let addButton = app.navigationBars["Tasks"].buttons["Add Task"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 3), "Add Task button should be visible")
        addButton.tap()
        
        // Wait for the form to appear and animate in
        sleep(2)
        XCTAssertTrue(app.navigationBars["New Task"].waitForExistence(timeout: 3), "New Task navigation bar should be visible")
        
        // Fill in task details
        let titleTextField = app.textFields["Task title"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 3), "Title field should be visible")
        titleTextField.tap()
        
        // Type slowly to avoid overwhelming the UI
        "Test Task".forEach { char in
            titleTextField.typeText(String(char))
            usleep(50000) // 0.05 seconds
        }
        
        // Wait before moving to next field
        sleep(1)
        
        let descriptionTextView = app.textViews.firstMatch
        XCTAssertTrue(descriptionTextView.waitForExistence(timeout: 3), "Description field should be visible")
        descriptionTextView.tap()
        
        // Type slowly to avoid overwhelming the UI
        "This is a test task description".forEach { char in
            descriptionTextView.typeText(String(char))
            usleep(50000) // 0.05 seconds
        }
        
        // Wait before tapping priority
        sleep(1)
        
        // Select priority
        let priorityButton = app.buttons["Priority"]
        XCTAssertTrue(priorityButton.waitForExistence(timeout: 3), "Priority button should be visible")
        priorityButton.tap()
        
        // Wait for priority picker to appear and animate in
        sleep(2)
        
        let highPriorityText = app.staticTexts["High"]
        XCTAssertTrue(highPriorityText.waitForExistence(timeout: 3), "High priority option should be visible")
        highPriorityText.tap()
        
        // Wait for the picker to dismiss and animate out
        sleep(2)
        
        // Add the task
        let addTaskButton = app.buttons["Add Task"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: 3), "Add Task button should be visible")
        addTaskButton.tap()
        
        // Wait for the task to be added and the list to update
        sleep(2)
        
        // Verify task was added
        XCTAssertTrue(app.staticTexts["Test Task"].exists, "Task title should be visible")
        XCTAssertTrue(app.staticTexts["This is a test task description"].exists, "Task description should be visible")
    }
    
    func testSortingAndFiltering() throws {
        // Add multiple tasks for testing
        addSampleTasks()
        
        // Wait for tasks to be fully loaded
        sleep(2)
        
        // Test filtering
        let allButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'All'")).firstMatch
        XCTAssertTrue(allButton.waitForExistence(timeout: 3), "All filter button should be visible")
        allButton.tap()
        
        // Wait for menu to appear
        sleep(1)
        
        let completedButton = app.buttons["Completed"]
        XCTAssertTrue(completedButton.waitForExistence(timeout: 3), "Completed button should be visible")
        completedButton.tap()
        
        // Wait for filter to be applied
        sleep(2)
        
        // Verify only completed tasks are shown
        XCTAssertTrue(app.staticTexts["Completed Task 1"].exists, "Completed task should be visible")
        XCTAssertFalse(app.staticTexts["Pending Task 1"].exists, "Pending task should not be visible")
        
        // Switch to pending tasks
        let completedFilterButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Completed'")).firstMatch
        XCTAssertTrue(completedFilterButton.waitForExistence(timeout: 3), "Completed filter button should be visible")
        completedFilterButton.tap()
        
        // Wait for menu to appear
        sleep(1)
        
        let pendingButton = app.buttons["Pending"]
        XCTAssertTrue(pendingButton.waitForExistence(timeout: 3), "Pending button should be visible")
        pendingButton.tap()
        
        // Wait for filter to be applied
        sleep(2)
        
        // Verify only pending tasks are shown
        XCTAssertTrue(app.staticTexts["Pending Task 1"].exists, "Pending task should be visible")
        XCTAssertFalse(app.staticTexts["Completed Task 1"].exists, "Completed task should not be visible")
        
        // Test sorting
        let dueDateButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Due Date'")).firstMatch
        XCTAssertTrue(dueDateButton.waitForExistence(timeout: 3), "Due Date button should be visible")
        dueDateButton.tap()
        
        // Wait for menu to appear
        sleep(1)
        
        let alphabeticalButton = app.buttons["Alphabetical"]
        XCTAssertTrue(alphabeticalButton.waitForExistence(timeout: 3), "Alphabetical button should be visible")
        alphabeticalButton.tap()
        
        // Wait for sort to be applied
        sleep(2)
    }
    
    func testTaskCompletionAndDeletion() throws {
        // Add a task
        addSampleTasks()
        
        // Wait for tasks to be fully loaded
        sleep(2)
        
        // Mark a task as completed
        let completeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Not completed'")).firstMatch
        XCTAssertTrue(completeButton.waitForExistence(timeout: 3), "Not completed button should be visible")
        completeButton.tap()
        
        // Wait for completion status to update
        sleep(2)
        
        // Verify task is marked as completed
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS 'Completed'")).firstMatch.exists, "Completed button should be visible")
        
        // Delete a task using swipe
        let firstTask = app.staticTexts["Pending Task 1"]
        XCTAssertTrue(firstTask.waitForExistence(timeout: 3), "Pending task should be visible")
        firstTask.swipeLeft()
        
        // Wait for swipe animation to complete
        sleep(1)
        
        // Wait for delete button to appear
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 3), "Delete button should be visible")
        deleteButton.tap()
        
        // Wait for deletion to complete
        sleep(2)
        
        // Verify task was deleted
        XCTAssertFalse(app.staticTexts["Pending Task 1"].exists, "Pending task should be deleted")
    }
    
    func testTaskDetailView() throws {
        // Add a task
        addSampleTasks()
        
        // Wait for tasks to be fully loaded
        sleep(2)
        
        // Navigate to task detail
        let taskText = app.staticTexts["Pending Task 1"]
        XCTAssertTrue(taskText.waitForExistence(timeout: 3), "Pending task should be visible")
        taskText.tap()
        
        // Wait for detail view to load and animate in
        sleep(2)
        
        // Verify task details are displayed
        XCTAssertTrue(app.staticTexts["Pending Task 1"].exists, "Task title should be visible in detail view")
        XCTAssertTrue(app.staticTexts["This is a pending task"].exists, "Task description should be visible in detail view")
        
        // Test edit functionality
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 3), "Edit button should be visible")
        editButton.tap()
        
        // Wait for edit form to appear and animate in
        sleep(2)
        
        let titleTextField = app.textFields["Task title"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 3), "Title field should be visible")
        titleTextField.tap()
        titleTextField.clearText()
        
        // Wait after clearing text
        sleep(1)
        
        // Type slowly to avoid overwhelming the UI
        "Updated Task".forEach { char in
            titleTextField.typeText(String(char))
            usleep(50000) // 0.05 seconds
        }
        
        // Wait before saving
        sleep(1)
        
        let saveButton = app.buttons["Save Changes"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3), "Save Changes button should be visible")
        saveButton.tap()
        
        // Wait for update to complete and UI to refresh
        sleep(2)
        
        // Verify task was updated
        XCTAssertTrue(app.staticTexts["Updated Task"].exists, "Updated task title should be visible")
    }
    
    func testSettingsView() throws {
        // Navigate to settings
        let settingsButton = app.navigationBars["Tasks"].buttons["Settings"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 3), "Settings button should be visible")
        settingsButton.tap()
        
        // Wait for settings view to appear and animate in
        sleep(2)
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 3), "Settings navigation bar should be visible")
        
        // Toggle dark mode
        let darkModeSwitch = app.switches["Dark Mode"]
        XCTAssertTrue(darkModeSwitch.waitForExistence(timeout: 3), "Dark Mode switch should be visible")
        darkModeSwitch.tap()
        
        // Wait for toggle to take effect
        sleep(2)
        
        // Select a different accent color
        let colorGrid = app.otherElements.containing(.staticText, identifier: "Accent Color").element
        XCTAssertTrue(colorGrid.waitForExistence(timeout: 3), "Color grid should be visible")
        let colors = colorGrid.children(matching: .any)
        if colors.count > 2 {
            colors.element(boundBy: 2).tap() // Select the third color
        }
        
        // Wait for color selection to take effect
        sleep(2)
        
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 3), "Done button should be visible")
        doneButton.tap()
        
        // Wait for settings to be applied and view to dismiss
        sleep(2)
    }
    
    func testSearchFunctionality() throws {
        // Add sample tasks
        addSampleTasks()
        
        // Wait for tasks to be fully loaded
        sleep(2)
        
        // Search for a specific task
        let searchField = app.textFields["Search tasks"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search field should be visible")
        searchField.tap()
        
        // Wait for keyboard to appear
        sleep(1)
        
        // Type slowly to avoid overwhelming the UI
        "Pending Task 1".forEach { char in
            searchField.typeText(String(char))
            usleep(50000) // 0.05 seconds
        }
        
        // Wait before tapping search
        sleep(1)
        
        // Tap search on keyboard
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
        
        // Verify only the matching task is shown
        XCTAssertTrue(app.staticTexts["Pending Task 1"].exists, "Matching task should be visible")
        XCTAssertFalse(app.staticTexts["Pending Task 2"].exists, "Non-matching task should not be visible")
        XCTAssertFalse(app.staticTexts["Completed Task 1"].exists, "Non-matching task should not be visible")
        
        // Clear search
        let clearButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Clear search'")).firstMatch
        XCTAssertTrue(clearButton.waitForExistence(timeout: 3), "Clear search button should be visible")
        clearButton.tap()
        
        // Wait for search results to update
        sleep(2)
        
        // Verify all tasks are shown again
        XCTAssertTrue(app.staticTexts["Pending Task 1"].exists, "Task should be visible after clearing search")
        XCTAssertTrue(app.staticTexts["Pending Task 2"].exists, "Task should be visible after clearing search")
        XCTAssertTrue(app.staticTexts["Completed Task 1"].exists, "Task should be visible after clearing search")
    }
    
    // MARK: - Helper Methods
    
    private func addSampleTasks() {
        // Add a completed task
        addTask(title: "Completed Task 1", description: "This is a completed task", priority: "Medium", isCompleted: true)
        
        // Add pending tasks
        addTask(title: "Pending Task 1", description: "This is a pending task", priority: "High", isCompleted: false)
        addTask(title: "Pending Task 2", description: "This is another pending task", priority: "Low", isCompleted: false)
    }
    
    private func addTask(title: String, description: String, priority: String, isCompleted: Bool) {
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
        
        if isCompleted {
            // Mark as completed
            let completeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Not completed'")).firstMatch
            XCTAssertTrue(completeButton.waitForExistence(timeout: 3), "Not completed button should be visible")
            completeButton.tap()
            
            // Wait for completion status to update
            sleep(2)
        }
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

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        
        // Select all and delete
        self.tap()
        self.press(forDuration: 1.0)
        
        // Wait for menu to appear
        sleep(1)
        
        // Tap the "Select All" button if it appears
        let selectAllButton = XCUIApplication().menuItems["Select All"]
        if selectAllButton.waitForExistence(timeout: 3) {
            selectAllButton.tap()
            
            // Wait for selection to take effect
            sleep(1)
            
            let cutButton = XCUIApplication().menuItems["Cut"]
            if cutButton.waitForExistence(timeout: 3) {
                cutButton.tap()
                
                // Wait for cut operation to complete
                sleep(1)
            }
        } else {
            // If "Select All" doesn't appear, try to delete the text character by character
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            self.typeText(deleteString)
            
            // Wait for deletion to complete
            sleep(1)
        }
    }
}
