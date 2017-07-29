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
    
    let billId        : String?
    let bullettinCode : String?
    let year          : String?
    let description   : String?
    let expiringDate  : String?
    let amount        : Double?
    let statusPayment : String?
    
    public init?(json: JSON) {
        self.billId        = "billId" <~~ json
        self.bullettinCode = "bullettinCode" <~~ json
        self.year          = "year" <~~ json
        self.description   = "description" <~~ json
        self.expiringDate  = "expiringDate" <~~ json
        self.amount        = "amount" <~~ json
        self.statusPayment = "statusPayment" <~~ json
    }
    
    public static func getAllTaxes(_ completionHandler: @escaping (Taxes?) -> Void) {
        Alamofire.request(
            MyUnimolEndPoints.GET_TAXES,
            method: .post,
            parameters: ParameterHandler.getStandardParameters())
            .responseAllTaxes { response in
                completionHandler(response.value!)
        }
    }
}

///Contains a list of `Tax` objects
open class Taxes {
    
    ///A list of `Tax` objects
    var taxes = [Tax]()
    
    init(json: JSON) {
        self.taxes = [Tax].from(jsonArray: ("taxes" <~~ json)!)!
    }
}

extension Alamofire.DataRequest {
    func responseAllTaxes(_ completionHandler: @escaping (DataResponse<Taxes>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<Taxes> { request, response, data, error in
            
            guard error == nil else {
                return .failure(BackendError.network(error: error!))
            }
            
//            guard let responseData = data else {
//                let failureReason = "Array could not be serialized because input data was nil"
//                let userInfo: Dictionary<NSObject, AnyObject> = [NSLocalizedFailureReasonErrorKey: failureReason, Error.UserInfoKeys.StatusCode: response!.statusCode]
//                let error = NSError(domain: Error.Domain, code: Error.Code.StatusCodeValidationFailed.rawValue, userInfo: userInfo)
//                return .failure(error)
//            }
            
            let JSONResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .success(let value):
                let taxes: Taxes = Taxes(json: value as! JSON)
                // store in cache
                CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.TAX, json: value as! JSON)
                return .success(taxes)
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

