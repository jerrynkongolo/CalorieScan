import SwiftUI

struct ProgressView: View {
    @StateObject private var profileService = UserProfileService()
    
    var body: some View {
        ScrollableView(title: "Progress") {
            if let profile = profileService.currentProfile {
                VStack(spacing: Constants.Spacing.large) {
                    // Profile Summary
                    ProgressSection(title: "Profile Summary", iconName: "person.circle.fill") {
                        VStack(spacing: Constants.Spacing.medium) {
                            HStack {
                                statItem(title: "Current", value: String(format: "%.1f kg", profile.weight), icon: "scalemass.fill")
                                Spacer()
                                statItem(title: "Target", value: String(format: "%.1f kg", profile.targetWeight), icon: "target")
                                Spacer()
                                statItem(title: "BMI", value: String(format: "%.1f", profile.bmi), icon: "chart.bar.fill")
                            }
                            
                            HStack {
                                statItem(title: "Height", value: String(format: "%.1f cm", profile.height), icon: "ruler.fill")
                                Spacer()
                                statItem(title: "Activity", value: profile.workoutFrequency.rawValue, icon: "figure.run")
                                Spacer()
                                let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: profile.targetDate).day ?? 0
                                statItem(title: "Days Left", value: "\(daysLeft)", icon: "calendar")
                            }
                        }
                    }
                    
                    // Weight Goal Progress
                    ProgressSection(title: "Weight Goal Progress", iconName: "chart.line.uptrend.xyaxis") {
                        VStack(spacing: Constants.Spacing.medium) {
                            let weightDiff = profile.targetWeight - profile.weight
                            let totalDays = Calendar.current.dateComponents([.day], from: Date(), to: profile.targetDate).day ?? 90
                            let weeklyChange = (weightDiff / Double(totalDays)) * 7.0
                            
                            HStack {
                                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                                    Text("Weekly Change")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(String(format: "%.1f kg/week", abs(weeklyChange)))
                                        .font(.headline)
                                        .foregroundColor(weeklyChange < 0 ? .red : .green)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: Constants.Spacing.small) {
                                    Text("Target Date")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(profile.targetDate, style: .date)
                                        .font(.headline)
                                }
                            }
                            
                            ProgressBar(value: min(1.0, max(0.0, abs(profile.weight - profile.targetWeight) / abs(weightDiff))))
                                .frame(height: 8)
                        }
                    }
                    
                    // Daily Energy Plan
                    ProgressSection(title: "Daily Energy Plan", iconName: "bolt.circle.fill") {
                        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                            energyRow(title: "Base Metabolic Rate", value: String(format: "%.0f kcal", profile.bmr), icon: "flame.fill")
                            
                            let activityCalories = profile.bmr * (profile.workoutFrequency.activityMultiplier - 1)
                            energyRow(
                                title: "Activity Calories",
                                value: String(format: "+%.0f kcal", activityCalories),
                                icon: "figure.walk"
                            )
                            
                            // Calculate daily calorie adjustment based on weight goal
                            let weightDiff = profile.targetWeight - profile.weight
                            let totalDays = max(1.0, Double(Calendar.current.dateComponents([.day], from: Date(), to: profile.targetDate).day ?? 90))
                            let dailyWeightChange = weightDiff / totalDays
                            // 1 kg of weight change requires approximately 7700 calories
                            let goalAdjustment = dailyWeightChange * 7700
                            
                            energyRow(
                                title: "Goal Adjustment",
                                value: String(format: "%+.0f kcal", goalAdjustment),
                                icon: "arrow.up.arrow.down"
                            )
                            
                            Divider()
                                .padding(.vertical, Constants.Spacing.small)
                            
                            let totalDailyCalories = profile.bmr + activityCalories + goalAdjustment
                            energyRow(
                                title: "Daily Target",
                                value: String(format: "%.0f kcal", max(1200, totalDailyCalories)), // Minimum 1200 calories for safety
                                icon: "star.fill"
                            )
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(Constants.CornerRadius.medium)
                    }
                    
                    // Food Target
                    ProgressSection(title: "Food Target", iconName: "fork.knife.circle.fill") {
                        VStack(spacing: Constants.Spacing.medium) {
                            // Calculate macros based on daily calorie target
                            let proteinGrams = Double(profile.dailyCalorieTarget) * 0.3 / 4 // 30% of calories from protein
                            let carbsGrams = Double(profile.dailyCalorieTarget) * 0.45 / 4  // 45% of calories from carbs
                            let fatGrams = Double(profile.dailyCalorieTarget) * 0.25 / 9    // 25% of calories from fat
                            
                            macroRow(title: "Protein", value: "\(Int(proteinGrams))g", subtitle: "30% of daily calories", icon: "circle.grid.cross.fill")
                            Divider()
                            macroRow(title: "Carbs", value: "\(Int(carbsGrams))g", subtitle: "45% of daily calories", icon: "circle.grid.2x2.fill")
                            Divider()
                            macroRow(title: "Fat", value: "\(Int(fatGrams))g", subtitle: "25% of daily calories", icon: "circle.grid.3x3.fill")
                        }
                    }
                }
            } else {
                // Show loading or placeholder state
                ProgressView()
            }
        }
    }
    
    private func statItem(title: String, value: String, icon: String) -> some View {
        VStack(spacing: Constants.Spacing.small) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.callout)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Constants.Spacing.small)
        .background(Color(.systemBackground))
        .cornerRadius(Constants.CornerRadius.medium)
    }
    
    private func energyRow(title: String, value: String, icon: String, isTotal: Bool = false) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(isTotal ? .accentColor : .secondary)
            
            Text(title)
                .font(isTotal ? .headline : .body)
            
            Spacer()
            
            Text(value)
                .font(isTotal ? .headline : .body)
                .fontWeight(isTotal ? .bold : .regular)
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
}

struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.secondary.opacity(0.3))
                
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: geometry.size.width * value)
            }
            .cornerRadius(4)
        }
    }
}
