//
//  Utils.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 25/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

/// Generic utility class
class Utils {
    
    let instance = Utils()
    
    /// the `UIView` which contain the loading sentences and the activity indicator
    static var messageFrame = UIView()
    /// the activity indicator
    static var activityIndicator = UIActivityIndicatorView()
    /// the label for the current sentences
    static var strLabel = UILabel()
    
    /// various types of colors for MyUnimol UI
    static let myUnimolBlue = CIColor(red: 75.0/255.0, green: 101.0/255.0, blue: 149.0/255.0, alpha: 1.0)
    static let myUnimolBack = CIColor(red: 75.0/255.0, green: 101.0/255.0, blue: 149.0/255.0, alpha: 0.9)
    static let myUnimolBlueUIColor = UIColor(ciColor: Utils.myUnimolBlue)
    
    /**
     Display an alert message for the passed `UIViewController`
     - parameters:
     - targetVC: the view controller
     - title: the title of the message
     - message: the body of the message
     */
    static func displayAlert(_ targetVC: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction((UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
        })))
        targetVC.present(alertController, animated: true) { }
    }
    
    /**
     Sets an activity indicator with a random sentence in the view passed as parameter
     - parameters:
     - targetVC: the view
     - msg: the message
     - indicator: a boolean value which handle the presence of the activity indicator
     */
    static func progressBarDisplayer(_ targetVC: UIViewController, msg:String, indicator:Bool ) {
        
        let height = myHeightForView(msg, width: 200)
        
        strLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: height))
        strLabel.numberOfLines = 0
        strLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        strLabel.text = msg
        strLabel.textAlignment = .center
        strLabel.center = CGPoint(x: 125, y: (height/2 + 20.0))
        strLabel.textColor = UIColor.white
        
        let size: CGFloat = 260
        var screeHeight: CGFloat
        if (targetVC.isEqual(LoginController())) {
            screeHeight = targetVC.view.frame.size.height
        } else {
            screeHeight = targetVC.view.frame.size.height - 64
        }
        let screenWidth = targetVC.view.frame.size.width
        
        let frame = CGRect(x: (screenWidth / 2) - (size / 2), y: (screeHeight / 2) - (height / 2), width: size, height: height)
        messageFrame = UIView(frame: frame)
        
        messageFrame.layer.cornerRadius = 15
        
        messageFrame.backgroundColor = UIColor(ciColor: Utils.myUnimolBack)
        if (indicator) {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.center = CGPoint(x: 125, y: 35)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        targetVC.view.addSubview(messageFrame)
    }
    
    fileprivate static func myHeightForView(_ text: String, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        label.sizeToFit()
        if (label.frame.height <= 50) {
            return 50.0 + 75.0
        } else {
            return label.frame.height + 75.0
        }
    }
    
    /// Removes the progress bar from a given view
    static func removeProgressBar(_ targetVC: UIViewController) {
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
    static func setNavigationControllerStatusBar(_ myView: UIViewController, title: String, color: CIColor, style: UIBarStyle) {
        let navigation = myView.navigationController!
        navigation.navigationBar.barStyle = style
        navigation.navigationBar.barTintColor = UIColor(ciColor: color)
        navigation.navigationBar.isTranslucent = false
        navigation.navigationBar.tintColor = UIColor.white
        myView.navigationItem.title = title
    
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                         style: UIBarButtonItemStyle.plain ,
                                         target: myView, action: #selector(UIViewController.menuClicked(_:)))
        
        myView.navigationItem.leftBarButtonItem = menuButton
    }
    
    /// Sets a placeholder in a view with no data
    static func setPlaceholderForEmptyTable(_ calling: UIViewController, message: String) {
        let imageView = UIImageView(image: UIImage(named: "swag.png"))
        imageView.frame = CGRect(x: (calling.view.frame.size.width - 120) / 2, y: 50, width: 120, height: 120)
        let label = UILabel(frame: CGRect(x: (calling.view.frame.size.width - 300) / 2, y: 180, width: 300, height: 50))
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.text = message
        
        // give tags to views in order to delete them later
        imageView.tag = 1
        label.tag = 2
        
        calling.view.addSubview(label)
        calling.view.addSubview(imageView)
    }
    
    /// Set a table view to visible and reload data
    static func reloadTable(_ table: UITableView) {
        table.reloadData()
        table.isHidden = false
    }
    
    /// Returns the app number of version
    static func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "no version info"
    }
    
    /// Returns the SO version
    static func getSOVersion() -> String {
        return UIDevice.current.systemVersion;
    }
    
    /// The privacy policy message
    static let privacyStatement = "ATTENZIONE: MyUnimol non è un\'applicazione ufficiale dell\'Università degli Studi del Molise. Tutti i dati vengono reperiti dal portale dello Studente dell\'Università degli Studi del Molise.\n\nEffettuando l\'accesso si esprime il proprio consenso al download automatico dei propri dati (quali nome, cognome, voto degli esami, corso di studi...) dal portale.\n\nPer maggiori info toc-toc@myunimol.it."
    
    /// Returns to the app home page
    static func goToMainPage() {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let centerViewContainer = appDelegate.mainStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let centerNav = UINavigationController(rootViewController: centerViewContainer)
        
        appDelegate.centerContainer!.centerViewController = centerNav
        appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
    }
    
    /// Returns to the login page
    static func goToLogin() {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let centerViewContainer = appDelegate.mainStoryBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        let centerNav = UINavigationController(rootViewController: centerViewContainer)
        
        appDelegate.centerContainer!.centerViewController = centerNav
        appDelegate.centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode()
    }
}

