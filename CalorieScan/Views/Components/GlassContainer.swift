import SwiftUI

struct GlassContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    // Base material
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Material.ultraThinMaterial)
                    
                    // Top highlight
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .white.opacity(0.3),
                            .clear
                        ]),
                        startPoint: .top,
                        endPoint: .center
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
