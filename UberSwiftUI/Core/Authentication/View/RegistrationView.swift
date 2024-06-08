//
//  RegistrationView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct RegistrationView: View {
    @State var email = ""
    @State var fullname = ""
    @State var password = ""
    
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            VStack (alignment: .leading, spacing: 50) {
                
                Button(action: {}, label: {
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
                    CustomTextField(text: $fullname, title: "Full Name", placeholder: "Enter your Fullname")
                    CustomTextField(text: $email, title: "Email Address", placeholder: "email @example.com")
                    CustomTextField(text: $password, title: "Password", placeholder: "Enter Your Password", isSecureField: true)
                }
                
                //MARK: Signin Button
                Button(action: {}, label: {
                    Text("SIGN UP")                    
                        .foregroundColor(Color(.secondarySystemBackground))
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color(.label))
                        .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
                })
                
                Spacer()
                

            }
            .padding()
        }
        
    }
}

#Preview {
    RegistrationView()
}
