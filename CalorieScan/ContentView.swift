import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var userDataService = UserDataService.shared
    @State private var showLaunchScreen = true
    @State private var userIsAuthenticated = false    

    var body: some View {
        NavigationView {
            ZStack {
                if showLaunchScreen {
                    LaunchScreenView(onAnimationComplete: { 
                        withAnimation { showLaunchScreen = false }
                        
                        checkAuthentication()
                    })
                } else if !userIsAuthenticated {
                    Text("Authenticating...")
                } else if !appState.hasCompletedProfile {
                    ProfileSetupView()
                        .environmentObject(appState)
                        .environmentObject(userDataService)
                } else {
                    MainTabView()
                        .withGradientBackground()
                }
            }
        }
        .onAppear {
            checkAuthentication()
        }
    }

    private func checkAuthentication() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                userIsAuthenticated = true
            } else {
                userIsAuthenticated = false
                signInAnonymously()
            }
        if userIsAuthenticated && user != nil {
            userDataService.refreshUserData()
        }
    }

    private func signInAnonymously() {
        Auth.auth().signInAnonymously { result, error in
            if let user = result?.user {
                userIsAuthenticated = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}