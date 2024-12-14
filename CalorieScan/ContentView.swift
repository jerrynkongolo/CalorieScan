import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
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
                } else if !appState.hasCompletedProfile {
                    ProfileSetupView()
                        .environmentObject(appState)
                } else {
                    MainTabView()
                        .withGradientBackground()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}