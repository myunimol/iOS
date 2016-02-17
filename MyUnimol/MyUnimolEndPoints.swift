//
//  MyUnimolEndPoints.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation

struct MyUnimolEndPoints {
    static let BASE_URL = "https://myunimol.it/api/";
    static let TEST_CREDENTIALS = BASE_URL + "testCredentials"
    static let GET_EXAM_SESSIONS = BASE_URL + "getExamSessions"
    static let GET_ENROLLED_EXAMS = BASE_URL + "getEnrolledExams"
    static let ENROLL_EXAMS = BASE_URL + "enrollExam"
    static let GET_RECORD_BOOK = BASE_URL + "getRecordBook"
    //to be continue
}

struct MyUnimolToken {
    static let TOKEN = "7a8999400fd7787d259cfb949e731e97"
}
