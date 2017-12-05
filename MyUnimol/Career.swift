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
public struct Career: JSONDecodable {
    
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
    
    public static func getAllCareers(_ username: String, password: String, completionHandler: @escaping (Careers?) -> Void) {
        
        let parameters = ["username": username,
                          "password": password,
                          "token"   : MyUnimolToken.TOKEN]
        
        Alamofire.request(
            MyUnimolEndPoints.GET_CAREERS, method: .post,
            parameters: parameters).responseAllCareers(username, password: password) { response in
                completionHandler(response.value!)
        }
    }
}


/// Stores an array of all student careers
open class Careers {
    
    var careers: Array<Career>?
    var areCredentialsValid : Bool?
    
    init(json: JSON) {
        self.careers = [Career].from(jsonArray: ("careers" <~~ json)!)
        self.areCredentialsValid = false
    }
    
    init() { }
    
    open func getNumberOfCareers() -> Int {
        return self.careers?.count ?? 0
    }
}

extension Alamofire.DataRequest {
    func responseAllCareers(_ username: String, password: String, completionHandler: @escaping (DataResponse<Careers>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<Careers> { request, response, data, error in
            
            guard error == nil else {
                return .failure(BackendError.network(error: error!))
            }
            
//            guard let responseData = data else {
//                let failureReason = "Array could not be serialized because input data was nil"
//                let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey: failureReason, Error.UserInfoKeys.StatusCode: response!.statusCode]
//                let error = NSError(domain: Error.Domain, code: Error.Code.StatusCodeValidationFailed.rawValue, userInfo: userInfo)
//                let error = NSError(domain: error.debugDescription, code: (response?.statusCode)!, userInfo: nil)
//                return .failure(error)
//            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)

            guard case let .success(_) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            switch result {
            case .success(let value):
                let api: APIMessage = APIMessage(json: value as! JSON)!
                print(value)
                var careers: Careers = Careers()
                
                // check for correct credentials
                if api.result != "failure" {
                    careers = Careers(json: value as! JSON)
                    CacheManager.sharedInstance.storeCredentials(username, password: password)
                    CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.CAREERS, json: value as! JSON)
                    careers.areCredentialsValid = true
                }
                print(careers.getNumberOfCareers())
                return .success(careers)
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
