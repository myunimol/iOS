 //
//  models.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 11/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss
import Alamofire
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


/// A single done exam in student career
public struct Exam: JSONDecodable {
    
    let name : String?
    let cfu  : Int?
    let vote : String?
    let date : String?
    let year : String?
    let id   : String?
    
    public init?(json: JSON) {
        
        self.name = Decoder.getExamName("name", json: json).capitalized
        self.cfu  = "cfu" <~~ json
        self.vote = "vote" <~~ json
        self.date = "date" <~~ json
        self.year = "year" <~~ json
        self.id   = "id" <~~ json
    }
}

/// Info about student career (exams, average and starting degree)
open class RecordBook {

    /// Average degree
    let average : Double?
    /// A list of `Exam` objects
    var exams = [Exam]()
    /// Weighted average
    let weightedAverage : Double?
    // exams with a numeric grade
    var examsGrades = [Int]()
    // progression of final starting degree
    var staringDegree = [Int]()
    
    var totalCFU : Int = 0
    
    init(json: JSON) {
        self.average = "average" <~~ json
        self.exams = [Exam].from(jsonArray: ("exams" <~~ json)!)!
        self.weightedAverage = "weightedAverage" <~~ json
        
        self.exams.sorted(by: orderExamsByDate)
        
        var cfuCounter = 0
        var accumulator = 0
        
        for exam in self.exams {
            if exam.vote != "/" {
                totalCFU += exam.cfu!
            }
            
            if let grade = exam.vote?.getDegreeByString {
                cfuCounter += exam.cfu!
                accumulator += exam.cfu! * grade
                
                self.examsGrades.append(grade)
                let currentAverage: Double = (Double(accumulator) / Double(cfuCounter))
                self.staringDegree.append(Int(round(currentAverage * 11 / 3)))
            }
        }
    }
    
    open static func getRecordBook(_ completionHandler: @escaping (RecordBook?) -> Void) {
        Alamofire.request(
            MyUnimolEndPoints.GET_RECORD_BOOK,
            method: .post,
            parameters: ParameterHandler.getStandardParameters()).responseRecordBook { response in
                completionHandler(response.value!)
        }
    }
    
    func orderExamsByDate(_ exam1: Exam, exam2: Exam) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if let date1 = exam1.date, let date2 = exam2.date {
            return dateFormatter.date(from: date1)?.timeIntervalSince1970 < dateFormatter.date(from: date2)?.timeIntervalSince1970
        } else {
            return true
        }
    }
}

/// Singleton which contains a `RecordBookClass` istance
open class RecordBookClass {
    
    open static let sharedInstance = RecordBookClass()
    
    open var recordBook: RecordBook?
    
    fileprivate init() { }
}

extension Alamofire.DataRequest {
    func responseRecordBook(_ completionHandler: @escaping (DataResponse<RecordBook>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<RecordBook> { request, response, data, error in
            
            guard error == nil else {
                return .failure(BackendError.network(error: error!))
            }
            
//            guard let responseData = data else {
//                let failureReason = "Array could not be serialized because input data was nil"
//                let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey: failureReason, Error.UserInfoKeys.StatusCode: response!.statusCode]
//                let error = NSError(domain: Error.Domain, code: Error.Code.StatusCodeValidationFailed.rawValue, userInfo: userInfo)
//                  let error = NSError(domain: error.debugDescription, code: response?.statusCode, userInfo: nil)
//                return .Failure(error)
//            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            switch result {
            case .success(let value):
                let recordBook: RecordBook = RecordBook(json: value as! JSON)
                // store info about exams into the singleton class
                RecordBookClass.sharedInstance.recordBook = recordBook
                // store json in cache
                CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.RECORD_BOOK, json: value as! JSON)
                return .success(recordBook)
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

extension Gloss.Decoder {
    
    static func getExamName(_ key: String, json: JSON) -> (String) {
        let string = json.valueForKeyPath(keyPath: key) as? String
        if string!.contains(" - ") {
            var idAndName = string!.components(separatedBy: " - ")
            return (idAndName[1])
        } else {
            return string!
        }
    }
}

extension String {
    struct NumberFormatter {
        static let instance = Foundation.NumberFormatter()
    }
    var doubleValue:Double? {
        return NumberFormatter.instance.number(from: self)?.doubleValue
    }
    /// Returns an exam degree or a nil value; for 30L it returns 30
    var getDegreeByString:Int? {
        if (self == "30L") {
            return 30
        }
        return NumberFormatter.instance.number(from: self)?.intValue
    }
}


