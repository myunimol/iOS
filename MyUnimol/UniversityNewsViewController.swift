//
//  UniversityNewsViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 19/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class UniversityNewsViewController: UIViewController, UITableViewDelegate {

    var news: NewsClass?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setTabNavigation("News", color: Utils.myUnimolBlue)
        
        self.tableView.hidden = true
        ApiCall.getNews(self, table: self.tableView, kindOfNews: 0)
        
        self.news = NewsClass.sharedInstance
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationItem.title = "News"
        self.navigationController?.navigationBar.barTintColor = Utils.myUnimolBlueUIColor
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tabBarController?.tabBar.tintColor = UIColor.blueColor()
        self.tabBarController?.tabBar.barTintColor = Utils.myUnimolBlueUIColor
        self.tabBarController?.tabBar.translucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news?.news?.newsList.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCell
        
        let news = self.news?.news?.newsList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
