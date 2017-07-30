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
    
    var drawerMenuItems = ["Home", "Libretto", "Rubrica", "Appelli", "Orario", "News", "Pagamenti", "Suggerimenti", "#MyUnimol su Facebook", "Il mio Portale", "Logout", "v1.2 \"Vittorio\""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "", color: Utils.myUnimolBlue, style: UIBarStyle.black)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let studentInfo = Student.sharedInstance
        
        self.studentName.text = (studentInfo.studentInfo?.name)! + " " + (studentInfo.studentInfo?.surname)!
        self.studentID.text = studentInfo.studentInfo?.studentId
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell", for: indexPath) as! DrawerCell
        cell.menuItemLabel.text = drawerMenuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        var mainWindowController: UIViewController
        
        switch(indexPath.row) {
            
        case 0:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 1:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "RecordBookController") as! RecordBookController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 2:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 3:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "ExamsTabBarController") as! UITabBarController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
        case 4:
            mainWindowController =
                self.storyboard?.instantiateViewController(withIdentifier: "DayTimesTabController") as!
            UITabBarController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
        case 5:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "UITabBarController") as! UITabBarController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 6:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "TaxesViewController") as! TaxesViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 7:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "TipsViewController") as! TipsViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 8:
            shareAppOnFacebook()
            break;
            
        case 9:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            break;
            
        case 10:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            // remove credentials and refresh cache
            CacheManager.sharedInstance.resetCredentials()
            CacheManager.sharedInstance.refreshCache()
            break;
        case 11:
            mainWindowController =
            self.storyboard?.instantiateViewController(withIdentifier: "HelpUsViewController") as!
            HelpUsViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
        default:
            mainWindowController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let centerNavigation = UINavigationController(rootViewController: mainWindowController)
            appDelegate.centerContainer!.centerViewController = centerNavigation
            print("I am in the default section")
            break;
        }
        
        
        if (indexPath.row != 9) {
            appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
        } else {
            appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode()
        }
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
        
    }
    
    func shareAppOnFacebook() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.add(URL(string: "https://myunimol.it/"))
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Facebook", message: "Connetti un account Facebook per condividere", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
