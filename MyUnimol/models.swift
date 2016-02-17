//
//  models.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 11/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss

struct StudentInfo {
    
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
        self.studentId = "studentId" <~~ json
    }

}
