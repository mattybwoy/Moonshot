//
//  Url.swift
//  Moonshot
//
//  Created by Matthew Lock on 01/03/2022.
//

import Foundation

enum Url: String {
    case status = "https://api.coingecko.com/api/v3/ping"
    case base = "https://api.coingecko.com/api/v3/coins/markets?vs_currency="
    case pageNum = "&page="
    case trending = "https://api.coingecko.com/api/v3/search/trending"
    case total = "https://api.coingecko.com/api/v3/global"
    case search = "https://api.coingecko.com/api/v3/search?query="
    case btc = "https://api.coingecko.com/api/v3/exchange_rates"
    case coinHistory = "https://api.coingecko.com/api/v3/coins/"
    case coinParams = "?localization=false&tickers=false&community_data=false&developer_data=false"
    case coinHistoryCurrency = "/market_chart?vs_currency="
    case coinInterval = "&days=7&interval=daily"
    
}
