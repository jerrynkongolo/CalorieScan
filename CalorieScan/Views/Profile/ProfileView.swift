import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.95, blue: 1.0),
                    Color(red: 1.0, green: 0.98, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Logout") {
                    do {
                        try Auth.auth().signOut()
                        appState.isAuthenticated = false
                    } catch {
                        // Handle error
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.55, green: 0.25, blue: 0.75)) // Deeper purple tint
                .cornerRadius(25)
                .padding(.horizontal)
            }
            .padding()
        }
    }
}
