//
//  CoinDetail.swift
//  Moonshot
//
//  Created by Matthew Lock on 16/02/2022.
//

import Foundation

struct CoinDetail: Decodable {
    let name: String
    let symbol: String
    let market_cap_rank: Int
    let market_data: CoinMarketData
    let image: Image
}

struct Image: Decodable {
    let small: String
}

struct CoinMarketData: Decodable {
    var total_supply: Double? = nil
    var circulating_supply: Double? = nil
    let current_price: Current
    let ath: High
    let atl: Low
    let market_cap: Cap
    let high_24h: High24
    let low_24h: Low24
}

struct Current: Decodable {
    let usd: Double
    let gbp: Double
    let eur: Double
    let aud: Double
    let cad: Double
    let cny: Double
    let hkd: Double
    let inr: Double
    let jpy: Double
    let twd: Double
}

struct High: Decodable {
    let usd: Double
    let gbp: Double
    let eur: Double
    let aud: Double
    let cad: Double
    let cny: Double
    let hkd: Double
    let inr: Double
    let jpy: Double
    let twd: Double
}

struct Low: Decodable {
    let usd: Double
    let gbp: Double
    let eur: Double
    let aud: Double
    let cad: Double
    let cny: Double
    let hkd: Double
    let inr: Double
    let jpy: Double
    let twd: Double
}

struct Cap: Decodable {
    let usd: Double
    let gbp: Double
    let eur: Double
    let aud: Double
    let cad: Double
    let cny: Double
    let hkd: Double
    let inr: Double
    let jpy: Double
    let twd: Double
}

struct High24: Decodable {
    let usd: Double
    let gbp: Double
    let eur: Double
    let aud: Double
    let cad: Double
    let cny: Double
    let hkd: Double
    let inr: Double
    let jpy: Double
    let twd: Double
}

struct Low24: Decodable {
    let usd: Double
    let gbp: Double
    let eur: Double
    let aud: Double
    let cad: Double
    let cny: Double
    let hkd: Double
    let inr: Double
    let jpy: Double
    let twd: Double
}
