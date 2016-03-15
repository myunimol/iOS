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
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    var isLogged: Bool?
    
    var studentInfo: StudentInfo?
    
    var username: String = ""
    var password: String = ""
    
    @IBAction func login(sender: AnyObject) {
        
        self.username = self.usernameField.text!
        self.password = self.passwordField.text!
        
        if username == "" || password == "" {
            Utils.displayAlert(self, title: "Oops!", message: "Username e/o password mancanti")
        } else {
            let parameters = [
                "username" : username,
                "password" : password,
                "token"    : MyUnimolToken.TOKEN
            ]
            
            Utils.progressBarDisplayer(self, msg: "Wait for login", indicator: true)
            
            Alamofire.request(.POST, MyUnimolEndPoints.TEST_CREDENTIALS, parameters: parameters)
                .responseJSON { response in
                    
                    
                    Utils.removeProgressBar(self)
                    
                    var statusCode : Int
                    if let httpError = response.result.error {
                        statusCode = httpError.code
                    } else {
                        statusCode = (response.response?.statusCode)!
                    }
                    
                    print("Status code is \(statusCode)")
                    if (statusCode == 200) {
                        // login success
                        self.studentInfo = StudentInfo(json: response.result.value as! JSON)
                        
                        // put credentials into NSUserDefault
                        NSUserDefaults.standardUserDefaults().setObject(self.username, forKey: "username")
                        NSUserDefaults.standardUserDefaults().setObject(self.password, forKey: "password")
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey: "isLogged")
                        
                        let student = Student.sharedInstance
                        student.studentInfo = self.studentInfo
                        //TODO insert credential remember
                        self.performSegueWithIdentifier("ViewController", sender: self)
                        
                    } else if (statusCode == 401) {
                        
                        // error on credential
                        Utils.displayAlert(self, title: "Oops!", message: "I tuoi dati di accesso sembrano errati")
                    }
            }
        } // else credential not null
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let centerViewContainer = appDelegate.mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: centerViewContainer)
        
        appDelegate.centerContainer!.centerViewController = centerNav
        appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        //appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        // load all values from NSUserDefaults
        self.isLogged = NSUserDefaults.standardUserDefaults().boolForKey("isLogged")
        
        if (isLogged != nil && isLogged == true) {
            
            let (username, password) = Utils.getUsernameAndPassword()
            
            let parameters = [
                "username" : username,
                "password" : password,
                "token"    : MyUnimolToken.TOKEN
            ]
            
            Utils.progressBarDisplayer(self, msg: "Wait for login", indicator: true)
            
            Alamofire.request(.POST, MyUnimolEndPoints.TEST_CREDENTIALS, parameters: parameters)
                .responseJSON { response in
                    
                    
                    Utils.removeProgressBar(self)
                    
                    var statusCode : Int
                    if let httpError = response.result.error {
                        statusCode = httpError.code
                    } else {
                        statusCode = (response.response?.statusCode)!
                    }
                    print("Status code is \(statusCode)")
                    if (statusCode == 200) {
                        // login success
                        self.studentInfo = StudentInfo(json: response.result.value as! JSON)
                        
                        let student = Student.sharedInstance
                        student.studentInfo = self.studentInfo
                        //TODO insert credential remember
                        self.performSegueWithIdentifier("ViewController", sender: self)

                    } else if (statusCode == 401) {
                        
                        // error on credential
                        Utils.displayAlert(self, title: "Oops!", message: "Qualcosa di strano è successo")
                    }
            }
        } // user already logged
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func didReceiveMemoryWarning() {}
    
    // Remove focus form a TextField
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}