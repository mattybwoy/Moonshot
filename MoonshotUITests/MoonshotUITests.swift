//
//  MoonshotUITests.swift
//  MoonshotUITests
//
//  Created by Matthew Lock on 04/03/2022.
//

import XCTest

class MoonshotUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Search"].tap()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testSearchViewController_DisplaysSearchBar() throws {
        let searchField = app.searchFields["Search"]
        XCTAssertTrue(searchField.isEnabled)
    }
    
    func testSearchViewController_DisplaysPlaceholderForSearchBar() {
        let searchField = app.searchFields["Search"]
        XCTAssertEqual(searchField.placeholderValue, "Search")
    }
    
    func testSearchViewController_DisplaysAlert_WhenNoSearchTermIsTyped() {
        _ = app.searchFields["Search"]
        app.buttons.matching(identifier: "Search").staticTexts["Search"].tap()
        
        XCTAssertTrue(app.alerts["Invalid Search Term"].waitForExistence(timeout: 1))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
