import Foundation
import Network
import os.log
import FirebaseFirestore
import Combine

final class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    private let logger = Logger(subsystem: "com.jerrynkongolo.CalorieScan", category: "Network")
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.jerrynkongolo.CalorieScan.NetworkManager")
    
    @Published private(set) var isConnected = false
    private(set) var connectionType: NWInterface.InterfaceType?
    
    enum ConnectionState: String {
        case disconnected
        case connecting
        case connected
        case suspended
    }
    
    @Published private(set) var state: ConnectionState = .disconnected
    
    private var stateUpdateTimer: Timer?
    private var retryCount = 0
    private let maxRetries = 3
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupNetworkMonitoring()
        configureGRPC()
    }
    
    deinit {
        cleanup()
    }
    
    private func cleanup() {
        stateUpdateTimer?.invalidate()
        stateUpdateTimer = nil
        monitor.cancel()
        cancellables.removeAll()
    }
    
    private func configureGRPC() {
        // Configure gRPC settings via environment variables
        setenv("GRPC_GO_LOG_VERBOSITY_LEVEL", "99", 1)  // Disable verbose logging
        setenv("GRPC_GO_LOG_SEVERITY_LEVEL", "error", 1) // Only log errors
        
        // Configure keepalive
        setenv("GRPC_KEEPALIVE_TIME_MS", "20000", 1)  // 20 seconds
        setenv("GRPC_KEEPALIVE_TIMEOUT_MS", "10000", 1)  // 10 seconds
        setenv("GRPC_KEEPALIVE_PERMIT_WITHOUT_CALLS", "0", 1)
        setenv("GRPC_CLIENT_IDLE_TIMEOUT_MS", "60000", 1)  // 1 minute
        
        // Configure retry behavior
        setenv("GRPC_ENABLE_RETRIES", "0", 1)  // Disable automatic retries
        setenv("GRPC_MAX_RECONNECT_BACKOFF_MS", "1000", 1)  // 1 second max backoff
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.connectionType = path.availableInterfaces.first?.type
                
                if self.isConnected {
                    if self.state == .disconnected || self.state == .suspended {
                        self.state = .connecting
                        self.startReconnection()
                    }
                } else {
                    self.state = .disconnected
                    self.suspendConnections()
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    private func startReconnection() {
        guard state == .connecting else { return }
        
        retryCount = 0
        attemptReconnection()
    }
    
    private func attemptReconnection() {
        guard retryCount < maxRetries else {
            DispatchQueue.main.async {
                self.state = .suspended
                self.scheduleReconnection()
            }
            return
        }
        
        retryCount += 1
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                // Use FirestoreManager to check connection
                _ = try await FirestoreManager.shared.getDocument("_health/status")
                DispatchQueue.main.async {
                    self.state = .connected
                }
            } catch {
                self.logger.error("Reconnection attempt \(self.retryCount) failed: \(error.localizedDescription)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self, self.state == .connecting else { return }
                    self.attemptReconnection()
                }
            }
        }
    }
    
    private func suspendConnections() {
        stateUpdateTimer?.invalidate()
        stateUpdateTimer = nil
        DispatchQueue.main.async {
            self.state = .suspended
        }
    }
    
    private func scheduleReconnection() {
        stateUpdateTimer?.invalidate()
        stateUpdateTimer = nil
        
        stateUpdateTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.state = .connecting
                self.startReconnection()
            }
        }
    }
    
    func waitForConnection() async throws {
        if isConnected { return }
        
        return try await withCheckedThrowingContinuation { continuation in
            let cancellable = $isConnected
                .dropFirst()
                .first(where: { $0 })
                .timeout(.seconds(10), scheduler: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            continuation.resume()
                        case .failure:
                            continuation.resume(throwing: NSError(
                                domain: "com.jerrynkongolo.CalorieScan",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Connection timeout"]
                            ))
                        }
                    },
                    receiveValue: { _ in }
                )
            
            cancellables.insert(cancellable)
        }
    }
}
