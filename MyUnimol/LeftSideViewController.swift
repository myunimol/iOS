//
//  LeftSideViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 19/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Social

class LeftSideViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentID: UILabel!
    
    var drawerMenuItems = ["Home", "Libretto", "Rubrica", "Appelli", "News", "Pagamenti", "Suggerimenti", "#MyUnimol su Facebook", "Il mio Portale", "Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "", color: Utils.myUnimolBlue, style: UIBarStyle.Black)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        let studentInfo = Student.sharedInstance
        
        self.studentName.text = (studentInfo.studentInfo?.name)! + " " + (studentInfo.studentInfo?.surname)!
        self.studentID.text = studentInfo.studentInfo?.studentId
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerMenuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DrawerCell", forIndexPath: indexPath) as! DrawerCell
        cell.menuItemLabel.text = drawerMenuItems[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var mainWindowController: UIViewController
        
        switch(indexPath.row) {
            
        case 0:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 1:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("RecordBookController") as! RecordBookController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 2:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("ContactViewController") as! ContactViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 3:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("ExamsTabBarController") as! UITabBarController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 4:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("UITabBarController") as! UITabBarController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 5:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("TaxesViewController") as! TaxesViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 6:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("TipsViewController") as! TipsViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 7:
            shareAppOnFacebook()
            break;
            
        case 8:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 9:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            // remove credentials and refresh cache
            CacheManager.sharedInstance.resetCredentials()
            CacheManager.sharedInstance.refreshCache()
            break;
            
        default:
            mainWindowController = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            print("I am in the default section")
            break;
        }
        
        
        if (indexPath.row != 8) {
            appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        } else {
            appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.None
        }
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        
    }
    
    func shareAppOnFacebook() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.addURL(NSURL(string: "https://myunimol.it/"))
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Facebook", message: "Connetti un account Facebook per condividere", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
}
