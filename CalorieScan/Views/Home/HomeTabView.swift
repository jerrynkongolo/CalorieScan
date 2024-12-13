import SwiftUI

struct HomeTabView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.Spacing.large) {
                headerSection
                progressSection
                mealsSection
                recentFoodsSection
                Spacer(minLength: 0)
            }
        }
        .withGradientBackground()
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Good Evening")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Jerry")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: Constants.Size.iconMedium, height: Constants.Size.iconMedium)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                )
        }
        .padding()
    }
    
    private var progressSection: some View {
        GlassContainer {
            VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                Text("Today's Progress")
                    .font(.headline)
                    .padding(.top, Constants.Spacing.small)
                    .padding(.horizontal)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: Constants.CornerRadius.small)
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 20)
                        
                        RoundedRectangle(cornerRadius: Constants.CornerRadius.small)
                            .fill(Color.purple)
                            .frame(width: geometry.size.width * viewModel.calculateProgress(), height: 20)
                    }
                }
                .frame(height: 20)
                .padding(.horizontal)
                
                caloriesInfo
                    .padding(.horizontal)
                    .padding(.bottom, Constants.Spacing.small)
            }
        }
        .padding(.horizontal)
    }
    
    private var caloriesInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Remaining")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(viewModel.remainingCalories)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Consumed")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(viewModel.consumedCalories)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
    }
    
    private var mealsSection: some View {
        VStack(spacing: Constants.Spacing.medium) {
            SectionHeader(title: "Meals Today", showSeeAll: true) {
                // Handle see all action
            }
            
            VStack(spacing: Constants.Spacing.small) {
                ForEach(Meal.sampleMeals) { meal in
                    MealListItem(meal: meal)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var recentFoodsSection: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            SectionHeader(title: "Recent Foods")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Constants.Spacing.medium) {
                    ForEach(Food.sampleFoods) { food in
                        FoodCard(food: food)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
