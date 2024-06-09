//
//  String.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation

extension String {
    /// Checks whether the string is a valid email address.
    var isValidEmail: Bool {
        let trimmedEmail = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: trimmedEmail)
    }
    
    
    /// Checks whether the string is a valid password.
    var isValidPassword: Bool {
        let trimmedPassword = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedPassword.isEmpty && trimmedPassword.count >= 6
    }
    
    /// Validates whether the string is a valid  based on a minimum count.
    /// - Parameters:
    ///   - count: The minimum count required for the password. Default is 3.
    /// - Returns: `true` if the string is valid, otherwise `false`.
    func isValid(withCount count: Int = 3) -> Bool {
        let trimmedPassword = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedPassword.isEmpty && trimmedPassword.count >= count
    }
}
