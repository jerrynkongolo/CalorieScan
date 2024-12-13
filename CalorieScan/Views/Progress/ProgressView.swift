import SwiftUI

struct ProgressView: View {
    @StateObject private var profileService = UserProfileService()
    
    var body: some View {
        ScrollableView(title: "Progress", horizontalPadding: Constants.Spacing.small) {
            if let profile = profileService.currentProfile {
                VStack(spacing: Constants.Spacing.large) {
                    // Profile Summary
                    ProgressSection(title: "Profile Summary", iconName: "person.circle.fill") {
                        VStack(spacing: Constants.Spacing.medium) {
                            HStack {
                                statItem(title: "Weight", value: String(format: "%.1f kg", profile.weight), icon: "scalemass.fill")
                                Spacer()
                                statItem(title: "Height", value: String(format: "%.1f cm", profile.height), icon: "ruler.fill")
                                Spacer()
                                statItem(title: "BMI", value: String(format: "%.1f", profile.bmi), icon: "chart.bar.fill")
                            }
                            
                            HStack {
                                statItem(title: "Age", value: "\(profile.age)", icon: "calendar")
                                Spacer()
                                statItem(title: "Activity", value: profile.workoutFrequency.rawValue, icon: "figure.run")
                                Spacer()
                                statItem(title: "Goal", value: profile.weightGoal.rawValue, icon: "target")
                            }
                        }
                    }
                    
                    // Daily Energy Plan
                    ProgressSection(title: "Daily Energy Plan", iconName: "bolt.circle.fill") {
                        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                            energyRow(title: "Base Metabolic Rate", value: String(format: "%.0f kcal", profile.bmr), icon: "flame.fill")
                            energyRow(
                                title: "Activity Calories",
                                value: String(format: "+%.0f kcal", profile.bmr * (profile.workoutFrequency.activityMultiplier - 1)),
                                icon: "figure.walk"
                            )
                            energyRow(
                                title: "Goal Adjustment",
                                value: String(format: "%.0f kcal", profile.weightGoal.calorieAdjustment),
                                icon: "arrow.up.and.down"
                            )
                            
                            Divider()
                            
                            energyRow(
                                title: "Daily Target",
                                value: String(format: "%.0f kcal", profile.dailyCalorieTarget),
                                isTotal: true,
                                icon: "star.fill"
                            )
                        }
                    }
                    
                    // Food Target
                    ProgressSection(title: "Food Target", iconName: "fork.knife.circle.fill") {
                        VStack(spacing: Constants.Spacing.medium) {
                            // Calculate macros based on daily calorie target
                            let proteinGrams = profile.dailyCalorieTarget * 0.3 / 4 // 30% of calories from protein
                            let carbsGrams = profile.dailyCalorieTarget * 0.45 / 4  // 45% of calories from carbs
                            let fatGrams = profile.dailyCalorieTarget * 0.25 / 9    // 25% of calories from fat
                            
                            macroRow(title: "Protein", value: "\(Int(proteinGrams))g", subtitle: "30% of daily calories", icon: "circle.grid.cross.fill")
                            Divider()
                            macroRow(title: "Carbs", value: "\(Int(carbsGrams))g", subtitle: "45% of daily calories", icon: "circle.grid.2x2.fill")
                            Divider()
                            macroRow(title: "Fat", value: "\(Int(fatGrams))g", subtitle: "25% of daily calories", icon: "circle.fill")
                        }
                    }
                    
                    // Active Target
                    ProgressSection(title: "Active Target", iconName: "flame.circle.fill") {
                        VStack(spacing: Constants.Spacing.medium) {
                            targetRow(title: "Daily Steps", value: "10,000 steps", icon: "figure.walk")
                            Divider()
                            targetRow(title: "Active Minutes", value: "30 mins", icon: "timer")
                            Divider()
                            targetRow(title: "Active Calories", value: "300 kcal", icon: "flame")
                        }
                    }
                }
                .padding(.horizontal, Constants.Spacing.small)
            } else {
                // Show loading or placeholder state
                ProgressView()
            }
        }
    }
    
    private func statItem(title: String, value: String, icon: String) -> some View {
        VStack(spacing: Constants.Spacing.small) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(Constants.Colors.textSecondary)
            HStack(spacing: Constants.Spacing.small) {
                Image(systemName: icon)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
                    .foregroundColor(Constants.Colors.textPrimary)
            }
        }
    }
    
    private func energyRow(title: String, value: String, isTotal: Bool = false, icon: String) -> some View {
        HStack {
            HStack(spacing: Constants.Spacing.small) {
                Image(systemName: icon)
                    .foregroundColor(isTotal ? .orange : .gray)
                Text(title)
                    .font(isTotal ? .headline : .subheadline)
                    .foregroundColor(isTotal ? Constants.Colors.textPrimary : Constants.Colors.textSecondary)
            }
            Spacer()
            Text(value)
                .font(isTotal ? .headline : .subheadline)
                .foregroundColor(isTotal ? Constants.Colors.primary : Color(.darkGray))
        }
    }
    
    private func macroRow(title: String, value: String, subtitle: String, icon: String) -> some View {
        HStack {
            HStack(spacing: Constants.Spacing.small) {
                Image(systemName: icon)
                    .foregroundColor(title == "Protein" ? .red : title == "Carbs" ? .green : .yellow)
                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(Constants.Colors.textSecondary)
                }
            }
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(Constants.Colors.primary)
        }
    }
    
    private func targetRow(title: String, value: String, icon: String) -> some View {
        HStack {
            HStack(spacing: Constants.Spacing.small) {
                Image(systemName: icon)
                    .foregroundColor(title == "Daily Steps" ? .blue : 
                                   title == "Active Minutes" ? .green : .orange)
                Text(title)
                    .font(.headline)
            }
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundColor(Constants.Colors.primary)
        }
    }
}
