import SwiftUI

struct FoodCard: View {
    let food: Food
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
            foodImage
            foodInfo
        }
        .cardStyle()
        .frame(width: Constants.Size.foodCardWidth)
    }
    
    private var foodImage: some View {
        Image(food.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: Constants.Size.foodCardWidth, height: Constants.Size.foodCardImageHeight)
            .clipped()
            .cornerRadius(Constants.CornerRadius.medium)
    }
    
    private var foodInfo: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
            Text(food.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
            
            Text("\(food.calories) kcal")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, Constants.Spacing.small)
        .padding(.bottom, Constants.Spacing.small)
    }
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: Constants.Spacing.medium) {
            ForEach(Food.sampleFoods) { food in
                FoodCard(food: food)
            }
        }
        .padding()
    }
    .background(Color(.systemGray6))
}
