//
//  BookExamController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 29/06/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class BookExamController: UIViewController {
    
    var exam: SessionExam?
    
    @IBOutlet weak var examName: UILabel!
    
    @IBOutlet weak var professorName: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var enrollButton: UIButton!
    
    @IBOutlet weak var okButton: UIImageView!
    
    @IBAction func bookExam(sender: AnyObject) {
        self.enrollButton.enabled = false
        
        let alertController = UIAlertController(title: "😎 Yeeahhh", message: "Sei stato prenotato all'esame di \(self.exam!.name!)!\n\nOra fila a studiare 😪", preferredStyle: .Alert)
        alertController.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
        })))
        self.presentViewController(alertController, animated: true) {
            self.okButton.hidden     = false
            self.enrollButton.hidden = true
        }
    }
    
    func appoggio () {
        self.enrollButton.enabled = false
        
        Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
        SessionExam.enroll(exam!.id!) { api, error in
            guard error == nil else {
                Utils.removeProgressBar(self)
                Utils.displayAlert(self, title: "😱 Oooops!!", message: "Per qualche strano motivo la prenotazione non è andata a buon fine 😅")
                self.enrollButton.enabled = true
                return
            } // end error
            
            Utils.removeProgressBar(self)
            let alertController = UIAlertController(title: "😎 Yeeahhh", message: "Sei stato prenotato all'esame di \(self.exam!.name!)!\n\nOra fila a studiare 😪", preferredStyle: .Alert)
            alertController.addAction((UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            })))
            self.presentViewController(alertController, animated: true) {
                self.okButton.hidden     = false
                self.enrollButton.hidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationController()
        self.enrollButton.hidden    = false
        self.okButton.hidden        = true
        self.examName.text          = exam!.name
        self.professorName.text     = exam!.professor
        self.date.attributedText    = self.attributedExamDateString()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // here I have to put an asyncronous call to refresh the API for available exams
    }
    
    func configureNavigationController() {
        let navigation = self.navigationController!
        navigation.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = "Prenota"
    }
    
    func attributedExamDateString() -> NSAttributedString {
        let examDate = "Fissato il: \(exam!.date!.dateToString!)" as NSString
        
        let attributedString = NSMutableAttributedString(string: examDate as String, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15.0, weight: UIFontWeightLight)])
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(15.0)]

        attributedString.addAttributes(boldFontAttribute, range: examDate.rangeOfString("Fissato il:"))

        return attributedString
    }
}
