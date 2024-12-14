//
//  OnboardingContainerView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Track Your Calories",
            description: "Easily log your meals and track your daily calorie intake",
            imageName: "chart.bar.fill"
        ),
        OnboardingPage(
            title: "Set Goals",
            description: "Set personalized goals and track your progress",
            imageName: "target"
        ),
        OnboardingPage(
            title: "Stay Healthy",
            description: "Make informed decisions about your nutrition",
            imageName: "heart.fill"
        )
    ]
    
    var body: some View {
        TabView(selection: $currentPage) {
            ForEach(pages.indices, id: \.self) { index in
                OnboardingPageView(page: pages[index]) {
                    if index == pages.count - 1 {
                        withAnimation {
                            appState.hasCompletedOnboarding = true
                        }
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingContainerView()
        .environmentObject(AppState())
}
