import SwiftUI

enum TabGradient {
    case home, scan, progress, profile
    
    var colors: [Color] {
        switch self {
        case .home:
            return [
                Color(red: 0.9, green: 0.95, blue: 1.0),    // Light blue-white
                Color(red: 0.8, green: 0.9, blue: 1.0),     // Medium blue
                Color(red: 0.7, green: 0.85, blue: 1.0)     // Deeper blue
            ]
        case .scan:
            return [
                Color(red: 1.0, green: 0.9, blue: 0.9),     // Light pink
                Color(red: 1.0, green: 0.8, blue: 0.85),    // Medium pink
                Color(red: 0.95, green: 0.7, blue: 0.8)     // Deeper rose
            ]
        case .progress:
            return [
                Color(red: 0.9, green: 1.0, blue: 0.9),     // Light mint
                Color(red: 0.8, green: 0.95, blue: 0.85),   // Medium mint
                Color(red: 0.7, green: 0.9, blue: 0.8)      // Deeper mint
            ]
        case .profile:
            return [
                Color(red: 0.9, green: 0.9, blue: 1.0),     // Light lavender
                Color(red: 0.85, green: 0.8, blue: 1.0),    // Medium lavender
                Color(red: 0.8, green: 0.7, blue: 0.95)     // Deeper purple
            ]
        }
    }
}

struct GradientBackground<Content: View>: View {
    let content: Content
    let tab: TabGradient
    
    init(tab: TabGradient = .home, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.tab = tab
    }
    
    var body: some View {
        ZStack {
            // Windows 11-inspired gradient background
            LinearGradient(
                gradient: Gradient(colors: tab.colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle overlay pattern for depth
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let size = min(width, height) * 0.8
                    
                    path.addEllipse(in: CGRect(
                        x: width * 0.2,
                        y: -size * 0.2,
                        width: size,
                        height: size
                    ))
                }
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.15),
                            Color.clear
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: geometry.size.width
                    )
                )
            }
            
            content
        }
    }
}

// View modifier for easy application with tab selection
struct GradientBackgroundModifier: ViewModifier {
    let tab: TabGradient
    
    func body(content: Content) -> some View {
        GradientBackground(tab: tab) {
            content
        }
    }
}

// View extension for convenient usage
extension View {
    func withGradientBackground(_ tab: TabGradient = .home) -> some View {
        modifier(GradientBackgroundModifier(tab: tab))
    }
}
