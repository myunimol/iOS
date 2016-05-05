//
//  CacheManager.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 03/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation
import Gloss

class CacheManager {
    
    static let STUDENT_INFO_KEY = "studentInfo"
    
    /**
     Stores the user credentials in the permanent cache
     - parameter username: the username
     - parameter password: the password
    */
    static func storeLoginInformation(username: String, password: String) {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
    }
    
    /**
     Resets the user credentials
    */
    static func resetLoginInformation() {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "password")
    }

    /**
     Returns the user credential, if stored the permanent cache; otherwise, it returns null values
     - returns: `(String?, String?)`, a tuple for username and password
    */
    static func getUserCredential() -> (String?, String?) {
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String
        let password = NSUserDefaults.standardUserDefaults().objectForKey("password") as? String
        return (username, password)
    }
    
    /**
     Store a json response from server into `NSUserDefaults` for a given key
     - parameter key: the key
     - parameter json: the object to store
    */
    static func storeJsonInCacheByKey(key: String, json: Dictionary<String, AnyObject>) {
        NSUserDefaults.standardUserDefaults().setObject(json, forKey: key)
    }
    
    static func storeStudentInfo(student: Dictionary<String, AnyObject>) {
        NSUserDefaults.standardUserDefaults().setObject(student, forKey: "studentInfo")
    }
    
    /** 
     Get the `JSON` from `NSUserDefaults` for the key passed as parameter
     - parameter key: the key
    */
    static func getJsonFromCacheByKey(key: String) -> JSON? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key) as? JSON
    }
    
    
    
}