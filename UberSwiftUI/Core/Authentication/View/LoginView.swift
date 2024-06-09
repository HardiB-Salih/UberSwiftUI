//
//  LoginView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                
                VStack (spacing: 24){
                    Spacer()
                    //MARK: Logo Area
                    Image("uberLogo")
                        .resizable()
                        .frame(width: 150, height: 150)
                    
                    Text("UBER")
                        .foregroundStyle(Color(.label))
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    //"Email Address"
                    //"email @example.com"
                    // "Enter Your Password"
                    
                    VStack (spacing: 32){
                        CustomTextField(text: $authVM.email, title: "Email Address", placeholder: "email @example.com")
                        CustomTextField(text: $authVM.password, title: "Password", placeholder: "Enter Your Password", isSecureField: true)
                        
                        
                        //MARK: Forgot password
                        Button(action: {
                            
                        }, label: {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(.label))
                        })
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                    
                    
                    //MARK: Social Meadia
                    VStack (spacing: 16){
                        HStack {
                            Divider()
                                .frame(width: 100, height: 1)
                                .background(Color(.systemGray2))
                            
                            Text("Sign in withsocial")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Divider()
                                .frame(width: 100, height: 1)
                                .background(Color(.systemGray2))
                        }
                        
                        HStack (spacing: 24){
                            Image("facebook").resizable().frame(width: 44, height: 44)
                            Image("google").resizable().frame(width: 44, height: 44)
                            Image("github").resizable().frame(width: 44, height: 44)
                        }
                    }
                    .padding(.vertical)
                    
                    
                    //MARK: Signin Button
                    Button(action: {
                        Task { try await authVM.handleLogin() }
                    }, label: {
                        HStack {
                            Text("SIGN IN")
                            Image(systemName: "arrow.right")
                        }
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(.secondarySystemBackground))
                        .background(Color(.label))
                        .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                        
                    })
                    .disabled(authVM.disableLoginButton)
                    .opacity(authVM.disableLoginButton ? 0.5 : 1)
                    
                    
                    //MARK: Singup Button
                    Spacer()
                    NavigationLink {
                        RegistrationView(authVM: authVM)
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack {
                            Text("Don't have an account?") +
                            Text(" Sign up")
                                .fontWeight(.semibold)
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color(.label))
                    }
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
        }
        
    }
}


//#Preview {
//    LoginView()
//}
//


