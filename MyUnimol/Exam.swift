//
//  Exams.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 08/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss
import Alamofire

/// Info about an exam of the current session (already enrolled or not yet)
public struct SessionExam: Decodable {
    
    let name: String?
    let cfu: String?
    let professor: String?
    let date: NSDate?
    let expiringDate: NSDate?
    let room: String?
    let notes: String?
    let id: String?
    
    /// Enrollement position (only for enrolled exams)
    let enrollmentPosition: String?
    /// Total number of enrolled (only for enrolled ones)
    let enrolled: String?
    
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
        
        self.enrollmentPosition = "enrollmentPosition" <~~ json
        self.enrolled = "enrolled" <~~ json
    }
    
    public static func getSessionExams(completionHandler: (SessionExams?, NSError?) -> Void) {
        Alamofire.request(.POST, MyUnimolEndPoints.GET_EXAM_SESSIONS, parameters: ParameterHandler.getStandardParameters()).responseSessionExams { response in
            completionHandler(response.result.value, response.result.error)
        }
    }
    
    public static func getEnrolledExams(completionHandler: (SessionExams?, NSError?) -> Void) {
        Alamofire.request(.POST, MyUnimolEndPoints.GET_ENROLLED_EXAMS, parameters: ParameterHandler.getStandardParameters()).responseSessionExams { response in
            completionHandler(response.result.value, response.result.error)
        }
    }
}

/// Contains a list of `TodoExam` for the current section
public struct SessionExams {
    
    /// A list of all available exams
    var examsList = [SessionExam]()
    
    init(json: JSON) {
        self.examsList = [SessionExam].fromJSONArray(("exams" <~~ json)!)
    }
}

extension Alamofire.Request {
    func responseSessionExams(completionHandler: Response<SessionExams, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<SessionExams, NSError> { request, response, data, error in
            
            guard error == nil else {
                return .Failure(error!)
            }
            
            guard let responseData = data else {
                let failureReason = "Array could not be serialized because input data was nil"
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
            
            switch result {
            case .Success(let value):
                let exams: SessionExams = SessionExams(json: value as! JSON)
                return .Success(exams)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
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