//
//  Career.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 16/06/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss
import Alamofire

/// The informations about a single student career
public struct Career: Decodable {
    
    let matricola       : String?
    let tipoCorso       : String?
    let corsoDiStudio   : String?
    let stato           : String?
    let id              : String?
    
  
    
    public init?(json: JSON) {
        self.matricola          = "matricola" <~~ json
        self.tipoCorso          = "tipoCorso" <~~ json
        self.corsoDiStudio      = "corsoDiStudio" <~~ json
        self.stato              = "stato" <~~ json
        self.id                 = "id" <~~ json
        
    }
    
    public static func getAllCareers(username: String, password: String, completionHandler: (Careers?, NSError?) -> Void) {
        
        let parameters = ["username": username,
                          "password": password,
                          "token"   : MyUnimolToken.TOKEN]
        
        Alamofire.request(.POST, MyUnimolEndPoints.GET_CAREERS, parameters: parameters).responseAllCareers(username, password: password) { response in
            completionHandler(response.result.value, response.result.error)
        }
    }
}


/// Stores an array of all student careers
public class Careers {
    
    var careers: Array<Career>?
    var areCredentialsValid : Bool?
    
    init(json: JSON) {
        self.careers = [Career].fromJSONArray(("careers" <~~ json)!)
        self.areCredentialsValid = false
    }
    
    init() { }
    
    public func getNumberOfCareers() -> Int {
        return self.careers?.count ?? 0
    }
}

extension Alamofire.Request {
    func responseAllCareers(username: String, password: String, completionHandler: Response<Careers, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<Careers, NSError> { request, response, data, error in
            
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
                let api: APIMessage = APIMessage(json: value as! JSON)!
                var careers: Careers = Careers()
                
                // check for correct credentials
                if api.result != "failure" {
                    careers = Careers(json: value as! JSON)
                    CacheManager.sharedInstance.storeCredentials(username, password: password)
                    CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.CAREERS, json: value as! JSON)
                    careers.areCredentialsValid = true
                }
                return .Success(careers)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}