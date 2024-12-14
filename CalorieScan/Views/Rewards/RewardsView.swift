import SwiftUI

struct RewardsView: View {
    var body: some View {
        ScrollableView(title: "Rewards") {
            VStack(spacing: Constants.Spacing.large) {
                // Points Summary Card
                VStack(spacing: Constants.Spacing.medium) {
                    pointsSummaryItem(title: "Total Points", value: "100", textColor: .purple)
                    Divider()
                    pointsSummaryItem(title: "Completed", value: "1/4")
                }
                .padding(Constants.Spacing.medium)
                .background(Color.white)
                .cornerRadius(Constants.CornerRadius.medium)
                
                // Available Rewards
                VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                    Text("Available Rewards")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Rewards List
                    VStack(spacing: Constants.Spacing.medium) {
                        rewardCard(
                            title: "First Week Streak",
                            description: "Log your meals for 7 consecutive days",
                            points: 100,
                            iconName: "star.fill",
                            iconColor: .green
                        )
                        
                        rewardCard(
                            title: "Healthy Balance",
                            description: "Maintain balanced macros for 5 days",
                            points: 150,
                            iconName: "triangle.fill",
                            iconColor: .blue
                        )
                        
                        rewardCard(
                            title: "Step Master",
                            description: "Reach 10,000 steps for 3 days",
                            points: 200,
                            iconName: "figure.walk",
                            iconColor: .blue
                        )
                        
                        rewardCard(
                            title: "Calorie Goal",
                            description: "Stay within calorie goal for 5 days",
                            points: 300,
                            iconName: "flame.fill",
                            iconColor: .orange
                        )
                    }
                }
            }
        }
    }
    
    private func pointsSummaryItem(title: String, value: String, textColor: Color = .primary) -> some View {
        VStack(spacing: Constants.Spacing.small) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(textColor)
        }
    }
    
    private func rewardCard(title: String, description: String, points: Int, iconName: String, iconColor: Color) -> some View {
        HStack {
            Circle()
                .fill(iconColor.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: iconName)
                        .foregroundColor(iconColor)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(points)")
                    .font(.headline)
                    .foregroundColor(.purple)
                Text("pts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(Constants.Spacing.medium)
        .background(Color.white)
        .cornerRadius(Constants.CornerRadius.medium)
    }
}

#Preview {
    RewardsView()
}
