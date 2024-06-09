//
//  SettingsView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import SwiftUI

struct SettingsView: View {
    private let userItem: UserItem
    @Environment(\.dismiss) private var dismiss
    
    init(userItem: UserItem) {
        self.userItem = userItem
    }
    
    var body: some View {
        List {
            HStack {
                RoundedImageView(size: .custom(64), shape: .rounded(cornerRadius: 25))
                VStack (alignment: .leading, spacing: 8){
                    Text(userItem.fullname)
                        .fontWeight(.semibold)
                    Text(userItem.email)
                        .font(.subheadline)
                        .tint(Color(.secondaryLabel))
                }
            }
            .padding(.vertical, 8)
            
            
            
            Section("Faverates") {
                ForEach(SaveLocationViewModel.allCases) { viewModel in
                    NavigationLink {
                        SaveLocationSearchView(config: viewModel)
                    } label: {
                        SettingCell(title: viewModel.title,
                                    iconName: viewModel.iconName,
                                    subTitle: viewModel.subtitle)
                    }
                }
                
            }
            
            Section("Settings") {
                SettingCell(title: "Notifications", iconName: "bell.circle.fill", iconColor: .systemIndigo)
                SettingCell(title: "Payment Method", iconName: "creditcard.circle.fill").padding(.vertical, 3)
            }
            
            Section("Account") {
                SettingCell(title: "Make money driving", iconName: "dollarsign.circle.fill", iconColor: .systemGreen).padding(.vertical, 3)
                
                SettingCell(title: "Sign out", iconName: "arrow.backward.circle.fill", iconColor: .systemRed)
                    .padding(.vertical, 3)
                    .onTapGesture { Task { try await AuthService.shared.logOut()} }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .foregroundStyle(Color(.label))
                })
            }
        }
        .onAppear {
            print("SettingsView user is: \(userItem)")
        }
        
    }
}

//#Preview {
//    NavigationStack {
//        SettingsView(userItem: .placeholder)
//    }
//}

struct SettingCell : View {
    let title : String
    let iconName: String
    let iconColor: UIColor
    let subTitle: String?
    
    init(title: String,
         iconName: String = "house.circle.fill",
         iconColor: UIColor = .systemBlue ,
         subTitle: String? = nil) {
        
        self.title = title
        self.iconName = iconName
        self.iconColor = iconColor
        self.subTitle = subTitle
    }
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title)
                .foregroundStyle(Color(iconColor))
            
            VStack (alignment: .leading, spacing: 2){
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(.label))
                
                if let subTitle = subTitle {
                    Text(subTitle)
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
                }
                
            }
        }
        
    }
}
