//
//  MyUnimolEndPoints.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation

struct MyUnimolEndPoints {
    static let BASE_URL             =               "https://myunimol.it/api/"
    static let TEST_CREDENTIALS     = BASE_URL  +   "testCredentials"
    ///Fetchs all the exams availble fot the current exam session
    static let GET_EXAM_SESSIONS    = BASE_URL  +   "getExamSessions"
    ///Fetchs the exams for wich a student is enrolled
    static let GET_ENROLLED_EXAMS   = BASE_URL  +   "getEnrolledExams"
    static let ENROLL_EXAMS         = BASE_URL  +   "enrollExam"
    static let GET_RECORD_BOOK      = BASE_URL  +   "getRecordBook"
    static let GET_ADDRESS_BOOK     = BASE_URL  +   "getAddressBook"
    static let SEARCH_CONTACTS      = BASE_URL  +   "searchContacts"
    static let GET_TAXES            = BASE_URL  +   "getTaxes"
    static let GET_UNIVERSITY_NEWS  = BASE_URL  +   "getUniversityNews";
    static let GET_DEPARTMENT_NEWS  = BASE_URL  +   "getDepartmentNews";
    ///EndPoint for the news about the student course
    static let GET_NEWS_BOARD       = BASE_URL  +   "getNewsBoard";
}

struct MyUnimolToken {
    ///The token used to access webservices APIs
    static let TOKEN = "7a8999400fd7787d259cfb949e731e97"
}
