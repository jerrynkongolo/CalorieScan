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
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.95, blue: 1.0),
                    Color(red: 0.98, green: 0.95, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
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
                    Button(action: {
                        Task {
                            await viewModel.login()
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.purple)
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Sign In")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(height: 50)
                    .disabled(viewModel.isLoading)
                    
                    // Forgot Password
                    Button("Forgot Password?") {
                        showForgotPassword = true
                    }
                    .foregroundColor(.purple)
                    .sheet(isPresented: $showForgotPassword) {
                        ForgotPasswordView()
                    }
                    
                    // Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                        Text("or")
                            .foregroundColor(.gray)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    .padding(.vertical)
                    
                    // Social Sign In
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Image("google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "apple.logo")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Sign Up Navigation
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                            Text("Sign up")
                                .fontWeight(.medium)
                                .foregroundColor(.purple)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}
