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
    let baseURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency="
    let trendingURL = "https://api.coingecko.com/api/v3/search/trending"
    let totalURL = "https://api.coingecko.com/api/v3/global"
    let pageNum = "&page="
    var coins: [Coins]?
    var trendCoins: [TrendCoins.coins]?
    var totalMarketCap: Double?
    
    var favoriteCoins: [String] = [String]()
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func testAPIStatus(completionHandler: @escaping (Status?) -> Void) {
        let statusURL = "https://api.coingecko.com/api/v3/ping"
        if let url = URL(string: statusURL) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let status = try
                    JSONDecoder().decode(Status.self, from: data)
                    completionHandler(status)
                }
                catch {
                    return
                }
            }
            task.resume()
        }
    }
    
    func loadCoins(currency: String = "usd", completed: @escaping ([Coins]?) -> Void) {

        currentCurrency = currency
        
        if let url = URL(string: baseURL + currentCurrency!) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode([Coins].self, from: data)
                    self.coins = response
                    DispatchQueue.main.async {
                        completed(response)
                    }
                    self.pageCount = 2
                }
                catch {
                    return
                }
            }
            task.resume()
        }
    }
    
    func scrollCoin(pagination: Bool, completed: @escaping () -> ()) {
        
        isPaginating = true
        
        if let url = URL(string: baseURL + currentCurrency! + pageNum + String(pageCount)) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                let response = try
                    JSONDecoder().decode([Coins].self, from: data)
                    let newCoins = response
                    self.coins?.append(contentsOf: newCoins)
                    DispatchQueue.main.async {
                        completed()
                    }
                    if pagination {
                        self.isPaginating = false
                    }
                }
                catch {
                    return
                }
            }
            task.resume()
        }
        pageCount += 1
    }
    
    func reloadCoins(pagination: Bool = false, completed: @escaping ([Coins]?) -> Void) {
        
        if let url = URL(string: baseURL + currentCurrency!) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode([Coins].self, from: data)
                    self.coins = response
                    DispatchQueue.main.async {
                        completed(response)
                    }
                    self.pageCount = 2
                }
                catch {
                    return
                }
            }
            task.resume()
        }
    }
    
    func trendingCoins(pagination: Bool = false, completed: @escaping (TrendCoins?) -> ()) {
        
        if let url = URL(string: trendingURL) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let response = try
                    JSONDecoder().decode(TrendCoins.self, from: data)
                    self.trendCoins = response.coins
                    DispatchQueue.main.async {
                        completed(response)
                    }
                }
                catch {
                    return
                }
            }
            task.resume()
        }
    }
    
    func loadMarketData(completed: @escaping () -> ()) {
        if let url = URL(string: totalURL) {
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
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
                    case "sgd":
                        self.totalMarketCap = response.data.total_market_cap.sgd
                    case "twd":
                        self.totalMarketCap = response.data.total_market_cap.twd
                    case "vnd":
                        self.totalMarketCap = response.data.total_market_cap.vnd
                    default:
                        self.totalMarketCap = response.data.total_market_cap.usd
                    }
                    DispatchQueue.main.async {
                        completed()
                    }
                }
                catch {
                    return
                }
            }
            task.resume()
        }
    }
    
    
}
