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
    
    let name               : String?
    let cfu                : String?
    let professor          : String?
    let date               : Date?
    let expiringDate       : Date?
    let room               : String?
    let notes              : String?
    let id                 : String?
    
    /// Enrollement position (only for enrolled exams)
    let enrollmentPosition : String?
    /// Total number of enrolled (only for enrolled ones)
    let enrolled           : String?
    
    public init?(json: JSON) {
        self.name                = "name" <~~ json
        self.cfu                 = "cfu" <~~ json
        self.professor           = "professor" <~~ json
        let auxDate: String?     = "date" <~~ json
        self.date                = auxDate?.stringToDate
        let auxExpiring: String? = "expiringDate" <~~ json
        self.expiringDate        = auxExpiring?.stringToDate
        self.room                = "room" <~~ json
        self.notes               = "notes" <~~ json
        self.id                  = "id" <~~ json
        
        self.enrollmentPosition  = "enrollmentPosition" <~~ json
        self.enrolled            = "enrolled" <~~ json
    }
    
    public static func getSessionExams(_ completionHandler: @escaping (SessionExams?) -> Void) {
        Alamofire.request(MyUnimolEndPoints.GET_EXAM_SESSIONS, method: .post, parameters: ParameterHandler.getStandardParameters()).responseSessionExams { response in
            completionHandler(response.value)
        }
    }
    
    public static func getEnrolledExams(_ completionHandler: @escaping (SessionExams?) -> Void) {
        Alamofire.request(MyUnimolEndPoints.GET_ENROLLED_EXAMS, method: .post, parameters: ParameterHandler.getStandardParameters()).responseSessionExams { response in
                completionHandler(response.value!)
        }
    }
}

/// Contains a list of `TodoExam` for the current section
public struct SessionExams {
    
    /// A list of all available exams
    var examsList = [SessionExam]()
    
    init(json: JSON) {
        self.examsList = [SessionExam].from(jsonArray: ("exams" <~~ json)!)!
    }
}

extension Alamofire.DataRequest {
    func responseSessionExams(_ completionHandler: @escaping (DataResponse<SessionExams>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<SessionExams> { request, response, data, error in
            
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
                let exams: SessionExams = SessionExams(json: value as! JSON)
                
                // store in cache
                let endpoint = (request?.url)!
                switch endpoint.absoluteString {
                case MyUnimolEndPoints.GET_EXAM_SESSIONS:
                    CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.EXAMS_AVAILABLE, json: value as! JSON)
                    break
                case MyUnimolEndPoints.GET_ENROLLED_EXAMS:
                    CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.EXAMS_ENROLLED, json: value as! JSON)
                    break
                default:
                    break
                }
                
                return .success(exams)
            case .failure(let error):
                return .failure(error)
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
    var stringToDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    /**
     Returns a `String` for a given `NSDate` object, using the format dd/MM/yyyy
     - returns: a `NSDate` object for the given string
    */
    var dateToString: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
}
