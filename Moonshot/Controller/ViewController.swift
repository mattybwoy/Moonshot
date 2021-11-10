//
//  ViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 08/11/2021.
//

import UIKit

class ViewController: UIViewController {

    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Market"
        addTitle()
        dataManager.loadCoins()    }
    
    func addTitle() {
        let label = UILabel(frame: CGRect(x: 0, y: 80, width: 300, height: 30))
        label.center = CGPoint(x: 210, y: 100)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 30)
        label.textColor = .systemYellow
        label.text = "Moonshot"
        self.view.addSubview(label)
    }

    
}
