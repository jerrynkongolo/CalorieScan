import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(Constants.CornerRadius.large)
            .shadow(
                color: Constants.Shadow.small.color,
                radius: Constants.Shadow.small.radius,
                x: Constants.Shadow.small.x,
                y: Constants.Shadow.small.y
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}
