//
//  Paboda_Senevirathne_FE_8927315UITestsLaunchTests.swift
//  Paboda_Senevirathne_FE_8927315UITests
//
//  Created by user234693 on 12/6/23.
//

import XCTest

final class Paboda_Senevirathne_FE_8927315UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
