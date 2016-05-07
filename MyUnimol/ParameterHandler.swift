//
//  ParameterHandler.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 07/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation

public class ParameterHandler {
    
    ///Stores the parameter for course news API
    static let courseParameter = ["INFORMATICA" : "informatica",
                                  "SCIENZE BIOLOGICHE" : "scienzeBiologiche"]
    ///Stores the parameter for the department news API
    static let departmentParameter = ["INFORMATICA" : "bioscienzeTerritorio",
                                      "SCIENZE BIOLOGICHE" : "bioscienzeTerritorio"]
    
    public static func getParametersForBoardNews() -> [String : String] {
        return ["token" : MyUnimolToken.TOKEN,
                "course" : courseParameter[Student.sharedInstance.getStudentCourse()]!]
    }
    
    public static func getParametersForDepartmentNews() -> [String : String] {
        return ["token" : MyUnimolToken.TOKEN,
                "department" : departmentParameter[Student.sharedInstance.getStudentDepartment()]!]
    }
    
    public static func getParameterForUniversityNews() -> [String : String] {
        return ["token" : MyUnimolToken.TOKEN]
    }
    
}