//
//  TipsViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 12/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import MessageUI

class TipsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    /// Triggers the mailing
    @IBAction func send(sender: AnyObject) {
        let mailComposerController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposerController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Suggerimenti", color: Utils.myUnimolBlue, style: UIBarStyle.Black)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["tot-toc@teammolise.rocks"])
        mailComposer.setSubject("Feedback myUnimol@iOS")
        mailComposer.setMessageBody("", isHTML: false)
        return mailComposer
    }
    
    func showSendMailErrorAlert() {
        Utils.displayAlert(self, title: "Errore invio mail", message: "Il tuo dispositivo non può speire email! Per cortesia, controlla le impostazioni delle email")
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
