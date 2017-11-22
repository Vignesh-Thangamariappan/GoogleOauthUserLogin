//
//  MainTabBarController.swift
//  UserLogin
//
//  Created by user on 11/20/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let vc = viewControllers?[0] {
            selectedViewController = vc
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
