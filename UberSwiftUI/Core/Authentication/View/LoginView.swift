//
//  LoginView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    
    
    var body: some View {
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
                    CustomTextField(text: $email, title: "Email Address", placeholder: "email @example.com")
                    CustomTextField(text: $password, title: "Password", placeholder: "Enter Your Password", isSecureField: true)
                    
                    
                    //MARK: Forgot password
                    Button(action: {}, label: {
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
                Button(action: {}, label: {
                    HStack {
                        Text("SIGN IN")
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(Color(.secondarySystemBackground))
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color(.label))
                    .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                    
                })
                
                //MARK: Singup Button
                
                
                Spacer()
                Button(action: {}, label: {
                    HStack {
                        Text("Don't have an account?") +
                        Text(" Sign up")
                            .fontWeight(.semibold)
                    }
                    .font(.subheadline)
                    .foregroundStyle(Color(.label))
                })
                
                
                
            }
            .padding()
        }
        
    }
}

#Preview {
    LoginView()
}



