import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showLaunchScreen = true
    
    var body: some View {
        NavigationView {
            ZStack {
                if showLaunchScreen {
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
