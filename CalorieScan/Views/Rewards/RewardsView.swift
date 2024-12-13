import SwiftUI

struct RewardsView: View {
    var body: some View {
        ScrollableView(title: "Rewards") {
            // Rewards content will go here
            Text("Rewards Coming Soon!")
                .font(.title2)
                .foregroundColor(Constants.Colors.textSecondary)
        }
    }
}

#Preview {
    RewardsView()
}
