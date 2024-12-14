import SwiftUI

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Constants.Spacing.large) {
                    // Weekly Progress
                    VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                        SectionHeader(title: "Weekly Progress")
                        WeeklyProgressChart(data: viewModel.weeklyData)
                    }
                    
                    // Nutrition Breakdown
                    VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                        SectionHeader(title: "Nutrition Breakdown")
                        NutritionBreakdownCard(
                            protein: viewModel.proteinPercentage,
                            carbs: viewModel.carbsPercentage,
                            fats: viewModel.fatsPercentage
                        )
                    }
                    
                    // Trends
                    VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                        SectionHeader(title: "Trends")
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: Constants.Spacing.medium) {
                            TrendCard(
                                title: "Calorie Trend",
                                value: "\(Int(viewModel.averageCalories))",
                                subtitle: "Daily Average",
                                trend: viewModel.calorieTrend,
                                iconName: "flame.fill",
                                color: .blue.opacity(0.7)
                            )
                            
                            TrendCard(
                                title: "Protein Intake",
                                value: "\(Int(viewModel.averageProtein))g",
                                subtitle: "Daily Average",
                                trend: viewModel.proteinTrend,
                                iconName: "figure.strengthtraining.traditional",
                                color: .green.opacity(0.7)
                            )
                        }
                    }
                    
                    // Recommendations
                    VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                        SectionHeader(title: "Recommendations")
                        VStack(spacing: Constants.Spacing.small) {
                            ForEach(viewModel.recommendations) { recommendation in
                                RecommendationCard(recommendation: recommendation)
                            }
                        }
                    }
                }
                .padding(.horizontal, Constants.Spacing.medium)
            }
            .background(Constants.Colors.secondaryBackground)
            .withGradientBackground(.progress)
            .navigationTitle("Insights")
            .refreshable {
                await viewModel.refreshData()
            }
        }
    }
}

#Preview {
    InsightsView()
}
