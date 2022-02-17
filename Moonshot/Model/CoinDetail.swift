//
//  CoinDetail.swift
//  Moonshot
//
//  Created by Matthew Lock on 16/02/2022.
//

import Foundation

struct CoinDetail: Decodable {
    let symbol: String
    let market_cap_rank: Int
    let market_data: CoinMarketData
}

struct CoinMarketData: Decodable {
    var total_supply: Double? = nil
    var circulating_supply: Double? = nil
}
