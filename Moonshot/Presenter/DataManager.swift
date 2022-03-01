//
//  DataManager.swift
//  Moonshot
//
//  Created by Matthew Lock on 10/11/2021.
//

import Foundation
import UIKit

class DataManager {
    static let sharedInstance = DataManager()
    
    var pageCount = 2
    var currentCurrency: String?
    var isPaginating = false
    var coins: [Coins]?
    var trendCoins: [TrendCoins.coins]?
    var totalMarketCap: Double?
    var searchResults: [Coin]?
    var coinDetail: CoinDetail?
    var btcRates: Tokens?
    var historicalRates: [[Double]]?
    var favoriteCoins: [WatchCoins] = [WatchCoins]()
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func testAPIStatus(completionHandler: @escaping (Status?, NetworkError?) -> Void) {
        if let url = URL(string: Url.status.rawValue) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completionHandler(nil, NetworkError.failedRequest)
                    return
                }
                do {
                    let status = try
                    JSONDecoder().decode(Status.self, from: data)
                    completionHandler(status, nil)
                }
                catch {
                    completionHandler(nil, NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
    }
    
    func loadCoins(currency: String = "usd", completed: @escaping ([Coins]?, NetworkError?) -> Void) {

        currentCurrency = currency
        
        if let url = URL(string: Url.base.rawValue + currentCurrency!) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completed(nil, NetworkError.failedRequest)
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode([Coins].self, from: data)
                    self.coins = response
                    DispatchQueue.main.async {
                        completed(response, nil)
                    }
                    self.pageCount = 2
                }
                catch {
                    completed(nil, NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
    }
    
    func scrollCoin(pagination: Bool, completed: @escaping (NetworkError?) -> ()) {
        
        isPaginating = true
        
        if let url = URL(string: Url.base.rawValue + currentCurrency! + Url.pageNum.rawValue + String(pageCount)) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completed(NetworkError.failedRequest)
                    return
                }
                do {
                let response = try
                    JSONDecoder().decode([Coins].self, from: data)
                    let newCoins = response
                    self.coins?.append(contentsOf: newCoins)
                    DispatchQueue.main.async {
                        completed(nil)
                    }
                    if pagination {
                        self.isPaginating = false
                    }
                }
                catch {
                    completed(NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
        pageCount += 1
    }
    
    func reloadCoins(pagination: Bool = false, completed: @escaping ([Coins]?, NetworkError?) -> Void) {
        
        if let url = URL(string: Url.base.rawValue + currentCurrency!) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completed(nil, NetworkError.failedRequest)
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode([Coins].self, from: data)
                    self.coins = response
                    DispatchQueue.main.async {
                        completed(response, nil)
                    }
                    self.pageCount = 2
                }
                catch {
                    completed(nil, NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
    }
    
    func trendingCoins(pagination: Bool = false, completed: @escaping (TrendCoins?, NetworkError?) -> ()) {
        
        if let url = URL(string: Url.trending.rawValue) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completed(nil, NetworkError.failedRequest)
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode(TrendCoins.self, from: data)
                    self.trendCoins = response.coins
                    DispatchQueue.main.async {
                        completed(response, nil)
                    }
                }
                catch {
                    completed(nil, NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
    }
    
    func loadMarketData(completed: @escaping (MarketData?, NetworkError?) -> Void) {
        
        if let url = URL(string: Url.total.rawValue) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completed(nil, NetworkError.failedRequest)
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode(MarketData.self, from: data)
                    switch self.currentCurrency {
                    case "gbp":
                        self.totalMarketCap = response.data.total_market_cap.gbp
                    case "eur":
                        self.totalMarketCap = response.data.total_market_cap.eur
                    case "aud":
                        self.totalMarketCap = response.data.total_market_cap.aud
                    case "cad":
                        self.totalMarketCap = response.data.total_market_cap.cad
                    case "cny":
                        self.totalMarketCap = response.data.total_market_cap.cny
                    case "hkd":
                        self.totalMarketCap = response.data.total_market_cap.hkd
                    case "inr":
                        self.totalMarketCap = response.data.total_market_cap.inr
                    case "jpy":
                        self.totalMarketCap = response.data.total_market_cap.jpy
                    case "twd":
                        self.totalMarketCap = response.data.total_market_cap.twd
                    default:
                        self.totalMarketCap = response.data.total_market_cap.usd
                    }
                    DispatchQueue.main.async {
                        completed(response, nil)
                    }
                }
                catch {
                    completed(nil, NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
    }
    
    func searchCoin(userSearch: String, completed: @escaping (SearchCoin?, NetworkError?) -> Void) {
        
        if let url = URL(string: Url.search.rawValue + userSearch) {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completed(nil, NetworkError.failedRequest)
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode(SearchCoin.self, from: data)
                    self.searchResults = response.coins
                    DispatchQueue.main.async {
                        completed(response, nil)
                    }
                }
                catch {
                    completed(nil, NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
    }
    
    func btcComparision(completed: @escaping (BitcoinExchange?, NetworkError?) -> Void) {
        
        if let url = URL(string: Url.btc.rawValue) {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completed(nil, NetworkError.failedRequest)
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode(BitcoinExchange.self, from: data)
                    DispatchQueue.main.async {
                        self.btcRates = response.rates
                        completed(response, nil)
                    }
                }
                catch {
                    completed(nil, NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
    }
    
    func loadCoinInformation(userSearch: String, completed: @escaping (CoinDetail?, NetworkError?) -> Void) {
        
        if let url = URL(string: Url.coinHistory.rawValue + userSearch + Url.coinParams.rawValue) {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completed(nil, NetworkError.failedRequest)
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode(CoinDetail.self, from: data)
                    self.coinDetail = response
                    print(response)
                    DispatchQueue.main.async {
                        completed(response, nil)
                    }
                }
                catch {
                    completed(nil, NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
    }
    
    func loadCoinPriceHistory(userSearch: String, completed: @escaping (CoinHistory?, NetworkError?) -> Void) {
        
        if let url = URL(string: Url.coinHistory.rawValue + userSearch + Url.coinHistoryCurrency.rawValue + currentCurrency! + Url.coinInterval.rawValue) {
            let task = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completed(nil, NetworkError.failedRequest)
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode(CoinHistory.self, from: data)
                    self.historicalRates = response.prices
                    DispatchQueue.main.async {
                        completed(response, nil)
                    }
                }
                catch {
                    completed(nil, NetworkError.invalidRequestError)
                    return
                }
            }
            task.resume()
        }
    }
    
    
}
