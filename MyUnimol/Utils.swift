//
//  Utils.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 25/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

/// Generic utility class
class Utils {
    /// the `UIView` which contain the loading sentences and the activity indicator
    static var messageFrame = UIView()
    /// the activity indicator
    static var activityIndicator = UIActivityIndicatorView()
    /// the label for the current sentences
    static var strLabel = UILabel()
    
    /// various types of colors for MyUnimol UI
    static let myUnimolBlue = CIColor(red: 75.0/255.0, green: 101.0/255.0, blue: 149.0/255.0, alpha: 1.0)
    static let myUnimolBlueUIColor = UIColor(CIColor: Utils.myUnimolBlue)
    
    /**
     Display an alert message for the passed `UIViewController`
     - parameters:
        - targetVC: the view controller
        - title: the title of the message
        - message: the body of the message
     */
    static func displayAlert(targetVC: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
        })))
        targetVC.presentViewController(alertController, animated: true) { }
    }
    
    /**
     Sets an activity indicator with a random sentence in the view passed as parameter
     - parameters:
        - targetVC: the view
        - msg: the message
        - indicator: a boolean value which handle the presence of the activity indicator
     */
    static func progressBarDisplayer(targetVC: UIViewController, msg:String, indicator:Bool ) {
        
        let height = myHeightForView(msg, width: 200)
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: height))
        strLabel.numberOfLines = 0
        strLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        
        let size: CGFloat = 260
        var screeHeight: CGFloat
        if (targetVC.isEqual(LoginController)) {
            screeHeight = targetVC.view.frame.size.height
        } else {
            screeHeight = targetVC.view.frame.size.height - 64
        }
        let screenWidth = targetVC.view.frame.size.width
        
        let frame = CGRectMake((screenWidth / 2) - (size / 2), (screeHeight / 2) - (height / 2), size, height)
        messageFrame = UIView(frame: frame)
        
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if (indicator) {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.center = CGPointMake(25, (height / 2));
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        targetVC.view.addSubview(messageFrame)
    }
    
    private static func myHeightForView(text: String, width: CGFloat) -> CGFloat {
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
    
    /// Removes the progress bar from a given view
    static func removeProgressBar(targetVC: UIViewController) {
        messageFrame.removeFromSuperview()
    }
    
    /**
     Customize the navigation controller bar for the view passed as parameter
     - parameters:
        - myView: the view
        - title: the title of the view
        - color: the color of the bar
        - style: the style of the bar
     */
    static func setNavigationControllerStatusBar(myView: UIViewController, title: String, color: CIColor, style: UIBarStyle) {
        let navigation = myView.navigationController!
        navigation.navigationBar.barStyle = style
        navigation.navigationBar.barTintColor = UIColor(CIColor: color)
        navigation.navigationBar.translucent = false
        navigation.navigationBar.tintColor = UIColor.whiteColor()
        myView.navigationItem.title = title
    }
    
    /// Sets a placeholder in a view with no data
    static func setPlaceholderForEmptyTable(calling: UIViewController, message: String) {
        let imageView = UIImageView(image: UIImage(named: "swag.png"))
        imageView.frame = CGRect(x: (calling.view.frame.size.width - 120) / 2, y: 10, width: 120, height: 120)
        let label = UILabel(frame: CGRectMake((calling.view.frame.size.width - 300) / 2, 140, 300, 50))
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.Center
        label.text = message
        calling.view.addSubview(label)
        calling.view.addSubview(imageView)
    }
    
    /// Set a table view to visible and reload data
    static func reloadTable(table: UITableView) {
        table.reloadData()
        table.hidden = false
    }
    
}