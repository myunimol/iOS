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
            
            progressBarDisplayer("Wait for login", true)
            
            Alamofire.request(.POST, MyUnimolEndPoints.TEST_CREDENTIALS, parameters: parameters)
                .responseJSON { response in
                 
                    
                    self.messageFrame.removeFromSuperview()
                    //indicator.stopAnimating()
                    var statusCode : Int
                    if let httpError = response.result.error {
                        statusCode = httpError.code
                    } else {
                        statusCode = (response.response?.statusCode)!
                    }
                   
                    if (statusCode == 200) {
                        // login success
                        self.studentInfo = StudentInfo(json: response.result.value as! JSON)
                        
                        let student = Student.sharedInstance
                        student.studentInfo = self.studentInfo
                        //TODO insert credential remember
                        self.performSegueWithIdentifier("ViewController", sender: self)
                        
                    } else if (statusCode == 401) {
                    
                        // error on credential
                        Utils.displayAlert(self, title: "Oops!", message: "I tuoi dati di accesso sembrano errati")
                    }
                    
            }
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let centerViewContainer = appDelegate.mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: centerViewContainer)
        centerNav.navigationBar.hidden = true
        appDelegate.centerContainer!.centerViewController = centerNav
        appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
        //appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    override func viewDidLoad() {
        // load all values from NSUserDefaults
        self.isLogged = NSUserDefaults.standardUserDefaults().boolForKey("isLogged")
        
        if (isLogged != nil && isLogged == true) {
            //segue to next controller
        }
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