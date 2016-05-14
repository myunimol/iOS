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

class ContactViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactsWrapper: Contacts?
    var contactSearchResults: Array<Contact>?
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setNavigationControllerStatusBar(self, title: "Rubrica", color: Utils.myUnimolBlue, style: UIBarStyle.Black)
        self.tableView.hidden = true
        self.configureSearchController()
        self.loadContacts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (shouldShowSearchResults) {
            return contactSearchResults?.count ?? 0
        } else {
            return self.contactsWrapper?.contacts?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactCell
        
        var contact: Contact?
        if (shouldShowSearchResults) {
            contact = self.contactSearchResults![indexPath.row]
        } else {
            contact = self.contactsWrapper?.contacts?[indexPath.row]
        }
        cell.name.text = contact?.fullname
        cell.telephone.text = "📞 " + (contact?.externalTelephone)!
        cell.email.text = "📧 " + (contact?.email)!
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func configureSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Ricerca qui..."
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        //Place the search bar view to the tableView header view
        self.tableView.tableHeaderView = self.searchController.searchBar
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
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = self.searchController.searchBar.text
        
        if (self.contactsWrapper?.contacts == nil) {
            self.contactSearchResults = nil
            return
        }
        self.contactSearchResults = self.contactsWrapper?.contacts!.filter({( aContact: Contact) -> Bool in
            return aContact.fullname!.lowercaseString.rangeOfString(searchText!.lowercaseString) != nil
        })

        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        self.tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tableView.reloadData()
    }
    
    ///Delegate method that will display the search results and will resign the search field from first responder once the Search button in the keyboard gets tapped
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
}
