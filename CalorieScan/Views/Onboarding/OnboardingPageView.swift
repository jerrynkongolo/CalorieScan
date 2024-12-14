//
//  OnboardingPageView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .foregroundColor(.blue)
                .padding()
            
            Text(page.title)
                .font(.title)
                .fontWeight(.semibold)
            
            Text(page.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Button(action: action) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 30)
            .padding(.horizontal)
        }
        .padding()
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(
            page: OnboardingPage(
                title: "Track Your Calories",
                description: "Easily log your meals and track your daily calorie intake",
                imageName: "chart.bar.fill"
            ),
            action: {}
        )
    }
}
