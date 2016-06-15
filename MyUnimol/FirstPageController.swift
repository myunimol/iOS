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
            CacheManager.sharedInstance.getJsonByString(CacheManager.STUDENT_INFO) { json, error in
                if (json != nil) {
                    Student.sharedInstance.studentInfo = StudentInfo(json: json!)
                } else {
                    self.showErrorAndGoToLogin()
                }
                CacheManager.sharedInstance.getJsonByString(CacheManager.RECORD_BOOK) { json, error in
                    if (json != nil) {
                        RecordBookClass.sharedInstance.recordBook = RecordBook(json: json!)
                        self.performSegueWithIdentifier("ViewController", sender: self)
                    } else {
                        self.showErrorAndGoToLogin()
                    }
                }
            }
        } else {
            self.loginAndGetStudentInfo(username!, password: password!)
        }
    }
    
    func loginAndGetStudentInfo(username: String, password: String) {
        StudentInfo.getCredentials(username, password: password) { studentInfo, error in
            guard error == nil else {
                self.showErrorAndGoToLogin()
                return
            }
            if studentInfo!.areCredentialsValid {
                self.getRecordBook()
            } else {
                // login not valid
                Utils.displayAlert(self, title: "Ops 😨", message: "Credenziali non valide!")
                CacheManager.sharedInstance.resetCredentials()
                CacheManager.sharedInstance.refreshCache()
                Utils.goToLogin()
                return
            }
        }
    }
    
    func getRecordBook() {
        RecordBook.getRecordBook { recordBook, error in
            guard error == nil else {
                self.showErrorAndGoToLogin()
                return
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
    
    /// Showed when an API strange error occurs; shows an alert dialog and returns to login page
    private func showErrorAndGoToLogin() {
        Utils.displayAlert(self, title: "😨 Ooopss...", message: "Qualcosa è andato 👎 ma non saprei proprio cosa ☹️! Ritenta tra poco 💪")
        CacheManager.sharedInstance.resetCredentials()
        CacheManager.sharedInstance.refreshCache()
        Utils.goToLogin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
