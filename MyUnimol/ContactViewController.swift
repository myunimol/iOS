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

class ContactViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var contacts: Array<Contact>?
    var contactsWrapper: Contacts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadContacts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
        
        let contact = self.contactsWrapper?.contacts?[indexPath.row]
        cell.name.text = contact?.fullname
        cell.telephone.text = contact?.externalTelephone
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    func loadContacts() {
        Contact.getAllContacts { contacts, error in
            guard error == nil else {
                //TODO: error implementation
                return
            }
            self.contactsWrapper = contacts
            self.tableView.reloadData()
        }
    }
    
}
