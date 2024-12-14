import SwiftUI

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    @Published var hasCompletedProfile: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedProfile, forKey: "hasCompletedProfile")
        }
    }
    
    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.hasCompletedProfile = UserDefaults.standard.bool(forKey: "hasCompletedProfile")
    }
}