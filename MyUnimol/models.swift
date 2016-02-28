//
//  models.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 11/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss

public struct StudentInfo {
    
    let availableExams : Int?
    let course : String?
    let courseLength : Int?
    let department : String?
    let enrolledExams : Int?
    let name : String?
    let surname : String?
    let registrationDate : String?
    let studentClass : String?
    let studentId : String?
    
    init?(json: JSON) {
        self.availableExams = "availableExams" <~~ json
        self.course = "course" <~~ json
        self.courseLength = "courseLength" <~~ json
        self.department = "department" <~~ json
        self.enrolledExams = "enrolledExams" <~~ json
        self.name = "name" <~~ json
        self.surname = "surname" <~~ json
        self.registrationDate = "registrationDate" <~~ json
        self.studentClass = "studentClass" <~~ json
        self.studentId = "studentID" <~~ json
    }
}

public struct Exam: Decodable {
    
    let name : String?
    let cfu : Int?
    let vote : String?
    let date : String?
    let year : String?
    let id : String?

    public init?(json: JSON) {
        self.name = "name" <~~ json
        self.cfu = "cfu" <~~ json
        self.vote = "vote" <~~ json
        self.date = "date" <~~ json
        self.year = "year" <~~ json
        self.id = "id" <~~ json
    }
}

public struct RecordBook {
    
    let average : String?
    var exams = [Exam]()
    let weightedAverage : String?
    
    init(json: JSON) {
        self.average = "average" <~~ json
        self.exams = [Exam].fromJSONArray(("exams" <~~ json)!)
        self.weightedAverage = "weightedAverage" <~~ json
    }
    
}


public class Student {
    
    public static let sharedInstance = Student()
    
    public var studentInfo: StudentInfo?
    
    private init() { }
    
}

public class RecordBookClass {
    
    public static let sharedInstance = RecordBookClass()
    
    public var recordBook: RecordBook?
    
    private init() { }
}


