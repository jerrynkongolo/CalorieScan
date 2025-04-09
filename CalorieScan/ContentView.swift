import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var userDataService = UserDataService.shared
    @State private var showLaunchScreen = true
    @State private var userIsAuthenticated = false
    @State private var isSigningInAnonymously = false

    var body: some View {
        NavigationView {
            ZStack {
                if isSigningInAnonymously {
                    ProgressView("Signing in...")
                        .onAppear {
                            signInAnonymously()
                        }
                } else {
                    if showLaunchScreen {
                        LaunchScreenView {
                            withAnimation {
                                showLaunchScreen = false
                            }
                        }
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
        }
        .onAppear {
            checkAuthentication()
        }
    }

    private func checkAuthentication() {
        Auth.auth().addStateDidChangeListener { auth, user in
            userIsAuthenticated = user != nil
            if !userIsAuthenticated {
                isSigningInAnonymously = true
            }
        }
    }

    private func signInAnonymously() {
        Auth.auth().signInAnonymously { result, error in
            isSigningInAnonymously = false
            userIsAuthenticated = result?.user != nil
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}