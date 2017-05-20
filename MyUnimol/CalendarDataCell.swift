//
//  CalendarDataCell.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 01/08/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit

class CalendarDataCell: UITableViewCell {
    
    @IBOutlet weak var matsDataField: UITextField! // Data Field della materia
    @IBOutlet weak var commentDataField: UITextField! // Data Field dei commenti
    @IBOutlet weak var inizioLbl: UILabel! // Label Inizio
    @IBOutlet weak var terminaLbl: UILabel! // label Termina
    @IBOutlet weak var startHourLbl: UILabel! // Label ora inizio delle lezioni
    @IBOutlet weak var endHourLbl: UILabel! // Label ora termine delle lezioni
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var frameAdded = false
    var selectedCellRow :Int? = Int()
    
    class var expandedHeight: CGFloat { get { return 200 } }
    class var defaultHeight: CGFloat { get { return 44 } }
    
    @IBAction func datePickerAct(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let strDate = dateFormatter.string(from: datePicker.date)
        if selectedCellRow == 2 {
            CoreDataController.sharedIstanceCData.startHourNSDate = dateFormatter.date(from: strDate)!
            startHourLbl.text = strDate
            CoreDataController.sharedIstanceCData.labelOraInizioToString = strDate
        } else {
            CoreDataController.sharedIstanceCData.endHourNSDate = dateFormatter.date(from: strDate)!
            endHourLbl.text = strDate
            CoreDataController.sharedIstanceCData.labelOraTermineToString = strDate
        }
    }
    
  // ############################## METODI PER IL RIDIMENSIONAMENTO DELLE CELLE DEL DATE PICKER ########################
    
    func checkHeight() {
        if datePicker != nil {
            datePicker.isHidden = (frame.size.height < CalendarDataCell.expandedHeight)
        }
    }
    
    func watchFrameChanges() {
        if(!frameAdded) {
            addObserver(self, forKeyPath: "frame", options: .new, context: nil)
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    deinit {
        ignoreFrameChanges()
    }
    
    // ###################################################################################################################################
    
//    @IBAction func saveBtnAct(_ sender: AnyObject) {
//        guard !CoreDataController.sharedIstanceCData.matsDataField.isEmpty else {return}
//        guard !CoreDataController.sharedIstanceCData.commentDataField.isEmpty else {return}
//        // TODO Inserire controlli per l'orario
//        let materia = CoreDataController.sharedIstanceCData.matsDataField
//        let commento = CoreDataController.sharedIstanceCData.commentDataField
//        let data_inizio = CoreDataController.sharedIstanceCData.startHourNSDate
//        let data_termine = CoreDataController.sharedIstanceCData.endHourNSDate
//        CoreDataController.sharedIstanceCData.addOrario(materia, commento: commento, data_inizio: data_inizio, data_termine: data_termine, day: CoreDataController.sharedIstanceCData.dayOfTheWeek)
//        
//        // Svuoto le variabili in caso l'utente non inserisce i valori nei text field materia e commenti
//        // Non è possibile fare un controllo diretto sulle @IBOutlet dei data field in quanto abbandonata la cella
//        // risultano nil, il guard rimane impostato sulle variabili del singleton che devono essere azzerate dopo ogni
//        // inserimento altrimenti verrebbero memorizzati nel core data i valori rimasti in memoria
//        CoreDataController.sharedIstanceCData.matsDataField = ""
//        CoreDataController.sharedIstanceCData.commentDataField = ""
//        
//            }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
