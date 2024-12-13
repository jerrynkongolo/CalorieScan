//
//  SignUpView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Button(action: viewModel.signUp) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Capsule().foregroundColor(.green))
            .foregroundColor(.white)
            .disabled(viewModel.isLoading)
            .padding(.top, 20)
        }
        .padding()
    }
}
