import SwiftUI

class HomeViewModel: ObservableObject {
    private let userDataService = UserDataService.shared
    @Published var remainingCalories: Int = 0
    @Published var consumedCalories: Int = 0
    @Published var dailyCalorieTarget: Int = 2000
    
    init() {
        loadUserProfile()
    }
    
    private func loadUserProfile() {
        Task {
            do {
                if let profile = try await userDataService.fetchProfile() {
                    DispatchQueue.main.async {
                        self.dailyCalorieTarget = profile.dailyCalorieTarget
                        self.remainingCalories = profile.dailyCalorieTarget - self.consumedCalories
                    }
                }
            } catch {
                print("Error loading profile: \(error)")
            }
        }
    }
    
    func updateCalories(_ calories: Int) {
        consumedCalories += calories
        remainingCalories = max(0, dailyCalorieTarget - consumedCalories)
    }
    
    func calculateProgress() -> CGFloat {
        guard dailyCalorieTarget > 0 else { return 0 }
        return CGFloat(Float(consumedCalories) / Float(dailyCalorieTarget))
    }
}
