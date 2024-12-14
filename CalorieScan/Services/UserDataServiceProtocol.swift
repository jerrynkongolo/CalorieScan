import Foundation
import Combine

protocol UserDataServiceProtocol: AnyObject {
    var userProfile: UserProfile? { get }
    var isLoading: Bool { get }
    var error: Error? { get }
    
    var userProfilePublisher: AnyPublisher<UserProfile?, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    
    func refreshUserData() async
    func fetchProfile() async throws -> UserProfile
    func signOut() async throws
}
