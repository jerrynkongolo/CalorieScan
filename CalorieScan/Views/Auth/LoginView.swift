//
//  LoginView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showForgotPassword = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo and Welcome Text
            VStack(spacing: 8) {
                Text("logo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Welcome Back")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Sign in to continue")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity)
            
            // Login Form
            VStack(spacing: 25) {
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email address")
                        .foregroundColor(.gray)
                    TextField("", text: $viewModel.email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                // Password Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .foregroundColor(.gray)
                    SecureField("", text: $viewModel.password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding()
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                
                // Sign In Button
                AppButton(
                    "Sign In",
                    isLoading: viewModel.isLoading
                ) {
                    Task {
                        await viewModel.login()
                    }
                }
                
                // Forgot Password Button
                Button("Forgot Password?") {
                    showForgotPassword = true
                }
                .foregroundColor(.gray)
                .font(.subheadline)
                .sheet(isPresented: $showForgotPassword) {
                    ForgotPasswordView()
                }
                
                Spacer()
                
                // Sign Up Link
                HStack(spacing: 4) {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                        Text("Sign up")
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .withGradientBackground()
    }
}
