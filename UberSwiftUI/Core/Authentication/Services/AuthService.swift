//
//  AuthService.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation
import Combine
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: -ENUMs
enum AuthState {
    case pending, loggedIn(UserItem), loggedOut
}

enum AuthError: Error {
    case accountCreationFailed(description: String)
    case failedToSaveUserInfo(description: String)
    case failedToLogin(description: String)
    
    var title: String {
        switch self {
        case .accountCreationFailed:
            return "Account Creation Failed"
        case .failedToSaveUserInfo:
            return "Failed to Save User Info"
        case .failedToLogin:
            return "Failed to Log in"
        }
    }
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accountCreationFailed(let description):
            return "\(title): \(description)"
        case .failedToSaveUserInfo(let description):
            return "\(title): \(description)"
        case .failedToLogin(description: let description):
            return "\(title): \(description)"
        }
    }
}



//MARK: -AuthProvider
/// A protocol defining the necessary methods and properties for handling user authentication.
///
/// Conforming types provide functionality to log in, log out, create an account,
/// and manage the authentication state.
///
/// - Note: This protocol uses the Combine framework to publish authentication state changes.
protocol AuthProvider {
    
    /// The shared instance of the authentication provider.
    static var shared: AuthProvider { get }
    
    /// The current authentication state, published via Combine's `CurrentValueSubject`.
    var authState: CurrentValueSubject<AuthState, Never> { get }
    
    /// Attempts to automatically log in the user, updating the authentication state.
    func autoLogin() async
    
    /// Logs in the user with the provided email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    /// - Throws: An error if the login fails.
    func login(with email: String, password: String) async throws
    
    /// Creates a new account with the provided username, email, and password.
    ///
    /// - Parameters:
    ///   - username: The desired username.
    ///   - email: The email address of the user.
    ///   - password: The desired password.
    /// - Throws: An error if the account creation fails.
    func createAccount(for username: String, email: String, password: String) async throws
    
    /// Logs out the current user, updating the authentication state.
    ///
    /// - Throws: An error if the logout process fails.
    func logOut() async throws
}

final class AuthService: AuthProvider {
    
    private init(){
        Task { await autoLogin() }
    }
    
    static var shared: AuthProvider = AuthService()
    var authState = CurrentValueSubject<AuthState, Never>(.pending)
    
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            self.authState.send(.loggedOut)
        } else {
            fetchCurrentUserInfo()
        }
    }
    
    func login(with email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            fetchCurrentUserInfo()
            print("🙋‍♂️ \(authResult.user.email ?? "") is Logged In")
        } catch {
            print("🔐 Faild To Log in: \(error.localizedDescription)")
            throw AuthError.failedToLogin(description: error.localizedDescription)
        }
    }
    
    func createAccount(for fullname: String, email: String, password: String) async throws {
        do {
            // invoke firebase create account method: store the suer in out firebase auth
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            //store new user in out database
            let uid = authResult.user.uid
            let newUser = UserItem(uid: uid, fullname: fullname, email: email)
            try await saveUserInfoDatabase(user: newUser)
            
            //This is publish the new user information with this call
            self.authState.send(.loggedIn(newUser))
        } catch {
            print("🔐 Faild To Create An Account: \(error.localizedDescription)")
            throw AuthError.accountCreationFailed(description: error.localizedDescription)
            
        }
    }
    
    func logOut() async throws {
        do {
            try Auth.auth().signOut()
            authState.send(.loggedOut)
            print("👋 Succefully logged out")
        } catch {
            print("🔐 Faild To Log out current user: \(error.localizedDescription)")
        }
    }
}

extension AuthService {
    private func saveUserInfoDatabase(user : UserItem) async throws  {
        do {
            // String Constants made in UserItem
            guard let encodeUserItem = try? Firestore.Encoder().encode(user) else { return }
            try await Firestore.firestore().collection("users").document(user.uid).setData(encodeUserItem)
        } catch {
            print("🔐 Faild to save user info to Database: \(error.localizedDescription)")
            throw AuthError.failedToSaveUserInfo(description: error.localizedDescription)
        }
    }
    
    
    private func fetchCurrentUserInfo() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(currentUid).getDocument(as: UserItem.self) { [ weak self ] result in
            switch result {
            case .success(let loggedInUser):
                //This is publish the user information
                self?.authState.send(.loggedIn(loggedInUser))
                print("🙋‍♂️ \(loggedInUser.fullname) is Logged In")
            case .failure(let error):
                print("🔐 Faild to get current user Info: \(error.localizedDescription)")
            }
        }
    }
}
