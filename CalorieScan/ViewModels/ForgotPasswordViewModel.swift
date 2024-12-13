import Foundation

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isSuccess: Bool = false
    
    func resetPassword() async {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email"
            return
        }
        
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        do {
            try await FirebaseService.shared.resetPassword(email: email)
            isSuccess = true
            errorMessage = nil
        } catch let error as AuthError {
            errorMessage = error.localizedDescription
            isSuccess = false
        } catch {
            errorMessage = error.localizedDescription
            isSuccess = false
        }
        
        isLoading = false
    }
}
