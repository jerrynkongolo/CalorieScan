import SwiftUI
import FirebaseCore
import os.log

@main
struct CalorieScanApp: App {
    private let logger = Logger(subsystem: "com.jerrynkongolo.CalorieScan", category: "AppLaunch")

    init() {
        FirebaseApp.configure()
        logger.info("Firebase configured for data storage")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
