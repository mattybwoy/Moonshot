//
//  DataManager.swift
//  Moonshot
//
//  Created by Matthew Lock on 10/11/2021.
//

import Foundation
import UIKit

class DataManager {
    
    let baseURL = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd"
    var coins = [Coins]()
    
    var favoriteCoins = [Coins]()
    
    func loadCoins(completed: @escaping () -> ()) {
        if let url = URL(string: baseURL) {
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
