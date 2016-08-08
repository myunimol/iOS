//
//  CalendarDataViewController.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 01/08/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class CalendarDataViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var dataTableView: UITableView!
    var selectedIndexPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("matsCell", forIndexPath: indexPath) as! CalendarDataCell
            cell.matsDataField.delegate = self
            cell.matsDataField.tag = indexPath.row
            let placeholder = NSAttributedString(string: "Materia")
            cell.matsDataField.attributedPlaceholder = placeholder
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CalendarDataCell
            cell.commentDataField.delegate = self
            cell.commentDataField.tag = indexPath.row
            let placeholder = NSAttributedString(string: "Commento")
            cell.commentDataField.attributedPlaceholder = placeholder
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("startDateCell", forIndexPath: indexPath) as! CalendarDataCell
            let currentDay = NSDate()
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "it-IT")
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
            
            if CoreDataController.sharedIstanceCData.labelOraInizioToString == nil {
                cell.startHourLbl.text = dateFormatter.stringFromDate(currentDay)
            } else {
                cell.startHourLbl.text = CoreDataController.sharedIstanceCData.labelOraInizioToString
            }
            
            cell.selectedCellRow = indexPath.row
            cell.inizioLbl.text = "Inizio"
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("endDateCell", forIndexPath: indexPath) as! CalendarDataCell
            let currentDay = NSDate()
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            if CoreDataController.sharedIstanceCData.labelOraTermineToString == nil {
                cell.endHourLbl.text = dateFormatter.stringFromDate(currentDay)
            } else {
                cell.endHourLbl.text = CoreDataController.sharedIstanceCData.labelOraTermineToString
            }
            
            cell.selectedCellRow = indexPath.row
            cell.terminaLbl.text = "Termina"
            return cell

        }
        let cell = tableView.dequeueReusableCellWithIdentifier("saveCell", forIndexPath: indexPath) as! CalendarDataCell
        cell.saveBtnLbl.addTarget(self, action: #selector(CalendarDataViewController.makeSegue(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func makeSegue(button:UIButton) {
        // Si possono inserire funzioni di controllo prima di cambiare view
        self.performSegueWithIdentifier("returnToCalendar", sender: button)
    }

    // Con questo delegato del textField catturiamo ogni carattere digitato nel campo, compreso il backspace in modo 
    // da poterlo memorizzare nelle propietà relative
    func textField(textField: UITextField, shouldChangeCharactersInRange range:NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            CoreDataController.sharedIstanceCData.matsDataField = "" + textField.text!+string
        } else {
            CoreDataController.sharedIstanceCData.commentDataField = "" + textField.text!+string
        }
        return true
    }
    
    // ############################## METODI PER IL RIDIMENSIONAMENTO DELLE CELLE DEL DATE PICKER ########################
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! CalendarDataCell).watchFrameChanges()
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as! CalendarDataCell).ignoreFrameChanges()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Lasciamo l'altezza di default in caso vengano selezionate le celle 0 (materia) 1 (commenti) e 4 (save)
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4 {
            return CalendarDataCell.defaultHeight
        }
        if indexPath == selectedIndexPath {
            return CalendarDataCell.expandedHeight
        } else {
            return CalendarDataCell.defaultHeight
        }
    }
    // ###############################################################################################################################
}
