import SwiftUI

struct SectionHeader: View {
    let title: String
    var showSeeAll: Bool = false
    var onSeeAllTapped: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Constants.Colors.textPrimary)
            
            Spacer()
            
            if showSeeAll {
                Button {
                    onSeeAllTapped?()
                } label: {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(Constants.Colors.primary)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 20) {
        SectionHeader(title: "Sample Section")
        SectionHeader(title: "With See All", showSeeAll: true) {
            print("See all tapped")
        }
    }
    .padding()
}
