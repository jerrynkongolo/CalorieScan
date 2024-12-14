import Foundation
import FirebaseFirestore
import Combine
import os.log

final class FirestoreManager: ObservableObject {
    static let shared = FirestoreManager()
    
    private let logger = Logger(subsystem: "com.jerrynkongolo.CalorieScan", category: "Firestore")
    private let db: Firestore
    private var networkManager: NetworkManager?
    
    // Store active listeners with their registration tokens
    private var activeListeners: [String: ListenerRegistration] = [:]
    private var listenerRefs: [String: DocumentReference] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        db = Firestore.firestore()
        setupNetworkObserver()
    }
    
    deinit {
        cleanup()
    }
    
    private func setupNetworkObserver() {
        networkManager = NetworkManager.shared
        
        networkManager?.$state
            .sink { [weak self] state in
                switch state {
                case .disconnected, .suspended:
                    self?.cleanupListeners()
                case .connected:
                    self?.reattachListeners()
                case .connecting:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Listener Management
    
    func addListener(for documentPath: String, handler: @escaping (DocumentSnapshot?, Error?) -> Void) -> String {
        let docRef = db.document(documentPath)
        let listenerId = UUID().uuidString
        
        // Store the document reference
        listenerRefs[listenerId] = docRef
        
        // Only attach listener if network is connected
        if networkManager?.state == .connected {
            attachListener(id: listenerId, docRef: docRef, handler: handler)
        }
        
        return listenerId
    }
    
    func removeListener(id: String) {
        activeListeners[id]?.remove()
        activeListeners.removeValue(forKey: id)
        listenerRefs.removeValue(forKey: id)
    }
    
    private func attachListener(id: String, docRef: DocumentReference, handler: @escaping (DocumentSnapshot?, Error?) -> Void) {
        // Remove existing listener if any
        activeListeners[id]?.remove()
        
        // Add new listener
        let registration = docRef.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                self?.logger.error("Listener error for \(id): \(error.localizedDescription)")
            }
            handler(snapshot, error)
        }
        
        activeListeners[id] = registration
    }
    
    private func cleanupListeners() {
        logger.info("Cleaning up Firestore listeners")
        
        // Remove all active listeners
        activeListeners.forEach { $0.value.remove() }
        activeListeners.removeAll()
    }
    
    private func reattachListeners() {
        logger.info("Reattaching Firestore listeners")
        
        // Reattach all stored listeners
        listenerRefs.forEach { id, docRef in
            attachListener(id: id, docRef: docRef) { [weak self] snapshot, error in
                if let error = error {
                    self?.logger.error("Error reattaching listener \(id): \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func cleanup() {
        cleanupListeners()
        cancellables.removeAll()
        networkManager = nil
    }
    
    // MARK: - Document Operations
    
    func getDocument(_ path: String) async throws -> DocumentSnapshot {
        try await db.document(path).getDocument(source: .server)
    }
    
    func setDocument(_ path: String, data: [String: Any]) async throws {
        try await db.document(path).setData(data)
    }
    
    func updateDocument(_ path: String, data: [String: Any]) async throws {
        try await db.document(path).updateData(data)
    }
    
    func deleteDocument(_ path: String) async throws {
        try await db.document(path).delete()
    }
}
