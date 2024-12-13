import SwiftUI

struct ScrollableView<Content: View>: View {
    let title: String
    let content: Content
    var showsIndicators: Bool = false
    var horizontalPadding: CGFloat = Constants.Spacing.medium
    
    init(
        title: String,
        showsIndicators: Bool = false,
        horizontalPadding: CGFloat = Constants.Spacing.medium,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.showsIndicators = showsIndicators
        self.horizontalPadding = horizontalPadding
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: showsIndicators) {
                VStack(spacing: Constants.Spacing.large) {
                    content
                }
                .padding(.horizontal, horizontalPadding)
            }
            .navigationTitle(title)
            .background(Constants.Colors.secondaryBackground)
        }
    }
}

#Preview {
    ScrollableView(title: "Sample View") {
        ForEach(0..<5) { index in
            RoundedRectangle(cornerRadius: Constants.CornerRadius.medium)
                .fill(Color.white)
                .frame(height: 100)
                .overlay(
                    Text("Item \(index + 1)")
                )
        }
    }
}
