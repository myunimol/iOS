//
//  RecordBookController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 28/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class RecordBookController: UIViewController, UITableViewDelegate {

    var recordBook: RecordBook?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.setNavigationControllerStatusBar(self, title: "Libretto", color: Utils.myUnimolBlue, style: UIBarStyle.black)
        
        if !Reachability.isConnectedToNetwork() {
            CacheManager.sharedInstance.getJsonByString(CacheManager.RECORD_BOOK) { json in
                let recordBook = RecordBook(json: json!)
                self.recordBook = recordBook
            }
        } else {
            self.recordBook = RecordBookClass.sharedInstance.recordBook
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recordBook?.exams.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordBookCell", for: indexPath) as! RecordBookCell
        
        let currentRecordBook = self.recordBook?.exams[indexPath.row]
        cell.examName.text = currentRecordBook!.name
        cell.grade.text = currentRecordBook!.vote
        cell.cfu.text = "\(currentRecordBook!.cfu!)"
        cell.date.text = currentRecordBook!.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
