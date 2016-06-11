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
        
        let (username, password) = CacheManager.sharedInstance.getUserCredential()
    
        if !Reachability.isConnectedToNetwork() {
            // no connection available
            CacheManager.sharedInstance.getJsonByString(CacheManager.STUDENT_INFO) { json in
                Student.sharedInstance.studentInfo = StudentInfo(json: json)
                CacheManager.sharedInstance.getJsonByString(CacheManager.RECORD_BOOK) { json in
                    RecordBookClass.sharedInstance.recordBook = RecordBook(json: json)
                    self.performSegueWithIdentifier("ViewController", sender: self)
                }
            }
        } else {
            self.loginAndGetStudentInfo(username!, password: password!)
        }
    }
    
    func loginAndGetStudentInfo(username: String, password: String) {
        StudentInfo.getCredentials(username, password: password) { studentInfo, error in
            guard error == nil else {
                Utils.displayAlert(self, title: "Questo non era previsto!", message: "Riapri MyUnimol")
                CacheManager.sharedInstance.resetCredentials()
                CacheManager.sharedInstance.refreshCache()
                exit(0)
            }
            if studentInfo!.areCredentialsValid {
                self.getRecordBook()
            } else {
                // login not valid
                Utils.displayAlert(self, title: "Questo non era previsto!", message: "Riapri MyUnimol")
                CacheManager.sharedInstance.resetCredentials()
                CacheManager.sharedInstance.refreshCache()
                exit(0)
            }
        }
    }
    
    func getRecordBook() {
        RecordBook.getRecordBook { recordBook, error in
            guard error == nil else {
                Utils.displayAlert(self, title: "Questo non era previsto!", message: "Riapri MyUnimol")
                CacheManager.sharedInstance.resetCredentials()
                CacheManager.sharedInstance.refreshCache()
                exit(0)
            }
            self.performSegueWithIdentifier("ViewController", sender: self)
        }
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
