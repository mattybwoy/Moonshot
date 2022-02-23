//
//  SearchCoin.swift
//  Moonshot
//
//  Created by Matthew Lock on 03/02/2022.
//

import Foundation

struct SearchCoin: Decodable {
    let coins: [Coin]
}

struct Coin: Decodable {
    let id: String
    let name: String
    let thumb: String
}
