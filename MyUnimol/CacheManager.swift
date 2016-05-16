//
//  CacheManager.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 03/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation
import Gloss
import AwesomeCache

class CacheManager {
    
    static let STUDENT_INFO_KEY = "studentInfo"
    
    // Stores the credentials in NSUserDefaults
    static func storeCredentials(username: String, password: String) {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
    }
    
    /// Resets the users credentials
    static func resetCredentials() {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "password")
    }

    // Returns user credentials, if stored; otherwise returns nil
    static func getUserCredential() -> (String?, String?) {
        let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String
        let password = NSUserDefaults.standardUserDefaults().objectForKey("password") as? String
        return (username, password)
    }
    
    /// Checks if there are some credentials stored in NSUserDefaults
    static func areCredentialsStored() -> Bool {
        let (username, password) = self.getUserCredential()
        if (username != nil && password != nil) {
            return true
        }
        return false
    }
    
    /**
     Store a json response from server into `NSUserDefaults` for a given key
     - parameter key: the key
     - parameter json: the object to store
    */
    func storeJsonInCacheByKey(key: String, json: Gloss.JSON) {
        NSUserDefaults.standardUserDefaults().setObject(json, forKey: key)
    }
    
    /** 
     Get the `JSON` from `NSUserDefaults` for the key passed as parameter
     - parameter key: the key
    */
    static func getJsonFromCacheByKey(key: String) -> Gloss.JSON? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key) as? Gloss.JSON
    }
}