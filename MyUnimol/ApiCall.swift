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
     Checks the network availability
     */
    static func isConnectionAvailable() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    /**
     Checks for credentials stored in `NSUserDefaults`
     - returns: a boolean value
     */
    static func areCredentialsStored() -> Bool {
        let (username, password) = CacheManager.getUserCredential()
        
        if (username == nil && password == nil) {
            return false
        } else {
            return true
        }
    }
    
    static func areCredentialsValid(username: String, password: String, caller: UIViewController) {
        
        let parameters = [
            "username"  : username,
            "password"  : password,
            "token"     : MyUnimolToken.TOKEN
        ]
        
        Utils.progressBarDisplayer(caller, msg: LoadSentences.getSentence(), indicator: true)
        
        Alamofire.request(.POST, MyUnimolEndPoints.TEST_CREDENTIALS, parameters: parameters)
            .responseJSON {response in
                
                Utils.removeProgressBar(caller)
                
                var statusCode: Int
                if let httpError = response.result.error {
                    statusCode = httpError.code
                } else {
                    statusCode = (response.response?.statusCode)!
                }
                print(statusCode)
                if (statusCode == 200) {
                    // store gathered data into the singleton
                    let student = Student.sharedInstance
                    let json = response.result.value as! JSON
                    student.studentInfo = StudentInfo(json: json)
                    
                    // put the data into the cache
                    CacheManager.storeLoginInformation(username, password: password)
                    CacheManager.storeJsonInCacheByKey(CacheManager.STUDENT_INFO_KEY, json: json)
                    
                    // segue to home page
                    caller.performSegueWithIdentifier("ViewController", sender: self)
                } else if (statusCode == 401) {
                    // credentials not valid
                    Utils.displayAlert(caller, title: "Oops!", message: "I tuoi dati di accesso sembrano errati")
                }
        }
    }
    
    static func loginAndFetchDataForHome(username: String, password: String, caller: UIViewController) {
        
        let parameters = [
            "username"  : username,
            "password"  : password,
            "token"     : MyUnimolToken.TOKEN
        ]
        
        Utils.progressBarDisplayer(caller, msg: LoadSentences.getSentence(), indicator: true)
        
        Alamofire.request(.POST, MyUnimolEndPoints.TEST_CREDENTIALS, parameters: parameters)
            .responseJSON {response in
                
                var statusCode: Int
                if let httpError = response.result.error {
                    statusCode = httpError.code
                } else {
                    statusCode = (response.response?.statusCode)!
                }
                print(statusCode)
                if (statusCode == 200) {
                    // store gathered data into the singleton
                    let student = Student.sharedInstance
                    let json = response.result.value as! JSON
                    student.studentInfo = StudentInfo(json: json)
                    
                    // put the data into the cache
                    CacheManager.storeLoginInformation(username, password: password)
                    CacheManager.storeJsonInCacheByKey(CacheManager.STUDENT_INFO_KEY, json: json)
                    
                    // also fetch data for Home Page
                    fetchDataForHome(username, password: password, caller: caller)
                    
                } else if (statusCode == 401) {
                    // credentials not valid
                    Utils.displayAlert(caller, title: "Oops!", message: "I tuoi dati di accesso sembrano errati")
                }
        }
    }
    
    static func fetchDataForHome(username: String, password: String, caller: UIViewController) {
        
        let parameters = [
            "username"  : username,
            "password"  : password,
            "token"     : MyUnimolToken.TOKEN
        ]
        
        Alamofire.request(.POST, MyUnimolEndPoints.GET_RECORD_BOOK, parameters: parameters)
            .responseJSON { response in
                
                Utils.removeProgressBar(caller)
                var statusCode : Int
                if let httpError = response.result.error {
                    statusCode = httpError.code
                } else {
                    statusCode = (response.response?.statusCode)!
                }
                
                if statusCode == 200 {
                    
                    // put the record book in singleton
                    let recordBook = RecordBook(json: response.result.value as! JSON)
                    let recordBookSingleton = RecordBookClass.sharedInstance
                    recordBookSingleton.recordBook = recordBook
                    
                    //TODO: implement cache management
                    
                    // segue to home page
                    caller.performSegueWithIdentifier("ViewController", sender: self)
                } else if statusCode == 401 {
                    Utils.displayAlert(caller, title: "Oops!", message: "Abbiamo qualche problema")
                }
        }
    }
}

