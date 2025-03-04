//
//  APIConstant.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 2/28/25.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


typealias ApiResponseHandler = (_ success: Bool, _ result : JSON, _ responseCode : Int?) -> Void


// API is request object is created via this class
class API_Model: NSObject {
    
    
    var path        : String! // path of API
    var newPath     : String! // Added path
    var method      : HTTPMethod = .post // Method of API req, default is post
    var isRawData   : Bool = true
    var paramKey    : [String]?
    
    // initialising class
    init(_ path : String, _ httpMethod : HTTPMethod = .post,_ isRawData : Bool = true,_ param : [String]? = nil) {
        self.path       = path
        self.method     = httpMethod
        self.isRawData  = isRawData
        paramKey        = param
    }
    
    // calling API after request object is made, doing this in general is encouraged
    func  callAPI(baseURL: String, param : Parameters?, paramStr : String? = nil, completion completionBlock: ApiResponseHandler? = nil) {
        if let paramStr = paramStr {
            newPath = path+paramStr
        } else {
            newPath = path
        }
        
        APIManager.sharedInstance.callAPI(baseURL: baseURL, apiModel: self, param: param, completion: completionBlock)
    }
}


// different error handling messages
struct WebServiceCallErrorMessage {
    static let ErrorInvalidDataFormatMessage    = "Please try again, server not reachable";
    static let ErrorServerNotReachableMessage   = "Server Not Reachable";
    static let ErrorInternetConnectionNotAvailableMessage
        = "OOPS! Looks like you don't have internet access at this moment..."
    static let ErrorTitleInternetConnectionNotAvailableMessage
        = "Network Error.";
    static let ErrorNoDataFoundMessage          = "No Data Available";
    static let ErrorOccuredMessage              = "Error occurred! Please try again"
}

struct API {
    static let getUserResp = API_Model.init("v1/chat/completions", .post, true) // here .get means it will be get req, and false means there gonna be no body params
}

