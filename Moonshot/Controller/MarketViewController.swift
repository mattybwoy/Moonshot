//
//  ViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 08/11/2021.
//

import UIKit

protocol CoinManagerDelegate {
    func didFailWithError(error: Error)
    func coinUpdate(favourite: [Coins])
}

class MarketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CoinAccount {
    var dataManager: DataManager? = DataManager()
    
    var delegate: CoinManagerDelegate?
    var favoriteCoins = [Coins]()
    
    private var tableView: UITableView = UITableView()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Market"
        setupTableView()
        addTitle()
        view.backgroundColor = .darkGray
        dataManager?.loadCoins {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print(dataManager?.favoriteCoins.count)
    }
    
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            if(velocity.y < -0.2)
            {
                dataManager?.loadCoins {
                self.tableView.reloadData()
                }
                self.refreshControl.endRefreshing()
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let coinCount = dataManager?.coins.count else { return 0 }
        return coinCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.reuseIdentifier, for: indexPath) as! CoinCell
        cell.textLabel?.text = "\(dataManager!.coins[indexPath.row].name)     \(dataManager!.coins[indexPath.row].current_price)"
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .systemYellow
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favoriteAction = UITableViewRowAction(style: .normal, title: "Favourite") { _, indexPath in
            //self.dataManager?.favoriteCoins.append((self.dataManager!.coins[indexPath.row]))
            self.favoriteCoins.append(self.dataManager!.coins[indexPath.row])
            self.delegate?.coinUpdate(favourite: self.favoriteCoins)
            //print(self.dataManager?.favoriteCoins)
        }
        favoriteAction.backgroundColor = .systemYellow
        return [favoriteAction]
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
