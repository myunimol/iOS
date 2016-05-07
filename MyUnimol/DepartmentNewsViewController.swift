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

class DepartmentNewsViewController: UIViewController, UITableViewDelegate {
    
    var news: DepartmentNews!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "DefaultNewsCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DefaultNewsCell")
        
        self.tableView.hidden = true
        ApiCall.getNews(self, table: self.tableView, kindOfNews: 1)
        
        self.news = DepartmentNews.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationItem.title = "Dipartimento"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news?.news?.newsList.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultNewsCell", forIndexPath: indexPath) as! DefaultNewsCell
        
        let news = self.news?.news?.newsList[indexPath.row]
        cell.title.text = news?.title
        cell.date.text = news?.date
        cell.body.text = news?.text
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }

    
}

