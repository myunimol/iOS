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
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func login(_ sender: AnyObject) {
        self.loginButton.isEnabled = false
        self.username = self.usernameField.text!
        self.password = self.passwordField.text!
        self.view.endEditing(true)
        
        if !Reachability.isConnectedToNetwork() {
            // no available connection
            Utils.displayAlert(self, title: "😨 Ooopss...", message: "Sembra che tu non abbia una connessione disponibile 👎")
            self.loginButton.isEnabled = true
            return
        } else {
            if username == "" || password == "" {
                Utils.displayAlert(self, title: "Oops!", message: "Username e/o password mancanti")
                self.loginButton.isEnabled = true
            } else {
                self.getCareerAndLogin(username, password: password)
            }
        }
    }
    
    @IBAction func showPrivacy(_ sender: AnyObject) {
        Utils.displayAlert(self, title: "Privacy", message: Utils.privacyStatement)
    }
    
    func getCareerAndLogin(_ username: String, password: String) {
        Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
        Career.getAllCareers(username, password: password) { careers in
            guard careers != nil else {
                Utils.removeProgressBar(self)
                Utils.displayAlert(self, title: "😨 Ooopss...", message: "Qualcosa è andato 👎 ma non saprei proprio cosa ☹️! Ritenta tra poco 💪")
                self.loginButton.isEnabled = true
                return
            }
            if (careers!.areCredentialsValid == true) {
                let careers: Careers? = careers
                if (careers == nil || careers!.careers?.count == 0) {
                    self.getStudentInfo(false)
                } else {
                    Utils.removeProgressBar(self)
                    UIUtils.alertForCareerChoice(careers!) { 
                        self.getStudentInfo(true)
                    }
                }
            } else {
                self.displayWrongCredentials()
            }
        } // end completion block
    }
    
    func getStudentInfo(_ addSentenceBar: Bool) {
        if addSentenceBar {
            Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
        }
        StudentInfo.getCredentials { studentInfo in
            guard studentInfo != nil else {
                Utils.removeProgressBar(self)
                Utils.displayAlert(self, title: "😨 Ooopss...", message: "Qualcosa è andato 👎 ma non saprei proprio cosa ☹️! Ritenta tra poco 💪")
                self.loginButton.isEnabled = true
                return
            } // error guard
            if studentInfo!.areCredentialsValid {
                self.getRecordBook()
            } else {
                // login not valid
                self.displayWrongCredentials()
            }
            
        }
    }
    
    func getRecordBook() {
        RecordBook.getRecordBook { recordBook in
            guard recordBook != nil else {
                self.opsGiveMeAnError()
                return
            }
            self.performSegue(withIdentifier: "ViewController", sender: self)
            Utils.removeProgressBar(self)
            self.loginButton.isEnabled = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let keyboardSize: CGFloat = 260
        let bottomCoordinate = self.view.frame.origin.y + self.view.frame.size.height
        let textFieldCoordinate = textField.frame.origin.y
        
        if (bottomCoordinate - textFieldCoordinate < keyboardSize) {
            // the textField goes under the keyboard
            let remanence = keyboardSize - (bottomCoordinate - textFieldCoordinate)
            self.scrollView.setContentOffset(CGPoint(x: 0, y: remanence), animated: true)
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let centerViewContainer = appDelegate.mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: centerViewContainer)
        
        appDelegate.centerContainer!.centerViewController = centerNav
        appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func didReceiveMemoryWarning() {}
    
    ///Remove the focus from a texfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// Displays an error, enables the login button and refresh username and passoword
    fileprivate func opsGiveMeAnError() {
        Utils.removeProgressBar(self)
        Utils.displayAlert(self, title: "😨 Ooopss...", message: "Qualcosa è andato 👎 ma non saprei proprio cosa ☹️! Ritenta tra poco 💪")
        self.loginButton.isEnabled = true
        self.usernameField.text = ""
        self.passwordField.text = ""
    }
    
    /// Displays a messsage fro wrong credentials
    fileprivate func displayWrongCredentials() {
        Utils.removeProgressBar(self)
        Utils.displayAlert(self, title: "Credenziali non valide 😱", message: "Controlla username e password 😎")
        self.loginButton.isEnabled = true
        // DO NOT reset text field, preserve as much user input as we can
        //self.usernameField.text = ""
        //self.passwordField.text = ""
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
