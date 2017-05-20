//
//  DayTimeTableController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 30.04.17.
//  Copyright © 2017 Giovanni Grano. All rights reserved.
//

import Foundation

class DayTimeTableController: UIViewController, UITabBarControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // tab bar index; is 0 (monday) by default
    var tabBarIndex = 0
    
    // the arrays with the times
    var arrayTimes: [Orario]?
    // the current day that correspond to the selected tab
    var currentDay: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Orario", color: Utils.myUnimolBlue, style: UIBarStyle.black)
        self.tabBarController?.delegate = self
        
        self.arrayTimes = CoreDataController.sharedIstanceCData.loadAllOrario(CoreDataController.sharedIstanceCData.dayOfTheWeek)
        self.tableView.reloadData()
    }
    
    // Detect the click on the tab element
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.tabBarIndex = tabBarController.selectedIndex
        
        var day = "Lunedì"
        switch tabBarIndex {
        case 0:
            day = "Lunedì"
            self.currentDay = "monday"
        case 1:
            day = "Martedì"
            self.currentDay = "tuesday"
        case 2:
            day = "Mercoledì"
            self.currentDay = "wednesday"
        case 3:
            day = "Giovedì"
            self.currentDay = "thursday"
        case 4:
            day = "Venerdì"
            self.currentDay = "friday"
        default:
            day = "Lunedì"
            self.currentDay = "monday"
        }
        
        self.tabBarController?.navigationItem.title = day
        
        let retrieveOrariofromCoreData = CoreDataController.sharedIstanceCData.loadAllOrario(currentDay)
        self.arrayTimes = retrieveOrariofromCoreData
        print(day)
        print(arrayTimes)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        //
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableCell", for: indexPath) as! TimeTableCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
//        cell.lesson.text = arrayOrario![indexPath.row].materia
//        cell.comment.text = arrayOrario![indexPath.row].commento
//        cell.dot.text = "."
//        cell.dot.textAlignment = .center
//        cell.start_hour.text = dateFormatter.string(from: arrayOrario![indexPath.row].data_inizio! as Date)
//        cell.end_hour.text = dateFormatter.string(from: arrayOrario![indexPath.row].data_termine! as Date)
        cell.lessonName.text = self.arrayTimes![indexPath.row].materia
        cell.lessonComment.text = self.arrayTimes![indexPath.row].commento
        cell.startingTime.text = dateFormatter.string(from: self.arrayTimes![indexPath.row].data_inizio! as Date)
        cell.endingTime.text = dateFormatter.string(from: self.arrayTimes![indexPath.row].data_termine! as Date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTimes!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.navigationItem.title = "Lunedi"
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
    }
}
