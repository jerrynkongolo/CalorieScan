import SwiftUI

struct HomeTabView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var selectedTab = 0
    @State private var showProfile = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
                .tag(1)
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.fill")
                }
                .tag(2)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView()
        }
        .overlay(alignment: .topTrailing) {
            Button {
                showProfile = true
            } label: {
                if let profile = homeViewModel.userProfile {
                    ProfileButton(name: profile.name)
                } else {
                    ProfileButton(name: "Guest")
                }
            }
            .padding()
        }
    }
}

struct ProfileButton: View {
    let name: String
    
    var body: some View {
        HStack {
            Text(name.prefix(1).uppercased())
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(Circle().fill(Color.accentColor))
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
        }
    }
}

#Preview {
    HomeTabView()
}
