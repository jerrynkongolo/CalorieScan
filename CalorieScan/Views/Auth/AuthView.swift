//
//  AuthView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

public struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState
    @State private var selectedSegment = 0
    
    public var body: some View {
        VStack {
            Picker("", selection: $selectedSegment) {
                Text("Login").tag(0)
                Text("Sign Up").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedSegment == 0 {
                LoginView(viewModel: viewModel)
            } else {
                SignUpView(viewModel: viewModel)
            }
        }
        .onChange(of: viewModel.isAuthenticated) { newValue in
            if newValue {
                appState.isAuthenticated = true
            }
        }
    }
}
