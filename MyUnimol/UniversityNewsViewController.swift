//
//  BoardNewsViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 19/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss
import SafariServices

class UniversityNewsViewController: UIViewController, UITableViewDelegate {
    
    var news: Array<News>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "DefaultNewsCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DefaultNewsCell")
        
        self.tableView.hidden = true
        self.loadNews()
    }
    
    func loadNews() {
        Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
        News.getUniversityNews { news, error in
            guard error == nil else {
                //TODO: error implementation
                return
            }
            self.news = news?.newsList
            if (self.news?.count == 0) {
                self.tableView.hidden = true
                Utils.setPlaceholderForEmptyTable(self, message: "Nulla da segnalare al momento!")
            } else {
                self.tableView.reloadData()
                self.tableView.hidden = false
            }
            Utils.removeProgressBar(self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationItem.title = "Ateneo"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let svc = SFSafariViewController(URL: NSURL(string: (self.news?[indexPath.row].link)!)!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultNewsCell", forIndexPath: indexPath) as! DefaultNewsCell
        
        let news = self.news?[indexPath.row]
        cell.title.text = news?.title
        cell.date.text = news?.date
        cell.body.text = news?.text
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }

    
}
