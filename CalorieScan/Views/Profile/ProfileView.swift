import SwiftUI

struct ProfileView: View {
    @StateObject private var userDataService = UserDataService.shared
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Constants.Spacing.large) {
                    // Header
                    if let profile = userDataService.currentProfile {
                        ProfileHeader(
                            name: profile.name,
                            imageURL: nil
                        )
                    } else {
                        ProfileHeader(
                            name: "Guest User",
                            imageURL: nil
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
                                subtitle: "Customize your app experience",
                                action: {}
                            )
                            
                            ProfileMenuRow(
                                icon: "questionmark.circle.fill",
                                title: "Help & Support",
                                subtitle: "Get assistance and FAQs",
                                action: {}
                            )
                            
                            ProfileMenuRow(
                                icon: "arrow.clockwise",
                                title: "Reset App",
                                subtitle: "Clear all data and start fresh",
                                action: { showingResetAlert = true }
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(Constants.CornerRadius.medium)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        .withGradientBackground(.profile)
        .alert("Reset App", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                userDataService.refreshProfile()
            }
        } message: {
            Text("Are you sure you want to reset the app? This will clear all your data and cannot be undone.")
        }
    }
}

#Preview {
    ProfileView()
}
