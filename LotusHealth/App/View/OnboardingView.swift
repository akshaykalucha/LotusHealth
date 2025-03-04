//
//  OnboardingView.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 2/28/25.
//

import SwiftUI

//struct OnboardingView: View {
//    
//    @StateObject var viewModel = DataViewModel()
//    
//    var body: some View {
//        Text("\(infoForKey("CMSBaseURL")!)")
//    }
//}
//
//#Preview {
//    OnboardingView()
//}



import SwiftUI

struct HomeView: View {
    @State private var isButtonPressed: Bool = false
    @State private var name: String = "" // Name input
    @State private var selectedGender: String = "Male" // Gender selection
    @State private var customGender: String = "" // Custom gender input for "Other"
    @FocusState private var focusedField: Field? // Track focused TextField
    
    private let descriptionText = "Your personal health assistant. Get informed, stay well! "
    private let genderOptions = ["Male", "Female", "Other"]
    
    enum Field {
        case name
        case customGender
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                backgroundGradient
                
                // Main Content in a ScrollView to handle keyboard
                ScrollView {
                    VStack(spacing: 40) {
                        lotusIcon
                        titleText
                        descriptionTextView
                        userNameTextField
                        genderPicker
                        if selectedGender == "Other" {
                            customGenderTextField
                        }
                        startChattingButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20) // Stick upward
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Align to top
                // Removed .ignoresSafeArea(.keyboard) to allow scrolling with keyboard
            }
        }
    }
    
    // Background Gradient
    private var backgroundGradient: some View {
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
    }
    
    // Lotus Icon
    private var lotusIcon: some View {
        LotusFlower()
            .frame(width: 60, height: 60)
            .foregroundColor(Constants.accentColor)
            .shadow(color: Constants.accentColor.opacity(0.3), radius: 4, x: 0, y: 2)
    }
    
    // Title Text
    private var titleText: some View {
        Text("Lotus AI")
            .font(.system(size: 36, weight: .bold, design: .monospaced))
            .foregroundColor(Constants.textColor)
    }
    
    // Description Text
    private var descriptionTextView: some View {
        Text(descriptionText)
            .font(.system(size: 18, design: .monospaced))
            .foregroundColor(Constants.textColor.opacity(0.8))
            .multilineTextAlignment(.center)
    }
    
    // User Name Text Field
    private var userNameTextField: some View {
        ZStack(alignment: .leading) {
            if name.isEmpty {
                Text("Enter your name")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .foregroundColor(Constants.accentColor.opacity(0.5)) // Sand-brown placeholder
                    .padding(.leading, 24)
            }
            TextField("", text: $name)
                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                .foregroundColor(Constants.textColor) // Dark brown text
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Constants.accentColor.opacity(0.2)) // Light brown fill
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Constants.accentColor, lineWidth: 2) // Light brown border
                        )
                )
                .shadow(color: Constants.accentColor.opacity(0.3), radius: 4, x: 0, y: 2)
                .frame(maxWidth: 300)
                .tint(Constants.accentColor) // Light brown cursor
                .focused($focusedField, equals: .name) // Track focus
        }
    }
    
    // Gender Picker
    private var genderPicker: some View {
        Picker("Gender", selection: $selectedGender) {
            ForEach(genderOptions, id: \.self) { option in
                Text(option)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(Constants.textColor) // Dark brown text
                    .tag(option)
            }
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 300)
        .colorMultiply(Constants.accentColor.opacity(0.5)) // Sandy/light brown unselected segments
        .tint(Constants.textColor) // Dark brown selected segment
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Constants.backgroundColor) // Sandy background
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Constants.accentColor.opacity(0.5), lineWidth: 1) // Light brown border
                )
        )
    }
    
    // Custom Gender Text Field (shown when "Other" is selected)
    private var customGenderTextField: some View {
        ZStack(alignment: .leading) {
            if customGender.isEmpty {
                Text("Specify gender")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .foregroundColor(Constants.accentColor.opacity(0.5)) // Sand-brown placeholder
                    .padding(.leading, 24)
            }
            TextField("", text: $customGender)
                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                .foregroundColor(Constants.textColor) // Dark brown text
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Constants.accentColor.opacity(0.2)) // Light brown fill
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Constants.accentColor, lineWidth: 2) // Light brown border
                        )
                )
                .shadow(color: Constants.accentColor.opacity(0.3), radius: 4, x: 0, y: 2)
                .frame(maxWidth: 300)
                .tint(Constants.accentColor) // Light brown cursor
                .focused($focusedField, equals: .customGender) // Track focus
        }
    }
    
    // Start Chatting Button
    private var startChattingButton: some View {
        NavigationLink(destination: LotusChatView(userName: name), isActive: $isButtonPressed) {
            Button(action: {
                isButtonPressed = true
            }) {
                Text("Start Chatting")
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    .foregroundColor(Constants.textColor)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Constants.accentColor.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Constants.accentColor, lineWidth: 2)
                            )
                    )
            }
            .shadow(color: Constants.accentColor.opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
