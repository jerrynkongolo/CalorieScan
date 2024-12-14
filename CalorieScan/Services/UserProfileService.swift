import Foundation
import FirebaseFirestore

class UserProfileService: ObservableObject {
    static let shared = UserProfileService()
    private let userDataService = UserDataService.shared
    
    @Published var currentProfile: UserProfile?
    @Published var isProfileComplete: Bool = false
    
    init() {
        loadCurrentUserProfile()
    }
    
    func loadCurrentUserProfile() {
        Task {
            do {
                let profile = try await userDataService.fetchProfile()
                DispatchQueue.main.async {
                    self.currentProfile = profile
                    self.isProfileComplete = profile != nil
                }
            } catch {
                print("Error loading profile: \(error)")
                DispatchQueue.main.async {
                    self.isProfileComplete = false
                }
            }
        }
    }
    
    func updateProfile(_ profile: UserProfile) async throws {
        try await userDataService.updateProfile(profile)
        DispatchQueue.main.async {
            self.currentProfile = profile
            self.isProfileComplete = true
        }
    }
}
