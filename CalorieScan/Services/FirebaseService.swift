import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import os.log

enum AuthError: Error {
    case invalidEmail(String)
    case emailAlreadyExists
    case invalidDomain
    case configurationError
    
    var localizedDescription: String {
        switch self {
        case .invalidEmail(let message):
            return message
        case .emailAlreadyExists:
            return "This email is already registered"
        case .invalidDomain:
            return "Please use your registered email domain"
        case .configurationError:
            return "Failed to initialize Firebase services"
        }
    }
}

actor FirebaseService {
    static let shared = FirebaseService()
    private let allowedDomains = ["icloud.com"]
    private let logger = Logger(subsystem: "com.jerrynkongolo.CalorieScan", category: "Firebase")
    
    private var isConfigured = false
    private lazy var db: Firestore = {
        guard FirebaseApp.app() != nil else {
            logger.error("Firebase must be configured before using Firestore")
            fatalError("Firebase must be configured before using Firestore")
        }
        return Firestore.firestore()
    }()
    
    private init() {}
    
    func configure() {
        guard !isConfigured else { return }
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
            isConfigured = true
            logger.info("Firebase configured successfully")
        }
    }
    
    private func isAllowedDomain(_ email: String) -> Bool {
        let domain = email.components(separatedBy: "@").last ?? ""
        return allowedDomains.contains(domain)
    }
    
    private func isEmailRegistered(_ email: String) async throws -> Bool {
        guard isConfigured else {
            logger.error("Attempting to check email registration before Firebase configuration")
            throw AuthError.configurationError
        }
        
        let methods = try await Auth.auth().fetchSignInMethods(forEmail: email)
        return !methods.isEmpty
    }
    
    func signIn(email: String, password: String) async throws {
        guard isConfigured else {
            logger.error("Attempting to sign in before Firebase configuration")
            throw AuthError.configurationError
        }
        
        guard isAllowedDomain(email) else {
            throw AuthError.invalidDomain
        }
        
        try await Auth.auth().signIn(withEmail: email, password: password)
        logger.info("User signed in successfully: \(email)")
    }
    
    func signUp(email: String, password: String) async throws {
        guard isConfigured else {
            logger.error("Attempting to sign up before Firebase configuration")
            throw AuthError.configurationError
        }
        
        guard isAllowedDomain(email) else {
            throw AuthError.invalidDomain
        }
        
        if try await isEmailRegistered(email) {
            throw AuthError.emailAlreadyExists
        }
        
        try await Auth.auth().createUser(withEmail: email, password: password)
        logger.info("New user created successfully: \(email)")
    }
    
    func resetPassword(email: String) async throws {
        guard isConfigured else {
            logger.error("Attempting to reset password before Firebase configuration")
            throw AuthError.configurationError
        }
        
        guard isAllowedDomain(email) else {
            throw AuthError.invalidDomain
        }
        
        try await Auth.auth().sendPasswordReset(withEmail: email)
        logger.info("Password reset email sent to: \(email)")
    }
    
    func signOut() throws {
        guard isConfigured else {
            logger.error("Attempting to sign out before Firebase configuration")
            throw AuthError.configurationError
        }
        
        try Auth.auth().signOut()
        logger.info("User signed out successfully")
    }
}
