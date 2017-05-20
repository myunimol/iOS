//
//  CalendarDataViewController.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 01/08/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class CalendarDataViewController: UITableViewController, UITextFieldDelegate, UITabBarControllerDelegate {

    @IBOutlet var dataTableView: UITableView!
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
    }
    
    /// save a lesson 
    /// TODO: implement all the controls and the checks in this page
    func saveLesson(_ sender: UIBarButtonItem) {
        
        guard !CoreDataController.sharedIstanceCData.matsDataField.isEmpty else {
            Utils.displayAlert(self, title: "😨 Ooopss...", message: "Il campo Materia non può essere vuoto")
            return
        }
        
        // I would suggest that the comment field can be empty
        
        let materia = CoreDataController.sharedIstanceCData.matsDataField
        let commento = CoreDataController.sharedIstanceCData.commentDataField
        
        let startDate = CoreDataController.sharedIstanceCData.startHourNSDate
        let endDate = CoreDataController.sharedIstanceCData.endHourNSDate
        
        print(startDate)
        print(endDate)
        
        if(!isLessonTime(date: startDate, dateTarget: "08:00")) {
            Utils.displayAlert(self, title: "😴", message: "Ammirro davvero la tua determinazione, ma il professore probabilmente starà ancora dormendo 😴!")
        }
        
        if checkCorrectnessOfTime(start: startDate,to: endDate) {
            // date is ok
            CoreDataController.sharedIstanceCData.addOrario(materia, commento: commento, data_inizio: startDate, data_termine: endDate, day: CoreDataController.sharedIstanceCData.dayOfTheWeek)
            
            CoreDataController.sharedIstanceCData.matsDataField = ""
            CoreDataController.sharedIstanceCData.commentDataField = ""
            self.navigationController?.popViewController(animated: true)
        } else {
            // date is not valid
            Utils.displayAlert(self, title: "🤔 Sei sicuro?", message: "Non credo che una lezione possa terminare prima del suo inizio!")
        }
    }
    
    func checkCorrectnessOfTime(start startingTime: Date, to endingTime: Date) -> Bool {
        let startingHour = dateFormatter(data: startingTime)
        let endingHour = dateFormatter(data: endingTime)
        if (startingHour > endingHour) {
            return false
        } else {
            return true
        }
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
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellFinal: UITableViewCell

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matsCell", for: indexPath) as! CalendarDataCell
            cell.matsDataField.delegate = self
            cell.matsDataField.tag = indexPath.row
            cellFinal = cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CalendarDataCell
            cell.commentDataField.delegate = self
            cell.commentDataField.tag = indexPath.row
            cellFinal = cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "startDateCell", for: indexPath) as! CalendarDataCell
            let currentDay = Date()
            let dateFormatter:DateFormatter = DateFormatter()

            dateFormatter.dateFormat = "HH:mm"
            if CoreDataController.sharedIstanceCData.labelOraInizioToString == nil {
                cell.startHourLbl.text = dateFormatter.string(from: currentDay)
            } else {
                cell.startHourLbl.text = CoreDataController.sharedIstanceCData.labelOraInizioToString
            }
            
            cell.selectedCellRow = indexPath.row
            cell.inizioLbl.text = "Inizio"
            cellFinal = cell
        } else {
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
            cellFinal = cell
        }
        return cellFinal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // create the save button and add it to the tab bar controller
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLesson(_:)))
        save.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = save
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
    
    // compare two times in input (Date and String)
    func isLessonTime(date: Date, dateTarget: String) -> Bool {
        let startHour = dateFormatter(data: date)
        if (startHour < dateTarget) {
            return false
        }
        return true
    }
    
    // return a String from a Date
    func dateFormatter(data: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let hour = dateFormatter.string(from: data)
        return hour
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
