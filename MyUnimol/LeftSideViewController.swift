//
//  LeftSideViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 19/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentID: UILabel!
    
    var drawerMenuItems = ["Home", "Libretto", "Rubrica", "Appelli", "News", "Pagamenti", "Suggerimenti", "Il mio Portale"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let studentInfo = Student.sharedInstance

        self.studentName.text = (studentInfo.studentInfo?.name)! + " " + (studentInfo.studentInfo?.surname)!
        self.studentID.text = studentInfo.studentInfo?.studentId
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerMenuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DrawerCell", forIndexPath: indexPath) as! DrawerCell
        
        cell.menuItemLabel.text = drawerMenuItems[indexPath.row]
        return cell
    }
    
    // what happens after a tap in a cell
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //<#code#>
    }
    
}
