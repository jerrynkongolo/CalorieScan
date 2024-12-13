import SwiftUI

struct AppButton: View {
    enum Style {
        case primary
        case secondary
        case outline
        
        var backgroundColor: Color {
            switch self {
            case .primary:
                return .purple
            case .secondary:
                return Color(.systemGray5)
            case .outline:
                return .clear
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary:
                return .white
            case .secondary:
                return .black
            case .outline:
                return .purple
            }
        }
        
        var borderColor: Color {
            switch self {
            case .outline:
                return .purple
            default:
                return .clear
            }
        }
    }
    
    let title: String
    let style: Style
    let isLoading: Bool
    let action: () async -> Void
    
    init(
        _ title: String,
        style: Style = .primary,
        isLoading: Bool = false,
        action: @escaping () async -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(style.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(style.borderColor, lineWidth: 1.5)
                    )
                
                Group {
                    if isLoading {
                        ProgressView()
                            .tint(style.foregroundColor)
                    } else {
                        Text(title)
                            .font(.body)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(style.foregroundColor)
            }
        }
        .frame(height: 50)
        .disabled(isLoading)
    }
}

// Preview Provider
#Preview {
    VStack(spacing: 20) {
        AppButton("Primary Button") {}
        AppButton("Secondary Button", style: .secondary) {}
        AppButton("Outline Button", style: .outline) {}
        AppButton("Loading Button", isLoading: true) {}
    }
    .padding()
}
