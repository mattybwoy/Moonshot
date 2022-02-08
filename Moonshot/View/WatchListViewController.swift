//
//  ViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 08/11/2021.
//

import UIKit

class WatchListViewController: UIViewController {

    var myCoins: [String]? = [String]()
    
    private var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        title = "Watchlist"
        addTitle()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
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
    
    
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .darkGray
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(FavouriteCoinCell.self, forCellReuseIdentifier: FavouriteCoinCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.sharedInstance.favoriteCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCoinCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(DataManager.sharedInstance.favoriteCoins[indexPath.row])"
        cell.textLabel?.font = UIFont(name: "Nasalization", size: 15)
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
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            DataManager.sharedInstance.favoriteCoins.remove(at: indexPath.row)
            self?.tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.tableView.setSwipeActionFont(UIFont(name: "Nasalization", size: 15)!)
    }
    
    
}

class FavouriteCoinCell: UITableViewCell {
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
