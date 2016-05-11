//
//  ContactViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 08/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class ContactViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contacts: Array<Contact>?
    var contactsWrapper: Contacts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Rubrica", color: Utils.myUnimolBlue, style: UIBarStyle.Black)
        self.tableView.hidden = true
        self.loadContacts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsWrapper?.contacts?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
        
        let contact = self.contactsWrapper?.contacts?[indexPath.row]
        cell.name.text = contact?.fullname
        cell.telephone.text = contact?.externalTelephone
        cell.email.text = contact?.email  
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }

    func loadContacts() {
        Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
        Contact.getAllContacts { contacts, error in
            guard error == nil else {
                //TODO: error implementation
                return
            }
            self.contactsWrapper = contacts
            self.tableView.reloadData()
            self.tableView.hidden = false
            Utils.removeProgressBar(self)
        }
    }
    
}
