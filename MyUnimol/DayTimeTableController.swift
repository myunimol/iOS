//
//  DayTimeTableController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 30.04.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import Foundation
import CoreData

class DayTimeTableController: UITableViewController, UITabBarControllerDelegate, NSFetchedResultsControllerDelegate {
    
    var tabBarIndex = 0
    var myTabController: TimeBarController?
    // the arrays with the times
    var arrayTimes: [Orario]?
    // the current day that correspond to the selected tab
    var currentDay: String = "monday"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Orario", color: Utils.myUnimolBlue, style: UIBarStyle.black)
        self.tabBarController?.delegate = self
        
        self.myTabController = tabBarController as! TimeBarController
        
        self.tableView.delegate = self
        
        let nib = UINib(nibName: "TimeTableCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "TimeTableCell")
        
        self.tableView.isHidden = true
    }
    
    func removeSubView(_ view: UIViewController) {
        
        var sub1 = view.view.viewWithTag(1)
        var sub2 = view.view.viewWithTag(2)
        
        sub1?.removeFromSuperview()
        sub1 = nil
        
        sub2?.removeFromSuperview()
        sub2 = nil
     }
    
    func isPlaceholderHere(_ view: UIViewController) -> Bool {
        for view in view.view.subviews as [UIView] {
            if view.tag == 1 || view.tag == 2 {
                return true
            }
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableCell", for: indexPath) as! TimeTableCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.lessonName.text = self.arrayTimes![indexPath.row].materia
        cell.lessonComment.text = self.arrayTimes![indexPath.row].commento
        cell.startingTime.text = dateFormatter.string(from: self.arrayTimes![indexPath.row].data_inizio! as! Date)
        cell.endingTime.text = dateFormatter.string(from: self.arrayTimes![indexPath.row].data_termine! as! Date)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.self.arrayTimes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // delegato per attivare le azioni della cell dopo swipe
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Bottone per editare la cella
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("more button tapped")
        }
        edit.backgroundColor = UIColor.blue
        
        
        // Bottone per rimuovere la cella
        let delete = UITableViewRowAction(style: .destructive, title: "Elimina") { action, index in
            print("elimina button tapped")
            let commit = self.arrayTimes![indexPath.row]
            CoreDataController.sharedIstanceCData.context.delete(commit)
            self.arrayTimes?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try CoreDataController.sharedIstanceCData.context.save()
            } catch let errore {
                print("Problema eliminazione orario")
                print("Stampo l'errore: \n \(errore) \n")
            }
            tableView.reloadData()
        }
        
        return [delete, edit]
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.arrayTimes = CoreDataController.sharedIstanceCData.loadAllOrario((self.myTabController?.currentDay)!)
        CoreDataController.sharedIstanceCData.dayOfTheWeek = (self.myTabController?.currentDay)!
        
        self.tabBarController?.navigationItem.title = (self.myTabController?.day)!
        self.navigationController?.navigationBar.barTintColor = Utils.myUnimolBlueUIColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = Utils.myUnimolBlueUIColor
        self.tabBarController?.tabBar.isTranslucent = false
        
        let menuButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                         style: UIBarButtonItemStyle.plain ,
                                         target: self, action: #selector(UIViewController.menuClicked(_:)))
        
        menuButton.tintColor = UIColor.white
        
        let addButton = UIBarButtonItem(image: UIImage(named: "plus"),
                                        style: UIBarButtonItemStyle.plain ,
                                        target: self, action: #selector(UIViewController.addTime(_:)))
        
        addButton.tintColor = UIColor.white

        self.tabBarController?.navigationItem.leftBarButtonItem = menuButton
        self.tabBarController?.navigationItem.rightBarButtonItem = addButton
        
        
        if (self.arrayTimes?.isEmpty)! {
            self.tableView.isHidden = true
            if !self.isPlaceholderHere(self.tabBarController!) {
                Utils.setPlaceholderForEmptyTable(self.tabBarController!, message: "Niente lezioni oggi! 🍻")
            }
        } else {
            removeSubView(self.tabBarController!)
            Utils.reloadTable(self.tableView)
        }
    }
}
