//
//  RootViewController.swift
//  ViaBrowser
//
//  Created by yangjian on 2022/12/27.
//

import UIKit

class RootViewController: UITabBarController {
    
    lazy var launch: LaunchViewController = {
        LaunchViewController()
    }()
    
    lazy var home: UINavigationController = {
      UINavigationController(rootViewController: HomeViewController())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        viewControllers = [launch, home]
        
        
        AnalyticsHelper.log(property: .local)
        AnalyticsHelper.log(event: .open)
        AnalyticsHelper.log(event: .openCold)
    }
    
    
    func launching() {
        selectedIndex = 0
        launch.launching()
    }
    
    func launched() {
        selectedIndex = 1
    }

}
