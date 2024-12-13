import SwiftUI

enum Constants {
    enum Colors {
        static let primary = Color.purple
        static let textPrimary = Color.black
        static let textSecondary = Color.gray
        static let textDark = Color(.darkGray)
        static let iconSelected = Color(.darkGray)
        static let background = Color(.systemBackground)
        static let secondaryBackground = Color(.systemGray6)
    }
    
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 25
    }
    
    enum CornerRadius {
        static let small: CGFloat = 10
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 25
    }
    
    enum Size {
        static let iconSmall: CGFloat = 24
        static let iconMedium: CGFloat = 40
        static let iconLarge: CGFloat = 48
        static let foodCardWidth: CGFloat = 140
        static let foodCardImageHeight: CGFloat = 100
    }
    
    enum Shadow {
        static let small = Shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        
        struct Shadow {
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat
        }
    }
}
