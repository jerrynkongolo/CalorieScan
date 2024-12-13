import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingSignOutAlert = false
    
    var body: some View {
        ScrollableView(title: "Profile") {
            VStack(spacing: Constants.Spacing.large) {
                // Header
                if let user = Auth.auth().currentUser {
                    ProfileHeader(
                        name: user.displayName ?? "User",
                        email: user.email ?? "",
                        imageURL: user.photoURL
                    )
                }
                
                // Account Settings
                VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                    SectionHeader(title: "Account Settings")
                    
                    VStack(spacing: 0) {
                        ProfileMenuRow(
                            icon: "person.fill",
                            title: "Personal Information",
                            subtitle: "Update your profile details",
                            action: {}
                        )
                        
                        ProfileMenuRow(
                            icon: "target",
                            title: "Goals & Targets",
                            subtitle: "Set your health and fitness goals",
                            action: {}
                        )
                        
                        ProfileMenuRow(
                            icon: "bell.fill",
                            title: "Notifications",
                            subtitle: "Manage your notifications",
                            action: {}
                        )
                    }
                    .background(Color.white)
                    .cornerRadius(Constants.CornerRadius.medium)
                }
                
                // App Settings
                VStack(alignment: .leading, spacing: Constants.Spacing.medium) {
                    SectionHeader(title: "App Settings")
                    
                    VStack(spacing: 0) {
                        ProfileMenuRow(
                            icon: "gear",
                            title: "Preferences",
                            subtitle: "Units, language, theme",
                            action: {}
                        )
                        
                        ProfileMenuRow(
                            icon: "lock.fill",
                            title: "Privacy",
                            subtitle: "Manage your data and privacy",
                            action: {}
                        )
                        
                        ProfileMenuRow(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support",
                            subtitle: "FAQs, contact support",
                            action: {}
                        )
                    }
                    .background(Color.white)
                    .cornerRadius(Constants.CornerRadius.medium)
                }
                
                // Sign Out Button
                Button(action: { showingSignOutAlert = true }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Sign Out")
                    }
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(Constants.CornerRadius.medium)
                }
            }
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                do {
                    try Auth.auth().signOut()
                    appState.isAuthenticated = false
                } catch {
                    print("Error signing out: \(error)")
                }
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
