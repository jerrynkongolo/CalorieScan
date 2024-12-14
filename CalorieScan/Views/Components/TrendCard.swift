import SwiftUI

struct TrendCard: View {
    let title: String
    let value: String
    let subtitle: String
    let trend: Trend
    let iconName: String
    let color: Color
    
    var body: some View {
        GlassContainer {
            VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                HStack {
                    Image(systemName: iconName)
                        .foregroundColor(color)
                    
                    Spacer()
                    
                    TrendIndicator(trend: trend)
                }
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct TrendIndicator: View {
    let trend: Trend
    
    var iconName: String {
        switch trend {
        case .up:
            return "arrow.up.right"
        case .down:
            return "arrow.down.right"
        case .neutral:
            return "arrow.right"
        }
    }
    
    var color: Color {
        switch trend {
        case .up:
            return .green
        case .down:
            return .red
        case .neutral:
            return .gray
        }
    }
    
    var body: some View {
        Image(systemName: iconName)
            .foregroundColor(color)
    }
}

#Preview {
    TrendCard(
        title: "Calorie Trend",
        value: "2,100",
        subtitle: "Daily Average",
        trend: .up,
        iconName: "flame.fill",
        color: Constants.Colors.Pastel.blue
    )
    .padding()
}
