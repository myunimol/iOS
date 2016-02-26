//
//  Utils.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 25/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

// Utility class
class Utils {
    
    static func displayAlert(targetVC: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
        })))
        targetVC.presentViewController(alertController, animated: true) { }
    }
}