import SwiftUI

struct RewardsView: View {
    private let rewards = RewardModel.sampleRewards
    
    private var totalPoints: Int {
        rewards.filter { $0.isCompleted }.reduce(0) { $0 + $1.points }
    }
    
    private var completedRewards: Int {
        rewards.filter { $0.isCompleted }.count
    }
    
    var body: some View {
        ScrollableView(title: "Rewards") {
            VStack(spacing: Constants.Spacing.large) {
                // Summary Card
                VStack(spacing: Constants.Spacing.medium) {
                    // Points
                    VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                        Text("Total Points")
                            .font(.subheadline)
                            .foregroundColor(Constants.Colors.textSecondary)
                        
                        Text("\(totalPoints)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Constants.Colors.primary)
                    }
                    
                    Divider()
                    
                    // Progress
                    VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                        Text("Completed")
                            .font(.subheadline)
                            .foregroundColor(Constants.Colors.textSecondary)
                        
                        Text("\(completedRewards)/\(rewards.count)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Constants.Colors.textPrimary)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(Constants.CornerRadius.medium)
                
                // Available Rewards
                VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                    SectionHeader(title: "Available Rewards")
                    
                    ForEach(rewards) { reward in
                        // Reward Card
                        HStack(spacing: Constants.Spacing.medium) {
                            // Icon
                            Circle()
                                .fill(reward.isCompleted ? Constants.Colors.Pastel.green : Constants.Colors.Pastel.blue)
                                .frame(width: Constants.Size.iconLarge, height: Constants.Size.iconLarge)
                                .overlay(
                                    Image(systemName: reward.iconName)
                                        .font(.title2)
                                        .foregroundColor(Constants.Colors.textDark)
                                )
                            
                            // Content
                            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                                Text(reward.title)
                                    .font(.headline)
                                    .foregroundColor(Constants.Colors.textPrimary)
                                
                                Text(reward.description)
                                    .font(.subheadline)
                                    .foregroundColor(Constants.Colors.textSecondary)
                            }
                            
                            Spacer()
                            
                            // Points
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("\(reward.points)")
                                    .font(.headline)
                                    .foregroundColor(Constants.Colors.primary)
                                
                                Text("pts")
                                    .font(.caption)
                                    .foregroundColor(Constants.Colors.textSecondary)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(Constants.CornerRadius.medium)
                    }
                }
            }
        }
    }
}

#Preview {
    RewardsView()
}
