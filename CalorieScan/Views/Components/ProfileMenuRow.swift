import SwiftUI

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let showDivider: Bool
    let action: () -> Void
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        showDivider: Bool = true,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.showDivider = showDivider
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                HStack(spacing: Constants.Spacing.medium) {
                    // Icon
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(Constants.Colors.primary)
                        .frame(width: Constants.Size.iconMedium)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.body)
                            .foregroundColor(Constants.Colors.textPrimary)
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(Constants.Colors.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Chevron
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(Constants.Colors.textSecondary)
                }
                .padding(.vertical, Constants.Spacing.medium)
                .padding(.horizontal)
                
                if showDivider {
                    Divider()
                        .padding(.leading, 56)
                }
            }
            .background(Color.white)
        }
    }
}

#Preview {
    VStack {
        ProfileMenuRow(
            icon: "person.fill",
            title: "Personal Information",
            subtitle: "Name, email, phone",
            action: {}
        )
        
        ProfileMenuRow(
            icon: "bell.fill",
            title: "Notifications",
            action: {}
        )
    }
    .background(Constants.Colors.secondaryBackground)
}
