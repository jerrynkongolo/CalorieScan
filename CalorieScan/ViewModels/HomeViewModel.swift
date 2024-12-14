import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var remainingCalories: Int = 0
    @Published var consumedCalories: Int = 0
    @Published var progressValue: Double = 0.0
    @Published var isLoading = false
    @Published var error: Error?
    @Published var dailyCalorieTarget: Int = 2000
    
    private let userDataService: UserDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(userDataService: UserDataServiceProtocol = UserDataService.shared) {
        self.userDataService = userDataService
        setupSubscriptions()
        updateProgress()
    }
    
    private func setupSubscriptions() {
        // Subscribe to user profile updates
        userDataService.userProfilePublisher
            .sink { [weak self] profile in
                self?.userProfile = profile
                self?.updateProgress()
            }
            .store(in: &cancellables)
        
        // Subscribe to loading state
        userDataService.isLoadingPublisher
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        // Subscribe to errors
        userDataService.errorPublisher
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
    }
    
    private func updateProgress() {
        guard let profile = userProfile else {
            resetProgress()
            return
        }
        
        dailyCalorieTarget = profile.dailyCalorieTarget
        let target = Double(dailyCalorieTarget)
        let consumed = Double(consumedCalories)
        
        remainingCalories = dailyCalorieTarget - consumedCalories
        progressValue = min(consumed / target, 1.0)
    }
    
    private func resetProgress() {
        remainingCalories = 0
        consumedCalories = 0
        progressValue = 0.0
        dailyCalorieTarget = 2000
    }
    
    func updateCalories(_ calories: Int) {
        consumedCalories += calories
        updateProgress()
    }
    
    func refreshProfile() async {
        await userDataService.refreshUserData()
    }
    
    func signOut() async {
        do {
            try await userDataService.signOut()
            resetProgress()
        } catch {
            self.error = error
        }
    }
}
