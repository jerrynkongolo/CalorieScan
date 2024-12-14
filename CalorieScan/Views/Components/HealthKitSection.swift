import SwiftUI

struct HealthKitSection: View {
    var body: some View {
        VStack(spacing: Constants.Spacing.medium) {
            statItem(title: "Steps", value: "8,547", subtitle: "Goal: 10,000", icon: "figure.walk", color: .blue)
            statItem(title: "Active Energy", value: "385", subtitle: "kcal", icon: "flame.fill", color: .orange)
            statItem(title: "Exercise Time", value: "45", subtitle: "minutes", icon: "heart.fill", color: .red)
            statItem(title: "Stand Hours", value: "9", subtitle: "hours", icon: "figure.stand", color: .green)
        }
    }
    
    private func statItem(title: String, value: String, subtitle: String, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(value)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(Constants.CornerRadius.medium)
    }
}

#Preview {
    ScrollView {
        HealthKitSection()
            .padding()
    }
    .background(Constants.Colors.secondaryBackground)
}
