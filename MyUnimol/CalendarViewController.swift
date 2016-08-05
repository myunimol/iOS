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
    
    enum Day: Int {
        case monday = 0, tuesday, wednesday, thursday, friday
    }
    
    let getIndexDay = {(value: String) -> Day in
        switch(value) {
        case "monday":
            return Day.monday
        case "tuesday":
            return Day.tuesday
        case "wednesday":
            return Day.wednesday
        case "thursday":
            return Day.thursday
        case "friday":
            return Day.friday
        default:
            break
        }
        return Day.monday
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Orario", color: Utils.myUnimolBlue, style: UIBarStyle.Black)
        self.tableView.hidden = false
        self.tableView.backgroundColor = Utils.myUnimolBlueUIColor
        getSegmentController(getIndexDay(CoreDataController.sharedIstanceCData.dayOfTheWeek))
        
        // recupero i dati relativi al giorno Lunedì (o al current day) dal CoreData e lo assegno all'arrayOrario
        let array_orario = CoreDataController.sharedIstanceCData.loadAllOrario(CoreDataController.sharedIstanceCData.dayOfTheWeek)
        self.arrayOrario = array_orario
    }
    
    func getSegmentController(day: Day) {
        let items = ["Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = day.rawValue
        
        // Add target action method
        customSC.addTarget(self, action: #selector(CalendarViewController.setSegmentIndex(_:)), forControlEvents: .ValueChanged)
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        customSC.frame = CGRectMake(frame.minX + 10, frame.minY /*+ 50*/, frame.width - 20, 36/*frame.height*0.1*/)
        
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
        default:
            break
        }
    }
    
    func segmentControllerHandle(currentDay: String) {
        let retrieveOrariofromCoreData = CoreDataController.sharedIstanceCData.loadAllOrario(currentDay)
        self.arrayOrario = retrieveOrariofromCoreData
        CoreDataController.sharedIstanceCData.dayOfTheWeek = currentDay
        self.tableView.reloadData()
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
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let  footerCell = tableView.dequeueReusableCellWithIdentifier("FooterCell") as! FootherCalendarCell
        footerCell.addEvent.addTarget(self, action: #selector(CalendarViewController.changeFormView), forControlEvents: .TouchUpInside)

        return footerCell
    }

    func changeFormView() {
        self.performSegueWithIdentifier("eventSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCalendarCell
        headerCell.backgroundColor = Utils.myUnimolBlueUIColor
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
