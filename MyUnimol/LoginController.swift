//
//  LoginController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class LoginController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var isLogged: Bool?
    
    var username: String = ""
    var password: String = ""
    
    @IBAction func login(sender: AnyObject) {
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
        self.username = self.usernameField.text!
        self.password = self.passwordField.text!
        
        if username == "" || password == "" {
            Utils.displayAlert(self, title: "Oops!", message: "Username e/o password mancanti")
        } else {
            self.loginAndGetStudentInfo(username, password: password)
        }
    }
    
    func loginAndGetStudentInfo(username: String, password: String) {
        Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
            StudentInfo.getCredentials(username, password: password) { studentInfo, error in
            guard error == nil else {
                //TODO: error implementation
                return
            }
            Utils.removeProgressBar(self)
            self.getRecordBook()
        }
    }
    
    func getRecordBook() {
        RecordBook.getRecordBook { recordBook, error in
            guard error == nil else {
                //TODO: error implementation
                return
            }
            self.performSegueWithIdentifier("ViewController", sender: self)
            Utils.removeProgressBar(self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let centerViewContainer = appDelegate.mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: centerViewContainer)
        
        appDelegate.centerContainer!.centerViewController = centerNav
        appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
    }
    
    override func viewDidLoad() { super.viewDidLoad() }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func didReceiveMemoryWarning() {}
    
    ///Remove the focus from a texfield
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}