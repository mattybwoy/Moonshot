//
//  Coins.swift
//  Moonshot
//
//  Created by Matthew Lock on 10/11/2021.
//

import Foundation

struct Coins: Decodable {
    let id: String
    let name: String
    let current_price: Double
    let image: String
    let price_change_24h: Double
}
