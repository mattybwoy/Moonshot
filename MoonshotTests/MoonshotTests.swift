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
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = DataManager(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_APIStatus_WhenSuccessfulResponse_ReturnsSuccess() {
        
        let jsonString = "{\"gecko_says\":\"(V3) To the Moon!\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        let expectation = self.expectation(description: "Testing API Status")
        
        sut.testAPIStatus { (Status) in
            XCTAssertEqual(Status?.gecko_says, "(V3) To the Moon!")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 3)
    }

    func test_loadCoins_WhenSuccessfulResponse_ReturnsSuccessInUSD() throws {

        let expectation = self.expectation(description: "Loading Initial Cryptocurrency in USD")
        let current_price = 38346
        let jsonString = "[{\"name\": \"Bitcoin\", \"id\": \"bitcoin\", \"current_price\": \(current_price)}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)

        sut.loadCoins { (_: [Coins]?) in
            XCTAssertEqual(self.sut.coins![0].name, "Bitcoin")
            XCTAssertEqual(self.sut.coins![0].id, "bitcoin")
            XCTAssertEqual(self.sut.coins![0].current_price, 38346)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 3)
    }
    
    func test_loadCoins_WhenSuccessfulResponse_ReturnsRatesInGBP() {
        
        let expectation = self.expectation(description: "Loads Cryptocurrency in GBP")
        let current_price = 28794
        let jsonString = "[{\"name\": \"Bitcoin\", \"id\": \"bitcoin\", \"current_price\": \(current_price)}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        sut.loadCoins(currency: "gbp") { (_: [Coins]?) in
            XCTAssertEqual(self.sut.currentCurrency, "gbp")
            XCTAssertEqual(self.sut.coins![0].name, "Bitcoin")
            XCTAssertEqual(self.sut.coins![0].id, "bitcoin")
            XCTAssertEqual(self.sut.coins![0].current_price, 28794)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 3)
    }

    func test_scrollCoin_WhenSuccessfulResponse_ReturnsNextPageOfResults() {
        
        let expectation = self.expectation(description: "Loads results of next page in current currency")
        let current_price = 38346
        let jsonString = "[{\"name\": \"Bitcoin\", \"id\": \"bitcoin\", \"current_price\": \(current_price)}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        sut.currentCurrency = "usd"
        
        sut.scrollCoin(pagination: true) {
            expectation.fulfill()
        }
        XCTAssertEqual(sut.pageCount, 3)
        self.wait(for: [expectation], timeout: 3)
    }
    
    func test_reloadCoins_WhenSuccessfulResponse_ReturnsUpdatedRates() {
        
        let expectation = self.expectation(description: "Reloads results of page in current currency")
        let current_price = 28794
        let jsonString = "[{\"name\": \"Bitcoin\", \"id\": \"bitcoin\", \"current_price\": \(current_price)}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        sut.currentCurrency = "gbp"
        
        sut.reloadCoins { (_: [Coins]?) in
            XCTAssertEqual(self.sut.coins![0].name, "Bitcoin")
            XCTAssertEqual(self.sut.coins![0].id, "bitcoin")
            XCTAssertEqual(self.sut.coins![0].current_price, 28794)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    
}
