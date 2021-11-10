//
//  DataManager.swift
//  Moonshot
//
//  Created by Matthew Lock on 10/11/2021.
//

import Foundation
import UIKit

protocol CoinManagerDelegate {
    func didUpdateCoin(coins: [Coins])
    func didFailWithError(error: Error)
}

class DataManager {
    
    let baseURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    var coins = [Coins]()
    var delegate: CoinManagerDelegate?
    
    func loadCoins() {
        if let url = URL(string: baseURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let data = data {
                    self.coins = self.parseJSON(data)
                    
                    self.delegate?.didUpdateCoin(coins: self.coins)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> [Coins] {
        let decoder = JSONDecoder()
        do {
            let coins = try decoder.decode([Coins].self, from: data)
            coins.forEach { coin in
                print("\(coin.id): current price \(coin.current_price)")
            }
            return coins
        } catch {
            print(error)
            return []
        }
    }
}
