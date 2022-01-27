//
//  TabViewController.swift
//  Moonshot
//
//  Created by Matthew Lock on 08/11/2021.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = .darkGray
        tabBar.tintColor = .systemYellow
        tabBar.barTintColor = .darkGray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Astrolab", size: 10)!], for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabOne = MarketViewController()
        let tabOneBarItem = UITabBarItem(title: "Market", image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet"))
        tabOne.tabBarItem = tabOneBarItem
        
        let tabTwo = TrendingViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Trending", image: UIImage(systemName: "chart.line.uptrend.xyaxis"), selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis"))
        tabTwo.tabBarItem = tabTwoBarItem2
        
        let tabThree = SearchViewController()
        let tabThreeBarItem3 = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        tabThree.tabBarItem = tabThreeBarItem3
        
        let tabFour = WatchListViewController()
        let tabFourBarItem4 = UITabBarItem(title: "Watchlist", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star"))
        tabFour.tabBarItem = tabFourBarItem4
        
        self.viewControllers = [tabOne, tabTwo, tabThree, tabFour]
    }
       
       // UITabBarControllerDelegate method
       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
           print("Selected \(viewController.title!)")
       }
}
