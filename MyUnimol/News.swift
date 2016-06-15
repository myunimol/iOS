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
public struct News: Decodable {
    
    let date: String?
    let title: String?
    let text: String?
    let link: String?
    
    public init(json: JSON) {
        self.date = "date" <~~ json
        self.title = "title" <~~ json
        self.text = "text" <~~ json
        self.link = "link" <~~ json
    }
    
    public static func getBoardNews(completionHandler: (NewsList?, NSError?) -> Void) {
        Alamofire.request(.POST, MyUnimolEndPoints.GET_NEWS_BOARD, parameters: ParameterHandler.getParametersForBoardNews()).responseGenericNews { response in
            completionHandler(response.result.value, response.result.error)
        }
    }
    
    public static func getDepartmentNews(completionHandler: (NewsList?, NSError?) -> Void) {
        Alamofire.request(.POST, MyUnimolEndPoints.GET_DEPARTMENT_NEWS, parameters: ParameterHandler.getParametersForDepartmentNews()).responseGenericNews { response in
            completionHandler(response.result.value, response.result.error)
        }
    }
    
    public static func getUniversityNews(completionHandler: (NewsList?, NSError?) -> Void) {
        Alamofire.request(.POST, MyUnimolEndPoints.GET_UNIVERSITY_NEWS, parameters: ParameterHandler.getParameterForUniversityNews()).responseGenericNews { response in
            completionHandler(response.result.value, response.result.error)
        }
    }
}


/// Contains an array of `News` elements
public class NewsList {
    
    var newsList = [News]()
    
    init(json: JSON) {
        self.newsList = [News].fromJSONArray(("newsList" <~~ json)!)
    }
}

extension Alamofire.Request {
    func responseGenericNews(completionHandler: Response<NewsList, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<NewsList, NSError> { request, response, data, error in
            
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
                let news: NewsList = NewsList(json: value as! JSON)
                
                // store in cache
                let endpoint = (request?.URL)!
                switch endpoint {
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
                
                return .Success(news)
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
