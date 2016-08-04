//
//  CalendarViewController.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 31/07/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss
import CoreData

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func dayWeek(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Orario", color: Utils.myUnimolBlue, style: UIBarStyle.Black)
        self.tableView.hidden = false
        CoreDataController.sharedIstanceCData.fetchedResultController.delegate = self
        do {
            try CoreDataController.sharedIstanceCData.fetchedResultController.performFetch()
        } catch {
            print("An error occurred")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections = CoreDataController.sharedIstanceCData.fetchedResultController.sections?.count
        return numberOfSections!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = CoreDataController.sharedIstanceCData.fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  footerCell = tableView.dequeueReusableCellWithIdentifier("FooterCell") as! FootherCalendarCell
        footerCell.addEvent.addTarget(self, action: #selector(CalendarViewController.changeFormView), forControlEvents: .TouchUpInside)

        return footerCell
    }
    
    func changeFormView() {
        self.performSegueWithIdentifier("eventSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCalendarCell
        headerCell.backgroundColor = Utils.myUnimolBlueUIColor
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCell
        let task = CoreDataController.sharedIstanceCData.fetchedResultController.objectAtIndexPath(indexPath) as! Orario
        cell.lesson.text = task.materia
        cell.comment.text = task.commento
        cell.dot.text = "."
        cell.dot.textAlignment = .Center
        cell.start_hour.text = "10:00"
        cell.end_hour.text = "12:00"
        return cell
    }
    
}
