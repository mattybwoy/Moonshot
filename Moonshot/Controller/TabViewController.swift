//
//  TabViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 08/11/2021.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var dataManager: DataManager? = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = .gray
        tabBar.backgroundColor = .darkGray
        tabBar.tintColor = .systemYellow
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Astrolab", size: 10)!], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           // Create Tab one
           let tabOne = MarketViewController()
           let tabOneBarItem = UITabBarItem(title: "Market", image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet"))
           tabOne.tabBarItem = tabOneBarItem
        
           // Create Tab two
           let tabTwo = WatchListViewController()
           let tabTwoBarItem2 = UITabBarItem(title: "Watchlist", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star"))
           
           tabTwo.tabBarItem = tabTwoBarItem2
           
           self.viewControllers = [tabOne, tabTwo]
       }
       
       // UITabBarControllerDelegate method
       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
           print("Selected \(viewController.title!)")
       }
}
