//
//  Tax.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 17/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss
import Alamofire

/// Store the info for a tax
public struct Tax: Decodable {
    
    let billId: String?
    let bullettinCode: String?
    let year: String?
    let description: String?
    let expiringDate: String?
    let amount: Double?
    let statusPayment: String?
    
    public init?(json: JSON) {
        self.billId = "billId" <~~ json
        self.bullettinCode = "bullettinCode" <~~ json
        self.year = "year" <~~ json
        self.description = "description" <~~ json
        self.expiringDate = "expiringDate" <~~ json
        self.amount = "amount" <~~ json
        self.statusPayment = "statusPayment" <~~ json
    }
    
    public static func getAllTaxes(completionHandler: (Taxes?, NSError?) -> Void) {
        Alamofire.request(.POST, MyUnimolEndPoints.GET_TAXES, parameters: ParameterHandler.getStandardParameters()).responseAllTaxes { response in
            completionHandler(response.result.value, response.result.error)
        }
    }

}

///Contains a list of `Tax` objects
public class Taxes {
    
    ///A list of `Tax` objects
    var taxes = [Tax]()
    
    init(json: JSON) {
        self.taxes = [Tax].fromJSONArray(("taxes" <~~ json)!)
    }
}

extension Alamofire.Request {
    func responseAllTaxes(completionHandler: Response<Taxes, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<Taxes, NSError> { request, response, data, error in
            
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
                let taxes: Taxes = Taxes(json: value as! JSON)
                return .Success(taxes)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

