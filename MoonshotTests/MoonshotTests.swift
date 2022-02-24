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
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
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
        let image = "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
        let priceChange = 710.45
        let jsonString = "[{\"name\": \"Bitcoin\", \"id\": \"bitcoin\", \"current_price\": \(current_price), \"image\": \"https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579\", \"price_change_24h\": \(priceChange)}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)

        sut.loadCoins { (_: [Coins]?) in
            XCTAssertEqual(self.sut.coins![0].name, "Bitcoin")
            XCTAssertEqual(self.sut.coins![0].id, "bitcoin")
            XCTAssertEqual(self.sut.coins![0].current_price, 38346)
            XCTAssertEqual(self.sut.coins![0].image, image)
            XCTAssertEqual(self.sut.coins![0].price_change_24h, priceChange)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 3)
    }
    
    func test_loadCoins_WhenSuccessfulResponse_ReturnsRatesInGBP() {
        
        let expectation = self.expectation(description: "Loads Cryptocurrency in GBP")
        let current_price = 28794
        let image = "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
        let priceChange = 582.5
        let jsonString = "[{\"name\": \"Bitcoin\", \"id\": \"bitcoin\", \"current_price\": \(current_price), \"image\": \"https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579\", \"price_change_24h\": \(priceChange)}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        sut.loadCoins(currency: "gbp") { (_: [Coins]?) in
            XCTAssertEqual(self.sut.currentCurrency, "gbp")
            XCTAssertEqual(self.sut.coins![0].name, "Bitcoin")
            XCTAssertEqual(self.sut.coins![0].id, "bitcoin")
            XCTAssertEqual(self.sut.coins![0].current_price, 28794)
            XCTAssertEqual(self.sut.coins![0].image, image)
            XCTAssertEqual(self.sut.coins![0].price_change_24h, priceChange)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 3)
    }

    func test_scrollCoin_WhenSuccessfulResponse_ReturnsNextPageOfResults() {
        
        let expectation = self.expectation(description: "Loads results of next page in current currency")
        let current_price = 38346
        let priceChange = 710.45
        let jsonString = "[{\"name\": \"Bitcoin\", \"id\": \"bitcoin\", \"current_price\": \(current_price), \"image\": \"https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579\", \"price_change_24h\": \(priceChange)}]"
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
        let image = "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
        let priceChange = 710.45
        let jsonString = "[{\"name\": \"Bitcoin\", \"id\": \"bitcoin\", \"current_price\": \(current_price), \"image\": \"https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579\", \"price_change_24h\": \(priceChange)}]"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        sut.currentCurrency = "gbp"
        
        sut.reloadCoins { (_: [Coins]?) in
            XCTAssertEqual(self.sut.coins![0].name, "Bitcoin")
            XCTAssertEqual(self.sut.coins![0].id, "bitcoin")
            XCTAssertEqual(self.sut.coins![0].current_price, 28794)
            XCTAssertEqual(self.sut.coins![0].image, image)
            XCTAssertEqual(self.sut.coins![0].price_change_24h, priceChange)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    func test_trendingCoins_WhenSuccessfulResponse_ReturnsLatestTrendingRates() {
        
        let expectation = self.expectation(description: "Loads latest trending rates")
        let jsonString = "{\"coins\": [{\"item\": {\"id\": \"cellframe\", \"name\": \"Cellframe\", \"thumb\": \"https://assets.coingecko.com/coins/images/14465/thumb/cellframe_logo.png\"}}]}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        sut.trendingCoins { (_: TrendCoins?) in
            XCTAssertNotNil(self.sut.trendCoins)
            XCTAssertEqual(self.sut.trendCoins?.count, 1)
            XCTAssertEqual(self.sut.trendCoins![0].item.id, "cellframe")
            XCTAssertEqual(self.sut.trendCoins![0].item.name, "Cellframe")
            XCTAssertEqual(self.sut.trendCoins![0].item.thumb, "https://assets.coingecko.com/coins/images/14465/thumb/cellframe_logo.png")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    func test_loadMarketData_WhenSuccessfulResponse_ReturnsTotalMarketCap() {
        
        let expectation = self.expectation(description: "Loads total market cap rates in current currency")
        let totalUSDMarket = 1862718374088.0632
        let totalGBPMarket = 1378260716636.8645
        let totalEURMarket = 1656172709895.6853
        let totalAUDMarket = 2618439982920.9585
        let totalCADMarket = 2363675990896.933
        let totalCNYMarket = 11848751577574.184
        let totalHKDMarket = 14518054948417.967
        let totalINRMarket = 139303160766379.22
        let totalJPYMarket = 213648209352778.78
        let totalSGDMarket = 2513319334197.6733
        let totalTWDMarket = 51789155229333.49
        let jsonString = "{\"data\": {\"total_market_cap\": {\"usd\": \(totalUSDMarket), \"gbp\": \(totalGBPMarket), \"eur\": \(totalEURMarket), \"aud\": \(totalAUDMarket), \"cad\": \(totalCADMarket), \"cny\": \(totalCNYMarket), \"hkd\": \(totalHKDMarket), \"inr\": \(totalINRMarket), \"jpy\": \(totalJPYMarket), \"sgd\": \(totalSGDMarket), \"twd\": \(totalTWDMarket)}}}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        sut.loadMarketData { (_: MarketData?) in
            XCTAssertNotNil(self.sut.totalMarketCap)
            XCTAssertEqual(self.sut.totalMarketCap, 1862718374088.0632)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    func test_loadMarketData_WhenSuccessfulResponse_ReturnsTotalMarketCapinGBP() {
        
        let expectation = self.expectation(description: "Loads total market cap rates in GBP currency")
        let totalUSDMarket = 1862718374088.0632
        let totalGBPMarket = 1378260716636.8645
        let totalEURMarket = 1656172709895.6853
        let totalAUDMarket = 2618439982920.9585
        let totalCADMarket = 2363675990896.933
        let totalCNYMarket = 11848751577574.184
        let totalHKDMarket = 14518054948417.967
        let totalINRMarket = 139303160766379.22
        let totalJPYMarket = 213648209352778.78
        let totalSGDMarket = 2513319334197.6733
        let totalTWDMarket = 51789155229333.49
        let jsonString = "{\"data\": {\"total_market_cap\": {\"usd\": \(totalUSDMarket), \"gbp\": \(totalGBPMarket), \"eur\": \(totalEURMarket), \"aud\": \(totalAUDMarket), \"cad\": \(totalCADMarket), \"cny\": \(totalCNYMarket), \"hkd\": \(totalHKDMarket), \"inr\": \(totalINRMarket), \"jpy\": \(totalJPYMarket), \"sgd\": \(totalSGDMarket), \"twd\": \(totalTWDMarket)}}}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        sut.currentCurrency = "gbp"
        
        sut.loadMarketData { (_: MarketData?) in
            XCTAssertNotNil(self.sut.totalMarketCap)
            XCTAssertEqual(self.sut.totalMarketCap, 1378260716636.8645)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    func test_searchCoin_WhenSuccessfulResponse_ReturnsSearchResults() {
        
        let expectation = self.expectation(description: "Loads search results for user")
        
        let jsonString = "{\"coins\": [{\"id\": \"bitcoin\", \"name\": \"Bitcoin\", \"thumb\": \"https://assets.coingecko.com/coins/images/1/thumb/bitcoin.png\"}]}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        sut.searchCoin(userSearch: "Bitcoin") { (_: SearchCoin?, error) in
            XCTAssertNotNil(self.sut.searchResults)
            XCTAssertEqual(self.sut.searchResults![0].id, "bitcoin")
            XCTAssertEqual(self.sut.searchResults![0].name, "Bitcoin")
            XCTAssertEqual(self.sut.searchResults![0].thumb, "https://assets.coingecko.com/coins/images/1/thumb/bitcoin.png")
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    func test_searchCoin_WhenUnsuccessfulRequest_ReturnsZeroResults() {
        
        let expectation = self.expectation(description: "Zero results for user")
        let jsonString = "{\"co1ns\": [54htr]}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        sut.searchCoin(userSearch: "WrappedBitcoin") { (_: SearchCoin?, error) in
            XCTAssertTrue(error != nil)
            XCTAssertNil(self.sut.searchResults)
            XCTAssertEqual(error, NetworkError.invalidRequestError)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    
}
