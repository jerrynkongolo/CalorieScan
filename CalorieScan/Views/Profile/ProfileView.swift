import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollableView(title: "Profile") {
            VStack(spacing: Constants.Spacing.large) {
                // Profile content
                Text("Profile settings coming soon!")
                    .font(.title2)
                    .foregroundColor(Constants.Colors.textSecondary)
                
                // Sign out button
                Button {
                    do {
                        try Auth.auth().signOut()
                        appState.isAuthenticated = false
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                } label: {
                    Text("Sign Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Constants.Colors.primary)
                        .cornerRadius(Constants.CornerRadius.medium)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
