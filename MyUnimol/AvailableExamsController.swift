//
//  AvailableExamsController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 08/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class AvailableExamsController: UIViewController, UITableViewDelegate {

    var exams: ExamsClass!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DefaultExamCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DefaultExamCell")
        
        self.tableView.hidden = true
        ApiCall.getAvailableExams(self, table: self.tableView)
        self.exams = ExamsClass.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationItem.title = "Disponibili"
        self.navigationController?.navigationBar.barTintColor = Utils.myUnimolBlueUIColor
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        self.tabBarController?.tabBar.barTintColor = Utils.myUnimolBlueUIColor
        self.tabBarController?.tabBar.translucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exams.exams?.examsList.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultExamCell", forIndexPath: indexPath) as! DefaultExamCell
        
        let exam = self.exams.exams?.examsList[indexPath.row]
        cell.examName.text = exam?.name
        cell.professor.text = exam?.professor
        cell.examDate.text = exam?.date?.dateToString
        cell.expiringDate.text = exam?.expiringDate?.dateToString
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
}
