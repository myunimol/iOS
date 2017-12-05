//
//  TaxesViewController.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 17/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import UIKit
import Alamofire
import Gloss


class TaxesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var taxes: Array<Tax>?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.setNavigationControllerStatusBar(self, title: "Pagamenti", color: Utils.myUnimolBlue, style: UIBarStyle.black)
        
        self.tableView.isHidden = true
        self.loadTaxes()
    }
    
    func loadTaxes() {
        Utils.progressBarDisplayer(self, msg: LoadSentences.getSentence(), indicator: true)
        Tax.getAllTaxes { taxes in
            guard taxes != nil else {
                
                self.recoverFromCache { 
                    if (self.taxes != nil) {
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        Utils.removeProgressBar(self)
                    } else {
                        Utils.removeProgressBar(self)
                        Utils.displayAlert(self, title: "😨 Ooopss...", message: "Per qualche strano motivo non riusciamo a recuperare le info sulle tasse pagate 😔")
                        Utils.goToMainPage()
                    }
                }
                
                return
                
            } // end errors
            self.taxes = taxes?.taxes
            if (self.taxes?.count == 0) {
                self.tableView.isHidden = true
                Utils.setPlaceholderForEmptyTable(self, message: "Niente soldi da sborsare per ora! 😎")
            } else {
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
            Utils.removeProgressBar(self)
        }
    }
        
    fileprivate func recoverFromCache(_ completion: @escaping ()-> Void) {
        CacheManager.sharedInstance.getJsonByString(CacheManager.TAX) { json in
            if (json != nil) {
                let auxTaxes: Taxes = Taxes(json: json!)
                self.taxes = auxTaxes.taxes
            }
            return completion()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taxes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaxesCell", for: indexPath) as! TaxesCell
        
        let tax = self.taxes?[indexPath.row]
        
        cell.billId.text = tax!.billId! + " - " + tax!.description!
        cell.accademicYear.text = "Anno accademico: " + tax!.year!
        cell.deadlineDate.text = "Data scadenza: " + tax!.expiringDate!
        
        cell.amount.text = "€ " + String(format: "%.2f", tax!.amount!)
        
        cell.view.layer.cornerRadius = cell.view.frame.size.height/2
        cell.view.layer.masksToBounds = true
        
        if (tax?.statusPayment == "pagato") {
            cell.view.backgroundColor = UIColor.green
        } else {
            cell.view.backgroundColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
