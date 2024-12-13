//
//  CalorieScanApp.swift
//  CalorieScan
//
//  Created by Jerry Nkongolo on 13/12/2024.
//

import SwiftUI
import os.log

@main
struct CalorieScanApp: App {
    @StateObject var appState = AppState()
    private let logger = Logger(subsystem: "com.jerrynkongolo.CalorieScan", category: "AppLaunch")
    
    init() {
        // Configure app launch performance tracking
        if #available(iOS 15.0, *) {
            configureAppAsync()
        } else {
            configureAppFallback()
        }
    }
    
    private func configureAppFallback() {
        // Synchronous configuration for iOS 14 and below
        Task {
            await FirebaseService.shared.configure()
        }
    }
    
    @available(iOS 15.0, *)
    private func configureAppAsync() {
        Task {
            do {
                try await Task.detached(priority: .userInitiated) {
                    await FirebaseService.shared.configure()
                }.value
            } catch {
                logger.error("Failed to configure Firebase: \(error.localizedDescription)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                // Optimize Core Animation performance
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }
        }
    }
}
