//
//  CustomTextField.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text : String
    let title : String
    let placeholder: String
    var isSecureField : Bool = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 12){
            //MARK: TextField
            Text(title)
                .font(.footnote)
                .fontWeight(.semibold)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .foregroundStyle(Color(.label))
            } else {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .foregroundStyle(Color(.label))
            }
            
            Divider()
                .frame(height: 0.7)
                .background(Color(.init(white: 1, alpha: 0.3)))
        }
    }
}


#Preview {
    CustomTextField(text: .constant(""), title: "Email Address", placeholder: "email @example.com")
}

