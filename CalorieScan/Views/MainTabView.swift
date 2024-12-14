import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            ProgressView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
                .tag(1)
            
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
                .tag(2)
            
            RewardsView()
                .tabItem {
                    Image(systemName: "gift.fill")
                    Text("Rewards")
                }
                .tag(3)
            
            InsightsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Insights")
                }
                .tag(4)
        }
        .tint(Constants.Colors.iconSelected)
    }
}

#Preview {
    MainTabView()
}
