//
//  ButtonSelectorController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 21/06/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

protocol ButtonSelectorController {
    func menuClicked(sender: UIBarButtonItem)
}

extension UIViewController: ButtonSelectorController {
    func menuClicked(sender: UIBarButtonItem) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
}
