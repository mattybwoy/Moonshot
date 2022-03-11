//
//  ViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 08/11/2021.
//

import UIKit
import DropDown
import Nuke

class MarketViewController: UIViewController {
    
    let currencyMenu: DropDown = {
        let currencyMenu = DropDown()
        currencyMenu.dataSource = [
        "USD",
        "GBP",
        "EUR",
        "AUD",
        "CAD",
        "CNY",
        "HKD",
        "INR",
        "JPY",
        "TWD"
        ]
        currencyMenu.backgroundColor = .darkGray
        currencyMenu.textColor = .systemYellow
        currencyMenu.textFont = UIFont(name: "Nasalization", size: 15)!
        currencyMenu.selectedTextColor = .systemYellow
        currencyMenu.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .center
        }
        return currencyMenu
    }()
    
    let currencySelector = UIButton(frame: CGRect(x: 0, y: 50, width: 100, height: 30))
    
    private var tableView: UITableView = UITableView()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Market"
        setupTableView()
        currencyButton()
        view.addSubview(header)
        view.addSubview(marketTotal)
        view.addSubview(coinLabel)
        view.addSubview(priceLabel)
        view.addSubview(trendLabel)
        view.addSubview(topLineView)
        view.addSubview(bottomLineView)
        view.backgroundColor = .darkGray
        DataManager.sharedInstance.loadMarketData {_,_  in
            self.addMarketTotal(total: DataManager.sharedInstance.totalMarketCap!)
        }
        DataManager.sharedInstance.loadCoins {_,_  in 
            self.tableView.reloadData()
        }
    }
    
    let header: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 300, height: 30))
        label.center = CGPoint(x: 210, y: 80)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 30)
        label.textColor = .systemYellow
        label.text = "Moonshot"
        return label
    }()
    
    let marketTotal: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 265, height: 40))
        label.center = CGPoint(x: 280, y: 130)
        label.textAlignment = .center
        label.font = UIFont(name: "Nasalization", size: 17)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemYellow
        label.numberOfLines = 0
        return label
    }()
    
    let coinLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 50, width: 80, height: 20))
        label.center = CGPoint(x: 80, y: 175)
        label.textAlignment = .center
        label.font = UIFont(name: "Nasalization", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemYellow
        label.text = "Coin"
        return label
    }()
    
    let priceLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 50, width: 80, height: 20))
        label.center = CGPoint(x: 280, y: 175)
        label.textAlignment = .center
        label.font = UIFont(name: "Nasalization", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemYellow
        label.text = "Price"
        
        return label
    }()
    
    let trendLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 50, width: 80, height: 20))
        label.center = CGPoint(x: 370, y: 175)
        label.textAlignment = .center
        label.font = UIFont(name: "Nasalization", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .systemYellow
        label.text = "Trend 24H"
        return label
    }()
    
    let topLineView: UIView = {
        var line = UIView(frame: CGRect(x: 0, y: 162, width: 420, height: 1))
        line.layer.borderWidth = 1.0
        line.layer.borderColor = UIColor.systemYellow.cgColor
        return line
    }()
    
    let bottomLineView: UIView = {
        var line = UIView(frame: CGRect(x: 0, y: 185, width: 420, height: 1))
        line.layer.borderWidth = 1.0
        line.layer.borderColor = UIColor.systemYellow.cgColor
        return line
    }()
    
    func addMarketTotal(total: Double) {
        marketTotal.text = "Total Market Cap \n\(total)"
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        footerView.backgroundColor = UIColor.darkGray
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = UIColor.systemYellow
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func currencyButton() {
        currencySelector.center = CGPoint(x: 85, y: 130)
        currencySelector.setTitle("USD", for: .normal)
        currencySelector.titleLabel?.font = UIFont(name: "Nasalization", size: 18)!
        currencySelector.titleLabel?.textColor = .systemYellow
        currencySelector.setTitleColor(.systemYellow, for: .normal)
        currencySelector.layer.borderWidth = 1
        currencySelector.layer.borderColor = UIColor.systemYellow.cgColor
        currencyMenu.anchorView = currencySelector
        currencyMenu.bottomOffset = CGPoint(x: 0, y: currencySelector.frame.size.height)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCurrencySelector))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        currencySelector.addGestureRecognizer(gesture)
        self.view.addSubview(currencySelector)
    }
    
    @objc func didTapCurrencySelector() {
        currencyMenu.show()
        currencyMenu.selectionAction = { index, title in
            print("index \(index) and \(title)")
            self.currencySelector.setTitle(title, for: .normal)
            let newCurrency = title.lowercased()
            DataManager.sharedInstance.loadCoins(currency: newCurrency, completed: {_,_  in 
                self.tableView.reloadData()
            })
            DataManager.sharedInstance.loadMarketData {_,_  in 
                self.addMarketTotal(total: DataManager.sharedInstance.totalMarketCap!)
            }
        }
    }
    
    func sendAlert() {
        let alert = UIAlertController(title: "Alert", message: "Coin already in Watchlist", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        alert.view.accessibilityIdentifier = "Coin already saved"
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


extension MarketViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            if (velocity.y < -0.2)
            {
                DataManager.sharedInstance.reloadCoins {_,_  in 
                    self.tableView.reloadData()
                }
                    self.refreshControl.endRefreshing()
            }
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            self.tableView.tableFooterView = createSpinnerFooter()
            DataManager.sharedInstance.scrollCoin(pagination: true, completed: {_ in 
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                    self.tableView.reloadData()
                }
                
            })
        }
    }
}

