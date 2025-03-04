//
//  OpenAIService.swift
//  MediumFunctionCalls
//
//  Created by kemo konteh on 11/6/23.
//

import Foundation
import Alamofire
import Combine

struct OpenAIMessage: Codable {
    let role: String
    let content: String
}


struct MessageResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let choices: [ResponseChoice]
}

struct ResponseChoice: Decodable {
    let index: Int
    let message: OpenAIMessage
    let finish_reason: String
    
}


struct Message: Identifiable, Equatable {
    let id = UUID()
    var text: String
    let isUser: Bool
    var isLoading: Bool
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id && lhs.text == rhs.text && lhs.isUser == rhs.isUser && lhs.isLoading == rhs.isLoading
    }
}


struct APIBody: Encodable {
    var model: String
    var messages: [[String: String]]
}
