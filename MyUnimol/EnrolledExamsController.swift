//
//  EnrolledExamsController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 08/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class EnrolledExamsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var exams: Array<SessionExam>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DefaultExamCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DefaultExamCell")
        
        self.tableView.isHidden = true
        self.loadExams()
    }
    
    func loadExams() {
        Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
        SessionExam.getEnrolledExams { exams in
            guard exams != nil else {
                
                self.recoverFromCache { 
                    if (self.exams != nil) {
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        Utils.removeProgressBar(self)
                    } else {
                        Utils.removeProgressBar(self)
                        Utils.displayAlert(self, title: "😨 Ooopss...", message: "Per qualche strano motivo non riusciamo a recuperare gli esami disponibili 😔")
                        Utils.goToMainPage()
                    }
                }
                
                return

            } // end error
            self.exams = exams?.examsList
            if (self.exams?.count == 0) {
                self.tableView.isHidden = true
                Utils.setPlaceholderForEmptyTable(self, message: "Non ci sono appelli prenotati")
            } else {
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
            Utils.removeProgressBar(self)
        }
    }
    
    fileprivate func recoverFromCache(_ completion: @escaping ()-> Void) {
        CacheManager.sharedInstance.getJsonByString(CacheManager.EXAMS_ENROLLED) { json in
            if (json != nil) {
                let auxExams: SessionExams = SessionExams(json: json!)
                self.exams = auxExams.examsList
            }
            return completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Prenotati"
        self.navigationController?.navigationBar.barTintColor = Utils.myUnimolBlueUIColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = Utils.myUnimolBlueUIColor
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exams?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultExamCell", for: indexPath) as! DefaultExamCell
        
        let exam = self.exams?[indexPath.row]
        cell.examName.text = exam?.name
        cell.professor.text = exam?.professor
        cell.examDate.text = exam?.date?.dateToString
        cell.expiringDate.text = exam?.expiringDate?.dateToString
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}
