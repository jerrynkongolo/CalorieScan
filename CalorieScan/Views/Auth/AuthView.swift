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
    
    public var body: some View {
        LoginView(viewModel: viewModel)
            .onChange(of: viewModel.isAuthenticated) { newValue in
                if newValue {
                    appState.isAuthenticated = true
                }
            }
    }
}
