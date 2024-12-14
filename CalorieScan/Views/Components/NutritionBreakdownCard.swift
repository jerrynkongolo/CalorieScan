import SwiftUI

struct NutritionBreakdownCard: View {
    let protein: Double
    let carbs: Double
    let fats: Double
    
    var body: some View {
        GlassContainer {
            VStack(spacing: Constants.Spacing.medium) {
                MacroProgressBar(
                    title: "Protein",
                    value: protein,
                    color: .blue.opacity(0.7)
                )
                
                MacroProgressBar(
                    title: "Carbs",
                    value: carbs,
                    color: .green.opacity(0.7)
                )
                
                MacroProgressBar(
                    title: "Fats",
                    value: fats,
                    color: .purple.opacity(0.7)
                )
            }
            .padding()
        }
    }
}

struct MacroProgressBar: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(value * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * value, height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    NutritionBreakdownCard(protein: 0.3, carbs: 0.5, fats: 0.2)
        .padding()
}
