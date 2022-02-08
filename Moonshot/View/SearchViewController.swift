//
//  SearchViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 27/01/2022.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    private var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        addTitle()
        searchBar.delegate = self
        view.addSubview(searchBar)
        setupSearchButton()
        setupTable()
        view.backgroundColor = .darkGray
    }
    
    func addTitle() {
        let label = UILabel(frame: CGRect(x: 0, y: 80, width: 300, height: 30))
        label.center = CGPoint(x: 210, y: 100)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 30)
        label.textColor = .systemYellow
        label.text = "Search"
        self.view.addSubview(label)
    }
    
    let searchBar: UISearchBar = {
        var bar = UISearchBar(frame: CGRect(x: 0, y: 150, width: 350, height: 40))
        bar.center = CGPoint(x: 210, y: 170)
        bar.placeholder = "Search"
        bar.backgroundColor = .darkGray
        bar.searchTextField.font = UIFont(name: "Astrolab", size: 12)
        bar.layer.borderWidth = 2
        bar.barTintColor = .darkGray
        bar.layer.borderColor = UIColor.systemYellow.cgColor
        bar.searchTextField.textColor = .systemYellow
        return bar
    }()
    
    func setupSearchButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 50, width: 100, height: 30))
        button.setTitle("Search", for: .normal)
        button.center = CGPoint(x: 210, y: 230)
        button.titleLabel!.font = UIFont(name: "Nasalization", size: 12)
        button.titleLabel?.textColor = .systemYellow
        button.setTitleColor(.systemYellow, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemYellow.cgColor
        let gesture = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        button.addGestureRecognizer(gesture)
        self.view.addSubview(button)
    }
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .darkGray
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 270),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -85),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(SearchCoinCell.self, forCellReuseIdentifier: SearchCoinCell.reuseIdentifier)
    }
    
    @objc func searchTapped() {
        guard let text = searchBar.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Alert", message: "Invalid search term, please try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let searchString = text.replacingOccurrences(of: " ", with: "%20")
        DataManager.sharedInstance.searchCoin(userSearch: searchString) {_,_  in
            self.tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func sendAlert() {
        let alert = UIAlertController(title: "Alert", message: "Coin already in Watchlist", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchResultTotal = DataManager.sharedInstance.searchResults?.count else {
            return 0
        }
        return searchResultTotal
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCoinCell.reuseIdentifier, for: indexPath) as! SearchCoinCell
        guard let searchedCoins = DataManager.sharedInstance.searchResults else {
            return cell
        }
        cell.textLabel?.text = "\(searchedCoins[indexPath.row].name)"
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
        let favouriteAction = UIContextualAction(style: .normal, title: "Favourite") { [weak self] (action, view, completionHandler) in
            
            guard let searchedCoins = DataManager.sharedInstance.searchResults else {
                return
            }
            if DataManager.sharedInstance.favoriteCoins.contains(searchedCoins[indexPath.row].name) {
                self?.sendAlert()
            } else {
                DataManager.sharedInstance.favoriteCoins.append((searchedCoins[indexPath.row].name))
            }
            print(DataManager.sharedInstance.favoriteCoins)
            completionHandler(true)
        }
        favouriteAction.backgroundColor = .systemYellow
        let swipeActions = UISwipeActionsConfiguration(actions: [favouriteAction])
        return swipeActions
    }

    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.tableView.setSwipeActionFont(UIFont(name: "Nasalization", size: 15)!)
    }
    
    
}



class SearchCoinCell: UITableViewCell {
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