extension MarketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        refreshControl.backgroundColor = UIColor.darkGray
        refreshControl.tintColor = .systemYellow
        let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow]
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Market Data...", attributes: myAttribute)

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 192),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let nib = UINib(nibName: "MarketTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: MarketTableViewCell.reuseidentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let coinCount = DataManager.sharedInstance.coins?.count else { return 0 }
        return coinCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketTableViewCell.reuseidentifier, for: indexPath) as! MarketTableViewCell
        guard let loadedCoins = DataManager.sharedInstance.coins else {
            return cell
        }
        
        if loadedCoins[indexPath.row].price_change_24h > 0.005 {
            let imageIcon = UIImage(systemName: "arrow.up.right")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            cell.arrowIndicator.image = imageIcon
        } else if loadedCoins[indexPath.row].price_change_24h < -0.005 {
            let imageIcon = UIImage(systemName: "arrow.down.right")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            cell.arrowIndicator.image = imageIcon
        } else {
            let imageIcon = UIImage(systemName: "minus")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
            cell.arrowIndicator.image = imageIcon
        }
        cell.coinLabel.text = "\(loadedCoins[indexPath.row].name)"
        cell.coinLabel.textColor = .systemYellow
        cell.coinLabel.font = UIFont(name: "Nasalization", size: 15)
        cell.coinLabel.adjustsFontSizeToFitWidth = true
        cell.coinValue.text = "\(loadedCoins[indexPath.row].current_price.toString())"
        cell.coinValue.textColor = .systemYellow
        cell.coinValue.font = UIFont(name: "Nasalization", size: 15)
        Nuke.loadImage(with: URL(string: loadedCoins[indexPath.row].image)!, into: cell.thumbNail)
        cell.backgroundColor = .darkGray
        cell.layer.borderColor = UIColor.systemYellow.cgColor
        cell.layer.borderWidth = 1.0
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favouriteAction = UIContextualAction(style: .normal, title: "Favourite") { [weak self] (action, view, completionHandler) in
            
            guard let loadedCoins = DataManager.sharedInstance.coins else {
                return
            }
            
            if DataManager.sharedInstance.favoriteCoins.isEmpty {
                DataManager.sharedInstance.favoriteCoins.append(WatchCoins(id: loadedCoins[indexPath.row].id, name: loadedCoins[indexPath.row].name, thumb: loadedCoins[indexPath.row].image))

                    print(DataManager.sharedInstance.favoriteCoins)
                    completionHandler(true)
            } else {
                for coin in DataManager.sharedInstance.favoriteCoins {
                    if coin.name == (loadedCoins[indexPath.row].name) {
                        self?.sendAlert()
                        return
                    }
                }
                DataManager.sharedInstance.favoriteCoins.append(WatchCoins(id: loadedCoins[indexPath.row].id, name: loadedCoins[indexPath.row].name, thumb: loadedCoins[indexPath.row].image))
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let loadedCoins = DataManager.sharedInstance.coins else {
            return
        }
        let coinSelected = loadedCoins[indexPath.row]
        let coinController = CoinViewController(coin: coinSelected.id)
        show(coinController, sender: self)
    }
    
    
}


extension UITableView {
    public func setSwipeActionFont(_ font: UIFont, withTintColor tintColor: UIColor? = nil, andIgnoreFirst ignoreFirst: Bool = false) {
        for subview in self.subviews {
            guard NSStringFromClass(type(of: subview)) == "_UITableViewCellSwipeContainerView" else {
                continue
            }

            for swipeContainerSubview in subview.subviews {
                guard NSStringFromClass(type(of: swipeContainerSubview)) == "UISwipeActionPullView" else {
                    continue
                }

                for (index, view) in swipeContainerSubview.subviews.filter({ $0 is UIButton }).enumerated() {

                    guard let button = view as? UIButton else {
                        continue
                    }
                    button.titleLabel?.font = font
                    
                    guard index > 0 || !ignoreFirst else {
                        continue
                    }
                    button.setTitleColor(tintColor, for: .normal)
                    button.imageView?.tintColor = tintColor
                }
            }
        }
    }
}

//Convert scientific notation to Double
extension Double {

    func toString(decimal: Int = 9) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)

        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
}
