import SwiftUI

struct ProfileHeader: View {
    let name: String
    let imageURL: URL?
    
    var body: some View {
        VStack(spacing: Constants.Spacing.medium) {
            // Profile Image
            if let imageURL = imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 100)
            }
            
            // Name
            Text(name)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

#Preview {
    ProfileHeader(
        name: "John Doe",
        imageURL: nil
    )
    .background(Constants.Colors.secondaryBackground)
}
