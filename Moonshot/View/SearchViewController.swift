//
//  SearchViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 27/01/2022.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        addTitle()
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

}
