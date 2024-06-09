//
//  SideMenuView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import SwiftUI

struct SideMenuView: View {
    let userItem: UserItem
    
    let gradientColors = [
        Color(hex: "#F58529"),
        Color(hex: "#FEDA77"),
        Color(hex: "#DD2A7B"),
        Color(hex: "#8134AF"),
        Color(hex: "#515BD4")
    ]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 40){
            //MARK: Header View
            VStack (alignment: .leading, spacing: 32) {
                HStack {
                    RoundedImageView(size: .custom(64), shape: .rounded(cornerRadius: 25))
                        .padding(3)
                        .overlay {
                            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                .stroke(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .leading, endPoint: .trailing)
                                    ,
                                    lineWidth: 3.0)
                        }
                    
                    VStack (alignment: .leading, spacing: 8){
                        Text(userItem.fullname)
                            .fontWeight(.semibold)
                        Text(userItem.email)
                            .font(.subheadline)
                            .tint(Color(.secondaryLabel))
                    }
                }
                
                
                VStack (alignment: .leading, spacing: 16){
                    Text("Do more with account")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    OptionListCell(systemName: "dollarsign.square", title: "Make Money Driving")
                    Divider()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)
            
            
            //MARK: Option list
            VStack (alignment: .leading){
                ForEach(SideMenuOption.allCases) { option in
                    NavigationLink(value: option) {
                        
                        OptionListCell(systemName: option.iconName, title: option.title)
                            .padding(.vertical)
                            .foregroundStyle(Color(.label))
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.theme.backgroundColor)
        .navigationDestination(for: SideMenuOption.self) { option in
            Text(option.title)
        }
    }
}

//#Preview {
//    SideMenuView()
//}

struct OptionListCell: View {
    let systemName: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .font(.title2)
                .imageScale(.medium)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}


