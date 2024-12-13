import SwiftUI

struct SectionHeader: View {
    let title: String
    var showSeeAll: Bool = false
    var seeAllAction: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
            
            if showSeeAll {
                Button(action: { seeAllAction?() }) {
                    Text("See All")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 20) {
        SectionHeader(title: "Section Title")
        SectionHeader(title: "With See All", showSeeAll: true) {
            print("See all tapped")
        }
    }
}
