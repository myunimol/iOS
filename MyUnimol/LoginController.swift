//
//  LoginController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class LoginController : UIViewController, UITextFieldDelegate {
    
    let username : String = ""
    let password : String = ""
    
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func login(sender: AnyObject) {
    }
    
    override func viewDidLoad() {}
    
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