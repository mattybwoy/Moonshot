//
//  ViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 08/11/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataManager = DataManager()
    private var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Market"
        setupTableView()
        addTitle()
        dataManager.loadCoins {
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(CoinCell.self, forCellReuseIdentifier: CoinCell.reuseIdentifier)
    }
    
    func addTitle() {
        let label = UILabel(frame: CGRect(x: 0, y: 80, width: 300, height: 30))
        label.center = CGPoint(x: 210, y: 100)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 30)
        label.textColor = .systemYellow
        label.text = "Moonshot"
        self.view.addSubview(label)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.reuseIdentifier, for: indexPath) as! CoinCell
        cell.textLabel?.text = "\(dataManager.coins[indexPath.row].name)"
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favoriteAction = UITableViewRowAction(style: .normal, title: "Favourite") { _, indexPath in
            self.dataManager.favoriteCoins.append(self.dataManager.coins[indexPath.row])
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

//extension ViewController: CoinManagerDelegate {
//    func didUpdateCoin(coins: [Coins]) {
//        DispatchQueue.main.async {
//            coins.forEach { coin in
//                self.title = coin.id
//            }
//
//        }
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//
//
//}
