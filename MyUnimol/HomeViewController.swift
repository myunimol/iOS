//
//  HomeViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 17/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import KYDrawerController

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        title = "MainViewController"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "didTapOpenButton:"
        )
    }
    
    func didTapOpenButton(sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parentViewController as? KYDrawerController {
            drawerController.setDrawerState(.Opened, animated: true)
        }
    }
}

