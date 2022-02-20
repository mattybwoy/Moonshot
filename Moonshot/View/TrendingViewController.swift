//
//  TrendingViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 24/12/2021.
//

import UIKit

class TrendingViewController: UIViewController {
    
    private var tableView: UITableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        title = "Trending"
        view.addSubview(header)
        view.addSubview(btcLabel)
        view.addSubview(usdPrice)
        view.addSubview(gbpPrice)
        view.addSubview(eurPrice)
        view.addSubview(cadPrice)
        view.addSubview(audPrice)
        view.addSubview(hkdPrice)
        view.addSubview(cnyPrice)
        view.addSubview(twdPrice)
        view.addSubview(jpyPrice)
        view.addSubview(inrPrice)
        setupTableView()
        DataManager.sharedInstance.trendingCoins {_ in 
            self.tableView.reloadData()
        }
        DataManager.sharedInstance.btcComparision {
            self.loadCurrencies()
        }
        
    }
    
    let header: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 80, width: 300, height: 30))
        label.center = CGPoint(x: 210, y: 100)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 30)
        label.textColor = .systemYellow
        label.text = "Trending"
        return label
    }()
    
    let btcLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 40))
        label.center = CGPoint(x: 200, y: 520)
        label.textAlignment = .center
        label.font = UIFont(name: "Nasalization", size: 24)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        label.text = "1 BTC ="
        return label
    }()
    
    let usdPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 110, y: 560)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let gbpPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 110, y: 600)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let eurPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 110, y: 640)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let cadPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 110, y: 680)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let audPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 110, y: 720)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let hkdPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 310, y: 560)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let cnyPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 300, y: 600)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let twdPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 300, y: 640)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let jpyPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 300, y: 680)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let inrPrice: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        label.center = CGPoint(x: 300, y: 720)
        label.font = UIFont(name: "Nasalization", size: 16)
        label.textColor = .systemYellow
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    func sendAlert() {
        self.tableView.reloadData()
        let alert = UIAlertController(title: "Alert", message: "Coin already in Watchlist", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadCurrencies() {
        guard let fiatRates = DataManager.sharedInstance.btcRates else {
            return
        }
        usdPrice.text = "USD: \(fiatRates.usd.value)"
        gbpPrice.text = "GBP: \(fiatRates.gbp.value)"
        eurPrice.text = "EUR: \(fiatRates.eur.value)"
        cadPrice.text = "CAD: \(fiatRates.cad.value)"
        audPrice.text = "AUD: \(fiatRates.aud.value)"
        hkdPrice.text = "HKD: \(fiatRates.hkd.value)"
        cnyPrice.text = "CNY: \(fiatRates.cny.value)"
        twdPrice.text = "TWD: \(fiatRates.twd.value)"
        jpyPrice.text = "JPY: \(fiatRates.jpy.value)"
        inrPrice.text = "INR: \(fiatRates.inr.value)"
    }
    
    
}

extension TrendingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .darkGray
        tableView.refreshControl = refreshControl
        refreshControl.backgroundColor = .darkGray
        refreshControl.tintColor = .systemYellow
        let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: myAttribute)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -420),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let nib = UINib(nibName: "TrendingCellTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: TrendingCellTableViewCell.reuseidentifier)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trendCoinCount = DataManager.sharedInstance.trendCoins?.count else {
            return 0
        }
        return trendCoinCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendingCellTableViewCell.reuseidentifier, for: indexPath) as! TrendingCellTableViewCell
        guard let trendingCoins = DataManager.sharedInstance.trendCoins else {
            return cell
        }
        cell.coinTitle.text = "\(trendingCoins[indexPath.row].item.name)"
        cell.coinTitle.textColor = .systemYellow
        cell.coinTitle.font = UIFont(name: "Nasalization", size: 15)
        cell.coinTitle.adjustsFontSizeToFitWidth = true
        cell.layer.borderColor = UIColor.systemYellow.cgColor
        cell.layer.borderWidth = 1.0
        cell.backgroundColor = .darkGray
        cell.thumbNail.image = UIImage(data: try! Data(contentsOf: URL(string: trendingCoins[indexPath.row].item.thumb)!))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favouriteAction = UIContextualAction(style: .normal, title: "Favourite") { [weak self] (action, view, completionHandler) in
            
            guard let trendingCoins = DataManager.sharedInstance.trendCoins else {
                return
            }
            
            if DataManager.sharedInstance.favoriteCoins.isEmpty {
                DataManager.sharedInstance.favoriteCoins.append(WatchCoins(name: trendingCoins[indexPath.row].item.name, thumb: trendingCoins[indexPath.row].item.thumb))

                    print(DataManager.sharedInstance.favoriteCoins)
                    completionHandler(true)
            } else {
                for coin in DataManager.sharedInstance.favoriteCoins {
                    if coin.name == (trendingCoins[indexPath.row].item.name) {
                        self?.sendAlert()
                        return
                    }
                }
                DataManager.sharedInstance.favoriteCoins.append(WatchCoins(name: trendingCoins[indexPath.row].item.name, thumb: trendingCoins[indexPath.row].item.thumb))
                    print(DataManager.sharedInstance.favoriteCoins)
                    completionHandler(true)
            }
            
        }
        favouriteAction.backgroundColor = .systemYellow
        let swipeActions = UISwipeActionsConfiguration(actions: [favouriteAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.tableView.setSwipeActionFont(UIFont(name: "Nasalization", size: 15)!)
    }
    
}
