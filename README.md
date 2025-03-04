# LotusHealth

![LotusHealth Logo](Assets.xcassets/AppIcon.appiconset/icon.png)  
*Your AI companion for exploring health and the universe.*

## Overview

**LotusHealth** is a SwiftUI-based iOS application designed as an AI-powered chat companion. With a clean, lotus-themed interface, it allows users to input their name and gender, then engage in a real-time chat experience with streaming responses. The app blends wellness inspiration (symbolized by the lotus) with curiosity-driven exploration, making it a unique health and knowledge tool.

Key features:
- **Onboarding Screen**: Collects user name and gender via `HomeView`.
- **Chat Interface**: Real-time message streaming with a custom navigation bar in `LotusChatView`.
- **Visual Design**: Gradient backgrounds, rotating lotus animations, and haptic feedback.

This project leverages modern SwiftUI practices, the MVVM architecture, and UIKit for haptic feedback, delivering a polished user experience.

---

## Architecture: MVVM

**LotusHealth** uses the **Model-View-ViewModel (MVVM)** architecture to organize its codebase efficiently:

- **Model**: Represents the data and business logic.
  - Example: `Message` struct for chat messages (text, isUser, isLoading).
- **View**: Handles the UI, built with SwiftUI.
  - Example: `HomeView` (onboarding) and `LotusChatView` (chat UI).
- **ViewModel**: Acts as an intermediary between Model and View, managing data and state.
  - Example: `DataViewModel` fetches API responses and updates the chat.

### Why MVVM?
- **Separation of Concerns**: UI is decoupled from data logic.
- **Testability**: ViewModels can be unit-tested independently.
- **Reactivity**: `@ObservedObject` in SwiftUI ensures seamless UI updates.

In `LotusChatView`, the `DataViewModel` handles API calls (e.g., `fetchResponseFromAPI`), while the View updates reactively via `@ObservedObject`.

---

## Dependencies: CocoaPods

**LotusHealth** uses **CocoaPods**, a dependency manager for iOS projects, to integrate external libraries. While the core code doesn’t explicitly show third-party dependencies, CocoaPods is a common setup for Swift projects requiring networking or additional frameworks.

### Podfile Example
Assuming potential dependencies like Alamofire for networking:
```ruby
platform :ios, '16.0'

target 'LotusHealth' do
  use_frameworks!

  # Pods for LotusHealth
  pod 'Alamofire', '~> 5.6'  # For API networking (hypothetical)

  target 'LotusHealthTests' do
    inherit! :search_paths
  end
end

Prerequisites
To run LotusHealth on your machine, ensure you have:

Xcode: Version 14.0 or later (SwiftUI requires iOS 16+ support).
CocoaPods: Installed on your system (sudo gem install cocoapods).
iOS Simulator: Included with Xcode.
Git: To clone the repository.

Setup Instructions
Follow these steps to set up and run LotusHealth in Xcode on a simulator:

1. Clone the Repository
bash

Collapse

Wrap

Copy
git clone https://github.com/akshaykalucha/LotusHealth.git
cd LotusHealth

2. Install CocoaPods Dependencies
If the project uses CocoaPods (check for a Podfile):

bash

Collapse

Wrap

Copy
pod install

LotusHealth/
├── LotusHealth.xcodeproj          # Xcode project file
├── LotusHealth.xcworkspace        # Xcode workspace (if CocoaPods used)
├── Podfile                        # CocoaPods configuration (if applicable)
├── LotusHealth/
│   ├── Assets.xcassets            # App icons and images
│   ├── HomeView.swift             # Onboarding screen
│   ├── LotusChatView.swift        # Chat interface
│   ├── DataViewModel.swift        # ViewModel for data handling
│   ├── LotusMessageBubble.swift   # Chat bubble component
│   ├── ChatInputView.swift        # Chat input field
│   ├── Constants.swift            # App-wide constants (colors, etc.)
│   ├── LotusFlower.swift          # Lotus icon view
│   └── Info.plist                 # App configuration
├── LotusHealthTests/              # Unit tests (if present)
└── README.md                      # This file