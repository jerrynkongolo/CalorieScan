import SwiftUI

struct RecommendationCard: View {
    let recommendation: Recommendation
    
    var body: some View {
        GlassContainer {
            HStack(spacing: Constants.Spacing.medium) {
                Image(systemName: recommendation.iconName)
                    .font(.title2)
                    .foregroundColor(recommendation.color)
                    .frame(width: 40, height: 40)
                    .background(recommendation.color.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: Constants.Spacing.small) {
                    Text(recommendation.title)
                        .font(.headline)
                    
                    Text(recommendation.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    RecommendationCard(recommendation: Recommendation.sampleRecommendations[0])
        .padding()
}
