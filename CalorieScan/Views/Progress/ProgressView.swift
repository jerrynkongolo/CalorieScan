import SwiftUI

struct ProgressView: View {
    var body: some View {
        ScrollableView(title: "Progress") {
            // Progress content will go here
            Text("Progress tracking coming soon!")
                .font(.title2)
                .foregroundColor(Constants.Colors.textSecondary)
        }
    }
}

#Preview {
    ProgressView()
}
