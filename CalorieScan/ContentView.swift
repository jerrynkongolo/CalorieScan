import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLaunchScreen = true
    @State private var isInitializing = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if showLaunchScreen || isInitializing {
                    LaunchScreenView {
                        withAnimation {
                            showLaunchScreen = false
                        }
                    }
                } else {
                    if appState.isAuthenticated {
                        HomeView(appState: appState)
                    } else {
                        OnboardingOrAuthView()
                            .environmentObject(appState)
                    }
                }
            }
        }
        .onAppear {
            // Check initial auth state
            Auth.auth().addStateDidChangeListener { _, user in
                appState.isAuthenticated = user != nil
                // Only hide the initialization screen after we've checked auth state
                withAnimation {
                    isInitializing = false
                }
            }
        }
    }
}

struct OnboardingOrAuthView: View {
    @State private var showAuth = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if showAuth {
                AuthView()
                    .environmentObject(appState)
            } else {
                OnboardingContainerView()
                    .environmentObject(appState)
                    .onAppear {
                        if !appState.isAuthenticated {
                            showAuth = true
                        }
                    }
            }
        }
    }
}
