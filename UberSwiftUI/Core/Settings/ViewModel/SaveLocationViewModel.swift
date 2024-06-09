//
//  SaveLocationViewModel.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation

enum SaveLocationViewModel: Int, CaseIterable, Identifiable {
    case home
    case word
    var id: Int { return self.rawValue }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .word:
            return "Work"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home:
            return "Add Home"
        case .word:
            return "Add Work"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house.circle.fill"
        case .word:
            return "archivebox.circle.fill"
        }
    }
}
