//
//  HomeView.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showProfile = false
    @State private var showAddMeal = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: Constants.Spacing.large) {
                        // Today's Progress
                        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                            SectionHeader(title: "Today's Progress")
                            TodayProgressCard(
                                remainingCalories: viewModel.remainingCalories,
                                consumedCalories: viewModel.consumedCalories,
                                progress: viewModel.progressValue
                            )
                        }
                        
                        // Insights
                        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                            SectionHeader(title: "Insights")
                            InsightCard(
                                message: "Based on your meals today, you're doing great with protein intake! Consider adding more vegetables to your next meal for balanced nutrition.",
                                iconName: "brain.head.profile",
                                accentColor: .blue.opacity(0.7)
                            )
                        }
                        
                        // Meals Today
                        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                            HStack {
                                SectionHeader(title: "Meals Today")
                                Spacer()
                                NavigationLink("See All") {
                                    MealHistoryView()
                                }
                                .foregroundColor(Constants.Colors.primary)
                                .fontWeight(.bold)
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
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding()
                }
                .background(Constants.Colors.secondaryBackground)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Hi, Jerry")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showProfile = true
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                        }
                    }
                }
                .sheet(isPresented: $showProfile) {
                    ProfileView()
                }
                .sheet(isPresented: $showAddMeal) {
                    // Add meal sheet will go here
                    Text("Add Meal Sheet")
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showAddMeal = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Circle().fill(Constants.Colors.primary))
                                .shadow(radius: 4, y: 2)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
