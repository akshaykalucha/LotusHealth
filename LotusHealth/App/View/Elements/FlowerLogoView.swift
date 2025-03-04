//
//  FlowerLogoView.swift
//  LotusHealth
//
//  Created by Akshay Kalucha on 3/1/25.
//

import Foundation
import SwiftUI


// Logo of our app, styled in ellipse with path vars
struct LotusFlower: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Path { path in
                let center = CGPoint(x: 12, y: 12) // Center of 24x24 frame
                let outerRadius: CGFloat = 12 // Full radius to edge
                let innerRadius: CGFloat = 5  // Inner points closer to center
                let points = 5               // 5-pointed star
                let angleStep = 360.0 / Double(points * 2) // Half-step for star points
                
                for i in 0..<points * 2 {
                    let radius = i % 2 == 0 ? outerRadius : innerRadius
                    let angle = Double(i) * angleStep - 90 // Start at top
                    let x = center.x + radius * cos(CGFloat(angle) * .pi / 180)
                    let y = center.y + radius * sin(CGFloat(angle) * .pi / 180)
                    
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                path.closeSubpath()
            }
            .foregroundColor(Constants.accentColor)
        }
        .frame(width: 24, height: 24)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360 // Clockwise rotation
            }
        }
    }
}
