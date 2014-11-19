//
//  HoopNavigationViewController.swift
//  Hoops
//
//  Created by Joe on 08.09.14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarHidden(false, animated: false)
        navigationBar.tintColor     = UIColor.whiteColor()
        navigationBar.barTintColor  = UIColor(red: 4.0/255.0, green: 165.0/255.0, blue: 182.0/255.0, alpha: 1.0)
        navigationBar.translucent   = true
              
        // change navigationbar font color to grey
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
}