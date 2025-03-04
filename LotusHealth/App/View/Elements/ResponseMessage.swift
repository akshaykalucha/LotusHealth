//
//  ResponseMessage.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 3/1/25.
//

import Foundation
import SwiftUI

struct LotusMessageBubble: View {
    let text: String
    let isUser: Bool
    let isLoading: Bool
    
    var body: some View {
        HStack {
            if isUser { Spacer() }
            
            if isUser {
                Text(text)
                    .padding(12)
                    .foregroundColor(Constants.textColor)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Constants.accentColor.opacity(0.8), Constants.accentColor.opacity(0.6)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Constants.accentColor.opacity(0.3), radius: 4, x: 0, y: 2)
            } else if isLoading {
                LoadingBubble()
            } else {
                Text(text)
                    .foregroundColor(Constants.textColor.opacity(0.9))
                    .shadow(color: Constants.textColor.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            
            if !isUser { Spacer() }
        }
        .frame(maxWidth: 320, alignment: isUser ? .trailing : .leading)
    }
}
