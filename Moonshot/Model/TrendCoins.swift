//
//  TrendCoins.swift
//  Moonshot
//
//  Created by Matthew Lock on 24/12/2021.
//

import Foundation

struct TrendCoins: Decodable {
    struct coins: Decodable {
        var item: Item
        struct Item: Decodable {
            var name: String
        }
    }
    let coins: [coins]
}



//struct item: Decodable {
//    let name: String
//}
