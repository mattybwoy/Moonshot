//
//  SearchControllerTest.swift
//  MoonshotTests
//
//  Created by Matthew Lock on 01/03/2022.
//

import XCTest
@testable import Moonshot

class SearchControllerTest: XCTestCase {

    var searchTab: SearchViewController!
    
    override func setUpWithError() throws {
        searchTab = SearchViewController()
    }

    override func tearDownWithError() throws {
        searchTab = nil
    }
    
    func testSearchController_WhenLoaded_HasRequiredSearchTexField() {
        searchTab.loadViewIfNeeded()
        
        XCTAssertNotNil(searchTab.searchBar)
    }
    
    func testSearchController_WhenSearchBarLoaded_TextFieldIsEmpty() {
        searchTab.loadViewIfNeeded()
        
        XCTAssertEqual(searchTab.searchBar.text, "")
    }

}
