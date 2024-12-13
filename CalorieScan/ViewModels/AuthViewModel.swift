//
//  AuthViewModel.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import FirebaseAuth
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func login() {
        guard isValidEmail(email), isValidPassword(password) else {
            errorMessage = "Please enter valid credentials."
            return
        }
        
        Task {
            isLoading = true
            do {
                try await FirebaseService.shared.signIn(email: email, password: password)
                isAuthenticated = true
                errorMessage = nil
            } catch let error as AuthError {
                errorMessage = error.localizedDescription
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func signUp() {
        guard isValidEmail(email), isValidPassword(password) else {
            errorMessage = "Please enter a valid email and password (6+ chars)."
            return
        }
        
        Task {
            isLoading = true
            do {
                try await FirebaseService.shared.signUp(email: email, password: password)
                isAuthenticated = true
                errorMessage = nil
            } catch let error as AuthError {
                errorMessage = error.localizedDescription
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
