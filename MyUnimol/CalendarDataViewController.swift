//
//  CalendarDataViewController.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 01/08/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

public struct LessonTime {
    var lessonName :String
    var commentName :String
    var startHour: Date
    var endHour: Date
    var dayOfTheWeek: String
    
    init(lessonName: String, commentName: String, startHour: Date, endHour: Date, dayOfTheWeek: String) {
        self.lessonName = lessonName
        self.commentName = commentName
        self.startHour = startHour
        self.endHour = endHour
        self.dayOfTheWeek = dayOfTheWeek
    }
}

// the class the control the new lessor to insert
class CalendarDataViewController: UITableViewController, UITextFieldDelegate, UITabBarControllerDelegate {

    @IBOutlet var dataTableView: UITableView!
    var selectedIndexPath : IndexPath?
    var setTime: String = ""
    var isPlayedOnce = false
    
    var lessonToUpdate: Orario?     // orario to be checked
    var isAnUpdate: Bool = false    // flag for update or new lesson
    
    var tempLessonNmae: String = ""
    var tempCommentName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
    }
    
    /**
        Saves a lesson to Core Data
     
        - parameter sender: the UIBarButtonItem
    */
    func saveLesson(_ sender: UIBarButtonItem) {
        let (isValid, lesson) = self.checkValidity()
        
        if isValid {
            CoreDataController.sharedIstanceCData.addOrario((lesson?.lessonName)!,
                                                            commento: (lesson?.commentName)!,
                                                            data_inizio: (lesson?.startHour)!,
                                                            data_termine: (lesson?.endHour)!,
                                                            day: (lesson?.dayOfTheWeek)!)
            
            CoreDataController.sharedIstanceCData.matsDataField = ""
            CoreDataController.sharedIstanceCData.commentDataField = ""
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /**
        Update a lesson to Core Data
    */
    func updateLesson(_ sender: UIBarButtonItem) {
        let (isValid, newLesson) = self.checkValidity()
        if isValid {
            CoreDataController.sharedIstanceCData.updateLesson(oldLesson: self.lessonToUpdate!, newLesson: newLesson!)
            
            CoreDataController.sharedIstanceCData.matsDataField = ""
            CoreDataController.sharedIstanceCData.commentDataField = ""
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /**
        Checks wheteher the contraints for the lessons the user want to insert are correct
     
        - return    a boolean flag
        - return    an LessonTime object
    */
    func checkValidity() -> (Bool, LessonTime?) {

        guard !CoreDataController.sharedIstanceCData.matsDataField.isEmpty || self.tempLessonNmae != "" else {
            Utils.displayAlert(self, title: "😨 Ooopss...", message: "Il campo Materia non può essere vuoto")
            return (false, nil)
        }

        let materia = (CoreDataController.sharedIstanceCData.matsDataField == "") ? self.tempLessonNmae : CoreDataController.sharedIstanceCData.matsDataField
        let commento = CoreDataController.sharedIstanceCData.commentDataField
        
        let startDate = CoreDataController.sharedIstanceCData.startHourNSDate
        let endDate = CoreDataController.sharedIstanceCData.endHourNSDate
        
        if(!isLessonTime(date: startDate, dateTarget: "08:00")) {
            Utils.displayAlert(self, title: "😴", message: "Ammirro davvero la tua determinazione, ma il professore probabilmente starà ancora dormendo 😴!")
            return (false, nil)
        }
        
        if checkCorrectnessOfTime(start: startDate,to: endDate) {
            let lessonTime: LessonTime = LessonTime(lessonName: materia, commentName: commento, startHour: startDate, endHour: endDate, dayOfTheWeek: CoreDataController.sharedIstanceCData.dayOfTheWeek)
            return (true, lessonTime)
        } else {
            // date is not valid
            Utils.displayAlert(self, title: "🤔 Sei sicuro?", message: "Non credo che una lezione possa terminare prima del suo inizio!")
            return (false, nil)
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
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matsCell", for: indexPath) as! CalendarDataCell
            self.tempLessonNmae = cell.matsDataField.text!
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CalendarDataCell
            self.tempCommentName = cell.commentDataField.text!
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellFinal: UITableViewCell

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "matsCell", for: indexPath) as! CalendarDataCell
            cell.matsDataField.delegate = self
            cell.matsDataField.tag = indexPath.row
            if (isAnUpdate) {
                cell.matsDataField.text = self.lessonToUpdate?.materia
            }
            self.tempLessonNmae = cell.matsDataField.text!
            cellFinal = cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CalendarDataCell
            cell.commentDataField.delegate = self
            cell.commentDataField.tag = indexPath.row
            if (isAnUpdate) {
                if (self.lessonToUpdate?.commento != nil) {
                    cell.commentDataField.text = self.lessonToUpdate?.commento
                }
            }
            self.tempCommentName = cell.commentDataField.text!
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
            
            cell.viewController = self
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
        if (self.isAnUpdate) {
            let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(updateLesson(_:)))
            edit.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = edit
        } else {
            let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLesson(_:)))
            save.tintColor = UIColor.white
            self.navigationItem.rightBarButtonItem = save
        }
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
        // Lasciamo l'altezza di default in caso vengano selezionate le celle 0 (materia) 1 (commenti)
        if indexPath.row == 0 || indexPath.row == 1 {
            return CalendarDataCell.defaultHeight
        }

        if indexPath == selectedIndexPath &&
            (indexPath.row == 2 || indexPath.row == 3) {
                return CalendarDataCell.expandedHeight
        } else {
            return CalendarDataCell.defaultHeight
        }
    }
    // ###############################################################################################################################
}
