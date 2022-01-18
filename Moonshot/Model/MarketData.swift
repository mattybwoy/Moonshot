//
//  MarketData.swift
//  Moonshot
//
//  Created by Matthew Lock on 18/01/2022.
//

import Foundation

struct MarketData: Decodable {
    let data: Market
}

struct Market: Decodable {
    let markets: Int
}
