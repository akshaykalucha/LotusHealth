//
//  File.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 2/28/25.
//

import SwiftUI
import Foundation
import Combine
import Alamofire
import UIKit
import SwiftyJSON


class DataViewModel: GlobalViewModel {
    
    
    let baseUrl = infoForKey("CMSBaseURL")!
    var isLoading: Bool = false
    // we keep track of the messages we send to the model, so that the model has context of the conversation

    @Published var messages: [Message] = [
        Message(text: "Greetings, human! How may I assist you in exploring the universe?", isUser: false, isLoading: false)
    ]
    
    
    
    @Published var allMessages : [String] = []
    
    func getMessageResp(message: String, completion: @escaping(Bool) async -> Void) {
        // if yu are connected to interenet
        if NetworkReachabilityManager.init()!.isReachable {
            // serialize the message to send in API body
    
            // Params for post request
            let parameters = [
                "model": "gpt-4o",
                "messages": [["role": "user", "content": message]]
            ] as [String : Any]
                        
            // calling API endpoint
            API.getUserResp.callAPI(baseURL: baseUrl, param: parameters, paramStr: nil) { (isSuccess, result, responseCode)  in
                
                let jsonData = getDataFrom(JSON: result)
                                
                if responseCode == 200 {
                    // if there is some result then parse it
                    
                    let jsonData = getDataFrom(JSON: result)
                    
                    // try to decode data if your models are in correct format else raise error
                    if let data = jsonData {
                        do {
                            let decodedResponse = try JSONDecoder().decode(MessageResponse.self, from: data) // JSONDecoder parses our data
                            self.allMessages.append(decodedResponse.choices[0].message.content)
                        }
                        catch let jsonError as NSError {
                            debugPrint(jsonError)
                            Task {
                                // data cannot be parsed correctly
                                await completion(false)
                            }
                            
                        }
                    }
                    Task {
                        await completion(true)
                    }
                    
                }
                else {
                    // we have reached limit of our API
                    Task {
                        await completion(false)
                    }
                }
            }
        }
        else {
            self.alertButton(passedText: AppConstant.NoInternetSubtitle)
            Task {
                await completion(false)
            }
        }
    }
    
    
    
    
    
    
    
    // New call API --> Closure not working with async for some reason
    func fetchResponseFromAPI(_ input: String) async throws -> String {
        // Example API call (replace with your actual API endpoint)
        print("API calll")
        let url = URL(string: "\(infoForKey("CMSBaseURL")!)v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.headers.add(name: "Authorization", value: "Bearer \(infoForKey("OPENAI_API_KEY")!)")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters = APIBody(model: "gpt-4o", messages: [["role": "user", "content": input]])
        
        request.httpBody = try JSONEncoder().encode(parameters)
        print(request)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let responseDict = try JSONDecoder().decode(MessageResponse.self, from: data)
        print(responseDict.choices[0].message.content)
        return responseDict.choices[0].message.content
    }
    
}
