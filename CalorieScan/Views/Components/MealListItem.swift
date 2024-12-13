import SwiftUI

struct MealListItem: View {
    let meal: Meal
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: Constants.Spacing.medium) {
            mealIcon
            mealInfo
            Spacer()
            calorieInfo
        }
        .padding(Constants.Spacing.medium)
        .cardStyle()
    }
    
    private var mealIcon: some View {
        Circle()
            .fill(Constants.Colors.primary.opacity(0.1))
            .frame(width: Constants.Size.iconLarge, height: Constants.Size.iconLarge)
            .overlay(
                Image(systemName: meal.icon)
                    .foregroundColor(Constants.Colors.primary)
                    .font(.title2)
            )
    }
    
    private var mealInfo: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
            Text(meal.name)
                .font(.headline)
                .foregroundColor(Constants.Colors.textPrimary)
            
            Text(dateFormatter.string(from: meal.timestamp))
                .font(.subheadline)
                .foregroundColor(Constants.Colors.textSecondary)
        }
    }
    
    private var calorieInfo: some View {
        Text("\(meal.calories) kcal")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(Constants.Colors.textDark)
    }
}

#Preview {
    VStack {
        ForEach(Meal.sampleMeals) { meal in
            MealListItem(meal: meal)
        }
    }
    .padding()
    .background(Color(.systemGray6))
}
