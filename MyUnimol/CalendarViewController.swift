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
        Utils.setNavigationControllerStatusBar(self, title: "Orario", color: Utils.myUnimolBlue, style: UIBarStyle.Black)
        self.tableView.hidden = false
        getSegmentController(getIndexDay(CoreDataController.sharedIstanceCData.dayOfTheWeek))
        makeButton()
        
        // recupero i dati relativi al giorno Lunedì (o al current day) dal CoreData e lo assegno all'arrayOrario
        let array_orario = CoreDataController.sharedIstanceCData.loadAllOrario(CoreDataController.sharedIstanceCData.dayOfTheWeek)
        self.arrayOrario = array_orario
    }
    
    func getSegmentController(day: Day) {
        let items = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = day.rawValue
        
        // Add target action method
        customSC.addTarget(self, action: #selector(CalendarViewController.setSegmentIndex(_:)), forControlEvents: .ValueChanged)
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        customSC.frame = CGRectMake(frame.minX , frame.minY, frame.width, 36)
        
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = Utils.myUnimolBlueUIColor
        customSC.tintColor = UIColor.whiteColor()
        self.view.addSubview(customSC)
    }
    
    func setSegmentIndex(sender: UISegmentedControl) {
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
    
    func segmentControllerHandle(currentDay: String) {
        if currentDay=="saturday" {
            let party_view : PartyAllNightView = PartyAllNightView(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))

            self.tableView.backgroundView = party_view
            self.tableView.separatorStyle = .None
            self.arrayOrario = []
            self.tableView.reloadData()
            self.add_course_btn.hidden=true
        } else {
            self.tableView.separatorStyle = .SingleLine
            self.tableView.backgroundView = nil
            self.add_course_btn.hidden=false
            let retrieveOrariofromCoreData = CoreDataController.sharedIstanceCData.loadAllOrario(currentDay)
            self.arrayOrario = retrieveOrariofromCoreData
            CoreDataController.sharedIstanceCData.dayOfTheWeek = currentDay
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOrario!.count
    }

    func changeFormView() {
        self.performSegueWithIdentifier("eventSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
 
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCalendarCell
        headerCell.backgroundColor = UIColor.whiteColor()
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCell
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.lesson.text = arrayOrario![indexPath.row].materia
        cell.comment.text = arrayOrario![indexPath.row].commento
        cell.dot.text = "."
        cell.dot.textAlignment = .Center
        cell.start_hour.text = dateFormatter.stringFromDate(arrayOrario![indexPath.row].data_inizio!)
        cell.end_hour.text = dateFormatter.stringFromDate(arrayOrario![indexPath.row].data_termine!)
        return cell
    }
    
    func makeButton() {
        
        let frame = UIScreen.mainScreen().bounds
        let btn = UIButton(frame: CGRect(x: frame.maxX - 70, y: frame.maxY - 150, width: 60, height: 60))
        if let image = UIImage(named: "voto_bg.png") {
            btn.setBackgroundImage(image, forState: .Normal)
        }
        btn.setTitle("+", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.titleLabel!.font = UIFont.boldSystemFontOfSize(27)
        btn.addTarget(self, action: #selector(self.buttonAction), forControlEvents: .TouchUpInside)
        self.add_course_btn = btn
        self.view.addSubview(btn)
    }
    
    func buttonAction(sender: UIButton!) {
        //guard sender == customButton else { return }
        self.performSegueWithIdentifier("eventSegue", sender: self)
        // Do anything you actually want to do here
    }
    
    // delegati per attivare il delete su swipe delle cell
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let commit = arrayOrario![indexPath.row]
            CoreDataController.sharedIstanceCData.context.deleteObject(commit)
            arrayOrario?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
