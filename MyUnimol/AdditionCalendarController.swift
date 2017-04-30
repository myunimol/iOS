//
//  AdditionCalendarController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 23.04.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import Foundation

class AdditionalCalendarController: UIViewController, UITextFieldDelegate {
    
    // starting staff
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // ending staff
    @IBOutlet weak var endButton: UIButton!
    
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func openDatePicker(_ sender: UIButton) {
        if self.startDatePicker.isHidden {
            self.startDatePicker.isHidden = false
        } else {
            self.startDatePicker.isHidden = true
        }
    }
    
    @IBAction func openEndDatePicker(_ sender: UIButton) {
        if self.endDatePicker.isHidden {
            self.endDatePicker.isHidden = false
        } else {
            self.endDatePicker.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        // both the datePickers are hidden
        self.startDatePicker.isHidden = true
        self.endDatePicker.isHidden = true
        
        self.hideKeyboardWhenTappedAround()
        
//        self.startButton.setTitle("Inizio", for: UIControlState.normal)
//        self.endButton.setTitle("Fine", for: UIControlState.normal)
//        
//        // selectors
//        self.startDatePicker.addTarget(self, action: #selector(startDateValueChanger(datePicker:)), for: .valueChanged)
//        self.endDatePicker.addTarget(self, action: #selector(endDateValueChanger(datePicker:)), for: .valueChanged)
    }
    
    /// Used to update the value in the starting label
//    func startDateValueChanger(datePicker: UIDatePicker) {
//        
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: datePicker.date)
//        let minutes = calendar.component(.minute, from: datePicker.date)
//        
//        self.startTimeLabel.text = "\(hour):\(minutes)"
//    }
//    
//    func endDateValueChanger(datePicker: UIDatePicker) {
//        
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: datePicker.date)
//        let minutes = calendar.component(.minute, from: datePicker.date)
//        
//        self.endDateLabel.text = "\(hour):\(minutes)"
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        // to implement
    }
}
