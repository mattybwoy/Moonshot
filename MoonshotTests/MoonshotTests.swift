//
//  MoonshotTests.swift
//  MoonshotTests
//
//  Created by Matthew Lock on 20/01/2022.
//

import XCTest
@testable import Moonshot

class MoonshotTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_loadCoins_WhenSucessfulResponse_ReturnsSucess() throws {
        //Arrange
        let expectation = self.expectation(description: "Loading Initial Cryptocurrency in USD")
        let sut = DataManager()
        
        //Act
        sut.loadCoins {
            XCTAssertNotNil(sut.coins)
            expectation.fulfill()
        }
        //Assert
        self.wait(for: [expectation], timeout: 5)
    }

}
