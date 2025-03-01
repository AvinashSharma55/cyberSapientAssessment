//
//  CyberSapientAssesmentUITestsLaunchTests.swift
//  CyberSapientAssesmentUITests
//
//  Created by Avinash Sharma on 27/02/25.
//

import XCTest

final class CyberSapientAssesmentUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Set a launch argument that can be detected in the app to reset state
        let app = XCUIApplication()
        app.launchArguments = ["UI-TESTING"]
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Wait for the app to fully load before taking a screenshot
        XCTAssertTrue(app.navigationBars["Tasks"].waitForExistence(timeout: 5), "Tasks navigation bar should be visible")
        
        // Give the app more time to fully initialize
        sleep(2)

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
