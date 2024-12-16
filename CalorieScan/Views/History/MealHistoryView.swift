import SwiftUI

struct MealHistoryView: View {
    @State private var selectedFilter: MealType? = nil
    @State private var searchText = ""
    @State private var isShowingFilters = false
    
    var body: some View {
        ScrollableView(title: "Meal History") {
            VStack(spacing: Constants.Spacing.large) {
                // Weekly Summary Card
                WeeklySummaryCard(
                    averageCalories: 1850,
                    totalMeals: 21,
                    streakDays: 7
                )
                
                // Search and Filter
                HStack {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search meals", text: $searchText)
                    }
                    .padding(8)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    
                    // Filter Button
                    Button {
                        isShowingFilters.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.primary)
                            .font(.title2)
                    }
                }
                .padding(.horizontal, Constants.Spacing.medium)
                
                // Meal Type Filter Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterPill(title: "All", isSelected: selectedFilter == nil) {
                            selectedFilter = nil
                        }
                        
                        ForEach(MealType.allCases, id: \.self) { type in
                            FilterPill(title: type.rawValue, isSelected: selectedFilter == type) {
                                selectedFilter = type
                            }
                        }
                    }
                    .padding(.horizontal, Constants.Spacing.medium)
                }
                
                // Daily Sections
                VStack(spacing: Constants.Spacing.large) {
                    // Today
                    DaySection(
                        title: "Today",
                        totalCalories: 840,
                        meals: [
                            MealData(type: "Breakfast", time: "8:00 AM", calories: 320, iconColor: .yellow),
                            MealData(type: "Lunch", time: "1:00 PM", calories: 520, iconColor: .green)
                        ]
                    )
                    
                    // Yesterday
                    DaySection(
                        title: "Yesterday",
                        totalCalories: 1480,
                        meals: [
                            MealData(type: "Breakfast", time: "8:30 AM", calories: 350, iconColor: .yellow),
                            MealData(type: "Lunch", time: "12:30 PM", calories: 480, iconColor: .green),
                            MealData(type: "Dinner", time: "7:00 PM", calories: 650, iconColor: .blue)
                        ]
                    )
                }
            }
        }
        .sheet(isPresented: $isShowingFilters) {
            FilterView()
        }
    }
}

// MARK: - Supporting Views

struct WeeklySummaryCard: View {
    let averageCalories: Int
    let totalMeals: Int
    let streakDays: Int
    
    var body: some View {
        GlassContainer {
            VStack(spacing: Constants.Spacing.medium) {
                Text("Weekly Summary")
                    .font(.headline)
                
                HStack(spacing: Constants.Spacing.large) {
                    StatItem(title: "Average", value: "\(averageCalories)", unit: "kcal")
                    StatItem(title: "Meals", value: "\(totalMeals)", unit: "total")
                    StatItem(title: "Streak", value: "\(streakDays)", unit: "days")
                }
            }
            .padding(Constants.Spacing.medium)
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, Constants.Spacing.medium)
                .padding(.vertical, 8)
                .background(isSelected ? Constants.Colors.primary : Color(.systemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct DaySection: View {
    let title: String
    let totalCalories: Int
    let meals: [MealData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(totalCalories) kcal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: Constants.Spacing.small) {
                ForEach(meals) { meal in
                    MealCard(
                        mealType: meal.type,
                        time: meal.time,
                        calories: meal.calories,
                        iconColor: meal.iconColor.opacity(0.2)
                    )
                }
            }
        }
        .padding(.horizontal, Constants.Spacing.medium)
    }
}

struct FilterView: View {
    var body: some View {
        NavigationView {
            List {
                Section("Date Range") {
                    Text("Today")
                    Text("Last 7 Days")
                    Text("Last 30 Days")
                    Text("Custom Range...")
                }
                
                Section("Meal Type") {
                    ForEach(MealType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                
                Section("Calories") {
                    Text("Under 300 kcal")
                    Text("300-500 kcal")
                    Text("500-800 kcal")
                    Text("Over 800 kcal")
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Supporting Types

struct MealData: Identifiable {
    let id = UUID()
    let type: String
    let time: String
    let calories: Int
    let iconColor: Color
}

#Preview {
    NavigationStack {
        MealHistoryView()
    }
}
