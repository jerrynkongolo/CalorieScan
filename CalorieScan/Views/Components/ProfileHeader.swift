import SwiftUI

struct ProfileHeader: View {
    let name: String
    let email: String
    let imageURL: URL?
    
    var body: some View {
        VStack(spacing: Constants.Spacing.medium) {
            // Profile Image
            Group {
                if let imageURL = imageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Constants.Colors.primary)
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Constants.Colors.primary)
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Constants.Colors.primary.opacity(0.2), lineWidth: 2)
            )
            
            // User Info
            VStack(spacing: Constants.Spacing.small) {
                Text(name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Constants.Colors.textPrimary)
                
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(Constants.Colors.textSecondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

#Preview {
    ProfileHeader(
        name: "John Doe",
        email: "john@example.com",
        imageURL: nil
    )
    .background(Constants.Colors.secondaryBackground)
}
