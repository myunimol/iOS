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
    
    @IBOutlet weak var loginButton: UIButton!
    
    var isButtonTapped: Bool = false
    
    var username: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(sender: AnyObject) {
        self.loginButton.enabled = false
        
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
            if studentInfo!.areCredentialsValid {
                self.getRecordBook()
            } else {
                // login not valid
                Utils.displayAlert(self, title: "Credenziali non valide", message: "Controlla username e password")
                self.loginButton.enabled = true
                self.usernameField.text = ""
                self.passwordField.text = ""
                Utils.removeProgressBar(self)
            }
            
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
            self.loginButton.enabled = true
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let keyboardSize: CGFloat = 260
        let bottomCoordinate = self.view.frame.origin.y + self.view.frame.size.height
        let textFieldCoordinate = textField.frame.origin.y
        
        if (bottomCoordinate - textFieldCoordinate < keyboardSize) {
            // the textField goes under the keyboard
            let remanence = keyboardSize - (bottomCoordinate - textFieldCoordinate)
            print(remanence)
            self.scrollView.setContentOffset(CGPointMake(0, remanence), animated: true)
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let centerViewContainer = appDelegate.mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: centerViewContainer)
        
        appDelegate.centerContainer!.centerViewController = centerNav
        appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
    }
    
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