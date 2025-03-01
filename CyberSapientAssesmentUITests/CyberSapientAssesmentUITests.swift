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
        app.launchArguments = ["UI-TESTING"]
        app.launch()
        
        XCTAssertTrue(app.navigationBars["Tasks"].waitForExistence(timeout: 5))
        
        sleep(2)
        
        clearAllTasks()
        
        sleep(2)
    }
    
    func testTaskCreationFlow() throws {
        let addButton = app.navigationBars["Tasks"].buttons["Add Task"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 3), "Add Task button should be visible")
        addButton.tap()
    
        sleep(2)
        XCTAssertTrue(app.navigationBars["New Task"].waitForExistence(timeout: 3), "New Task navigation bar should be visible")
      
        let titleTextField = app.textFields["Task title"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 3), "Title field should be visible")
        titleTextField.tap()

        "Test Task".forEach { char in
            titleTextField.typeText(String(char))
            usleep(50000)
        }
        
        sleep(1)
        
        let descriptionTextView = app.textViews.firstMatch
        XCTAssertTrue(descriptionTextView.waitForExistence(timeout: 3), "Description field should be visible")
        descriptionTextView.tap()

        "This is a test task description".forEach { char in
            descriptionTextView.typeText(String(char))
            usleep(50000) // 0.05 seconds
        }
        
        sleep(1)
       
        let priorityButton = app.buttons["Priority"]
        XCTAssertTrue(priorityButton.waitForExistence(timeout: 3), "Priority button should be visible")
        priorityButton.tap()
        
        sleep(2)
        
        let highPriorityText = app.staticTexts["High"]
        XCTAssertTrue(highPriorityText.waitForExistence(timeout: 3), "High priority option should be visible")
        highPriorityText.tap()
        
        sleep(2)
        
        let addTaskButton = app.buttons["Add Task"]
        XCTAssertTrue(addTaskButton.waitForExistence(timeout: 3), "Add Task button should be visible")
        addTaskButton.tap()
        
        sleep(2)
        
        XCTAssertTrue(app.staticTexts["Test Task"].exists, "Task title should be visible")
        XCTAssertTrue(app.staticTexts["This is a test task description"].exists, "Task description should be visible")
    }
    
    func testSortingAndFiltering() throws {
        addSampleTasks()
        
        sleep(2)
        
        let allButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'All'")).firstMatch
        XCTAssertTrue(allButton.waitForExistence(timeout: 3), "All filter button should be visible")
        allButton.tap()
     
        sleep(1)
        
        let completedButton = app.buttons["Completed"]
        XCTAssertTrue(completedButton.waitForExistence(timeout: 3), "Completed button should be visible")
        completedButton.tap()
        
        sleep(2)
      
        XCTAssertTrue(app.staticTexts["Completed Task 1"].exists, "Completed task should be visible")
        XCTAssertFalse(app.staticTexts["Pending Task 1"].exists, "Pending task should not be visible")
        
        let completedFilterButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Completed'")).firstMatch
        XCTAssertTrue(completedFilterButton.waitForExistence(timeout: 3), "Completed filter button should be visible")
        completedFilterButton.tap()
        
        sleep(1)
        
        let pendingButton = app.buttons["Pending"]
        XCTAssertTrue(pendingButton.waitForExistence(timeout: 3), "Pending button should be visible")
        pendingButton.tap()
        
        sleep(2)
        
        XCTAssertTrue(app.staticTexts["Pending Task 1"].exists, "Pending task should be visible")
        XCTAssertFalse(app.staticTexts["Completed Task 1"].exists, "Completed task should not be visible")
        
        let dueDateButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Due Date'")).firstMatch
        XCTAssertTrue(dueDateButton.waitForExistence(timeout: 3), "Due Date button should be visible")
        dueDateButton.tap()
        
        sleep(1)
        
        let alphabeticalButton = app.buttons["Alphabetical"]
        XCTAssertTrue(alphabeticalButton.waitForExistence(timeout: 3), "Alphabetical button should be visible")
        alphabeticalButton.tap()
        
        sleep(2)
    }
    
    func testTaskCompletionAndDeletion() throws {
        addSampleTasks()
        
        sleep(2)
        
        let completeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Not completed'")).firstMatch
        XCTAssertTrue(completeButton.waitForExistence(timeout: 3), "Not completed button should be visible")
        completeButton.tap()
        
        sleep(2)
        
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS 'Completed'")).firstMatch.exists, "Completed button should be visible")
        
        let firstTask = app.staticTexts["Pending Task 1"]
        XCTAssertTrue(firstTask.waitForExistence(timeout: 3), "Pending task should be visible")
        firstTask.swipeLeft()
        
        sleep(1)
        
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 3), "Delete button should be visible")
        deleteButton.tap()
        
        sleep(2)
        
        XCTAssertFalse(app.staticTexts["Pending Task 1"].exists, "Pending task should be deleted")
    }
    
    func testTaskDetailView() throws {
        addSampleTasks()
        
        sleep(2)
        
        let taskText = app.staticTexts["Pending Task 1"]
        XCTAssertTrue(taskText.waitForExistence(timeout: 3), "Pending task should be visible")
        taskText.tap()
        
        sleep(2)
        
        XCTAssertTrue(app.staticTexts["Pending Task 1"].exists, "Task title should be visible in detail view")
        XCTAssertTrue(app.staticTexts["This is a pending task"].exists, "Task description should be visible in detail view")
        
        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 3), "Edit button should be visible")
        editButton.tap()
        
        sleep(2)
        
        let titleTextField = app.textFields["Task title"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 3), "Title field should be visible")
        titleTextField.tap()
        titleTextField.clearText()
        
        sleep(1)
    
        "Updated Task".forEach { char in
            titleTextField.typeText(String(char))
            usleep(50000) // 0.05 seconds
        }
   
        sleep(1)
        
        let saveButton = app.buttons["Save Changes"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3), "Save Changes button should be visible")
        saveButton.tap()
        
        sleep(2)
    
        XCTAssertTrue(app.staticTexts["Updated Task"].exists, "Updated task title should be visible")
    }
    
    func testSettingsView() throws {
        let settingsButton = app.navigationBars["Tasks"].buttons["Settings"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 3), "Settings button should be visible")
        settingsButton.tap()
        
        sleep(2)
        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 3), "Settings navigation bar should be visible")
        
        let darkModeSwitch = app.switches["Dark Mode"]
        XCTAssertTrue(darkModeSwitch.waitForExistence(timeout: 3), "Dark Mode switch should be visible")
        darkModeSwitch.tap()
        
        sleep(2)
        
        let colorGrid = app.otherElements.containing(.staticText, identifier: "Accent Color").element
        XCTAssertTrue(colorGrid.waitForExistence(timeout: 3), "Color grid should be visible")
        let colors = colorGrid.children(matching: .any)
        if colors.count > 2 {
            colors.element(boundBy: 2).tap() // Select the third color
        }
        
        sleep(2)
        
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 3), "Done button should be visible")
        doneButton.tap()
        
        sleep(2)
    }
    
    func testSearchFunctionality() throws {
        addSampleTasks()
        
        sleep(2)
        
        let searchField = app.textFields["Search tasks"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search field should be visible")
        searchField.tap()
        
        sleep(1)
        
        "Pending Task 1".forEach { char in
            searchField.typeText(String(char))
            usleep(50000) // 0.05 seconds
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
        
        XCTAssertTrue(app.staticTexts["Pending Task 1"].exists, "Matching task should be visible")
        XCTAssertFalse(app.staticTexts["Pending Task 2"].exists, "Non-matching task should not be visible")
        XCTAssertFalse(app.staticTexts["Completed Task 1"].exists, "Non-matching task should not be visible")
      
        let clearButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Clear search'")).firstMatch
        XCTAssertTrue(clearButton.waitForExistence(timeout: 3), "Clear search button should be visible")
        clearButton.tap()
        
        sleep(2)
        
        XCTAssertTrue(app.staticTexts["Pending Task 1"].exists, "Task should be visible after clearing search")
        XCTAssertTrue(app.staticTexts["Pending Task 2"].exists, "Task should be visible after clearing search")
        XCTAssertTrue(app.staticTexts["Completed Task 1"].exists, "Task should be visible after clearing search")
    }
    
    // MARK: - Helper Methods
    
    private func addSampleTasks() {
        addTask(title: "Completed Task 1", description: "This is a completed task", priority: "Medium", isCompleted: true)
        
        addTask(title: "Pending Task 1", description: "This is a pending task", priority: "High", isCompleted: false)
        addTask(title: "Pending Task 2", description: "This is another pending task", priority: "Low", isCompleted: false)
    }
    
    private func addTask(title: String, description: String, priority: String, isCompleted: Bool) {
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
            usleep(50000) // 0.05 seconds
        }
       
        sleep(1)
        
        let descriptionTextView = app.textViews.firstMatch
        XCTAssertTrue(descriptionTextView.waitForExistence(timeout: 3), "Description field should be visible")
        descriptionTextView.tap()
        
        description.forEach { char in
            descriptionTextView.typeText(String(char))
            usleep(50000) // 0.05 seconds
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
        
        if isCompleted {
            let completeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Not completed'")).firstMatch
            XCTAssertTrue(completeButton.waitForExistence(timeout: 3), "Not completed button should be visible")
            completeButton.tap()
           
            sleep(2)
        }
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

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
    
        self.tap()
        self.press(forDuration: 1.0)
        
        sleep(1)
        
        let selectAllButton = XCUIApplication().menuItems["Select All"]
        if selectAllButton.waitForExistence(timeout: 3) {
            selectAllButton.tap()
            
            sleep(1)
            
            let cutButton = XCUIApplication().menuItems["Cut"]
            if cutButton.waitForExistence(timeout: 3) {
                cutButton.tap()
                
                sleep(1)
            }
        } else {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            self.typeText(deleteString)
            
            sleep(1)
        }
    }
}
