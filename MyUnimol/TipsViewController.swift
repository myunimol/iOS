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
    
    @IBAction func sendMail(_ sender: AnyObject) {
        let mailComposerController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Suggerimenti", color: Utils.myUnimolBlue, style: UIBarStyle.black)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["tot-toc@myunimol.it"])
        mailComposer.setSubject("Feedback MyUnimol@iOS")
        mailComposer.setMessageBody("\n\nApp Version: \(Utils.getAppVersion())\niOS version: \(Utils.getSOVersion())\nCorso: \(Student.sharedInstance.getStudentCourse())\nDipartimento: \(Student.sharedInstance.getStudentDepartment())", isHTML: false)
        return mailComposer
    }
    
    func showSendMailErrorAlert() {
        Utils.displayAlert(self, title: "Errore invio mail", message: "Il tuo dispositivo non può speire email! Per cortesia, controlla le impostazioni delle email")
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
