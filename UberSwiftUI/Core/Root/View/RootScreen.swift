//
//  RootScreen.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import SwiftUI

struct RootScreen: View {
    @StateObject var viewModel = RootScreenViewModel()
    
    var body: some View {
        switch viewModel.authState {
        case .pending:
            ProgressView()
                .controlSize(.large)
        case .loggedIn(let userItem):
            HomeView(userItem: userItem)
                .environmentObject(HomeViewModel(currentUser: userItem))
        case .loggedOut:
            LoginView()
        }
    }
}

#Preview {
    RootScreen()
}
