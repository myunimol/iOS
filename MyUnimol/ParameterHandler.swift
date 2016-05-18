//
//  ParameterHandler.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 07/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation

public class ParameterHandler {
    
    public static func getParametersForBoardNews() -> [String : String] {
        return ["token" : MyUnimolToken.TOKEN,
                "course" : self.guessCourseParameter(Student.sharedInstance.getStudentCourse())]
    }
    
    public static func getParametersForDepartmentNews() -> [String : String] {
        return ["token" : MyUnimolToken.TOKEN,
                "department" : self.guessDepartmentParameter(Student.sharedInstance.getStudentDepartment())]
    }
    
    public static func getParameterForUniversityNews() -> [String : String] {
        return ["token" : MyUnimolToken.TOKEN]
    }
    
    /// Returns the stadard parameters for API (a `Dictionary` with username, password and token)
    public static func getStandardParameters() -> [String : String] {
        let (username, password) = CacheManager.sharedInstance.getUserCredential()
        
        return ["username" : username!,
                "password" : password!,
                "token"    : MyUnimolToken.TOKEN]
    }
    
    private class func guessDepartmentParameter(studentDepartment: String) -> String {
        var departmentParameter: String = ""
        
        if (studentDepartment.lowercaseString.rangeOfString("bioscienze") != nil) {
            departmentParameter = "bioscienzeTerritorio"
        } else if (studentDepartment.lowercaseString.rangeOfString("agricol") != nil) {
            departmentParameter = "agricolturaAmbienteAlimenti"
        } else if (studentDepartment.lowercaseString.rangeOfString("economia") != nil) {
            departmentParameter = "economiaGestioneSocietaIstituzioni"
        } else if (studentDepartment.lowercaseString.rangeOfString("giuridico") != nil) {
            departmentParameter = "giuridico"
        } else if (studentDepartment.lowercaseString.rangeOfString("medicina") != nil) {
            departmentParameter = "medicinaScienzeSalute"
        } else if (studentDepartment.lowercaseString.rangeOfString("umanistic") != nil) {
            departmentParameter = "scienzeUmanisticheSocialiFormazione"
        }
        return departmentParameter
    }
    
    private class func guessCourseParameter(studentCourse: String) -> String {
        var courseParameter: String = ""
        
        if (studentCourse.lowercaseString.rangeOfString("informatica") != nil) {
            courseParameter = "informatica"
        } else if (studentCourse.lowercaseString.rangeOfString("scienze biologiche lm") != nil) {
            courseParameter = "scienzeBiologicheMaster"
        } else if (studentCourse.lowercaseString.rangeOfString("scienze biologiche") != nil) {
            courseParameter = "scienzeBiologiche"
        } else if (studentCourse.lowercaseString.rangeOfString("medicina chirurgia") != nil) {
            courseParameter = "medicina"
        } else if (studentCourse.lowercaseString.rangeOfString("economia aziendale") != nil) {
            courseParameter = "economia"
        } else if (studentCourse.lowercaseString.rangeOfString("scienze politiche istit europ") != nil) {
            courseParameter = "scienzePoliticheIstituzioniEuropee"
        } else if (studentCourse.lowercaseString.rangeOfString("sociale politiche sociali") != nil) {
            courseParameter = "servizioSocialePoliticheSociali"
        } else if (studentCourse.lowercaseString.rangeOfString("scienze politiche") != nil) {
            courseParameter = "scienzePolitiche"
        } else if (studentCourse.lowercaseString.rangeOfString("servizio sociale") != nil) {
            courseParameter = "scienzeServizioSociale"
        } else if (studentCourse.lowercaseString.rangeOfString("giurisprudenza") != nil) {
            courseParameter = "giurisprudenza"
        } else if (studentCourse.lowercaseString.rangeOfString("scienze tecnologie alimentari") != nil)  {
            courseParameter = "scienzeTecnologieAlimentari"
        } else if (studentCourse.lowercaseString.rangeOfString("agraria") != nil) {
            courseParameter = "agraria"
        } else if (studentCourse.lowercaseString.rangeOfString("tecnologie forestali ambientali") != nil) {
            courseParameter = "tecnologieForestaliAmbientali"
        } else if (studentCourse.lowercaseString.rangeOfString("lettere") != nil) {
            courseParameter = "lettere"
        } else if (studentCourse.lowercaseString.rangeOfString("scienze comunicazione") != nil) {
            courseParameter = "comunicazione"
        } else if (studentCourse.lowercaseString.rangeOfString("scienze formazione primaria") != nil) {
            courseParameter = "scienzeFormazionePrimaria"
        } else if (studentCourse.lowercaseString.rangeOfString("ingegneria edile") != nil) {
            courseParameter = "ingEdile"
        } else if (studentCourse.lowercaseString.rangeOfString("ingegneria civile lm") != nil) {
            courseParameter = "ingCivileMaster"
        } else if (studentCourse.lowercaseString.rangeOfString("ingegneria civile") != nil) {
            courseParameter = "ingCivile"
        } else if (studentCourse.lowercaseString.rangeOfString("scienze turistiche") != nil) {
            courseParameter = "scienzeTuristiche"
        } else if (studentCourse.lowercaseString.rangeOfString("turismo beni culturali") != nil) {
            courseParameter = "turismoBeniCulturali"
        }
        return courseParameter
    }
}