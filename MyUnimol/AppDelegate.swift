//
//  AppDelegate.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var centerContainer: MMDrawerController?
    let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var avoidLogin: Bool = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //self.avoidLogin = CacheManager.sharedInstance.areCredentialsStored()
        
        let firstViewController = configureCenterViewController()
        let leftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideViewController") as! LeftSideViewController
        
        let leftSideNav = UINavigationController(rootViewController: leftViewController)
        leftSideNav.navigationBar.hidden = true

        let centerNav = UINavigationController(rootViewController: firstViewController)
        centerNav.navigationBar.hidden = true
        
        centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav)
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
        
        window!.rootViewController = centerContainer
        window!.makeKeyAndVisible()
        return true
    }
    
    
    func configureCenterViewController() -> UIViewController {
        let centerViewController: UIViewController
        if (avoidLogin) {
            centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("FirstPageController") as! FirstPageController
        } else {
            centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        }
        return centerViewController
    }
        
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

