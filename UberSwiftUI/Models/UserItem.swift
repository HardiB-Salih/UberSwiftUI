//
//  UserItem.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation

// MARK: - User Data Model
struct UserItem: Identifiable, Codable {
    let uid: String
    let fullname: String
    let email: String
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
    
    var bio: String? = nil
    var profileImageUrl: String? = nil
    
    var id: String {
        return uid
    }
   

}


extension UserItem {
    static var placeholder = UserItem(uid: "123456", fullname: "HardiB", email: "hardib.sal@gmail.com")
}
