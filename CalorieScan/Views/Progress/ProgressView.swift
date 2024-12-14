import SwiftUI

struct ProgressView: View {
    var body: some View {
        ScrollableView(title: "Progress") {
            VStack(spacing: Constants.Spacing.large) {
                // Profile Summary
                ProgressSection(title: "Profile Summary", iconName: "person.circle.fill") {
                    VStack(spacing: Constants.Spacing.medium) {
                        HStack(spacing: Constants.Spacing.large) {
                            statItem(title: "Current", value: "75.0 kg", icon: "scalemass.fill")
                            Spacer()
                            statItem(title: "Target", value: "70.0 kg", icon: "target")
                            Spacer()
                            statItem(title: "BMI", value: "24.5", icon: "chart.bar.fill")
                        }
                        
                        HStack(spacing: Constants.Spacing.large) {
                            statItem(title: "Height", value: "175 cm", icon: "ruler.fill")
                            Spacer()
                            statItem(title: "Activity", value: "Moderate", icon: "figure.run")
                            Spacer()
                            statItem(title: "Days Left", value: "60", icon: "calendar")
                        }
                    }
                }
                
                // Health Kit Section
                ProgressSection(title: "Health Data", iconName: "heart.fill") {
                    HealthKitSection()
                }
                
                // Weight Goal Progress
                ProgressSection(title: "Weight Goal Progress", iconName: "chart.line.uptrend.xyaxis") {
                    VStack(spacing: Constants.Spacing.medium) {
                        HStack {
                            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                                Text("Weekly Change")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("-0.5 kg/week")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: Constants.Spacing.small) {
                                Text("Target Date")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Feb 14, 2024")
                                    .font(.headline)
                            }
                        }
                        
                        ProgressBar(value: 0.4)
                            .frame(height: 8)
                    }
                }
                
                // Daily Energy Plan
                ProgressSection(title: "Daily Energy Plan", iconName: "bolt.circle.fill") {
                    VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                        energyRow(title: "Base Metabolic Rate", value: "1,800 kcal", icon: "flame.fill")
                        energyRow(title: "Activity Calories", value: "+400 kcal", icon: "figure.walk")
                        energyRow(title: "Goal Adjustment", value: "-500 kcal", icon: "arrow.up.arrow.down")
                        
                        Divider()
                            .padding(.vertical, Constants.Spacing.small)
                        
                        energyRow(title: "Daily Target", value: "1,700 kcal", icon: "star.fill")
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(Constants.CornerRadius.medium)
                }
                
                // Food Target
                ProgressSection(title: "Food Target", iconName: "fork.knife.circle.fill") {
                    VStack(spacing: 0) {
                        macroRow(title: "Protein", value: "128g", subtitle: "30% of daily calories", icon: "circle.grid.cross.fill")
                        Divider()
                            .padding(.vertical, 8)
                        macroRow(title: "Carbs", value: "191g", subtitle: "45% of daily calories", icon: "circle.grid.2x2.fill")
                        Divider()
                            .padding(.vertical, 8)
                        macroRow(title: "Fat", value: "47g", subtitle: "25% of daily calories", icon: "circle.grid.3x3.fill")
                        Divider()
                            .padding(.vertical, 8)
                        macroRow(title: "Daily Target", value: "1,700 kcal", subtitle: "Total daily calories", icon: "star.fill")
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(Constants.CornerRadius.medium)
                }
            }
        }
        .background(Constants.Colors.secondaryBackground)
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
        .background(Color(.systemBackground))
        .cornerRadius(Constants.CornerRadius.medium)
    }
    
    private func energyRow(title: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.regular)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(Constants.CornerRadius.medium)
    }
    
    private func macroRow(title: String, value: String, subtitle: String, icon: String) -> some View {
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

#Preview {
    NavigationStack {
        ProgressView()
    }
}
