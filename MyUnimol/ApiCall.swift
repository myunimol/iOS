//
//  ApiCall.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 18/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//


import UIKit
import Alamofire
import Gloss

/**
    A class which contains all static methods used to query the services from web server
*/
class ApiCall {
    
    /**
        Call the getTaxes service from server, instantiating the TaxClass singleton.
        Update the asyncronous the table passed as parameter
        
        - parameter calling: the UIViewController that send the request
        - parameter table: the table to update
    */
    static func getTaxes(calling: UIViewController, table: UITableView) {
        
        let (username, password) = Utils.getUsernameAndPassword()
        
        let parameters = [
            "username" : username,
            "password" : password,
            "token"    : MyUnimolToken.TOKEN
        ]
        
        Utils.progressBarDisplayer(calling, msg: "Wait for taxes", indicator: true)
        
        Alamofire.request(.POST, MyUnimolEndPoints.GET_TAXES, parameters: parameters)
            .responseJSON { response in
                
                Utils.removeProgressBar(calling)
                
                var statusCode : Int
                if let httpError = response.result.error {
                    statusCode = httpError.code
                } else {
                    statusCode = (response.response?.statusCode)!
                }
                
                print("Calling getTaxes! The response from server is: \(statusCode)")
                
                if (statusCode == 200) {
                    
                    let taxesSingleton = TaxClass.sharedInstance
                    taxesSingleton.taxes = Taxes(json: response.result.value as! JSON)
                    
                } else if (statusCode == 401) {
                    
                    Utils.displayAlert(calling, title: "Oops!", message: "Qualcosa di strano è successo")
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    table.reloadData()
                })
        }
    }
    
    /**
        Call the getNews service from server and instatiate the NewsClass singleton
        
        - parameter calling: the UIViewController that send the request
        - parameter table: the table to update
        - parameter kindOfNews: 0 calls the university news
                                1 calls the department news
                                2 calls the board news
    */
    static func getNews(calling: UIViewController, table: UITableView, kindOfNews: Int) {
        
        let (username, password) = Utils.getUsernameAndPassword()
        
        let parameters = [
            "username" : username,
            "password" : password,
            "token"    : MyUnimolToken.TOKEN
        ]
        
        Utils.progressBarDisplayer(calling, msg: "Wait for taxes", indicator: true)
        
        Alamofire.request(.POST, MyUnimolEndPoints.GET_TAXES, parameters: parameters)
            .responseJSON { response in
                
                Utils.removeProgressBar(calling)
                
                var statusCode : Int
                if let httpError = response.result.error {
                    statusCode = httpError.code
                } else {
                    statusCode = (response.response?.statusCode)!
                }
                
                print("Calling getNews! The response from server is: \(statusCode)")
                
                if (statusCode == 200) {
                    
                    let taxesSingleton = TaxClass.sharedInstance
                    taxesSingleton.taxes = Taxes(json: response.result.value as! JSON)
                    
                } else if (statusCode == 401) {
                    
                    Utils.displayAlert(calling, title: "Oops!", message: "Qualcosa di strano è successo")
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    table.reloadData()
                })
        }
    }

    
}

