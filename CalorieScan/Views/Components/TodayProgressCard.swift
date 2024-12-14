import SwiftUI

struct TodayProgressCard: View {
    let remainingCalories: Int
    let consumedCalories: Int
    let progress: Double
    
    var body: some View {
        GlassContainer {
            VStack(spacing: Constants.Spacing.medium) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Calories Remaining")
                            .font(.headline)
                        Text("\(remainingCalories)")
                            .font(.system(size: 32, weight: .bold))
                    }
                    Spacer()
                    CircularProgressView(progress: progress)
                        .frame(width: 80, height: 80)
                }
                
                HStack(spacing: Constants.Spacing.large) {
                    VStack {
                        Text("Goal")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(remainingCalories + consumedCalories)")
                            .font(.headline)
                    }
                    
                    VStack {
                        Text("Consumed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(consumedCalories)")
                            .font(.headline)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    TodayProgressCard(
        remainingCalories: 1200,
        consumedCalories: 800,
        progress: 0.4
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}
