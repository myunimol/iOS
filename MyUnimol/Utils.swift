//
//  Utils.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 25/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

/**
    Generic utility class
*/

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
        
        let height = myHeightForView(msg, width: 200)
        print(height)
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: height))
        strLabel.numberOfLines = 0
        strLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        
        let size: CGFloat = 260
        let screenWidth = targetVC.view.frame.size.width
        let screeHeight = targetVC.view.frame.size.height
        
        let frame = CGRectMake((screenWidth / 2) - (size / 2), (screeHeight / 2) - (height / 2), size, height)
        messageFrame = UIView(frame: frame)

        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if (indicator) {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50) // size of activity indicator view
            activityIndicator.center = CGPointMake(25, (height / 2));
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        targetVC.view.addSubview(messageFrame)
    }
    
    
    static func myHeightForView(text: String, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.text = text
        label.sizeToFit()
        if (label.frame.height <= 50) {
            return 50.0
        } else {
            return label.frame.height
        }
    }
    
    
    /**
     Removes the progress bar from a given view
     - parameter targetVC: the view
    */
    static func removeProgressBar(targetVC: UIViewController) {
        messageFrame.removeFromSuperview()
    }
    
    static func setNavigationControllerStatusBar(myView: UIViewController, title: String, color: CIColor, style: UIBarStyle) {
        
        let navigation = myView.navigationController!
        
        navigation.navigationBar.barStyle = style
        navigation.navigationBar.barTintColor = UIColor(CIColor: color)
        navigation.navigationBar.translucent = false
        navigation.navigationBar.tintColor = UIColor.whiteColor()
        myView.navigationItem.title = title
    }

    /**
     Store the credential for a given user in the NSUserDefault cache
     - parameter username: the username
     - parameter password: the password
    */
    static func saveUsernameAndPassoword (username: String, password: String) {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
    }
    
    /**
     Checks if a user is already stored in the permanent cache
    */
    static func userAlreadyExists() -> Bool {
        let usersDefault = NSUserDefaults.standardUserDefaults()
        
        if usersDefault.objectForKey("username") != nil && usersDefault.objectForKey("password") != nil {
            return true
        } else {
            return false
        }
    }
    
    /**
     Return the username and password credential for a given user
     - returns: a tuple with username and password
    */
    static func getUsernameAndPassword() -> (String, String) {
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
        let password = NSUserDefaults.standardUserDefaults().objectForKey("password") as! String
        return (username, password)
    }
    
    // various types of colors for MyUnimol UI
    static let myUnimolBlue = CIColor(red: 75.0/255.0, green: 101.0/255.0, blue: 149.0/255.0, alpha: 1.0)
    static let myUnimolBlueUIColor = UIColor(CIColor: Utils.myUnimolBlue)
}