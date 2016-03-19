//
//  TaxesViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 17/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss


class TaxesViewController: UIViewController, UITableViewDelegate {
    
    var taxes: TaxClass!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.setNavigationControllerStatusBar(self, title: "Pagamenti", color: Utils.myUnimolBlue, style: UIBarStyle.Black)
        
        ApiCall.getTaxes(self, table: self.tableView)
        
        self.taxes = TaxClass.sharedInstance
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taxes.taxes?.taxes.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TaxesCell", forIndexPath: indexPath) as! TaxesCell
        
        let tax = self.taxes.taxes?.taxes[indexPath.row]
        
        cell.billId.text = tax!.billId! + " - " + tax!.description!
        cell.accademicYear.text = "Anno accademico: " + tax!.year!
        cell.deadlineDate.text = "Data scadenza: " + tax!.expiringDate!
        
        cell.amount.text = "€ " + String(format: "%.2f", tax!.amount!)
        
        cell.view.layer.cornerRadius = cell.view.frame.size.height/2
        cell.view.layer.masksToBounds = true
        
        if (tax?.statusPayment == "pagato") {
            cell.view.backgroundColor = UIColor.greenColor()
        } else {
            cell.view.backgroundColor = UIColor.redColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
}
