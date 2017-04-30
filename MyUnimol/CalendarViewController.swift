//
//  CalendarViewController.swift
//  MyUnimol
//
//  Created by Vittorio Pinti on 31/07/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import CoreData

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayOrario: [Orario]?
    var add_course_btn: UIButton = UIButton()
    
    enum Day: Int {
        case monday = 0, tuesday, wednesday, thursday, friday, saturday
    }
    
    let getIndexDay = {(value: String)  -> Day in
        switch(value) {
        case "monday":
            return .monday
        case "tuesday":
            return .tuesday
        case "wednesday":
            return .wednesday
        case "thursday":
            return .thursday
        case "friday":
            return .friday
        case "saturday":
            return .saturday
        default:
            break
        }
        return .monday
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Orario", color: Utils.myUnimolBlue, style: UIBarStyle.black)
        self.tableView.isHidden = false
        getSegmentController(getIndexDay(CoreDataController.sharedIstanceCData.dayOfTheWeek))
        makeButton()
        
        // recupero i dati relativi al giorno Lunedì (o al current day) dal CoreData e lo assegno all'arrayOrario
        let array_orario = CoreDataController.sharedIstanceCData.loadAllOrario(CoreDataController.sharedIstanceCData.dayOfTheWeek)
        self.arrayOrario = array_orario
    }
    
    func getSegmentController(_ day: Day) {
        let items = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = day.rawValue
        
        // Add target action method
        customSC.addTarget(self, action: #selector(CalendarViewController.setSegmentIndex(_:)), for: .valueChanged)
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.main.bounds
        customSC.frame = CGRect(x: frame.minX , y: frame.minY, width: frame.width, height: 36)
        
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = Utils.myUnimolBlueUIColor
        customSC.tintColor = UIColor.white
        self.view.addSubview(customSC)
    }
    
    func setSegmentIndex(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentControllerHandle("monday")
            sender.selectedSegmentIndex = 0
            break
        case 1:
            segmentControllerHandle("tuesday")
            sender.selectedSegmentIndex = 1
            break
        case 2:
            segmentControllerHandle("wednesday")
            sender.selectedSegmentIndex = 2
            break
        case 3:
            segmentControllerHandle("thursday")
            sender.selectedSegmentIndex = 3
            break
        case 4:
            segmentControllerHandle("friday")
            sender.selectedSegmentIndex = 4
            break
        case 5:
            segmentControllerHandle("saturday")
            sender.selectedSegmentIndex = 5
            break
        default:
            break
        }
    }
    
    func segmentControllerHandle(_ currentDay: String) {
        if currentDay=="saturday" {
            let party_view : PartyAllNightView = PartyAllNightView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))

            self.tableView.backgroundView = party_view
            self.tableView.separatorStyle = .none
            self.arrayOrario = []
            self.tableView.reloadData()
            self.add_course_btn.isHidden=true
        } else {
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView = nil
            self.add_course_btn.isHidden=false
            let retrieveOrariofromCoreData = CoreDataController.sharedIstanceCData.loadAllOrario(currentDay)
            self.arrayOrario = retrieveOrariofromCoreData
            CoreDataController.sharedIstanceCData.dayOfTheWeek = currentDay
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOrario!.count
    }

    func changeFormView() {
        self.performSegue(withIdentifier: "eventSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCalendarCell
        headerCell.backgroundColor = UIColor.white
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.lesson.text = arrayOrario![indexPath.row].materia
        cell.comment.text = arrayOrario![indexPath.row].commento
        cell.dot.text = "."
        cell.dot.textAlignment = .center
        cell.start_hour.text = dateFormatter.string(from: arrayOrario![indexPath.row].data_inizio! as Date)
        cell.end_hour.text = dateFormatter.string(from: arrayOrario![indexPath.row].data_termine! as Date)
        return cell
    }
    
    func makeButton() {
        
        let frame = UIScreen.main.bounds
        let btn = UIButton(frame: CGRect(x: frame.maxX - 70, y: frame.maxY - 150, width: 60, height: 60))
        if let image = UIImage(named: "voto_bg.png") {
            btn.setBackgroundImage(image, for: UIControlState())
        }
        btn.setTitle("+", for: UIControlState())
        btn.setTitleColor(UIColor.white, for: UIControlState())
        btn.titleLabel!.font = UIFont.boldSystemFont(ofSize: 27)
        btn.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
        self.add_course_btn = btn
        self.view.addSubview(btn)
    }
    
    func buttonAction(_ sender: UIButton!) {
        //guard sender == customButton else { return }
        self.performSegue(withIdentifier: "eventSegue", sender: self)
        // Do anything you actually want to do here
    }
    
    // delegati per attivare il delete su swipe delle cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let commit = arrayOrario![indexPath.row]
            CoreDataController.sharedIstanceCData.context.delete(commit)
            arrayOrario?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try CoreDataController.sharedIstanceCData.context.save()
            } catch let errore {
                print("Problema eliminazione orario")
                print("Stampo l'errore: \n \(errore) \n")
            }
            tableView.reloadData()
        }
    }
    
}
