import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
}
