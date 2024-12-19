//
//  LaunchScreenView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.8
    
    let onAnimationComplete: () -> Void
    
    var body: some View {
        ZStack {
            // A fresh green gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.55, green: 0.78, blue: 0.27),  // Lighter green
                    Color(red: 0.41, green: 0.62, blue: 0.22)   // Deeper green
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "leaf.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        // Animate logo appearing and scaling up
                        withAnimation(.easeInOut(duration: 1)) {
                            opacity = 1.0
                            scale = 1.0
                        }
                    }
                
                Text("CalorieScan")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(opacity)
            }
        }
        .onAppear {
            // After a brief pause, fade out and trigger completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 1)) {
                    opacity = 0.0
                    scale = 0.8
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    onAnimationComplete()
                }
            }
        }
    }
}
