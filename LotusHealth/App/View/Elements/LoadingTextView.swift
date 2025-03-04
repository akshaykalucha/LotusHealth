//
//  LoadingTextView.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 3/1/25.
//

import Foundation
import SwiftUI

struct LoadingBubble: View {
    @State private var dots = "..."
    
    var body: some View {
        Text(dots)
            .foregroundColor(Constants.textColor.opacity(0.7))
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    withAnimation {
                        dots = dots == "..." ? "." : dots + "."
                    }
                }
            }
    }
}
