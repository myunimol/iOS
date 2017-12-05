//
//  News.swift
//  MyUnimol
//
//  Created by Giovanni Grano on 19/03/16.
//  Copyright © 2016 Giovanni Grano. All rights reserved.
//

import Gloss
import Alamofire

/// Info about a generic news
public struct News: JSONDecodable {
    
    let date  : String?
    let title : String?
    let text  : String?
    let link  : String?
    
    public init(json: JSON) {
        self.date  = "date" <~~ json
        self.title = "title" <~~ json
        self.text  = "text" <~~ json
        self.link  = "link" <~~ json
    }
    
    public static func getBoardNews(_ completionHandler: @escaping (NewsList?) -> Void) {
        Alamofire.request(MyUnimolEndPoints.GET_NEWS_BOARD, method: .post, parameters: ParameterHandler.getParametersForBoardNews()).responseGenericNews { response in
            completionHandler(response.value!)
        }
    }
    
    public static func getDepartmentNews(_ completionHandler: @escaping (NewsList?) -> Void) {
        Alamofire.request(MyUnimolEndPoints.GET_DEPARTMENT_NEWS, method: .post, parameters: ParameterHandler.getParametersForDepartmentNews()).responseGenericNews { response in
            completionHandler(response.value!)
        }
    }
    
    public static func getUniversityNews(_ completionHandler: @escaping (NewsList?) -> Void) {
        Alamofire.request(MyUnimolEndPoints.GET_UNIVERSITY_NEWS, method: .post, parameters: ParameterHandler.getParameterForUniversityNews()).responseGenericNews { response in
            completionHandler(response.value!)
        }
    }
}


/// Contains an array of `News` elements
open class NewsList {
    
    var newsList = [News]()
    
    init(json: JSON) {
        self.newsList = [News].from(jsonArray: ("newsList" <~~ json)!)!
    }
}

extension Alamofire.DataRequest {
    func responseGenericNews(_ completionHandler: @escaping (DataResponse<NewsList>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<NewsList> { request, response, data, error in
            
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
                let news: NewsList = NewsList(json: value as! JSON)
                
                // store in cache
                let endpoint = (request?.url)!
                switch endpoint.absoluteString {
                case MyUnimolEndPoints.GET_NEWS_BOARD:
                    CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.BOARD_NEWS, json: value as! JSON)
                    break
                case MyUnimolEndPoints.GET_DEPARTMENT_NEWS:
                    CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.DEPARTMENT_NEWS, json: value as! JSON)
                    break
                case MyUnimolEndPoints.GET_UNIVERSITY_NEWS:
                    CacheManager.sharedInstance.storeJsonInCacheByKey(CacheManager.UNIVERSITY_NEWS, json: value as! JSON)
                    break
                default:
                    break
                }
                
                return .success(news)
            case .failure(let error):
                return .failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
