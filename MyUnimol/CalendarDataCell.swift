//
//  CalendarDataCell.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 01/08/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class CalendarDataCell: UITableViewCell {
    
    @IBOutlet weak var matsDataField: UITextField!
    @IBOutlet weak var commentDataField: UITextField!
    @IBOutlet weak var inizioLbl: UILabel!
    @IBOutlet weak var terminaLbl: UILabel!
    @IBOutlet weak var startHourLbl: UILabel!
    @IBOutlet weak var endHourLbl: UILabel!
    @IBOutlet weak var saveBtnLbl: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var frameAdded = false
    var selectedCellRow :Int? = Int()
    
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat { get { return 44 } }
    
    @IBAction func datePickerAct(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        if selectedCellRow == 2 {
            CoreDataController.sharedIstanceCData.startHourNSDate = dateFormatter.dateFromString(strDate)!
            startHourLbl.text = strDate
        } else {
            CoreDataController.sharedIstanceCData.endHourNSDate = dateFormatter.dateFromString(strDate)!
            endHourLbl.text = strDate
        }
    }
    
  // ############################## METODI PER IL RIDIMENSIONAMENTO DELLE CELLE DEL DATE PICKER ########################
    
    func checkHeight() {
        if datePicker != nil {
            datePicker.hidden = (frame.size.height < CalendarDataCell.expandedHeight)
        }
    }
    
    func watchFrameChanges() {
        if(!frameAdded) {
            addObserver(self, forKeyPath: "frame", options: .New, context: nil)
            checkHeight()
            frameAdded = true
        }
    }
    
    func ignoreFrameChanges() {
        if(frameAdded) {
            removeObserver(self, forKeyPath: "frame")
            frameAdded = false
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    deinit {
        ignoreFrameChanges()
    }
    
    // ###################################################################################################################################
    
    @IBAction func saveBtnAct(sender: AnyObject) {
        guard !CoreDataController.sharedIstanceCData.matsDataField.isEmpty else {return}
        guard !CoreDataController.sharedIstanceCData.commentDataField.isEmpty else {return}
        // TODO Inserire controlli per l'orario
        let materia = CoreDataController.sharedIstanceCData.matsDataField
        let commento = CoreDataController.sharedIstanceCData.commentDataField
        let data_inizio = CoreDataController.sharedIstanceCData.startHourNSDate
        let data_termine = CoreDataController.sharedIstanceCData.endHourNSDate
        CoreDataController.sharedIstanceCData.addOrario(materia, commento: commento, data_inizio: data_inizio, data_termine: data_termine, day: CoreDataController.sharedIstanceCData.dayOfTheWeek)
        
        // Svuoto le variabili in caso l'utente non inserisce i valori nei text field materia e commenti
        // Non è possibile fare un controllo diretto sulle @IBOutlet dei data field in quanto abbandonata la cella
        // risultano nil, il guard rimane impostato sulle variabili del singleton che devono essere azzerate dopo ogni
        // inserimento aktrimenti verrebbero memorizzati nel core data i valori rimasti in memoria
        CoreDataController.sharedIstanceCData.matsDataField = ""
        CoreDataController.sharedIstanceCData.commentDataField = ""
        
            }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
