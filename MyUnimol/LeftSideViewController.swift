//
//  LeftSideViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 19/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class LeftSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var drawerMenuItems = ["Home", "Libretto", "Rubrica", "AppellI", "News", "Pagamenti", "Suggerimenti", "Il mio Portale"]
    
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawerMenuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DrawerCell", forIndexPath: indexPath) as! DrawerCell
        
        cell.menuItemLabel.text = drawerMenuItems[indexPath.row]
        return cell
    }
    
    // what happens after a tap in a cell
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //<#code#>
    }
}
