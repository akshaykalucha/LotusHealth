//
//  ChatView.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 2/28/25.
//

import SwiftUI
import UIKit  // Added for haptic feedback

struct LotusChatView: View {
    
    
    @ObservedObject var viewModel = DataViewModel()
    
    @State private var messages: [Message] = [Message(text: "", isUser: false, isLoading: false)]
    
    @State private var response: [OpenAIMessage] = []
    @State private var messageText: String = ""
    @State private var scrollProxy: ScrollViewProxy?
    @State private var lotusRotation: Double = 0
    @State private var isScrollingManually = false
    @State private var streamingTask: Task<Void, Never>?
    @State private var isResponseStreaming: Bool = false
    
    let userName: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Constants.backgroundColor
                .ignoresSafeArea()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Constants.backgroundColor.opacity(0.9),
                            Constants.accentColor.opacity(0.2)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            VStack(spacing: 0) {
                // Custom Top Bar
                HStack {
                    // Back Button (Chevron)
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .foregroundColor(Constants.accentColor)
                    }
                    
                    Spacer()
                    
                    // Title
                    Text("Lotus")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(Constants.textColor)
                    
                    Spacer()
                    
                    // Lotus Flower
                    LotusFlower()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Constants.accentColor)
                        .rotationEffect(.degrees(lotusRotation))
                        .onAppear {
                            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                                lotusRotation = 360
                            }
                        }
                }
                .padding()
                .background(Constants.backgroundColor.opacity(0.8))
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(messages) { message in
                                LotusMessageBubble(
                                    text: message.text.trim(),
                                    isUser: message.isUser,
                                    isLoading: message.isLoading
                                )
                                .id(message.id)
                                .transition(.asymmetric(
                                    insertion: .opacity.combined(with: .move(edge: .bottom)),
                                    removal: .opacity
                                ))
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                isScrollingManually = true
                            }
                            .onEnded { _ in
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isScrollingManually = false
                                }
                            }
                    )
                    .onAppear { scrollProxy = proxy }
                }
                
                ChatInputView(
                    messageText: $messageText,
                    isResponseStreaming: $isResponseStreaming,
                    sendMessage: sendMessage,
                    stopStreaming: stopStreaming
                )
            }
        }
        .navigationBarHidden(true) // Hide default navigation bar
        .animation(.spring(), value: isResponseStreaming)
        .onAppear { //initializiing state on appear
            self.messages[0].text = "Greetings, \(self.userName)! How may I assist you in exploring the universe?"
        }
    }
    
    private func sendMessage() {
        print("sending message ==> Construct message body and call API", messageText.trim())
        guard !messageText.isEmpty else { return }
        
        
        // stop all previous streaming
        streamingTask?.cancel()
        streamingTask = nil
        isResponseStreaming = false
        messages.removeAll { !$0.isUser && $0.isLoading }
        
        
        // append current message to queue
        withAnimation(.spring()) {
            messages.append(Message(text: messageText, isUser: true, isLoading: false))
            let responseMessage = Message(text: "", isUser: false, isLoading: true)
            messages.append(responseMessage)
            scrollProxy?.scrollTo(responseMessage.id, anchor: .bottom)
        }
        
        let userMessage = messageText
        messageText = "" // clear textfield
        
        streamingTask = Task {
                    do {
                        let apiResponse = try await self.viewModel.fetchResponseFromAPI(userMessage)
                        isResponseStreaming = true
                        await streamResponse(apiResponse, messageId: messages.last!.id)
                    } catch {
                        await MainActor.run {
                            messages.append(Message(text: "Error: Could not fetch response", isUser: false, isLoading: false))
                            stopStreaming() // stop all streaming if something goes wrong
                        }
                    }
                }
        
        
//        streamingTask = Task {
//            
//            if isResponseStreaming {
//                print("one respinse already in queue")
//            }
//                    do {
//                        // Simulate API call with delay
//                        self.viewModel.getMessageResp(message: userMessage, completion: {
//                            resp in
//                            if resp { // if some response from API
//                                isResponseStreaming = true
//                                await streamResponse(self.viewModel.allMessages.last ?? "No resp", messageId: messages.last!.id)
//                            }
//                            else {
//                                isResponseStreaming = true
//                                await streamResponse("Unable to fetch req", messageId: messages.last!.id)
//                            }
//                        })
//
//                    } catch {
//                        await MainActor.run {
//                            messages.append(Message(text: "Error: Could not fetch response", isUser: false, isLoading: false))
//                            isResponseStreaming = false
//                            streamingTask = nil
//                        }
//                    }
//                }
    }
    
    private func stopStreaming() {
        print("task cncelled")
        streamingTask?.cancel()
        streamingTask = nil
        isResponseStreaming = false
        messages.removeAll { !$0.isUser && $0.isLoading }
        print(messages)
    }
    
    private func streamResponse(_ response: String, messageId: UUID) async {
        guard let index = messages.firstIndex(where: { $0.id == messageId }) else { return }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.prepare()
        
        await MainActor.run {
            messages[index].isLoading = false
        }
        
        var accumulatedLength = 0
        let scrollThreshold = 140
        let charactersPerScroll = 10
        
        for (i, char) in response.enumerated() {
            if Task.isCancelled {
                isResponseStreaming = false
                return
            }
            
            await MainActor.run {
                messages[index].text.append(char)
                accumulatedLength += 1
                
                if !isScrollingManually && accumulatedLength > scrollThreshold {
                    let shouldScroll = accumulatedLength % charactersPerScroll == 0
                    if shouldScroll {
                        impactFeedback.impactOccurred(intensity: 0.7)
                        withAnimation(.interpolatingSpring(stiffness: 300, damping: 25)) {
                            scrollProxy?.scrollTo(messageId, anchor: .bottom)
                        }
                    }
                }
                
                if i == response.count - 1 {
                    withAnimation(.easeOut(duration: 0.25)) {
                        scrollProxy?.scrollTo(messageId, anchor: .bottom) // Fixed: use messageId
                    }
                    isResponseStreaming = false
                }
            }
            
            try? await Task.sleep(nanoseconds: 30_000_000)
        }
        
        streamingTask = nil
        isResponseStreaming = false
    }
}
