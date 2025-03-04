//
//  TextView.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 3/1/25.
//

import Foundation
import SwiftUI

struct ChatInputView: View {
    @Binding var messageText: String
    @Binding var isResponseStreaming: Bool
    let sendMessage: () -> Void
    let stopStreaming: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .leading) {
                if messageText.isEmpty {
                    Text("Ask me anything...")
                        .foregroundColor(Constants.textColor.opacity(0.5))
                        .padding(.leading, 12)
                }
                TextField("", text: $messageText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .foregroundColor(Constants.textColor)
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Constants.accentColor.opacity(0.5), lineWidth: 1)
                    )
                    .tint(Constants.accentColor)
                    .submitLabel(.return)
            }
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(messageText.trim().isEmpty ? Constants.textColor.opacity(0.3) : Constants.accentColor)
                    .rotationEffect(.degrees(messageText.trim().isEmpty ? 0 : 45))
            }
            .disabled(messageText.trim().isEmpty)
            .animation(.spring(), value: messageText.trim())
            
            if isResponseStreaming {
                Button(action: stopStreaming) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Constants.accentColor)
                }
                .transition(.opacity)
            }
        }
        .padding()
        .background(Constants.backgroundColor.opacity(0.8))
    }
}
