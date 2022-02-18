//
//  CoinViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 15/02/2022.
//

import UIKit
import Nuke

class CoinViewController: UIViewController {
    
    let coin: Coins
    var currency = DataManager.sharedInstance.currentCurrency

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        view.addSubview(coinHeader)
        view.addSubview(coinSymbol)
        view.addSubview(coinRank)
        view.addSubview(currentPrice)
        view.addSubview(marketCapLabel)
        view.addSubview(totalSupply)
        view.addSubview(circulatingSupply)
        view.addSubview(high24Price)
        view.addSubview(low24Price)
        DataManager.sharedInstance.loadCoinInformation(userSearch: self.coin.id) {
            self.setupScreen()
        }
        setupCoinImage()
    }
    
    init(coin: Coins) {
        self.coin = coin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let coinHeader: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 30))
        label.center = CGPoint(x: 210, y: 40)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 22)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let coinSymbol: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 50, height: 25))
        label.center = CGPoint(x: 208, y: 127)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 14)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let coinRank: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 70, height: 20))
        label.center = CGPoint(x: 355, y: 150)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 14)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let currentPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 220, height: 25))
        label.center = CGPoint(x: 208, y: 450)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 14)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let high24Price: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        label.center = CGPoint(x: 110, y: 500)
        label.font = UIFont(name: "Astrolab", size: 12)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    let low24Price: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        label.center = CGPoint(x: 310, y: 500)
        label.font = UIFont(name: "Astrolab", size: 12)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    let marketCapLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 20))
        label.center = CGPoint(x: 208, y: 705)
        label.font = UIFont(name: "Astrolab", size: 12)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let totalSupply: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 20))
        label.center = CGPoint(x: 208, y: 730)
        label.font = UIFont(name: "Astrolab", size: 12)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let circulatingSupply: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 20))
        label.center = CGPoint(x: 208, y: 755)
        label.font = UIFont(name: "Astrolab", size: 12)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    func setupScreen() {
        guard let coinInfo = DataManager.sharedInstance.coinDetail else {
            return
        }
        coinHeader.text = "\(self.coin.name)"
        coinRank.text = "Rank: \(coinInfo.market_cap_rank)"
        totalSupply.text = "Total Supply: \(coinInfo.market_data.total_supply ?? 0)"
        circulatingSupply.text = "Circulating Supply: \(coinInfo.market_data.circulating_supply ?? 0)"
        coinSymbol.text = "\(coinInfo.symbol)"
        
        switch currency {
        case "gbp":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.gbp)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.gbp)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.gbp)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.gbp)"
        case "eur":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.eur)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.eur)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.eur)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.eur)"
        case "aud":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.aud)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.aud)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.aud)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.aud)"
        case "cad":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.cad)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.cad)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.cad)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.cad)"
        case "cny":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.cny)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.cny)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.cny)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.cny)"
        case "hkd":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.hkd)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.hkd)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.hkd)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.hkd)"
        case "inr":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.inr)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.inr)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.inr)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.inr)"
        case "jpy":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.jpy)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.jpy)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.jpy)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.jpy)"
        case "sgd":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.sgd)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.sgd)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.sgd)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.sgd)"
        case "twd":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.twd)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.twd)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.twd)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.twd)"
        default:
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.usd)"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.usd)"
            high24Price.text = "Max price 24Hours \n\(coinInfo.market_data.high_24h.usd)"
            low24Price.text = "Min price 24Hours \n\(coinInfo.market_data.low_24h.usd)"
        }
    }
    
    func setupCoinImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 50, width: 16, height: 16))
        Nuke.loadImage(with: URL(string: self.coin.image)!, into: imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -725),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180),
        ])
    }
    
}
