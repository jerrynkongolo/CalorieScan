import SwiftUI

struct GradientBackground<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.App.gradient1,
                    Color.App.gradient2,
                    Color.App.gradient3
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            content
        }
    }
}

// View modifier for easy application
struct GradientBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        GradientBackground {
            content
        }
    }
}

// View extension for convenient usage
extension View {
    func withGradientBackground() -> some View {
        modifier(GradientBackgroundModifier())
    }
}
