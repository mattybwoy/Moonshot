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
        view.addSubview(marketCapLabel)
        view.addSubview(totalSupply)
        view.addSubview(circulatingSupply)
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
    
    let marketCapLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 20))
        label.center = CGPoint(x: 140, y: 705)
        label.font = UIFont(name: "Astrolab", size: 12)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let totalSupply: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 20))
        label.center = CGPoint(x: 140, y: 730)
        label.font = UIFont(name: "Astrolab", size: 12)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let circulatingSupply: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 20))
        label.center = CGPoint(x: 140, y: 755)
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
        case "eur":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.eur)"
        case "aud":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.aud)"
        case "cad":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.cad)"
        case "cny":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.cny)"
        case "hkd":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.hkd)"
        case "inr":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.inr)"
        case "jpy":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.jpy)"
        case "sgd":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.sgd)"
        case "twd":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.twd)"
        default:
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.usd)"
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
