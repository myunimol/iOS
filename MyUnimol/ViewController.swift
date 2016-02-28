//
//  ViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class ViewController: UIViewController {
    
    @IBOutlet weak var progress: KDCircularProgress!
    @IBOutlet weak var percentage: UILabel!
    
    var recordBook: RecordBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if Utils.userAlreadyExists() {
            let (username, password) = Utils.getUsernameAndPassword()
            
            let parameters = [
                "username" : username,
                "password" : password,
                "token"    : MyUnimolToken.TOKEN
            ]
            
            Utils.progressBarDisplayer(self, msg: "Wait", indicator: true)
            
            // Request
            Alamofire.request(.POST, MyUnimolEndPoints.GET_RECORD_BOOK, parameters: parameters)
                .responseJSON { response in
                    
                    Utils.removeProgressBar(self)
                    var statusCode : Int
                    if let httpError = response.result.error {
                        statusCode = httpError.code
                    } else {
                        statusCode = (response.response?.statusCode)!
                    }
                    
                    if statusCode == 200 {
                        
                        self.recordBook = RecordBook(json: response.result.value as! JSON)
                        let recordBookSingleton = RecordBookClass.sharedInstance
                        recordBookSingleton.recordBook = self.recordBook
                        
                    } else if statusCode == 401 {
                        Utils.displayAlert(self, title: "Oops!", message: "Abbiamo qualche problema")
                    }
            }
            
        }
        
        animateButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateButton() {
        
        progress.animateFromAngle(0, toAngle: 360, duration: 1.5) { completed in
            if completed {
                self.percentage.text = "\(100)%"
            }
        }
    }
}


