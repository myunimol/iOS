//
//  ParameterHandler.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 07/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Foundation

open class ParameterHandler {
    
    open static func getParametersForBoardNews() -> [String : String] {
        return ["token" : MyUnimolToken.TOKEN,
                "course" : self.guessCourseParameter(Student.sharedInstance.getStudentCourse())]
    }
    
    open static func getParametersForDepartmentNews() -> [String : String] {
        return ["token" : MyUnimolToken.TOKEN,
                "department" : self.guessDepartmentParameter(Student.sharedInstance.getStudentDepartment())]
    }
    
    open static func getParameterForUniversityNews() -> [String : String] {
        return ["token" : MyUnimolToken.TOKEN]
    }
    
    /// Returns the stadard parameters for API (a `Dictionary` with username, password and token)
    open static func getStandardParameters() -> [String : String] {
        let (username, password) = CacheManager.sharedInstance.getUserCredential()
        
        if let careerId = CacheManager.sharedInstance.getCareer() {
            return ["username" : username!,
                    "password" : password!,
                    "token"    : MyUnimolToken.TOKEN,
                    "careerId" : careerId]
        } else {
            return ["username" : username!,
                    "password" : password!,
                    "token"    : MyUnimolToken.TOKEN]
        }
    }
    
    fileprivate class func guessDepartmentParameter(_ studentDepartment: String) -> String {
        var departmentParameter: String = ""
        
        if (studentDepartment.lowercased().range(of: "bioscienze") != nil) {
            departmentParameter = "bioscienzeTerritorio"
        } else if (studentDepartment.lowercased().range(of: "agricol") != nil) {
            departmentParameter = "agricolturaAmbienteAlimenti"
        } else if (studentDepartment.lowercased().range(of: "economia") != nil) {
            departmentParameter = "economiaGestioneSocietaIstituzioni"
        } else if (studentDepartment.lowercased().range(of: "giuridico") != nil) {
            departmentParameter = "giuridico"
        } else if (studentDepartment.lowercased().range(of: "medicina") != nil) {
            departmentParameter = "medicinaScienzeSalute"
        } else if (studentDepartment.lowercased().range(of: "umanistic") != nil) {
            departmentParameter = "scienzeUmanisticheSocialiFormazione"
        }
        return departmentParameter
    }
    
    fileprivate class func guessCourseParameter(_ studentCourse: String) -> String {
        var courseParameter: String = ""
        
        if (studentCourse.lowercased().range(of: "informatica") != nil) {
            courseParameter = "informatica"
        } else if (studentCourse.lowercased().range(of: "scienze biologiche lm") != nil) {
            courseParameter = "scienzeBiologicheMaster"
        } else if (studentCourse.lowercased().range(of: "scienze biologiche") != nil) {
            courseParameter = "scienzeBiologiche"
        } else if (studentCourse.lowercased().range(of: "medicina e chirurgia") != nil) {
            courseParameter = "medicina"
        } else if (studentCourse.lowercased().range(of: "economia aziendale") != nil) {
            courseParameter = "economia"
        } else if (studentCourse.lowercased().range(of: "scienze politiche istit europ") != nil) {
            courseParameter = "scienzePoliticheIstituzioniEuropee"
        } else if (studentCourse.lowercased().range(of: "sociale politiche sociali") != nil) {
            courseParameter = "servizioSocialePoliticheSociali"
        } else if (studentCourse.lowercased().range(of: "scienze politiche") != nil) {
            courseParameter = "scienzePolitiche"
        } else if (studentCourse.lowercased().range(of: "servizio sociale") != nil) {
            courseParameter = "scienzeServizioSociale"
        } else if (studentCourse.lowercased().range(of: "giurisprudenza") != nil) {
            courseParameter = "giurisprudenza"
        } else if (studentCourse.lowercased().range(of: "scienze tecnologie alimentari") != nil)  {
            courseParameter = "scienzeTecnologieAlimentari"
        } else if (studentCourse.lowercased().range(of: "agraria") != nil) {
            courseParameter = "agraria"
        } else if (studentCourse.lowercased().range(of: "tecnologie forestali ambientali") != nil) {
            courseParameter = "tecnologieForestaliAmbientali"
        } else if (studentCourse.lowercased().range(of: "lettere") != nil) {
            courseParameter = "lettere"
        } else if (studentCourse.lowercased().range(of: "scienze comunicazione") != nil) {
            courseParameter = "comunicazione"
        } else if (studentCourse.lowercased().range(of: "scienze formazione primaria") != nil) {
            courseParameter = "scienzeFormazionePrimaria"
        } else if (studentCourse.lowercased().range(of: "ingegneria edile") != nil) {
            courseParameter = "ingEdile"
        } else if (studentCourse.lowercased().range(of: "ingegneria civile lm") != nil) {
            courseParameter = "ingCivileMaster"
        } else if (studentCourse.lowercased().range(of: "ingegneria civile") != nil) {
            courseParameter = "ingCivile"
        } else if (studentCourse.lowercased().range(of: "scienze turistiche") != nil) {
            courseParameter = "scienzeTuristiche"
        } else if (studentCourse.lowercased().range(of: "turismo beni culturali") != nil) {
            courseParameter = "turismoBeniCulturali"
        }
        return courseParameter
    }
}
