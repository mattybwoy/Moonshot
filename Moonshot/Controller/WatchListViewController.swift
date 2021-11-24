//
//  ViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 08/11/2021.
//

import UIKit

class WatchListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CoinAccount {
    
    var dataManager: DataManager?

    private var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        title = "Watchlist"
        addTitle()
        createTableView()
        //print(dataManager?.favoriteCoins.count)
    }

    func addTitle() {
        let label = UILabel(frame: CGRect(x: 0, y: 80, width: 300, height: 30))
        label.center = CGPoint(x: 210, y: 100)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 30)
        label.textColor = .systemYellow
        label.text = "Watchlist"
        self.view.addSubview(label)
    }
    
    func createTableView() {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let favouriteCoinCount = dataManager?.favoriteCoins.count else { return 0 }
        //print(favouriteCoinCount)
        //return favouriteCoinCount
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = "\(dataManager?.favoriteCoins[indexPath.row].name)"
        return cell
    }
    
}

extension WatchListViewController: CoinManagerDelegate {
    func coinUpdate(controller: MarketViewController, favourite: [Coins]) {
        print(favourite.count)
        tableView.reloadData()
    }

}
