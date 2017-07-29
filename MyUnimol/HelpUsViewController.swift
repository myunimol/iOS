//
//  HelpUsViewController.swift
//  MyUnimol
//
//  Created by Matteo Merola on 6/26/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation

class HelpUsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.setNavigationControllerStatusBar(self, title: "MyUnimol", color: Utils.myUnimolBlue, style: UIBarStyle.black)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
