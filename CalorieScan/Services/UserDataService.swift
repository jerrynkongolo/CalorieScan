import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

final class UserDataService: ObservableObject, UserDataServiceProtocol {
    static let shared = UserDataService()
    
    private let firestoreManager = FirestoreManager.shared
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var userProfile: UserProfile?
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    var userProfilePublisher: AnyPublisher<UserProfile?, Never> {
        $userProfile.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error?, Never> {
        $error.eraseToAnyPublisher()
    }
    
    private init() {
        setupAuthStateListener()
    }
    
    deinit {
        cleanup()
    }
    
    private func cleanup() {
        listenerRegistration?.remove()
        listenerRegistration = nil
        cancellables.removeAll()
    }
    
    private func setupAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                self?.startProfileListener(for: user.uid)
            } else {
                self?.cleanup()
                self?.userProfile = nil
            }
        }
    }
    
    private func startProfileListener(for userId: String) {
        // Remove existing listener if any
        cleanup()
        
        let profilePath = "users/\(userId)"
        
        // Add new listener using FirestoreManager
        let listenerId = firestoreManager.addListener(for: profilePath) { [weak self] snapshot, error in
            if let error = error {
                self?.error = error
                return
            }
            
            guard let snapshot = snapshot else {
                self?.error = NSError(domain: "com.jerrynkongolo.CalorieScan", code: -1, userInfo: [NSLocalizedDescriptionKey: "Profile not found"])
                return
            }
            
            do {
                let profile = try snapshot.data(as: UserProfile.self)
                DispatchQueue.main.async {
                    self?.userProfile = profile
                    self?.error = nil
                }
            } catch {
                self?.error = error
            }
        }
        
        // Store listener ID for cleanup
        UserDefaults.standard.set(listenerId, forKey: "UserProfileListenerId")
    }
    
    @MainActor
    func refreshUserData() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        error = nil
        
        do {
            let profilePath = "users/\(userId)"
            let docRef = db.document(profilePath)
            let document = try await docRef.getDocument()
            
            if let data = document.data() {
                let id = data["id"] as? String ?? UUID().uuidString
                let name = data["name"] as? String ?? ""
                let age = data["age"] as? Int ?? 0
                let weight = data["weight"] as? Double ?? 0.0
                let height = data["height"] as? Double ?? 0.0
                let workoutFrequencyRaw = data["workoutFrequency"] as? String ?? ""
                let weightGoalRaw = data["weightGoal"] as? String ?? ""
                let targetWeight = data["targetWeight"] as? Double ?? weight
                let targetDate = (data["targetDate"] as? Timestamp)?.dateValue() ?? Date()
                let dailyCalorieTarget = data["dailyCalorieTarget"] as? Int ?? 2000
                let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                let updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
                
                let workoutFrequency = WorkoutFrequency(rawValue: workoutFrequencyRaw) ?? .sedentary
                let weightGoal = WeightGoal(rawValue: weightGoalRaw) ?? .maintain
                
                self.userProfile = UserProfile(
                    id: UUID(uuidString: id) ?? UUID(),
                    name: name,
                    age: age,
                    weight: weight,
                    height: height,
                    workoutFrequency: workoutFrequency,
                    weightGoal: weightGoal,
                    targetWeight: targetWeight,
                    targetDate: targetDate,
                    dailyCalorieTarget: dailyCalorieTarget,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
            }
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func fetchProfile() async throws -> UserProfile {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "com.jerrynkongolo.CalorieScan", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let snapshot = try await firestoreManager.getDocument("users/\(userId)")
        return try snapshot.data(as: UserProfile.self)
    }
    
    func updateProfile(_ profile: UserProfile) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "com.jerrynkongolo.CalorieScan", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        let data = try Firestore.Encoder().encode(profile)
        try await firestoreManager.setDocument("users/\(userId)", data: data)
    }
    
    func deleteProfile() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "com.jerrynkongolo.CalorieScan", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        
        try await firestoreManager.deleteDocument("users/\(userId)")
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            cleanup()
            userProfile = nil
        } catch {
            self.error = error
        }
    }
}
