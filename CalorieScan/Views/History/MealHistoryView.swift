import SwiftUI

struct MealHistoryView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.Spacing.medium) {
                // Today
                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    Text("Today")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: Constants.Spacing.small) {
                        MealCard(
                            mealType: "Breakfast",
                            time: "8:00 AM",
                            calories: 320,
                            iconColor: .yellow.opacity(0.2)
                        )
                        
                        MealCard(
                            mealType: "Lunch",
                            time: "1:00 PM",
                            calories: 520,
                            iconColor: .green.opacity(0.2)
                        )
                    }
                }
                
                // Yesterday
                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    Text("Yesterday")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: Constants.Spacing.small) {
                        MealCard(
                            mealType: "Breakfast",
                            time: "8:30 AM",
                            calories: 350,
                            iconColor: .yellow.opacity(0.2)
                        )
                        
                        MealCard(
                            mealType: "Lunch",
                            time: "12:30 PM",
                            calories: 480,
                            iconColor: .green.opacity(0.2)
                        )
                        
                        MealCard(
                            mealType: "Dinner",
                            time: "7:00 PM",
                            calories: 650,
                            iconColor: .blue.opacity(0.2)
                        )
                    }
                }
            }
            .padding()
        }
        .background(Constants.Colors.secondaryBackground)
        .navigationTitle("Meal History")
    }
}

#Preview {
    NavigationStack {
        MealHistoryView()
    }
}
