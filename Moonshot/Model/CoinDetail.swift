//
//  CoinDetail.swift
//  Moonshot
//
//  Created by Matthew Lock on 16/02/2022.
//

import Foundation

struct CoinDetail: Decodable {
    let symbol: String
    let description: Description
    let market_cap_rank: Int
    let market_data: CoinMarketData
}

struct Description: Decodable {
    let en: String
}

struct CoinMarketData: Decodable {
    let total_supply: Double
    let circulating_supply: Double
}
