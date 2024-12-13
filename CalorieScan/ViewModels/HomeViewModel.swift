import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var remainingCalories: Int = 1248
    @Published var consumedCalories: Int = 752
    
    // Add any business logic methods here
    func calculateProgress() -> CGFloat {
        CGFloat(Float(consumedCalories) / Float(remainingCalories + consumedCalories))
    }
}
