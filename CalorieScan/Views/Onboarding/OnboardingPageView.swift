//
//  OnboardingPageView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

struct OnboardingPageView: View {
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .foregroundColor(.blue)
                .padding()
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .padding()
    }
}
