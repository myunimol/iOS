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
    
    let fullname: String?
    let role: String?
    let building: String?
    let internalTelephone: String?
    let externalTelephone: String?
    let email: String?
    
    public init?(json: JSON) {
        self.fullname = "fullname" <~~ json
        self.role = "role" <~~ json
        self.building = "building" <~~ json
        self.internalTelephone = "internalTelephone" <~~ json
        self.externalTelephone = "externalTelephone" <~~ json
        self.email = "email" <~~ json
    }
    
    public static func getAllContacts(completionHandler: (Contacts?, NSError?) -> Void) {
        let parameters = ["token" : MyUnimolToken.TOKEN]
        Alamofire.request(.POST, MyUnimolEndPoints.GET_ADDRESS_BOOK, parameters: parameters).responseAllContacts { response in
            completionHandler(response.result.value, response.result.error)
        }
    }
}

///Contains an arrays of `Contact` elements
public class Contacts {
    
    ///An array of `Contacts`
    var contacts: Array<Contact>?
    
    init(json: JSON) {
        self.contacts = [Contact].fromJSONArray(("contacts" <~~ json)!)
    }
}

extension Alamofire.Request {
    func responseAllContacts(completionHandler: Response<Contacts, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<Contacts, NSError> { request, response, data, error in
            
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
                let contacts: Contacts = Contacts(json: value as! JSON)
                return .Success(contacts)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}