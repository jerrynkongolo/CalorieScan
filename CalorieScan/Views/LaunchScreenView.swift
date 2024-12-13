//
//  LaunchScreenView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var opacity: Double = 0.0
    let onAnimationComplete: () -> Void
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            Text("CalorieScan")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        opacity = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        // Fade out
                        withAnimation(.easeInOut(duration: 1)) {
                            opacity = 0.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            onAnimationComplete()
                        }
                    }
                }
        }
    }
}
