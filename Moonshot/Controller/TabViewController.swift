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
        view.backgroundColor = .gray
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           // Create Tab one
           let tabOne = ViewController()
           let tabOneBarItem = UITabBarItem(title: "Market", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(systemName: "line.dash"))
           tabOne.tabBarItem = tabOneBarItem
           
           // Create Tab two
           let tabTwo = WatchListViewController()
           let tabTwoBarItem2 = UITabBarItem(title: "Watchlist", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(systemName: "star"))
           
           tabTwo.tabBarItem = tabTwoBarItem2
           
           
           self.viewControllers = [tabOne, tabTwo]
       }
       
       // UITabBarControllerDelegate method
       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
           print("Selected \(viewController.title!)")
       }
}
