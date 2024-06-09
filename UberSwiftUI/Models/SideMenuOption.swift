//
//  SideMenuOption.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation
import SwiftUI

enum SideMenuOption: Int, CaseIterable, Identifiable {
    case trips
    case wallet
    case settings
    case messages
    
    var id: Int { self.rawValue }
    
    var title : String {
        switch self {
        case .trips:
            return "Trips"
        case .wallet:
            return "Wallet"
        case .settings:
            return "Settings"
        case .messages:
            return "Messages"
        }
    }
    
    var iconName : String {
        switch self {
        case .trips:
            return "list.bullet.rectangle"
        case .wallet:
            return "creditcard"
        case .settings:
            return "gear"
        case .messages:
            return "bubble.left"
        }
    }
    
}

