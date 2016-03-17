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
        
        self.name = Decoder.getExamName("name", json: json)
        self.cfu = "cfu" <~~ json
        self.vote = "vote" <~~ json
        self.date = "date" <~~ json
        self.year = "year" <~~ json
        self.id = "id" <~~ json
    }
}

extension Decoder {
    
    static func getExamName(key: String, json: JSON) -> (String) {
        let string = json.valueForKeyPath(key) as? String
        if string!.containsString(" - ") {
            var idAndName = string!.componentsSeparatedByString(" - ")
            return (idAndName[1])
        } else {
            return string!
        }
    }
}

extension String {
    struct NumberFormatter {
        static let instance = NSNumberFormatter()
    }
    var doubleValue:Double? {
        return NumberFormatter.instance.numberFromString(self)?.doubleValue
    }
    var integerValue:Int? {
        return NumberFormatter.instance.numberFromString(self)?.integerValue
    }
}

public struct RecordBook {

    let average : Double?
    var exams = [Exam]()
    let weightedAverage : String?
    
    // exams with a numeric grade
    var examsGrades = [Int]()
    // progression of final starting degree
    var staringDegree = [Int]()
    
    var totalCFU : Int = 0
    
    init(json: JSON) {
        self.average = "average" <~~ json
        self.exams = [Exam].fromJSONArray(("exams" <~~ json)!)
        self.weightedAverage = "weightedAverage" <~~ json
        
        self.exams.sortInPlace(orderExamsByDate)
        
        var cfuCounter = 0
        var accumulator = 0
        
        for exam in self.exams {
            self.totalCFU += exam.cfu!
            if let grade = exam.vote?.integerValue {
                cfuCounter += exam.cfu!
                accumulator += exam.cfu! * grade
                
                self.examsGrades.append(grade)
                let currentAverage = (Double(accumulator) / Double(cfuCounter))
                
                self.staringDegree.append(Int((currentAverage * 11) / 3))
            }
        }
    }
    
    func orderExamsByDate(exam1: Exam, exam2: Exam) -> Bool {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let date1 = dateFormatter.dateFromString(exam1.date!)
        let date2 = dateFormatter.dateFromString(exam2.date!)
        
        return date1?.timeIntervalSince1970 < date2?.timeIntervalSince1970

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


