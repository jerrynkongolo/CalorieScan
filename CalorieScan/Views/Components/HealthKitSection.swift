import SwiftUI

struct HealthKitSection: View {
    var body: some View {
        VStack(spacing: 0) {
            healthRow(
                title: "Steps",
                value: "8,547",
                subtitle: "85% of daily goal",
                icon: "figure.walk"
            )
            Divider()
                .padding(.vertical, 8)
            
            healthRow(
                title: "Active Energy",
                value: "456 kcal",
                subtitle: "76% of daily goal",
                icon: "flame.fill"
            )
            Divider()
                .padding(.vertical, 8)
            
            healthRow(
                title: "Exercise Time",
                value: "45 min",
                subtitle: "90% of daily goal",
                icon: "timer"
            )
            Divider()
                .padding(.vertical, 8)
            
            healthRow(
                title: "Stand Hours",
                value: "10 hrs",
                subtitle: "83% of daily goal",
                icon: "figure.stand"
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(Constants.CornerRadius.medium)
    }
    
    private func healthRow(title: String, value: String, subtitle: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ScrollView {
        HealthKitSection()
            .padding()
    }
    .background(Constants.Colors.secondaryBackground)
}
