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
    
    func configure() async {
        guard !isConfigured else { return }
        isConfigured = true
        logger.info("Firebase service initialized")
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
    
    // MARK: - User Management
    
    private func createUserDocument(_ user: UserModel) async throws {
        try await db.collection("users").document(user.id).setData(user.toFirestore)
        logger.info("Created user document for: \(user.email)")
    }
    
    private func updateUserLastLogin(_ userId: String) async throws {
        try await db.collection("users").document(userId).updateData([
            "lastLoginAt": Timestamp(date: Date())
        ])
        logger.info("Updated last login for user: \(userId)")
    }
    
    func getCurrentUser() -> UserModel? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return UserModel(id: firebaseUser.uid, email: firebaseUser.email ?? "")
    }
    
    func signIn(email: String, password: String) async throws {
        guard isConfigured else {
            logger.error("Attempted to sign in before Firebase was configured")
            throw AuthError.configurationError
        }
        
        guard isAllowedDomain(email) else {
            throw AuthError.invalidDomain
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            try await updateUserLastLogin(result.user.uid)
            logger.info("User signed in successfully: \(email)")
        } catch {
            logger.error("Sign in failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signUp(email: String, password: String) async throws {
        guard isConfigured else {
            logger.error("Attempted to sign up before Firebase was configured")
            throw AuthError.configurationError
        }
        
        guard isAllowedDomain(email) else {
            throw AuthError.invalidDomain
        }
        
        if try await isEmailRegistered(email) {
            throw AuthError.emailAlreadyExists
        }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let newUser = UserModel(id: result.user.uid, email: email)
            try await createUserDocument(newUser)
            logger.info("New user created successfully: \(email)")
        } catch let error as NSError {
            logger.error("Sign up failed: \(error.localizedDescription)")
            
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                throw AuthError.emailAlreadyExists
            case AuthErrorCode.invalidEmail.rawValue:
                throw AuthError.invalidEmail(error.localizedDescription)
            default:
                throw error
            }
        }
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
