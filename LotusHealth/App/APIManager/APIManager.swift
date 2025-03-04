//
//  APIManager.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 2/28/25.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SwiftUI


// this manager calls the API
let noInternetConnectionMsg = "Connection error."

// MARK: API Manager Delegate
protocol ApiManagerDelegate : class {
    func didFinishCallingApiWithFailer(_ apiName: String)
    func receiveData(_ jsonData: AnyObject?, apiName: String)
}


// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]



class APIManager: NSObject {
    
    weak var delegate: ApiManagerDelegate! = nil
    static let authUsername: String = ""
    static let authPassword: String = ""
    var isPrintApiData : Bool = true
    
    
    // majority of content sharing takes place using JSON Data, so we specify default Content-Type headers to be "application/json"
    func getMainHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = ["Authorization" : "Bearer \(infoForKey("OPENAI_API_KEY")!)"]
        return headers
    }
    
    
    
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    func callAPI(baseURL: String, apiModel: API_Model, param: Parameters?,completion completionBlock: ApiResponseHandler? = nil){
        self.executeApi(baseURL+apiModel.newPath, param: param, apiMethod: apiModel.method, forDelegate: nil, userName: APIManager.authUsername, passWord: APIManager.authPassword, isRawData: apiModel.isRawData, completion: completionBlock)
        
        
    }
    
    // call API from a background thread for fast and smooth UI and send back response from that API on main thread
    func executeApi(_ apiName: String, param: Parameters?, apiMethod : HTTPMethod = .post, forDelegate: ApiManagerDelegate? = nil, userName : String = authUsername, passWord : String = authPassword, isRawData : Bool = false, completion completionBlock: ApiResponseHandler? = nil){
        delegate = forDelegate
        if Reach().isInternet() == true {
            DispatchQueue.global(qos: .background).async { [self] in // background thread
                            let headers: HTTPHeaders = getMainHeaders()
//                self.printText("Headers ==> \(headers)")
                            var parEncoding: ParameterEncoding = (apiMethod == .get ? URLEncoding.default : URLEncoding.default)
                
                            // if there is a body in request, send it as JSON body
                            if isRawData == true {
                                parEncoding = JSONEncoding.default
                            }

                            //MARK: ALAMOFIRE API REQ
                            AF.request(
                                apiName,
                                method: apiMethod,
                                parameters: param,
                                encoding:parEncoding,
                                headers: headers).responseJSON { (response) in
                                switch response.result{
                                case .success:
                                    DispatchQueue.main.async { // push response to main thread
                                        do{
                                            let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                                            self.responseSend(isSuccess: true, apiStatusCode: response.response?.statusCode, apiName: apiName, resultData: json as AnyObject, param: param, completionBlock: completionBlock)
                                        }catch let error{
                                            self.failMessageSend(apiName: apiName, completionBlock: completionBlock, errorMsg: error.localizedDescription)
                                            print(error.localizedDescription)
                                        }
                                    }
                                case .failure(let error):
                                  print(error)
                                }
                            }
            }
        } else {
            self.failMessageSend(apiName: apiName, completionBlock: completionBlock, errorMsg: WebServiceCallErrorMessage.ErrorInternetConnectionNotAvailableMessage)
        }
    }
    
    func responseSend(isSuccess : Bool, apiStatusCode : Int?, apiName : String, resultData : AnyObject?, param : Parameters?, completionBlock : ApiResponseHandler?) {
        var newIsSuccess : Bool = isSuccess
        if apiStatusCode == 200 {
            newIsSuccess = true
        }
        if newIsSuccess == false {
            self.isPrintApiData = true
        }
        
        if apiStatusCode == 401 {  // Unauthorization
            if let completionBlock = completionBlock {
                let isValid : Bool = false
                if let stringDict = resultData as? Parameters {
                    if let isValidValue = stringDict["status"] {

                    }
                }
                if let resultData = resultData {
                    completionBlock(isValid, JSON.init(resultData), apiStatusCode)
                } else {
                    completionBlock(isValid, JSON.init([:]), apiStatusCode)
                }
            }
            guard newIsSuccess else {
                self.delegate?.didFinishCallingApiWithFailer(apiName)
                return
            }
            self.delegate?.receiveData(resultData!, apiName: apiName)
        } else {
            if let completionBlock = completionBlock {
                let isValid : Bool = false
                if let stringDict = resultData as? Parameters {
                    if let isValidValue = stringDict["status"] {
                        //                    isValid = isValidValue as! Bool
                    }
                }
                if let resultData = resultData {
                    completionBlock(isValid, JSON.init(resultData), apiStatusCode)
                } else {
                    completionBlock(isValid, JSON.init([:]), apiStatusCode)
                }
            }
            guard newIsSuccess else {
                self.delegate?.didFinishCallingApiWithFailer(apiName)
                return
            }
            self.delegate?.receiveData(resultData!, apiName: apiName)
        }
    }
    
    func failMessageSend(apiName : String, completionBlock : ApiResponseHandler?, errorMsg : String = noInternetConnectionMsg) {
//        errorMsg.showAsAlert()
        self.delegate?.didFinishCallingApiWithFailer(apiName)
        if let completionBlock = completionBlock {
            completionBlock(false, JSON.init(["message":errorMsg]), nil)
        }
    }
    
    func printText(_ text : Any) {
        if isPrintApiData {
            print(text)
        }
    }
}

