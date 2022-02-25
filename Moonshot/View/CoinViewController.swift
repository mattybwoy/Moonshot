//
//  CoinViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 15/02/2022.
//

import UIKit
import Nuke
import Charts

class CoinViewController: UIViewController, ChartViewDelegate {
    
    let coin: String
    var currency = DataManager.sharedInstance.currentCurrency
    
    let chartView: LineChartView = LineChartView()

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
        view.addSubview(highAllTimePrice)
        view.addSubview(lowAllTimePrice)
        view.addSubview(coinHistoryLabel)
        DataManager.sharedInstance.loadCoinInformation(userSearch: self.coin) {_ in 
            self.setupScreen()
            self.setupCoinImage()
        }
        DataManager.sharedInstance.loadCoinPriceHistory(userSearch: self.coin) { _ in [self]
            self.setData()
        }
        setupGraph()
    }
    
    init(coin: String) {
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
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 100, height: 30))
        label.center = CGPoint(x: 206, y: 127)
        label.textAlignment = .center
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let coinRank: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 70, height: 30))
        label.center = CGPoint(x: 355, y: 150)
        label.textAlignment = .center
        label.font = UIFont(name: "Nasalization", size: 20)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let marketCapLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 270, height: 25))
        label.center = CGPoint(x: 208, y: 180)
        label.font = UIFont(name: "Nasalization", size: 18)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let coinHistoryLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 240, height: 25))
        label.center = CGPoint(x: 208, y: 210)
        label.font = UIFont(name: "Nasalization", size: 14)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.text = "Coin history last 7 days"
        return label
    }()
    
    let currentPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 25))
        label.center = CGPoint(x: 208, y: 560)
        label.textAlignment = .center
        label.font = UIFont(name: "Nasalization", size: 18)
        label.textColor = .systemBlue
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let high24Price: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 190, height: 40))
        label.center = CGPoint(x: 115, y: 610)
        label.font = UIFont(name: "Nasalization", size: 18)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    let low24Price: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 190, height: 40))
        label.center = CGPoint(x: 315, y: 610)
        label.font = UIFont(name: "Nasalization", size: 18)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    let highAllTimePrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 190, height: 40))
        label.center = CGPoint(x: 115, y: 670)
        label.font = UIFont(name: "Nasalization", size: 18)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    let lowAllTimePrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 190, height: 40))
        label.center = CGPoint(x: 315, y: 670)
        label.font = UIFont(name: "Nasalization", size: 18)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    let totalSupply: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 270, height: 25))
        label.center = CGPoint(x: 208, y: 730)
        label.font = UIFont(name: "Nasalization", size: 18)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let circulatingSupply: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 270, height: 25))
        label.center = CGPoint(x: 208, y: 755)
        label.font = UIFont(name: "Nasalization", size: 18)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    func setupScreen() {
        guard let coinInfo = DataManager.sharedInstance.coinDetail else {
            return
        }
        coinHeader.text = "\(coinInfo.name)"
        coinRank.text = "Rank: \(coinInfo.market_cap_rank)"
        totalSupply.text = "Total Supply: \(coinInfo.market_data.total_supply ?? 0)"
        circulatingSupply.text = "Circulating Supply: \(coinInfo.market_data.circulating_supply ?? 0)"
        coinSymbol.text = "\(coinInfo.symbol)"
        
        switch currency {
        case "gbp":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.gbp.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.gbp.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.gbp.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.gbp.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.gbp.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.gbp.toString())"
        case "eur":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.eur.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.eur.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.eur.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.eur.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.eur.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.eur.toString())"
        case "aud":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.aud.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.aud.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.aud.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.aud.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.aud.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.aud.toString())"
        case "cad":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.cad.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.cad.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.cad.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.cad.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.cad.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.cad.toString())"
        case "cny":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.cny.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.cny.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.cny.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.cny.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.cny.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.cny.toString())"
        case "hkd":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.hkd.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.hkd.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.hkd.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.hkd.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.hkd.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.hkd.toString())"
        case "inr":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.inr.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.inr.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.inr.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.inr.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.inr.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.inr.toString())"
        case "jpy":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.jpy.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.jpy.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.jpy.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.jpy.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.jpy.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.jpy.toString())"
        case "twd":
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.twd.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.twd.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.twd.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.twd.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.twd.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.twd.toString())"
        default:
            marketCapLabel.text = "Market Cap: \(coinInfo.market_data.market_cap.usd.toString())"
            currentPrice.text = "Current Price: \(coinInfo.market_data.current_price.usd.toString())"
            high24Price.text = "Max price 24 Hours \n\(coinInfo.market_data.high_24h.usd.toString())"
            low24Price.text = "Min price 24 Hours \n\(coinInfo.market_data.low_24h.usd.toString())"
            highAllTimePrice.text = "Max all-time price \n\(coinInfo.market_data.ath.usd.toString())"
            lowAllTimePrice.text = "Min all-time price \n\(coinInfo.market_data.atl.usd.toString())"
        }
    }
    
    func setupGraph() {
        chartView.backgroundColor = .darkGray
        chartView.xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = UIFont(name: "Nasalization", size: 10)!
        yAxis.labelTextColor = .systemYellow
        yAxis.axisLineColor = .systemYellow
        yAxis.axisLineWidth = 2
        
        chartView.xAxis.labelFont = UIFont(name: "Nasalization", size: 7)!
        chartView.xAxis.labelTextColor = .systemYellow
        chartView.xAxis.axisLineColor = .systemYellow
        chartView.xAxis.axisLineWidth = 2
        
        chartView.animate(xAxisDuration: 1.2)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 220),
            chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        
        let yValues: [ChartDataEntry] = [
            ChartDataEntry(x: 0.0, y: DataManager.sharedInstance.historicalRates![0][1]),
            ChartDataEntry(x: 1.0, y: DataManager.sharedInstance.historicalRates![1][1]),
            ChartDataEntry(x: 2.0, y: DataManager.sharedInstance.historicalRates![2][1]),
            ChartDataEntry(x: 3.0, y: DataManager.sharedInstance.historicalRates![3][1]),
            ChartDataEntry(x: 4.0, y: DataManager.sharedInstance.historicalRates![4][1]),
            ChartDataEntry(x: 5.0, y: DataManager.sharedInstance.historicalRates![5][1]),
            ChartDataEntry(x: 6.0, y: DataManager.sharedInstance.historicalRates![6][1]),
            ChartDataEntry(x: 7.0, y: DataManager.sharedInstance.historicalRates![7][1])
        ]
        
        guard let previousRates = DataManager.sharedInstance.historicalRates else {
            return
        }
        
        let dateValue = [unixTimeConverter(unix: previousRates[0][0]),
                         unixTimeConverter(unix: previousRates[1][0]),
                         unixTimeConverter(unix: previousRates[2][0]),
                         unixTimeConverter(unix: previousRates[3][0]),
                         unixTimeConverter(unix: previousRates[4][0]),
                         unixTimeConverter(unix: previousRates[5][0]),
                         unixTimeConverter(unix: previousRates[6][0]),
                         unixTimeConverter(unix: previousRates[7][0])
        ]
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateValue)
        let set = LineChartDataSet(entries: yValues, label: "Price")
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.lineWidth = 2
        set.setColor(.systemYellow)
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        chartView.data = data
    }
    
    func setupCoinImage() {
        guard let coinImage = DataManager.sharedInstance.coinDetail?.image.small else {
            return
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 50, width: 16, height: 16))
        Nuke.loadImage(with: URL(string: coinImage)!, into: imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -725),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 180),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -180),
        ])
    }
    
    func unixTimeConverter(unix: Double) -> String {
        let formatTime = unix/1000
        let date = NSDate(timeIntervalSince1970: formatTime)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = .current
        dayTimePeriodFormatter.dateFormat = "dd/MM"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    
}
