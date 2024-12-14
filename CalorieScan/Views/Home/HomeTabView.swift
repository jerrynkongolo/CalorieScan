import SwiftUI

struct HomeTabView: View {
    @StateObject private var userDataService = UserDataService.shared
    @StateObject private var viewModel = HomeViewModel()
    @State private var showHistory = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Constants.Spacing.large) {
                    if let profile = userDataService.currentProfile {
                        Text("Hi, \(profile.name)")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Today's Progress
                    VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                        SectionHeader(title: "Today's Progress")
                        TodayProgressCard(
                            remainingCalories: viewModel.remainingCalories,
                            consumedCalories: viewModel.consumedCalories,
                            progress: viewModel.calculateProgress()
                        )
                    }
                    
                    // Insights
                    VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                        SectionHeader(title: "Insights")
                        InsightCard(
                            message: "Based on your meals today, you're doing great with protein intake! Consider adding more vegetables to your next meal for balanced nutrition.",
                            iconName: "brain.head.profile",
                            accentColor: Constants.Colors.Pastel.purple
                        )
                    }
                    
                    // Meals Today
                    VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                        HStack {
                            SectionHeader(title: "Meals Today")
                            Spacer()
                            Button("See All") {
                                showHistory = true
                            }
                            .foregroundColor(Constants.Colors.primary)
                        }
                        
                        VStack(spacing: Constants.Spacing.small) {
                            MealListItem(meal: Meal(name: "Breakfast", timestamp: Date(timeIntervalSince1970: 1608098400), calories: 320, icon: "sunrise.fill"))
                            MealListItem(meal: Meal(name: "Lunch", timestamp: Date(timeIntervalSince1970: 1608116400), calories: 520, icon: "sun.max.fill"))
                            MealListItem(meal: Meal(name: "Snack", timestamp: Date(timeIntervalSince1970: 1608127200), calories: 150, icon: "carrot.fill"))
                            MealListItem(meal: Meal(name: "Dinner", timestamp: Date(timeIntervalSince1970: 1608141600), calories: 450, icon: "moon.stars.fill"))
                        }
                    }
                    
                    // Recent Foods
                    VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                        SectionHeader(title: "Recent Foods")
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: Constants.Spacing.medium) {
                                ForEach(Food.sampleFoods) { food in
                                    FoodCard(food: food)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Constants.Spacing.medium)
            }
            .background(Constants.Colors.secondaryBackground)
        }
        .withGradientBackground(.home)
    }
}

#Preview {
    HomeTabView()
}
