//
//  StudentInfo.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 09/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss
import Alamofire

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
    
    public static func getCredentials(username: String, password: String, completionHandler: (StudentInfo?, NSError?) -> Void) {
        let parameters = ["username" : username,
                          "password" : password,
                          "token"    : MyUnimolToken.TOKEN]
        
        Alamofire.request(.POST, MyUnimolEndPoints.TEST_CREDENTIALS, parameters: parameters)
            .responseCredentials(username, password: password) { response in
                completionHandler(response.result.value, response.result.error)
        }
    }
}

/// Singleton wich contains an istance of `StudentInfo`
public class Student {
    
    public static let sharedInstance = Student()
    
    public var studentInfo: StudentInfo?
    
    private init() { }
    
    /// Returns the student course
    public func getStudentCourse() -> String {
        return (self.studentInfo?.course)!
    }
    
    /// Returns the student department
    public func getStudentDepartment() -> String {
        return (self.studentInfo?.department)!
    }
    
}

extension Alamofire.Request {
    func responseCredentials(username: String, password: String, completionHandler: Response<StudentInfo, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<StudentInfo, NSError> { request, response, data, error in
            
            guard error == nil else {
                return .Failure(error!)
            }
            
            guard let responseData = data else {
                let failureReason = "Array could not be serialized because input data was nil"
                let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey: failureReason, Error.UserInfoKeys.StatusCode: response!.statusCode]
                let error = NSError(domain: Error.Domain, code: Error.Code.StatusCodeValidationFailed.rawValue, userInfo: userInfo)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)

            switch result {
            case .Success(let value):
                // stores credentials into NsUsersDefaults and info in singleton
                let studentInfo: StudentInfo = StudentInfo(json: value as! JSON)!
                CacheManager.sharedInstance.storeCredentials(username, password: password)
                CacheManager.sharedInstance.storeJsonInCacheByKey("studentInfo", json: value as! JSON)
                Student.sharedInstance.studentInfo = studentInfo
                return .Success(studentInfo)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

extension String {
    func firstCharacterUpperCase() -> String {
        let lowercaseString = self.lowercaseString
        
        return lowercaseString.stringByReplacingCharactersInRange(lowercaseString.startIndex...lowercaseString.startIndex, withString: String(lowercaseString[lowercaseString.startIndex]).uppercaseString)
    }
}