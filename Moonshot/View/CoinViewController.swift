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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        view.addSubview(coinHeader)
        view.addSubview(coinSymbol)
        view.addSubview(coinRank)
        view.addSubview(totalSupply)
        view.addSubview(circulatingSupply)
        setupScreen()
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
    
    let totalSupply: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 20))
        label.center = CGPoint(x: 88, y: 730)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 12)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let circulatingSupply: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 20))
        label.center = CGPoint(x: 120, y: 755)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 12)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    func setupScreen() {
        coinHeader.text = "\(self.coin.name)"
        coinRank.text = "Rank: \(DataManager.sharedInstance.coinDetail?.market_cap_rank ?? 0)"
        totalSupply.text = "Total Supply: "
        circulatingSupply.text = "Circulating Supply: "
        coinSymbol.text = "btc"
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
