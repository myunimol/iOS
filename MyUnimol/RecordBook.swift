//
//  models.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 11/02/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss
import Alamofire

/// A single done exam in student career
public struct Exam: Decodable {
    
    let name : String?
    let cfu  : Int?
    let vote : String?
    let date : String?
    let year : String?
    let id   : String?
    
    public init?(json: JSON) {
        
        self.name = Decoder.getExamName("name", json: json).capitalizedString
        self.cfu  = "cfu" <~~ json
        self.vote = "vote" <~~ json
        self.date = "date" <~~ json
        self.year = "year" <~~ json
        self.id   = "id" <~~ json
    }
}

/// Info about student career (exams, average and starting degree)
public class RecordBook {

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
        self.exams = [Exam].fromJSONArray(("exams" <~~ json)!)
        self.weightedAverage = "weightedAverage" <~~ json
        
        self.exams.sortInPlace(orderExamsByDate)
        
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
            print(self.staringDegree)
        }
    }
    
    public static func getRecordBook(completionHandler: (RecordBook?, NSError?) -> Void) {
        Alamofire.request(.POST, MyUnimolEndPoints.GET_RECORD_BOOK, parameters: ParameterHandler.getStandardParameters()).responseRecordBook { response in
            completionHandler(response.result.value, response.result.error)
        }
    }
    
    func orderExamsByDate(exam1: Exam, exam2: Exam) -> Bool {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if let date1 = exam1.date, let date2 = exam2.date {
            return dateFormatter.dateFromString(date1)?.timeIntervalSince1970 < dateFormatter.dateFromString(date2)?.timeIntervalSince1970
        } else {
            return true
        }
    }
}

/// Singleton which contains a `RecordBookClass` istance
public class RecordBookClass {
    
    public static let sharedInstance = RecordBookClass()
    
    public var recordBook: RecordBook?
    
    private init() { }
}

extension Alamofire.Request {
    func responseRecordBook(completionHandler: Response<RecordBook, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<RecordBook, NSError> { request, response, data, error in
            
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
                let recordBook: RecordBook = RecordBook(json: value as! JSON)
                // store info about exams into the singleton class
                RecordBookClass.sharedInstance.recordBook = recordBook
                // store json in cache
                CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.RECORD_BOOK, json: value as! JSON)
                return .Success(recordBook)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

extension Decoder {
    
    static func getExamName(key: String, json: JSON) -> (String) {
        let string = json.valueForKeyPath(key) as? String
        if string!.containsString(" - ") {
            var idAndName = string!.componentsSeparatedByString(" - ")
            return (idAndName[1])
        } else {
            return string!
        }
    }
}

extension String {
    struct NumberFormatter {
        static let instance = NSNumberFormatter()
    }
    var doubleValue:Double? {
        return NumberFormatter.instance.numberFromString(self)?.doubleValue
    }
    /// Returns an exam degree or a nil value; for 30L it returns 30
    var getDegreeByString:Int? {
        if (self == "30L") {
            return 30
        }
        return NumberFormatter.instance.numberFromString(self)?.integerValue
    }
}


