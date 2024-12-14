import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var error: Error?
    @Published var showError = false
    @Published var isLoading = false
    
    private let userDataService = UserDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
        Task {
            await refreshProfile()
        }
    }
    
    private func setupSubscriptions() {
        // Subscribe to user profile changes
        userDataService.$userProfile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                self?.userProfile = profile
            }
            .store(in: &cancellables)
        
        // Subscribe to loading state
        userDataService.$isLoading
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        // Subscribe to errors
        userDataService.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.error = error
                self?.showError = error != nil
            }
            .store(in: &cancellables)
    }
    
    func refreshProfile() async {
        do {
            userProfile = try await userDataService.fetchProfile()
            error = nil
            showError = false
        } catch {
            self.error = error
            self.showError = true
        }
    }
    
    func signOut() {
        userDataService.signOut()
    }
}
