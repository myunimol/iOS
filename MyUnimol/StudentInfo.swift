//
//  StudentInfo.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss

public struct StudentInfo {
    
    let availableExams : Int?
    ///the course in which the student is enrolled
    let course : String?
    let courseLength : Int?
    ///the department of the student course
    let department : String?
    let enrolledExams : Int?
    let name : String?
    let surname : String?
    let registrationDate : String?
    ///the course and the year for the current student
    let studentClass : String?
    let studentId : String?
    
    init?(json: JSON) {
        self.availableExams = "availableExams" <~~ json
        self.course = "course" <~~ json
        self.courseLength = "courseLength" <~~ json
        self.department = "department" <~~ json
        self.enrolledExams = "enrolledExams" <~~ json
        
        let auxName: String? = "name" <~~ json
        self.name = auxName?.firstCharacterUpperCase()
        
        let auxSurname: String? = "surname" <~~ json
        self.surname = auxSurname?.firstCharacterUpperCase()
        
        self.surname?.firstCharacterUpperCase()
        self.registrationDate = "registrationDate" <~~ json
        self.studentClass = "studentClass" <~~ json
        self.studentId = "studentID" <~~ json
    }
}

public class Student {
    
    public static let sharedInstance = Student()
    
    public var studentInfo: StudentInfo?
    
    private init() { }
    
    public func getStudentCourse() -> String {
        return (self.studentInfo?.course)!
    }
    
    public func getStudentDepartment() -> String {
        return (self.studentInfo?.department)!
    }
    
}

extension String {
    func firstCharacterUpperCase() -> String {
        let lowercaseString = self.lowercaseString
        
        return lowercaseString.stringByReplacingCharactersInRange(lowercaseString.startIndex...lowercaseString.startIndex, withString: String(lowercaseString[lowercaseString.startIndex]).uppercaseString)
    }
}