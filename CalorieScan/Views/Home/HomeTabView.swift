import SwiftUI

struct HomeTabView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var profileService = UserProfileService()
    @State private var showHistory = false
    @State private var showingProfileSetup = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if !profileService.isProfileComplete {
                    // Profile Setup Card
                    VStack(spacing: Constants.Spacing.medium) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(Constants.Colors.primary)
                        
                        Text("Welcome to CalorieScan!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Constants.Colors.textPrimary)
                        
                        Text("Let's set up your profile to get started with your health journey.")
                            .font(.body)
                            .foregroundColor(Constants.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            showingProfileSetup = true
                        } label: {
                            Text("Set Up Profile")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Constants.Colors.primary)
                                .cornerRadius(Constants.CornerRadius.medium)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(Constants.CornerRadius.medium)
                    .shadow(radius: 2)
                    .padding()
                } else {
                    VStack(spacing: Constants.Spacing.large) {
                        headerSection
                        progressSection
                        mealsSection
                        insightSection
                        recentFoodsSection
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, Constants.Spacing.small)
                }
            }
            .background(Constants.Colors.secondaryBackground)
            .navigationDestination(isPresented: $showHistory) {
                HistoryView()
            }
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showingProfileSetup) {
            ProfileSetupView(profileService: profileService)
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                Text("Good Evening")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(profileService.currentProfile?.name ?? "User")
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
                            .fill(Constants.Colors.primary)
                            .frame(width: geometry.size.width * viewModel.calculateProgress(), height: 20)
                    }
                }
                .frame(height: 20)
                .padding(.horizontal)
                
                if let profile = profileService.currentProfile {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Daily Target")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(Int(profile.dailyCalorieTarget))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.darkGray))
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Remaining")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(viewModel.remainingCalories)") // Will be updated with meal tracking
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.darkGray))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, Constants.Spacing.small)
                    .onAppear {
                        if let target = profileService.currentProfile?.dailyCalorieTarget {
                            viewModel.updateCalories(target: target)
                        }
                    }
                }
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
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            SectionHeader(
                title: "Meals Today",
                showSeeAll: true
            ) {
                showHistory = true
            }
            
            VStack(spacing: Constants.Spacing.small) {
                ForEach(Meal.sampleMeals) { meal in
                    MealListItem(meal: meal)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var insightSection: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            SectionHeader(title: "AI Food Insights")
            
            InsightCard(
                message: "Based on your meals today, you're doing great with protein intake! Consider adding more vegetables to your next meal for balanced nutrition.",
                iconName: "brain.head.profile",
                accentColor: Constants.Colors.Pastel.purple
            )
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

#Preview {
    HomeTabView()
}
