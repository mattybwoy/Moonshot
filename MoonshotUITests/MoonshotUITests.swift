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
    
    func testMarketViewController_DisplaysChangeCurrencyDropDown() {
        app.tabBars.buttons["Market"].tap()
        let dropDown = app/*@START_MENU_TOKEN@*/.staticTexts["USD"]/*[[".buttons[\"USD\"].staticTexts[\"USD\"]",".staticTexts[\"USD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        XCTAssertNotNil(dropDown)
    }
    
    func testMarketViewController_AllowsUserToChangeCurrency() {
        app.tabBars.buttons["Market"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["USD"]/*[[".buttons[\"USD\"].staticTexts[\"USD\"]",".staticTexts[\"USD\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let gbpStaticText = app/*@START_MENU_TOKEN@*/.tables.staticTexts["GBP"]/*[[".otherElements[\"drop_down\"].tables",".cells.staticTexts[\"GBP\"]",".staticTexts[\"GBP\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        gbpStaticText.tap()
        XCTAssertNoThrow(Error.self)
    }
    
    func testMarketViewControllerConnectedToWatchList_AllowsFavouriteCoinToBePassed() {
        app.tabBars.buttons["Market"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Bitcoin"]/*[[".cells.staticTexts[\"Bitcoin\"]",".staticTexts[\"Bitcoin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Favourite"]/*[[".cells.buttons[\"Favourite\"]",".buttons[\"Favourite\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["Watchlist"].tap()
        let savedCoin = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Bitcoin"]/*[[".cells.staticTexts[\"Bitcoin\"]",".staticTexts[\"Bitcoin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertNotNil(savedCoin)
        XCTAssertTrue(savedCoin.isHittable)
    }
    
    func testMarketViewController_WhenFavouritingDuplicateCoin_DisplaysAlert() {
        app.tabBars.buttons["Market"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Bitcoin"]/*[[".cells.staticTexts[\"Bitcoin\"]",".staticTexts[\"Bitcoin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Favourite"]/*[[".cells.buttons[\"Favourite\"]",".buttons[\"Favourite\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Bitcoin"]/*[[".cells.staticTexts[\"Bitcoin\"]",".staticTexts[\"Bitcoin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Favourite"]/*[[".cells.buttons[\"Favourite\"]",".buttons[\"Favourite\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssertTrue(app.alerts["Coin already saved"].waitForExistence(timeout: 1))
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
    
    func testSearchViewController_DisplaysResults_WhenSearchTermIsTyped() {
        let search = app.searchFields["Search"]
        search.tap()
        search.typeText("Bitcoin")
        app.buttons.matching(identifier: "Search").staticTexts["Search"].tap()
        let result = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Bitcoin"]/*[[".cells.staticTexts[\"Bitcoin\"]",".staticTexts[\"Bitcoin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertTrue(result.isHittable)
        XCTAssertNoThrow(app.alerts["Invalid Search Term"])
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
