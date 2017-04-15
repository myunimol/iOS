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
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matsCell", for: indexPath) as! CalendarDataCell
            cell.matsDataField.delegate = self
            cell.matsDataField.tag = indexPath.row
            let placeholder = NSAttributedString(string: "Materia")
            cell.matsDataField.attributedPlaceholder = placeholder
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CalendarDataCell
            cell.commentDataField.delegate = self
            cell.commentDataField.tag = indexPath.row
            let placeholder = NSAttributedString(string: "Commento")
            cell.commentDataField.attributedPlaceholder = placeholder
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "startDateCell", for: indexPath) as! CalendarDataCell
            let currentDay = Date()
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "it-IT")
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
            
            if CoreDataController.sharedIstanceCData.labelOraInizioToString == nil {
                cell.startHourLbl.text = dateFormatter.string(from: currentDay)
            } else {
                cell.startHourLbl.text = CoreDataController.sharedIstanceCData.labelOraInizioToString
            }
            
            cell.selectedCellRow = indexPath.row
            cell.inizioLbl.text = "Inizio"
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "endDateCell", for: indexPath) as! CalendarDataCell
            let currentDay = Date()
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            if CoreDataController.sharedIstanceCData.labelOraTermineToString == nil {
                cell.endHourLbl.text = dateFormatter.string(from: currentDay)
            } else {
                cell.endHourLbl.text = CoreDataController.sharedIstanceCData.labelOraTermineToString
            }
            
            cell.selectedCellRow = indexPath.row
            cell.terminaLbl.text = "Termina"
            return cell

        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "saveCell", for: indexPath) as! CalendarDataCell
        cell.saveBtnLbl.addTarget(self, action: #selector(CalendarDataViewController.makeSegue(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func makeSegue(_ button:UIButton) {
        // Si possono inserire funzioni di controllo prima di cambiare view
        self.performSegue(withIdentifier: "returnToCalendar", sender: button)
    }

    // Con questo delegato del textField catturiamo ogni carattere digitato nel campo, compreso il backspace in modo 
    // da poterlo memorizzare nelle propietà relative
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            CoreDataController.sharedIstanceCData.matsDataField = "" + textField.text!+string
        } else {
            CoreDataController.sharedIstanceCData.commentDataField = "" + textField.text!+string
        }
        return true
    }
    
    // ############################## METODI PER IL RIDIMENSIONAMENTO DELLE CELLE DEL DATE PICKER ########################
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! CalendarDataCell).watchFrameChanges()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! CalendarDataCell).ignoreFrameChanges()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
