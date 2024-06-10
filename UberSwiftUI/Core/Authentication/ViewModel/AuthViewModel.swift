//
//  AuthViewModel.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation
import CoreLocation

@MainActor
final class AuthViewModel: ObservableObject {
    // MARK: -Published Properties
    @Published var isLoading: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullname: String = ""
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Uh Oh")
    
    var userLocation: CLLocationCoordinate2D?
    
    // MARK: -Computed Properties
    var disableLoginButton: Bool {
        return !email.isValidEmail || !password.isValidPassword || isLoading
    }

    
    var disableSignupButton: Bool {
        return !email.isValidEmail || !password.isValidPassword || !fullname.isValid(withCount: 3) || isLoading
    }

    
    func handleSignUp() async throws {
        guard let userLocation = self.userLocation else { return }
        let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        print("User Location: \(userLocation.latitude), \(userLocation.longitude)")
        

        isLoading = true
        
        do {
            let cityName = try await UserService.getCityName(from: location)
            try await AuthService.shared.createAccount(for: fullname, email: email, password: password, userLocation: userLocation, cityName: cityName)
        } catch {
            errorState.errorMessage = error.localizedDescription
            errorState.showError = true
            isLoading = false
        }
        
    }
    
    func handleLogin() async throws {
        isLoading = true
        do {
            try await AuthService.shared.login(with: email, password: password)
        } catch {
            errorState.errorMessage = error.localizedDescription
            errorState.showError = true
            isLoading = false
        }
    }
}
