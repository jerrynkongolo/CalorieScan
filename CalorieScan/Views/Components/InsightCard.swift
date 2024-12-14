import SwiftUI

struct InsightCard: View {
    let title: String
    let message: String
    let iconName: String
    let accentColor: Color
    
    init(
        title: String = "AI Food Insight",
        message: String,
        iconName: String = "sparkles.rectangle.stack.fill",
        accentColor: Color = Constants.Colors.Pastel.blue
    ) {
        self.title = title
        self.message = message
        self.iconName = iconName
        self.accentColor = accentColor
    }
    
    var body: some View {
        GlassContainer {
            VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                HStack(spacing: Constants.Spacing.medium) {
                    Circle()
                        .fill(accentColor)
                        .frame(width: Constants.Size.iconMedium, height: Constants.Size.iconMedium)
                        .overlay(
                            Image(systemName: iconName)
                                .foregroundColor(Constants.Colors.textDark)
                                .font(.title3)
                        )
                    
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Constants.Colors.textPrimary)
                }
                .padding(.horizontal, Constants.Spacing.medium)
                .padding(.top, Constants.Spacing.medium)
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(Constants.Colors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, Constants.Spacing.medium)
                    .padding(.bottom, Constants.Spacing.medium)
            }
        }
    }
}

#Preview {
    VStack {
        InsightCard(
            message: "Based on your meals today, you're doing great with protein intake! Consider adding more vegetables to your next meal for balanced nutrition."
        )
        
        InsightCard(
            title: "Calorie Analysis",
            message: "You've consumed 1,440 calories today. You're on track to meet your daily goal of 2,000 calories.",
            iconName: "chart.bar.fill",
            accentColor: Constants.Colors.Pastel.green
        )
    }
    .padding()
    .background(Color(.systemGray6))
}
