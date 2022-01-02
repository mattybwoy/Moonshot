//
//  DataManager.swift
//  Moonshot
//
//  Created by Matthew Lock on 10/11/2021.
//

import Foundation
import UIKit

class DataManager {
    
    var pageCount = 1
    var currentCurrency: String?
    var isPaginating = false
    let baseURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency="
    let trendingURL = "https://api.coingecko.com/api/v3/search/trending"
    let pageNum = "&page="
    var coins = [Coins]()
    var trendCoins = [TrendCoins.coins]()
    //var trendArray = [TrendCoins]()
    
    //var favoriteCoins = [Coins]()
    
    func loadCoins(pagination: Bool = false, currency: String = "usd", completed: @escaping () -> ()) {
        
        if pagination {
            isPaginating = true
        }
        currentCurrency = currency

        if let url = URL(string: baseURL + currentCurrency!) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                if let data = data {
                    self.coins = self.parseJSON(data)
                    //print(self.coins)
                    DispatchQueue.main.async {
                        completed()
                    }
                    if pagination {
                        self.isPaginating = false
                    }
                }
            }
            task.resume()
        }
    }
    
    func scrollCoin(pagination: Bool = false, completed: @escaping () -> ()) {
        
        if pagination {
            isPaginating = true
        }
        
        if let url = URL(string: baseURL + currentCurrency! + pageNum + String(pageCount)) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                if let data = data {
                        let newCoins = self.parseJSON(data)
                        self.coins.append(contentsOf: newCoins)
                    //print(self.coins)
                    DispatchQueue.main.async {
                        completed()
                    }
                    if pagination {
                        self.isPaginating = false
                    }
                }
            }
            task.resume()
        }
        pageCount += 1
    }
    
    func reloadCoins(pagination: Bool = false, completed: @escaping () -> ()) {
        let newCurrency: String = baseURL + currentCurrency!
        
        if let url = URL(string: newCurrency) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                if let data = data {
                    self.coins = self.parseJSON(data)
                    print(self.coins)
                    DispatchQueue.main.async {
                        completed()
                    }
                }
            }
            task.resume()
        }
    }
    
    func trendingCoins(pagination: Bool = false, completed: @escaping () -> ()) {
        if let url = URL(string: trendingURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    return
                }
                if let data = data {
                    self.trendCoins = self.parseTrendingJSON(data)
                    DispatchQueue.main.async {
                        completed()
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> [Coins] {
        let decoder = JSONDecoder()
        do {
            let coins = try decoder.decode([Coins].self, from: data)
            print(coins)
            return coins
        } catch {
            print(error)
            return []
        }
    }
    
    func parseTrendingJSON(_ data: Data) -> [TrendCoins.coins] {
        let decoder = JSONDecoder()
        do {
            let coins = try decoder.decode(TrendCoins.self, from: data)
            return coins.coins
        } catch {
            print(error)
            return []
        }
    }
}
