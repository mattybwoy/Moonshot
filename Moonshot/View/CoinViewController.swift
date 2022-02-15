//
//  CoinViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 15/02/2022.
//

import UIKit

class CoinViewController: UIViewController {
    
    let coinId: String

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        view.addSubview(coinHeader)
        setupLabels()
    }
    
    init(coinId: String) {
        self.coinId = coinId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let coinHeader: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 70, width: 200, height: 30))
        label.center = CGPoint(x: 210, y: 50)
        label.textAlignment = .center
        label.font = UIFont(name: "Astrolab", size: 22)
        label.textColor = .systemYellow
        return label
    }()
    
    func setupLabels() {
        coinHeader.text = "\(self.coinId)"
    }
    
    
}
