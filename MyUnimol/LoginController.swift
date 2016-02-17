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
    
    var username: String = ""
    var password: String = ""
    
    @IBAction func login(sender: AnyObject) {
        
        self.username = self.usernameField.text!
        self.password = self.passwordField.text!
        
        if username == "" || password == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Username e/o password mancanti", preferredStyle: .Alert)
            // add a button
            let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) { }
        } else {
            let parameters = [
                "username" : username,
                "password" : password,
                "token"    : MyUnimolToken.TOKEN
            ]
            
            Alamofire.request(.POST, MyUnimolEndPoints.TEST_CREDENTIALS, parameters: parameters)
                .responseJSON { response in
                    
                    var statusCode : Int
                    if let httpError = response.result.error {
                        statusCode = httpError.code
                    } else {
                        statusCode = (response.response?.statusCode)!
                    }
                    
                    if (statusCode == 200) {
                        // login success
                        if let studentInfo = StudentInfo(json: response.result.value as! JSON) {
                            print(studentInfo.course!)
                        }
                    }
                    
            }
            

        }
        
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