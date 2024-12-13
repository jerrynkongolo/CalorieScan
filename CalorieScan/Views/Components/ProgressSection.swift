import SwiftUI

struct ProgressSection: View {
    let title: String
    let iconName: String
    let content: AnyView
    
    init<Content: View>(
        title: String,
        iconName: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.iconName = iconName
        self.content = AnyView(content())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
            HStack(spacing: Constants.Spacing.small) {
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundColor(Constants.Colors.primary)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(Constants.Colors.textPrimary)
            }
            
            content
        }
        .padding()
        .background(Color.white)
        .cornerRadius(Constants.CornerRadius.medium)
    }
}

#Preview {
    VStack {
        ProgressSection(
            title: "Sample Section",
            iconName: "star.fill"
        ) {
            Text("Sample Content")
                .foregroundColor(Constants.Colors.textSecondary)
        }
    }
    .padding()
    .background(Constants.Colors.secondaryBackground)
}