//
//  SaveLocationViewModel.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation

enum SaveLocationViewModel: Int, CaseIterable, Identifiable {
    case home
    case work
    var id: Int { return self.rawValue }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .work:
            return "Work"
        }
    }
    
    var subtitle: String {
        switch self {
        case .home:
            return "Add Home"
        case .work:
            return "Add Work"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house.circle.fill"
        case .work:
            return "archivebox.circle.fill"
        }
    }
    
    var key: String {
        switch self {
        case .home:
            return "homeLocation"
        case .work:
            return "workLocation"
        }
    }
    
    func subtitle(forUser userItem: UserItem) -> String {
        switch self {
        case .home:
            if let homeLocation = userItem.homeLocation {
                return homeLocation.title
            } else {
                return "Add Home"
            }
        case .work:
            if let workLocation = userItem.workLocation {
                return workLocation.title
            } else {
                return "Add Work"
            }
        }
    }
}
