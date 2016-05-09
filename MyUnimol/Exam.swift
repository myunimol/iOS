//
//  Exams.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 08/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss

///Contains info for an exam of the current session
public struct ExamSessionStruct: Decodable {
    
    let name: String?
    let cfu: String?
    let professor: String?
    let date: NSDate?
    let expiringDate: NSDate?
    let room: String?
    let notes: String?
    let id: String?
    
    public init?(json: JSON) {
        self.name = "name" <~~ json
        self.cfu = "cfu" <~~ json
        self.professor = "professor" <~~ json
        let auxDate: String? = "date" <~~ json
        self.date = auxDate?.stringToDate
        let auxExpiring: String? = "expiringDate" <~~ json
        self.expiringDate = auxExpiring?.stringToDate
        self.room = "room" <~~ json
        self.notes = "notes" <~~ json
        self.id = "id" <~~ json
    }
}

///Contains info for an enrolled exam
public struct EnrolledExamStruct: Decodable {
    
    let name: String?
    let cfu: String?
    let professor: String?
    let date: NSDate?
    let expiringDate: NSDate?
    let room: String?
    let enrollmentPosition: String?
    let enrolled: String?
    let notes: String?
    
    public init?(json: JSON) {
        self.name = "name" <~~ json
        self.cfu = "cfu" <~~ json
        self.professor = "professor" <~~ json
        let auxDate: String? = "date" <~~ json
        self.date = auxDate?.stringToDate
        let auxExpiring: String? = "expiringDate" <~~ json
        self.expiringDate = auxExpiring?.stringToDate
        self.room = "room" <~~ json
        self.enrollmentPosition = "enrollmentPosition" <~~ json
        self.enrolled = "enrolled" <~~ json
        self.notes = "notes" <~~ json
    }
}

///The list of available exams
public struct ExamSessionList {
    
    ///a list of all available exams
    var examsList = [ExamSessionStruct]()
    
    init(json: JSON) {
        self.examsList = [ExamSessionStruct].fromJSONArray(("exams" <~~ json)!)
    }
}

///The list of enrolled exams
public struct EnrolledExamsList {
    
    ///a list with all enrolled exams
    var examsList = [EnrolledExamStruct]()
    
    init(json: JSON) {
        self.examsList = [EnrolledExamStruct].fromJSONArray(("exams" <~~ json)!)
    }
}

///Singleton for the list of available exams
public class ExamsClass {
    
    public static let sharedInstance = ExamsClass()
    
    public var exams: ExamSessionList?
    
    private init() { }
}

///Singleton for the list of enrolled exams
public class EnrolledExamsClass {
    
    public static let sharedInstance = EnrolledExamsClass()
    
    public var exams: EnrolledExamsList?
    
    private init() { }
}

extension String {
    /**
     Returns a `NSDate` object from a given string, using the format dd/MM/yyyy
     - returns: a string value for the given date
    */
    var stringToDate: NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.dateFromString(self)
    }
}

extension NSDate {
    /**
     Returns a `String` for a given `NSDate` object, using the format dd/MM/yyyy
     - returns: a `NSDate` object for the given string
    */
    var dateToString: String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.stringFromDate(self)
    }
}