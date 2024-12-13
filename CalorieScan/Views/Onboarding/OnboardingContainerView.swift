//
//  OnboardingContainerView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

public struct OnboardingContainerView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentIndex = 0
    
    let pages = [
        (title: "Scan your food.", subtitle: "Use our camera-based scanner to identify food items.", image: "camera"),
        (title: "Track your calories.", subtitle: "Automatically get calorie counts and keep track of daily intake.", image: "heart.fill"),
        (title: "Stay healthy.", subtitle: "Maintain your diet goals with ease.", image: "leaf.fill")
    ]
    
    public var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(pages.indices, id: \.self) { i in
                    OnboardingPageView(title: pages[i].title, subtitle: pages[i].subtitle, imageName: pages[i].image)
                        .tag(i)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            
            if currentIndex == pages.count - 1 {
                Button(action: {
                    // Transition to authentication
                    // In ContentView, set a state to show AuthView
                    appState.isAuthenticated = false // Just ensuring state reflects no user
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Capsule().foregroundColor(.blue))
                }
                .padding(.bottom, 40)
            }
        }
    }
}
