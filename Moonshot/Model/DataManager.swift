//
//  DataManager.swift
//  Moonshot
//
//  Created by Matthew Lock on 10/11/2021.
//

import Foundation
import UIKit

protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func coinUpdate(dataManager: DataManager)
}

class DataManager {
    
    let baseURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    var coins = [Coins]()
    var delegate: CoinManagerDelegate?
    var favoriteCoins = [Coins]()
    
    func loadCoins(completed: @escaping () -> ()) {
        if let url = URL(string: baseURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
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
    
    func parseJSON(_ data: Data) -> [Coins] {
        let decoder = JSONDecoder()
        do {
            let coins = try decoder.decode([Coins].self, from: data)
            return coins
        } catch {
            print(error)
            return []
        }
    }
}
