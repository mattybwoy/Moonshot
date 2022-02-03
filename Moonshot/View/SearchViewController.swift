//
//  SearchViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 27/01/2022.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        addTitle()
        searchBar.delegate = self
        view.addSubview(searchBar)
        setupSearchButton()
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
        button.titleLabel!.font = UIFont(name: "Astrolab", size: 12)
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
    
    @objc func searchTapped() {
        guard let text = searchBar.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Alert", message: "Invalid search term, please try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let searchString = text.replacingOccurrences(of: " ", with: "%20")
        DataManager.sharedInstance.searchCoin(userSearch: searchString) {
            print("Matrix reloaded")
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    
}
