import SwiftUI
import Charts

struct WeeklyProgressChart: View {
    let data: [DailyNutrition]
    
    var body: some View {
        GlassContainer {
            Chart(data) { item in
                BarMark(
                    x: .value("Day", item.date, unit: .day),
                    y: .value("Calories", item.calories)
                )
                .foregroundStyle(Constants.Colors.primary.gradient)
            }
            .frame(height: 200)
            .padding()
        }
    }
}

#Preview {
    WeeklyProgressChart(data: DailyNutrition.sampleData)
        .padding()
}
