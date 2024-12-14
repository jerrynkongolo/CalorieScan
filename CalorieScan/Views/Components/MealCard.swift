import SwiftUI

struct MealCard: View {
    let mealType: String
    let time: String
    let calories: Int
    let iconColor: Color
    
    var body: some View {
        GlassContainer {
            HStack {
                Circle()
                    .fill(iconColor)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: mealIcon)
                            .foregroundColor(.gray)
                    }
                
                VStack(alignment: .leading) {
                    Text(mealType)
                        .font(.headline)
                    Text(time)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(calories) kcal")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 8)
        }
    }
    
    private var mealIcon: String {
        switch mealType.lowercased() {
        case "breakfast":
            return "sunrise.fill"
        case "lunch":
            return "sun.max.fill"
        case "dinner":
            return "moon.stars.fill"
        case "snack":
            return "carrot.fill"
        default:
            return "fork.knife"
        }
    }
}

#Preview {
    VStack {
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
    .padding()
}
