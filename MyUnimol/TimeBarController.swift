//
//  TimeBarController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 20.05.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import Foundation

class TimeBarController: UITabBarController {
    
    var tabBarIndex: Int = 0
    var currentDay: String = "monday"
    var day: String = "Lunedì"
    
    override func viewDidLoad() { self.view.backgroundColor = UIColor.white }
    
    override func didReceiveMemoryWarning() { }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    
        self.tabBarIndex = (self.tabBar.items?.index(of: item)) ?? 0
        
        switch self.tabBarIndex {
        case 0:
            self.day = "Lunedì"
            self.currentDay = "monday"
        case 1:
            self.day = "Martedì"
            self.currentDay = "tuesday"
        case 2:
            self.day = "Mercoledì"
            self.currentDay = "wednesday"
        case 3:
            self.day = "Giovedì"
            self.currentDay = "thursday"
        case 4:
            self.day = "Venerdì"
            self.currentDay = "friday"
        default:
            self.day = "Lunedì"
            self.currentDay = "monday"
        }
    }
}
