import Foundation
import FirebaseFirestore

enum AppConfiguration {
    static func configureFirestore() {
        let settings = FirestoreSettings()
        
        // Enable offline persistence with unlimited cache
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        settings.isSSLEnabled = true
        
        // Set a longer timeout for operations
        settings.dispatchQueue = DispatchQueue(
            label: "com.jerrynkongolo.CalorieScan.Firestore",
            qos: .userInitiated
        )
        
        // Configure the Firestore instance
        let db = Firestore.firestore()
        db.settings = settings
        
        // Enable network by default
        db.enableNetwork { error in
            if let error = error {
                print("Error enabling Firestore network: \(error.localizedDescription)")
            }
        }
    }
}
