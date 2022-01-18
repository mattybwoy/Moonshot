//
//  ViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 08/11/2021.
//

import UIKit
import DropDown

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
        "SGD",
        "TWD",
        "VND"
        ]
        currencyMenu.backgroundColor = .darkGray
        currencyMenu.textColor = .systemYellow
        return currencyMenu
    }()
    
    let currencySelector = UIButton(frame: CGRect(x: 0, y: 50, width: 100, height: 30))
    
    private var tableView: UITableView = UITableView()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Market"
        setupTableView()
        addTitle()
        currencyButton()
        addMarketTotal()
        view.backgroundColor = .darkGray
        DataManager.sharedInstance.loadMarketData {
        }
        DataManager.sharedInstance.loadCoins {
            self.tableView.reloadData()
        }
    }
    
    func addTitle() {
        let label = UILabel(frame: CGRect(x: 0, y: 70, width: 300, height: 30))
        label.center = CGPoint(x: 210, y: 80)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 30)
        label.textColor = .systemYellow
        label.text = "Moonshot"
        self.view.addSubview(label)
    }
    
    func addMarketTotal() {
        let marketTotal = UILabel(frame: CGRect(x: 0, y: 70, width: 250, height: 10))
        marketTotal.center = CGPoint(x: 250, y: 115)
        marketTotal.textAlignment = .center
        marketTotal.font = UIFont(name: "Astrolab", size: 10)
        marketTotal.textColor = .systemYellow
        marketTotal.text = "Total Market Cap"
        self.view.addSubview(marketTotal)
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
        currencySelector.center = CGPoint(x: 65, y: 125)
        currencySelector.setTitle("USD", for: .normal)
        currencySelector.titleLabel?.font = UIFont(name: "Astrolab", size: 10)!
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
            DataManager.sharedInstance.loadCoins(currency: newCurrency, completed: {
                self.tableView.reloadData()
            })
        }
    }
    
    func sendAlert() {
        let alert = UIAlertController(title: "Alert", message: "Coin already in Watchlist", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


extension MarketViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            if (velocity.y < -0.2)
            {
                DataManager.sharedInstance.reloadCoins {
                    self.tableView.reloadData()
                }
                    self.refreshControl.endRefreshing()
            }
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            self.tableView.tableFooterView = createSpinnerFooter()
            DataManager.sharedInstance.scrollCoin(pagination: true, completed: {
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
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let coinCount = DataManager.sharedInstance.coins?.count else { return 0 }
        return coinCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.reuseIdentifier, for: indexPath) as! CoinCell
        guard let loadedCoins = DataManager.sharedInstance.coins else {
            return cell
        }
        cell.textLabel?.text = "\(loadedCoins[indexPath.row].name)     \(loadedCoins[indexPath.row].current_price)"
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .systemYellow
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
            if DataManager.sharedInstance.favoriteCoins.contains(loadedCoins[indexPath.row].name) {
                self?.sendAlert()
            } else {
                DataManager.sharedInstance.favoriteCoins.append((loadedCoins[indexPath.row].name))
            }
            print(DataManager.sharedInstance.favoriteCoins)
            completionHandler(true)
        }
        favouriteAction.backgroundColor = .systemYellow
        let swipeActions = UISwipeActionsConfiguration(actions: [favouriteAction])
        return swipeActions
    }
    
    
}


class CoinCell: UITableViewCell {
    static let reuseIdentifier = "coincell"
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
    
}
