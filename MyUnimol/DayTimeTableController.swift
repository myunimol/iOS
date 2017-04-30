//
//  DayTimeTableController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 30.04.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import Foundation

class DayTimeTableController: UIViewController, UITabBarControllerDelegate {
    
    // tab bar index; is 0 (monday) by default
    var tabBarIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Orario", color: Utils.myUnimolBlue, style: UIBarStyle.black)
        self.tabBarController?.delegate = self
    }
    
    // Detect the click on the tab element
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tabBarIndex = tabBarController.selectedIndex
        
        var day = "Lunedì"
        switch tabBarIndex {
        case 0:
            day = "Lunedì"
        case 1:
            day = "Martedì"
        case 2:
            day = "Mercoledì"
        case 3:
            day = "Giovedì"
        case 4:
            day = "Venerdì"
        default:
            day = "Lunedì"
        }
        
        self.tabBarController?.navigationItem.title = day
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.navigationItem.title = "Lunedi"
        self.navigationController?.navigationBar.barTintColor = Utils.myUnimolBlueUIColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = Utils.myUnimolBlueUIColor
        self.tabBarController?.tabBar.isTranslucent = false
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                         style: UIBarButtonItemStyle.plain ,
                                         target: self, action: #selector(UIViewController.menuClicked(_:)))
        
        menuButton.tintColor = UIColor.white
        
        let addButton = UIBarButtonItem(image: UIImage(named: "plus"),
                                        style: UIBarButtonItemStyle.plain ,
                                        target: self, action: #selector(UIViewController.addTime(_:)))
        
        addButton.tintColor = UIColor.white
        
        self.tabBarController?.navigationItem.leftBarButtonItem = menuButton
        self.tabBarController?.navigationItem.rightBarButtonItem = addButton
    }
}
