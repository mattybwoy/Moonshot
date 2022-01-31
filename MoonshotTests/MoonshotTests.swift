//
//  MoonshotTests.swift
//  MoonshotTests
//
//  Created by Matthew Lock on 20/01/2022.
//

import XCTest
@testable import Moonshot

class MoonshotTests: XCTestCase {

    var sut: DataManager!
    
    override func setUpWithError() throws {
        //sut = DataManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_loadCoins_WhenSuccessfulResponse_ReturnsSuccess() throws {

        //Arrange
        let expectation = self.expectation(description: "Loading Initial Cryptocurrency in USD")

        //Act
        sut = DataManager()
        sut.loadCoins {
            XCTAssertNotNil(self.sut.coins)
            expectation.fulfill()
        }
        //Assert
        self.wait(for: [expectation], timeout: 5)
    }
    
    func test_APIStatus_WhenSuccessfulResponse_ReturnsSuccess() {
        
        //Arrange
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        let jsonString = "{\"gecko_says\":\"(V3) To the Moon!\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        let expectation = self.expectation(description: "Testing API Status")
        
        //Act
        sut = DataManager(urlSession: urlSession)
        sut.testAPIStatus { (Status) in
            XCTAssertEqual(Status?.gecko_says, "(V3) To the Moon!")
            expectation.fulfill()
        }
        
        //Assert
        self.wait(for: [expectation], timeout: 5)
    }
    
    func test_loadCoins_WhenSuccessfulResponse_ReturnsRatesInGBP() {
        //Arrange
        let expectation = self.expectation(description: "Loads Cryptocurrency in GBP")
        //Act
        sut = DataManager()
        sut.loadCoins(currency: "gbp") {
            //XCTAssertNotNil(self.sut.coins)
            XCTAssertEqual(self.sut.currentCurrency, "gbp")
            expectation.fulfill()
        }
        //Assert
        self.wait(for: [expectation], timeout: 5)
    }

}
