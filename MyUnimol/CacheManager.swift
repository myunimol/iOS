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

/// A singleton class which handles caching
class CacheManager {
    
    /// the `CacheManager` singleton object
    static let sharedInstance = CacheManager()
    
    fileprivate let cache = Cache<Gloss.JSON>(name: "myUnimolCache")
    
    fileprivate let userDefaults = UserDefaults.standard
    
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
    /// key for careers cache
    static let CAREERS = "careers"
    
    init() {}
    
    // Stores the credentials in NSUserDefaults
    internal func storeCredentials(_ username: String, password: String) {
        self.userDefaults.set(username, forKey: "username")
        self.userDefaults.set(password, forKey: "password")
    }
    
    /// Resets the users credentials
    internal func resetCredentials() {
        self.userDefaults.set(nil, forKey: "username")
        self.userDefaults.set(nil, forKey: "password")
        self.userDefaults.set(nil, forKey: CacheManager.CAREERS)
    }
    
    // Returns user credentials, if stored; otherwise returns nil
    internal func getUserCredential() -> (String?, String?) {
        let username = self.userDefaults.object(forKey: "username") as? String
        let password = self.userDefaults.object(forKey: "password") as? String
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
    
    /// Stores the user default career in `NSUserDefaults`
    internal func storeCareer(_ careerId: String) {
        self.userDefaults.set(careerId, forKey: CacheManager.CAREERS)
    }
    
    /// Gets the user default career in `NSUserDefaults`
    internal func getCareer() -> (String?) {
        let career = self.userDefaults.object(forKey: CacheManager.CAREERS) as? String
        return career
    }
    
    /// Store a `Gloss.JSON` into `NSUserDefaults` for a given key
    internal func storeJsonInCacheByKey(_ key: String, json: Gloss.JSON) {
        self.cache.set(value: json, key: key)
    }
    
    /// Returns a `Gloss.JSON` object for a given key
    internal func getJsonByString(_ key: String, completionHandler: @escaping (_ json: Gloss.JSON?) -> Void) {
        self.cache.fetch(key: key).onSuccess { json in
            return completionHandler(json)
            }.onFailure { error in
                return completionHandler(nil)
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
    
    public static func convertFromData(_ data:Data) -> Result? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Dictionary
    }
    
    public func asData() -> Data! {
        return NSKeyedArchiver.archivedData(withRootObject: self as AnyObject)
    }
}
