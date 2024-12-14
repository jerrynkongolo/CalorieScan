import SwiftUI
import Combine

class InsightsViewModel: ObservableObject {
    @Published var weeklyData: [DailyNutrition] = []
    @Published var recommendations: [Recommendation] = []
    
    @Published var proteinPercentage: Double = 0
    @Published var carbsPercentage: Double = 0
    @Published var fatsPercentage: Double = 0
    
    @Published var averageCalories: Double = 0
    @Published var averageProtein: Double = 0
    @Published var calorieTrend: Trend = .neutral
    @Published var proteinTrend: Trend = .neutral
    
    private var cancellables = Set<AnyCancellable>()
    private let userDataService: UserDataServiceProtocol
    
    init(userDataService: UserDataServiceProtocol = UserDataService.shared) {
        self.userDataService = userDataService
        setupSubscriptions()
        loadInitialData()
    }
    
    @MainActor
    func refreshData() async {
        await userDataService.refreshUserData()
        updateInsights()
    }
    
    private func setupSubscriptions() {
        // Observe user profile changes through Timer
        Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateInsights()
            }
            .store(in: &cancellables)
    }
    
    private func loadInitialData() {
        // Load sample data for now
        weeklyData = DailyNutrition.sampleData
        recommendations = Recommendation.sampleRecommendations
        updateInsights()
    }
    
    private func updateInsights() {
        // Calculate nutrition percentages
        let total = weeklyData.reduce(0) { $0 + $1.calories }
        averageCalories = total / Double(weeklyData.count)
        
        let totalProtein = weeklyData.reduce(0) { $0 + $1.protein }
        averageProtein = totalProtein / Double(weeklyData.count)
        
        // Calculate trends
        calorieTrend = calculateTrend(for: weeklyData.map { $0.calories })
        proteinTrend = calculateTrend(for: weeklyData.map { $0.protein })
        
        // Update macronutrient percentages
        let lastDay = weeklyData.last ?? DailyNutrition.sampleData[0]
        let totalMacros = lastDay.protein + lastDay.carbs + lastDay.fats
        
        proteinPercentage = lastDay.protein / totalMacros
        carbsPercentage = lastDay.carbs / totalMacros
        fatsPercentage = lastDay.fats / totalMacros
    }
    
    private func calculateTrend(for values: [Double]) -> Trend {
        guard values.count >= 2 else { return .neutral }
        
        let diff = values.last! - values[values.count - 2]
        if diff > 0 {
            return .up
        } else if diff < 0 {
            return .down
        } else {
            return .neutral
        }
    }
}

// Sample Data Structures
struct DailyNutrition: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Double
    let protein: Double
    let carbs: Double
    let fats: Double
    
    static var sampleData: [DailyNutrition] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<7).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            return DailyNutrition(
                date: date,
                calories: Double.random(in: 1800...2200),
                protein: Double.random(in: 100...150),
                carbs: Double.random(in: 200...300),
                fats: Double.random(in: 50...80)
            )
        }
    }
}

struct Recommendation: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let color: Color
    
    static var sampleRecommendations: [Recommendation] {
        [
            Recommendation(
                title: "Increase Protein Intake",
                description: "Try to include more lean protein sources in your meals to support your fitness goals.",
                iconName: "figure.strengthtraining.traditional",
                color: Constants.Colors.Pastel.blue
            ),
            Recommendation(
                title: "Stay Hydrated",
                description: "Remember to drink water throughout the day to maintain proper hydration.",
                iconName: "drop.fill",
                color: Constants.Colors.Pastel.blue
            ),
            Recommendation(
                title: "Balance Your Meals",
                description: "Include a variety of vegetables in your meals for essential nutrients.",
                iconName: "leaf.fill",
                color: Constants.Colors.Pastel.green
            )
        ]
    }
}

enum Trend {
    case up
    case down
    case neutral
}
