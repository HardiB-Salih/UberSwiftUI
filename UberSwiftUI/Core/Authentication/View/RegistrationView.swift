//
//  RegistrationView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct RegistrationView: View {
    @ObservedObject var authVM : AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 50) {
                
                Button(action: { dismiss() }, label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .foregroundStyle(Color(.label))
                })
                
                Spacer()
                
                Text("Create New Account")
                    .foregroundStyle(Color(.label))
                    .font(.system(size: 40))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack (spacing: 32){
                    CustomTextField(text: $authVM.fullname, title: "Fullname", placeholder: "Enter your fullname")
                    CustomTextField(text: $authVM.email, title: "Email Address", placeholder: "email @example.com")
                    CustomTextField(text: $authVM.password, title: "Password", placeholder: "Enter Your Password", isSecureField: true)
                }
                
                //MARK: Signin Button
                Button(action: {
                    Task { try await authVM.handleSignUp() }
                }, label: {
                    Text("SIGN UP")                    
                        .foregroundColor(Color(.secondarySystemBackground))
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color(.label))
                        .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                })
                .disabled(authVM.disableSignupButton)
                .opacity(authVM.disableSignupButton ? 0.5 : 1)
                
                Spacer()
            }
            .padding()
            // Show the CustomProgressView when isLoading is true
            if authVM.isLoading {
                CustomProgressView()
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .offset(y: 10)),
                        removal: .opacity.combined(with: .offset(y: -10))
                    ))
                    .zIndex(1) // Ensure it appears on top of other content
            }
        }
        .animation(.easeInOut, value: authVM.isLoading)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                authVM.userLocation = location
            }
        }
        
    }
}

//#Preview {
//    RegistrationView(authVM: AuthViewModel())
//}
