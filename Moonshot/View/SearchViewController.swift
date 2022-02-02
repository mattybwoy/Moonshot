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
        addSearchBar()
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
    
    func addSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 150, width: 350, height: 40))
        searchBar.center = CGPoint(x: 210, y: 170)
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .darkGray
        searchBar.searchTextField.font = UIFont(name: "Astrolab", size: 12)
        searchBar.layer.borderWidth = 2
        searchBar.barTintColor = .darkGray
        searchBar.layer.borderColor = UIColor.systemYellow.cgColor
        searchBar.searchTextField.textColor = .systemYellow
        searchBar.delegate = self
        self.view.addSubview(searchBar)
    }
    

}
