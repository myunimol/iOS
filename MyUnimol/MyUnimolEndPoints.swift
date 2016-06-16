//
//  MyUnimolEndPoints.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation

/// stores all the endpoint for API calls
struct MyUnimolEndPoints {
    
    /// the base URL
    static let BASE_URL             =               "https://myunimol.it/api/"
    
    /// test the credentials and returns the basic information about the student
    static let TEST_CREDENTIALS     = BASE_URL  +   "testCredentials"
    
    /// fetchs all the exams availble fot the current exam session
    static let GET_EXAM_SESSIONS    = BASE_URL  +   "getExamSessions"
    
    /// fetchs the exams for wich a student is enrolled
    static let GET_ENROLLED_EXAMS   = BASE_URL  +   "getEnrolledExams"
    
    /// api for the list of enrolled exams
    static let ENROLL_EXAMS         = BASE_URL  +   "enrollExam"
    
    /// api for the student record book
    static let GET_RECORD_BOOK      = BASE_URL  +   "getRecordBook"
    
    /// api for all contacts
    static let GET_ADDRESS_BOOK     = BASE_URL  +   "getAddressBook"
    
    static let SEARCH_CONTACTS      = BASE_URL  +   "searchContacts"
    
    /// api for the student taxes
    static let GET_TAXES            = BASE_URL  +   "getTaxes"
    
    /// api for university news
    static let GET_UNIVERSITY_NEWS  = BASE_URL  +   "getUniversityNews"
    
    /// api for department news
    static let GET_DEPARTMENT_NEWS  = BASE_URL  +   "getDepartmentNews"
    
    /// api for student course news
    static let GET_NEWS_BOARD       = BASE_URL  +   "getNewsBoard"
    
    /// api for student careers
    static let GET_CAREERS          = BASE_URL  +   "listCareers"
}

/// stores some token valid to access to APIs
struct MyUnimolToken {
    /// the token used to access webservices APIs
    static let TOKEN = "7a8999400fd7787d259cfb949e731e97"
}
