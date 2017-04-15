//
//  DepartmentNewsViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 19/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss
import SafariServices

class DepartmentNewsViewController: UIViewController, UITableViewDelegate {
    
    //var news: DepartmentNews!
    var news: Array<News>?

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DefaultNewsCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DefaultNewsCell")
        
        self.tableView.isHidden = true
        self.loadNews()
    }
    
    func loadNews() {
        Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
        News.getDepartmentNews { news in
            guard news != nil else {
                
                self.recoverFromCache { _ in
                    if (self.news != nil) {
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        Utils.removeProgressBar(self)
                    } else {
                        Utils.removeProgressBar(self)
                        Utils.displayAlert(self, title: "😨 Ooopss...", message: "Per qualche strano motivo non riusciamo a recuperare le news del dipartimento 😔")
                        Utils.goToMainPage()
                    }
                }
                
                return
                
            } // end errors
            self.news = news?.newsList
            if (self.news?.count == 0) {
                self.tableView.isHidden = true
                Utils.setPlaceholderForEmptyTable(self, message: "Nulla da segnalare al momento! 😎")
            } else {
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
            Utils.removeProgressBar(self)
        }
    }
    
    fileprivate func recoverFromCache(_ completion: @escaping (Void)-> Void) {
        CacheManager.sharedInstance.getJsonByString(CacheManager.DEPARTMENT_NEWS) { json in
            if (json != nil) {
                let auxNews: NewsList = NewsList(json: json!)
                self.news = auxNews.newsList
            }
            return completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Dipartimento"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let svc = SFSafariViewController(url: URL(string: (self.news?[indexPath.row].link)!)!)
        self.present(svc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultNewsCell", for: indexPath) as! DefaultNewsCell
        
        let news = self.news?[indexPath.row]
        cell.title.text = news?.title
        cell.date.text = news?.date
        cell.body.text = news?.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    
}

