//
//  ButtonSelectorController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 21/06/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

protocol ButtonSelectorController {
    func menuClicked(_ sender: UIBarButtonItem)
    
    func addTime(_ senter: UIBarButtonItem)
}

extension UIViewController: ButtonSelectorController {
    func menuClicked(_ sender: UIBarButtonItem) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    func addTime(_ sender: UIBarButtonItem) {
        //TODO implement: segue into the page for the creation of a lesson
        self.performSegue(withIdentifier: "timeSegue", sender: self)
    }
}
