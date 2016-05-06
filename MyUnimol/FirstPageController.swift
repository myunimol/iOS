//
//  FirstPageController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 01/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class FirstPageController: UIViewController {

    var goToLoginPage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Utils.myUnimolBlueUIColor
        
        let (username, password) = CacheManager.getUserCredential()
            
        ApiCall.loginAndFetchDataForHome(username!, password: password!, caller: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let centerViewContainer = appDelegate.mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: centerViewContainer)
        
        appDelegate.centerContainer!.centerViewController = centerNav
        appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
