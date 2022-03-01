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
        
        sut.testAPIStatus { (Status, NetworkError)  in
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

        sut.loadCoins { (_: [Coins]?, NetworkError) in
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
        
        sut.loadCoins(currency: "gbp") { (_: [Coins]?, NetworkError) in
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
        
        sut.scrollCoin(pagination: true) {_ in
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
        
        sut.reloadCoins { (_: [Coins]?, NetworkError) in
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
        
        sut.trendingCoins { (_: TrendCoins?, NetworkError) in
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
        
        sut.loadMarketData { (_: MarketData?, NetworkError) in
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
        
        sut.loadMarketData { (_: MarketData?, NetworkError) in
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
        
        sut.searchCoin(userSearch: "Bitcoin") { (_: SearchCoin?, NetworkError) in
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
    
    func test_btcComparision_WhenSuccessfulRequest_ReturnsFiatRates() {
        
        let expectation = self.expectation(description: "Loads fiat currency results for 1 BTC")
        let USDRate = 36030.933
        let GBPRate = 27010.517
        let EURRate = 32346.373
        let AUDRate = 50591.177
        let CADRate = 46326.88
        let CNYRate = 228010.951
        let HKDRate = 281326.824
        let INRRate = 2728027.988
        let JPYRate = 4158987.564
        let TWDRate = 1013382.895
        let jsonString = "{\"rates\": {\"usd\": {\"name\": \"US Dollar\", \"value\": \(USDRate)}, \"gbp\": {\"name\": \"British Pound Sterling\", \"value\": \(GBPRate)}, \"eur\": {\"name\": \"Euro\", \"value\": \(EURRate)}, \"aud\": {\"name\": \"Australian Dollar\", \"value\": \(AUDRate)}, \"cad\": {\"name\": \"Canadian Dollar\", \"value\": \(CADRate)}, \"cny\": {\"name\": \"Chinese Yuan\", \"value\": \(CNYRate)}, \"hkd\": {\"name\": \"Hong Kong Dollar\", \"value\": \(HKDRate)}, \"inr\": {\"name\": \"Indian Rupee\", \"value\": \(INRRate)}, \"jpy\": {\"name\": \"Japanese Yen\", \"value\": \(JPYRate)}, \"twd\": {\"name\": \"New Taiwan Dollar\", \"value\": \(TWDRate)}}}"
        
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        sut.btcComparision {(_: BitcoinExchange?, NetworkError) in
            XCTAssertNotNil(self.sut.btcRates)
            XCTAssertEqual(self.sut.btcRates?.usd.name, "US Dollar")
            XCTAssertEqual(self.sut.btcRates?.usd.value, USDRate)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }

    func test_loadCoinInformation_WhenSuccessfulRequest_ReturnsCoinInformation() {
        
        let expectation = self.expectation(description: "Loads coin information and price history")
        let searchTerm = "bitcoin"
        let rank = 1
        let total = 21000000.0
        let circulating = 18968081.0
        let currentPrice = "{\"usd\": 39220.0, \"gbp\": 29282.0, \"eur\": 34906.0, \"aud\": 54286.0, \"cad\": 50080.0, \"cny\": 248767.0, \"hkd\": 307502.0, \"inr\": 2957863.0, \"jpy\": 4552872.0, \"twd\": 1102451.0}"
        let highPrice = "{\"usd\": 69045.0, \"gbp\": 51032.0, \"eur\": 59717.0, \"aud\": 93482.0, \"cad\": 85656.0, \"cny\": 440948.0, \"hkd\": 537865.0, \"inr\": 5128383.0, \"jpy\": 7828814.0, \"twd\": 1914232.0}"
        let lowPrice = "{\"usd\": 67.81, \"gbp\": 43.9, \"eur\": 51.3, \"aud\": 72.61, \"cad\": 69.81, \"cny\": 407.23, \"hkd\": 514.37, \"inr\": 3993.42, \"jpy\": 6641.83, \"twd\": 1998.66}"
        let capPrice = "{\"usd\": 746674075370.0, \"gbp\": 556248292581.0, \"eur\": 662776282914.0, \"aud\": 1032494191356.0, \"cad\": 950975302503.0, \"cny\": 4717113471153.0, \"hkd\": 5830750974301.0, \"inr\": 56065811233598.0, \"jpy\": 86289949525738.0, \"twd\": 20895673252567.0}"
        let high24Price = "{\"usd\": 39610.0, \"gbp\": 29572.0, \"eur\": 35287.0, \"aud\": 54829.0, \"cad\": 50560.0, \"cny\": 250115.0, \"hkd\": 309282.0, \"inr\": 2976416.0, \"jpy\": 4552872.0, \"twd\": 1102451.0}"
        let low24Price = "{\"usd\": 35907.0, \"gbp\": 26854.0, \"eur\": 32146.0, \"aud\": 50306.0, \"cad\": 46107.0, \"cny\": 227228.0, \"hkd\": 280360.0, \"inr\": 2719116.0, \"jpy\": 4139018.0, \"twd\": 1009992.0}"
        let image = "{\"small\": \"https://assets.coingecko.com/coins/images/1/small/bitcoin.png?1547033579\"}"
        let marketData = "{\"total_supply\": \(total), \"circulating_supply\": \(circulating), \"current_price\": \(currentPrice), \"ath\": \(highPrice), \"atl\": \(lowPrice), \"market_cap\": \(capPrice), \"high_24h\": \(high24Price), \"low_24h\": \(low24Price)}"
        let jsonString = "{\"name\": \"Bitcoin\", \"symbol\": \"btc\", \"market_cap_rank\": \(rank), \"market_data\": \(marketData), \"image\": \(image)}"
        
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        sut.loadCoinInformation(userSearch: searchTerm) { (_: CoinDetail?, NetworkError) in
            XCTAssertNotNil(self.sut.coinDetail)
            XCTAssertEqual(self.sut.coinDetail?.market_cap_rank, rank)
            XCTAssertEqual(self.sut.coinDetail?.market_data.total_supply, total)
            XCTAssertEqual(self.sut.coinDetail?.market_data.circulating_supply, circulating)
            XCTAssertEqual(self.sut.coinDetail?.market_data.ath.usd, 69045.0)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    func test_loadCoinPriceHistory() {
        
        let expectation = self.expectation(description: "Loads last 7 days price history")
        let searchTerm = "bitcoin"
        let jsonString = "{\"prices\": [[1645228800000, 40073.495362369824], [1645315200000, 40192.75912143141], [1645401600000, 38514.00853622455], [1645488000000, 37059.979402287514], [1645574400000, 38337.2038554348], [1645660800000, 37372.2926803477], [1645747200000, 38363.345488570165], [1645812330000, 39082.76215785049]]}"
        
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        sut.currentCurrency = "usd"
        
        sut.loadCoinPriceHistory(userSearch: searchTerm) { (_: CoinHistory?, NetworkError) in
            XCTAssertNotNil(self.sut.historicalRates)
            XCTAssertEqual(self.sut.historicalRates![0][0], 1645228800000)
            XCTAssertEqual(self.sut.historicalRates![0][1], 40073.495362369824)
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 3)
    }
    
    
}
