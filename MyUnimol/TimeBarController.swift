//
//  TimeBarController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 20.05.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import Foundation

class TimeBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        let mondayController = self.storyboard?.instantiateViewController(withIdentifier: "DayTimesTabController") as! DayTimeTableController
        mondayController.tabBarIndex = UITabBarItem(title: "Lunedì", image: UIImage("l-letter"), selectedImage: UIImage("l-letter"))

        let tuesdayController = self.storyboard?.instantiateViewController(withIdentifier: "DayTimesTabController") as! DayTimeTableController
        tuesdayController.tabBarIndex = UITabBarItem(title: "Martedì", image: UIImage("m-letter"), selectedImage: UIImage("m-letter"))
        
        let wednesdayController = self.storyboard?.instantiateViewController(withIdentifier: "DayTimesTabController") as! DayTimeTableController
        wednesdayController.tabBarIndex = UITabBarItem(title: "Mercoledì", image: UIImage("m-letter"), selectedImage: UIImage("m-letter"))
        
        let thursayController = self.storyboard?.instantiateViewController(withIdentifier: "DayTimesTabController") as! DayTimeTableController
        thursayController.tabBarIndex = UITabBarItem(title: "Giovedi", image: UIImage("g-letter"), selectedImage: UIImage("g-letter"))
        
        let fridayController = self.storyboard?.instantiateViewController(withIdentifier: "DayTimesTabController") as! DayTimeTableController
        fridayController.tabBarIndex = UITabBarItem(title: "Venerdì", image: UIImage("v-letter"), selectedImage: UIImage("v-letter"))
        
        self.tabBarController?.setViewControllers([mondayController, tuesdayController, wednesdayController, thursayController, fridayController], animated: True)
        
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    // do something when a tab is pressed
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //
    }
}
