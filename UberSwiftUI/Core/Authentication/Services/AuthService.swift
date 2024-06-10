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
import MapKit

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
    func createAccount(for username: String, email: String, password: String, userLocation: CLLocationCoordinate2D, cityName: String) async throws
    
    /// Saves the user location information to the database.
    ///
    /// - Parameters:
    ///   - key: The key under which the location information will be saved.
    ///   - savedLocation: The location information to be saved.
//    func saveLocation(withKey key: String, savedLocation: SavedLocation) async
    
    /// Logs out the current user, updating the authentication state.
    ///
    /// - Throws: An error if the logout process fails.
    func logOut() async throws
    
    
}

final class AuthService: AuthProvider {
    private var userListener: ListenerRegistration?
    private init(){
        Task { await autoLogin() }
    }
    
    deinit {
        stopListeningToCurrentUserInfo()
    }
    
    
    static var shared: AuthProvider = AuthService()
    var authState = CurrentValueSubject<AuthState, Never>(.pending)
    
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            self.authState.send(.loggedOut)
            stopListeningToCurrentUserInfo()
        } else {
            //            fetchCurrentUserInfo()
            startListeningToCurrentUserInfo()
        }
    }
    
    func login(with email: String, password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            startListeningToCurrentUserInfo()
            print("🙋‍♂️ \(authResult.user.email ?? "") is Logged In")
        } catch {
            print("🔐 Faild To Log in: \(error.localizedDescription)")
            throw AuthError.failedToLogin(description: error.localizedDescription)
        }
    }
    
    func createAccount(for fullname: String, email: String, password: String, userLocation: CLLocationCoordinate2D, cityName: String) async throws {
        print("User Location: \(userLocation.latitude), \(userLocation.longitude)")
 
        do {
            // invoke firebase create account method: store the suer in out firebase auth
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            //store new user in out database
            let uid = authResult.user.uid
            let newUser = UserItem(uid: uid,
                                   fullname: fullname,
                                   email: email,
                                   accountType: .driver,
                                   coordinates: GeoPoint(latitude: userLocation.latitude, longitude: userLocation.longitude),
                                   city: cityName)
            
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
    
    private func startListeningToCurrentUserInfo() {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            self.authState.send(.loggedOut)
            return
        }
        
        let USER_REF = Firestore.firestore().collection("users").document(currentUid)
        
        userListener = USER_REF.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("🔐 Failed to get current user info: \(error.localizedDescription)")
                return
            }
            
            guard let document = documentSnapshot else {
                print("🔐 Document snapshot is nil")
                return
            }
            
            do {
                let loggedInUser = try document.data(as: UserItem.self)
                // Publish the user information
                self.authState.send(.loggedIn(loggedInUser))
                print("🙋‍♂️ \(loggedInUser.fullname) is Logged In")
            } catch {
                print("🔐 Failed to decode user info: \(error.localizedDescription)")
            }
        }
    }
    
    private func stopListeningToCurrentUserInfo() {
        userListener?.remove()
        userListener = nil
    }
}
