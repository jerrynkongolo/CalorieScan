import Foundation

// This is just a UI model for displaying rewards
struct RewardModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let points: Int
    let iconName: String
    let isCompleted: Bool
    
    static let sampleRewards = [
        RewardModel(
            title: "First Week Streak",
            description: "Log your meals for 7 consecutive days",
            points: 100,
            iconName: "star.circle.fill",
            isCompleted: true
        ),
        RewardModel(
            title: "Healthy Balance",
            description: "Maintain balanced macros for 5 days",
            points: 150,
            iconName: "scale.3d",
            isCompleted: false
        ),
        RewardModel(
            title: "Step Master",
            description: "Reach 10,000 steps for 3 days",
            points: 200,
            iconName: "figure.walk.circle.fill",
            isCompleted: false
        ),
        RewardModel(
            title: "Calorie Goal",
            description: "Stay within calorie goal for a week",
            points: 300,
            iconName: "flame.circle.fill",
            isCompleted: false
        )
    ]
}
