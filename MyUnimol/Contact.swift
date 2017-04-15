//
//  Contact.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 08/05/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss
import Alamofire

///Contains the info for a contact
public struct Contact: Decodable {
    
    let fullname          : String?
    let role              : String?
    let building          : String?
    let internalTelephone : String?
    let externalTelephone : String?
    let email             : String?
    
    public init?(json: JSON) {
        self.fullname          = "fullname" <~~ json
        self.role              = "role" <~~ json
        self.building          = "building" <~~ json
        self.internalTelephone = "internalTelephone" <~~ json
        self.externalTelephone = "externalTelephone" <~~ json
        self.email             = "email" <~~ json
    }
    
    public static func getAllContacts(_ completionHandler: @escaping (Contacts?) -> Void) {
        
        let parameters = ["token" : MyUnimolToken.TOKEN]
        
        Alamofire.request(
            MyUnimolEndPoints.GET_ADDRESS_BOOK, // request URL
            method: .post,
            parameters: parameters).responseAllContacts { (response: DataResponse<Contacts>) in
                completionHandler(response.value!)
        }
    }
}

///Contains an arrays of `Contact` elements
open class Contacts {
    
    ///An array of `Contacts`
    var contacts: Array<Contact>?
    
    init(json: JSON) {
        self.contacts = [Contact].from(jsonArray: ("contacts" <~~ json)!)
    }
}

enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}

extension Alamofire.DataRequest {
    func responseAllContacts(_ completionHandler: @escaping (DataResponse<Contacts>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<Contacts> { request, response, data, error in
            
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
                let contacts: Contacts = Contacts(json: value as! JSON)
                
                // store in cache
                CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.CONTACTS, json: value as! JSON)
                
                return .success(contacts)
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
