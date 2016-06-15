//
//  CacheManager.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 03/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation
import Gloss
import Haneke

class CacheManager {
    
    static let sharedInstance = CacheManager()
    
    private let cache = Cache<Gloss.JSON>(name: "myUnimolCache")
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    /// key for student info cache
    static let STUDENT_INFO = "studentInfo"
    /// key for record book cache
    static let RECORD_BOOK = "recordBook"
    /// key for available exams cache
    static let EXAMS_AVAILABLE = "examsAvailable"
    /// key for enrolled exams cache
    static let EXAMS_ENROLLED = "examsEnrolled"
    /// key for tax cache
    static let TAX = "tax"
    /// key for board news cache
    static let BOARD_NEWS = "boardNews"
    /// key for department news cache
    static let DEPARTMENT_NEWS = "departmentNews"
    /// key for university news cache
    static let UNIVERSITY_NEWS = "universityNews"
    /// key for contacts cache
    static let CONTACTS = "contacts"
    
    init() {}
        
    // Stores the credentials in NSUserDefaults
    internal func storeCredentials(username: String, password: String) {
        self.userDefaults.setObject(username, forKey: "username")
        self.userDefaults.setObject(password, forKey: "password")
    }
    
    /// Resets the users credentials
    internal func resetCredentials() {
        self.userDefaults.setObject(nil, forKey: "username")
        self.userDefaults.setObject(nil, forKey: "password")
    }

    // Returns user credentials, if stored; otherwise returns nil
    internal func getUserCredential() -> (String?, String?) {
        let username = self.userDefaults.objectForKey("username") as? String
        let password = self.userDefaults.objectForKey("password") as? String
        return (username, password)
    }
    
    /// Checks if there are some credentials stored in NSUserDefaults
    internal func areCredentialsStored() -> Bool {
        let (username, password) = self.getUserCredential()
        if (username != nil && password != nil) {
            return true
        }
        return false
    }
    
    /// Store a `Gloss.JSON` into `NSUserDefaults` for a given key
    internal func storeJsonInCacheByKey(key: String, json: Gloss.JSON) {
        self.cache.set(value: json, key: key)
    }
    
    /// Returns a `Gloss.JSON` object for a given key
    internal func getJsonByString(key: String, completionHandler: (json: Gloss.JSON) -> Void) {
        self.cache.fetch(key: key).onSuccess { json in
            return completionHandler(json: json)
        }
    }
    
    /// Refresh the cache
    internal func refreshCache() {
        self.cache.removeAll()
    }
}

/// Adding support for `Dictionary` to Haneke
extension Dictionary : DataConvertible, DataRepresentable {
    
    public typealias Result = Dictionary
    
    public static func convertFromData(data:NSData) -> Result? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Dictionary
    }
    
    public func asData() -> NSData! {
        return NSKeyedArchiver.archivedDataWithRootObject(self as! AnyObject)
    }
}