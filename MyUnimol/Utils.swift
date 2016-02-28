//
//  Utils.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 25/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

// Utility class
class Utils {
    
    static var messageFrame = UIView()
    static var activityIndicator = UIActivityIndicatorView()
    static var strLabel = UILabel()
    
    static func displayAlert(targetVC: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
        })))
        targetVC.presentViewController(alertController, animated: true) { }
    }
    
    static func progressBarDisplayer(targetVC: UIViewController, msg:String, indicator:Bool ) {
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: targetVC.view.frame.midX - 90, y: targetVC.view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        targetVC.view.addSubview(messageFrame)
    }
    
    static func removeProgressBar(targetVC: UIViewController) {
        messageFrame.removeFromSuperview()
    }

    static func saveUsernameAndPassoword (username: String, password: String) {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
    }
    
    static func userAlreadyExists() -> Bool {
        let usersDefault = NSUserDefaults.standardUserDefaults()
        
        if usersDefault.objectForKey("username") != nil && usersDefault.objectForKey("password") != nil {
            return true
        } else {
            return false
        }
    }
    
    static func getUsernameAndPassword() -> (String, String) {
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
        let password = NSUserDefaults.standardUserDefaults().objectForKey("password") as! String
        return (username, password)
    }
}