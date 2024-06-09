//
//  RootScreenViewModel.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation
import Combine

@MainActor
final class RootScreenViewModel : ObservableObject {
    @Published private(set) var authState: AuthState = AuthState.pending
    private var cancellable = Set<AnyCancellable>()

    
    init() {
        observeAuthState()
    }
    
   
    private func observeAuthState() {
        AuthService.shared.authState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] latestAuthState in
                guard let self else { return }
                self.authState = latestAuthState
            }.store(in: &cancellable)
    }
}
