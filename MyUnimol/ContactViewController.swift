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
        Utils.setNavigationControllerStatusBar(self, title: "Rubrica", color: Utils.myUnimolBlue, style: UIBarStyle.black)
        self.tableView.isHidden = true
        self.configureSearchController()
        self.loadContacts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (shouldShowSearchResults) {
            return contactSearchResults?.count ?? 0
        } else {
            return self.contactsWrapper?.contacts?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func configureSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Cerca..."
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        //Place the search bar view to the tableView header view
        self.tableView.tableHeaderView = self.searchController.searchBar
    }
    
    func loadContacts() {
        Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
        Contact.getAllContacts { contacts in
            guard contacts != nil else {
            
                self.recoverFromCache { _ in
                    if (self.contactsWrapper != nil) {
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        Utils.removeProgressBar(self)
                    } else {
                        Utils.removeProgressBar(self)
                        Utils.displayAlert(self, title: "😨 Ooopss...", message: "Per qualche strano motivo non riusciamo a recuperare i tuoi contatti 😔")
                        Utils.goToMainPage()
                    }
                }
                
                return
            } // end error
            self.contactsWrapper = contacts
            self.tableView.reloadData()
            self.tableView.isHidden = false
            Utils.removeProgressBar(self)
        }
    }
    
    fileprivate func recoverFromCache(_ completion: @escaping (Void)-> Void) {
        CacheManager.sharedInstance.getJsonByString(CacheManager.CONTACTS) { json in
            if (json != nil) {
                self.contactsWrapper = Contacts(json: json!)
            }
            return completion()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = self.searchController.searchBar.text
        
        if (self.contactsWrapper?.contacts == nil) {
            self.contactSearchResults = nil
            return
        }
        self.contactSearchResults = self.contactsWrapper?.contacts!.filter({( aContact: Contact) -> Bool in
            return aContact.fullname!.lowercased().range(of: searchText!.lowercased()) != nil
        })
        
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        self.tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tableView.reloadData()
    }
    
    ///Delegate method that will display the search results and will resign the search field from first responder once the Search button in the keyboard gets tapped
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
}
