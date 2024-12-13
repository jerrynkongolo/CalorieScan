import SwiftUI

struct ProgressView: View {
    var body: some View {
        ScrollableView(title: "Progress") {
            VStack(spacing: Constants.Spacing.large) {
                profileSummarySection
                dailyEnergySection
                foodTargetSection
                activeTargetSection
            }
        }
    }
    
    private var profileSummarySection: some View {
        ProgressSection(
            title: "Profile Summary",
            iconName: "person.circle.fill"
        ) {
            VStack(spacing: Constants.Spacing.medium) {
                HStack {
                    statItem(title: "Weight", value: "75 kg")
                    Spacer()
                    statItem(title: "Height", value: "175 cm")
                    Spacer()
                    statItem(title: "BMI", value: "24.5")
                }
                
                HStack {
                    statItem(title: "Age", value: "28")
                    Spacer()
                    statItem(title: "Gender", value: "Male")
                    Spacer()
                    statItem(title: "Activity", value: "Active")
                }
            }
        }
    }
    
    private var dailyEnergySection: some View {
        ProgressSection(
            title: "Daily Energy Plan",
            iconName: "bolt.circle.fill"
        ) {
            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                energyRow(title: "Base Metabolic Rate", value: "1,700 kcal")
                energyRow(title: "Activity Calories", value: "+400 kcal")
                energyRow(title: "Food Calories", value: "-2,000 kcal")
                
                Divider()
                
                energyRow(title: "Net Calories", value: "100 kcal")
                    .fontWeight(.semibold)
            }
        }
    }
    
    private var foodTargetSection: some View {
        ProgressSection(
            title: "Daily Food Target",
            iconName: "fork.knife.circle.fill"
        ) {
            VStack(spacing: Constants.Spacing.medium) {
                nutrientProgress(
                    title: "Protein",
                    current: 80,
                    target: 120,
                    unit: "g",
                    color: .blue
                )
                
                nutrientProgress(
                    title: "Carbs",
                    current: 200,
                    target: 250,
                    unit: "g",
                    color: .green
                )
                
                nutrientProgress(
                    title: "Fat",
                    current: 45,
                    target: 65,
                    unit: "g",
                    color: .orange
                )
            }
        }
    }
    
    private var activeTargetSection: some View {
        ProgressSection(
            title: "Active Target",
            iconName: "figure.walk.circle.fill"
        ) {
            VStack(spacing: Constants.Spacing.medium) {
                HStack {
                    activityItem(
                        icon: "flame.fill",
                        value: "400",
                        unit: "kcal",
                        color: .orange
                    )
                    
                    Spacer()
                    
                    activityItem(
                        icon: "figure.walk",
                        value: "8,500",
                        unit: "steps",
                        color: .green
                    )
                    
                    Spacer()
                    
                    activityItem(
                        icon: "clock.fill",
                        value: "45",
                        unit: "min",
                        color: .blue
                    )
                }
            }
        }
    }
    
    private func statItem(title: String, value: String) -> some View {
        VStack(spacing: Constants.Spacing.small) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(Constants.Colors.textSecondary)
            
            Text(value)
                .font(.headline)
                .foregroundColor(Constants.Colors.textPrimary)
        }
    }
    
    private func energyRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(Constants.Colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(Constants.Colors.textPrimary)
        }
    }
    
    private func nutrientProgress(
        title: String,
        current: Int,
        target: Int,
        unit: String,
        color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Constants.Colors.textSecondary)
                
                Spacer()
                
                Text("\(current)/\(target) \(unit)")
                    .font(.subheadline)
                    .foregroundColor(Constants.Colors.textPrimary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: Constants.CornerRadius.small)
                        .fill(color.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: Constants.CornerRadius.small)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(current) / CGFloat(target), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
    
    private func activityItem(
        icon: String,
        value: String,
        unit: String,
        color: Color
    ) -> some View {
        VStack(spacing: Constants.Spacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.headline)
                    .foregroundColor(Constants.Colors.textPrimary)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(Constants.Colors.textSecondary)
            }
        }
    }
}

#Preview {
    ProgressView()
}
