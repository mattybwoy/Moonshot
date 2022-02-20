//
//  BitcoinExchange.swift
//  Moonshot
//
//  Created by Matthew Lock on 19/02/2022.
//

import Foundation

struct BitcoinExchange: Decodable {
    let rates: Tokens
}

struct Tokens: Decodable {
    let usd: Token
    let gbp: Token
    let eur: Token
    let aud: Token
    let cad: Token
    let cny: Token
    let hkd: Token
    let inr: Token
    let jpy: Token
    let twd: Token
}

struct Token: Decodable {
    let name: String
    let value: Double
}
