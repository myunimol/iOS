//
//  StudentInfo.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss
import Alamofire
import Foundation

open class StudentInfo {
    
    let availableExams      : Int?
    ///the course in which the student is enrolled
    let course              : String?
    let courseLength        : Int?
    ///the department of the student course
    let department          : String?
    let enrolledExams       : Int?
    let name                : String?
    let surname             : String?
    let registrationDate    : String?
    ///the course and the year for the current student
    let studentClass        : String?
    let studentId           : String?
    
    /// true if the API server returns a valid users; false otherwise
    var areCredentialsValid : Bool
    
    init?(json: JSON) {
        self.availableExams      = "availableExams" <~~ json
        self.course              = "course" <~~ json
        self.courseLength        = "courseLength" <~~ json
        self.department          = "department" <~~ json
        self.enrolledExams       = "enrolledExams" <~~ json
        
        let auxName: String?     = "name" <~~ json
        self.name                = auxName?.capitalized
        
        let auxSurname: String?  = "surname" <~~ json
        self.surname             = auxSurname?.capitalized
        
        self.registrationDate    = "registrationDate" <~~ json
        self.studentClass        = "studentClass" <~~ json
        self.studentId           = "studentID" <~~ json
        
        self.areCredentialsValid = true
        
        // Easter love egg
        if (self.surname == "Di Cristino") && (self.name == "Francesca") {
            self.surname! += " ❤️"
        }
        // Matt's Easter Eggs
        if (self.surname == "Merola") && (self.name == "Matteo") {
            self.surname! += " 🔝"
        }
        if (self.surname == "Grano") && (self.name == "Giovanni") {
            self.surname! += " 🇨🇱"
        }
    }
    
    // TODO: implement fetch from cache and background API
    open static func getCredentials(_ completionHandler: @escaping (StudentInfo?) -> Void) {
        
        CacheManager.sharedInstance.getJsonByString(CacheManager.STUDENT_INFO) { json in
            if (json != nil) {
                let studentInfo = StudentInfo(json: json!)
                Student.sharedInstance.studentInfo = studentInfo
                refresh()
                completionHandler(studentInfo)
            } else {
                Alamofire.request(MyUnimolEndPoints.TEST_CREDENTIALS, method: .post, parameters: ParameterHandler.getStandardParameters())
                    .responseCredentials { response in
                        completionHandler(response.value!)
                } // newtwork call
            }
        } //end get from cache
    }
    
    fileprivate static func refresh() {
        Alamofire.request(MyUnimolEndPoints.TEST_CREDENTIALS, method: .post, parameters: ParameterHandler.getStandardParameters())
            .responseCredentials { _ in }
    }
}


/// Singleton wich contains an istance of `StudentInfo`
open class Student {
    
    open static let sharedInstance = Student()
    
    open var studentInfo: StudentInfo?
    
    fileprivate init() { }
    
    /// Returns the student course
    open func getStudentCourse() -> String {
        return (self.studentInfo?.course)!
    }
    
    /// Returns the student department
    open func getStudentDepartment() -> String {
        return (self.studentInfo?.department)!
    }
    
}

extension Alamofire.DataRequest {
    func responseCredentials(_ completionHandler: @escaping (DataResponse<StudentInfo>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<StudentInfo> { request, response, data, error in
            
            guard error == nil else {
                return .failure(BackendError.network(error: error!))
            }
            
//            guard let responseData = data else {
//                let failureReason = "Array could not be serialized because input data was nil"
//                let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey: failureReason, Error.UserInfoKeys.StatusCode: response!.statusCode]
//                let error = NSError(domain: Error.Domain, code: Error.Code.StatusCodeValidationFailed.rawValue, userInfo: userInfo)
//                return .Failure(error)
//            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            switch result {
            case .success(let value):
                let api: APIMessage = APIMessage(json: value as! JSON)!
                let studentInfo: StudentInfo = StudentInfo(json: value as! JSON)!
                if api.result != "failure" {
                    // successfull login; store credentials in cache
                    CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.STUDENT_INFO, json: value as! JSON)
                    Student.sharedInstance.studentInfo = studentInfo
                } else {
                    // login failed
                    studentInfo.areCredentialsValid = false
                }
                return .success(studentInfo)
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
