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
    let total_market_cap: Totals
}

struct Totals: Decodable {
    let usd: Double
    let gbp: Double
    let eur: Double
    let aud: Double
    let cad: Double
    let cny: Double
    let hkd: Double
    let inr: Double
    let jpy: Double
    let sgd: Double
    let twd: Double
}
