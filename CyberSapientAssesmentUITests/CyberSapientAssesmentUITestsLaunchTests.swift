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
        
        let app = XCUIApplication()
        app.launchArguments = ["UI-TESTING"]
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.navigationBars["Tasks"].waitForExistence(timeout: 5), "Tasks navigation bar should be visible")
        
        sleep(2)

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
