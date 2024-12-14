import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        ProfileInfoSection()
                        GoalsSection()
                        HealthMetricsSection()
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Sign out action
                        dismiss()
                    } label: {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
}

struct ProfileInfoSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Personal Information")
                .font(.headline)
            
            GlassContainer {
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(title: "Name", value: "John Doe")
                    InfoRow(title: "Age", value: "28 years")
                    InfoRow(title: "Height", value: "175.0 cm")
                    InfoRow(title: "Weight", value: "75.0 kg")
                }
            }
        }
    }
}

struct GoalsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Goals")
                .font(.headline)
            
            GlassContainer {
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(title: "Weight Goal", value: "Weight Loss")
                    InfoRow(title: "Target Weight", value: "70.0 kg")
                    InfoRow(title: "Target Date", value: "Feb 14, 2024")
                    InfoRow(title: "Daily Calorie Target", value: "2100 kcal")
                }
            }
        }
    }
}

struct HealthMetricsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health Metrics")
                .font(.headline)
            
            GlassContainer {
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(title: "BMI", value: "24.5")
                    InfoRow(title: "Workout Frequency", value: "Moderate")
                }
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ProfileView()
}
