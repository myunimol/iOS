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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationController()
        self.examName.text          = exam!.name
        self.professorName.text     = exam!.professor
        self.date.attributedText    = self.attributedExamDateString()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
