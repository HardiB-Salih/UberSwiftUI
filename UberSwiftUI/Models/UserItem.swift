//
//  UserItem.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Firebase

enum AccountType: Int, Codable {
    case passenger
    case driver
}

// MARK: - User Data Model
struct UserItem: Identifiable, Codable {
    let uid: String
    let fullname: String
    let email: String
    
    var accountType: AccountType
    var coordinates: GeoPoint
   
    
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
    
    var bio: String? = nil
    var profileImageUrl: String? = nil
    var rideTypeImage: String? = nil
    
    var id: String {
        return uid
    }
   

}


extension UserItem {
    static let placeholder = UserItem(uid: UUID().uuidString, fullname: "John Doe", email: "john.doe@test.com", accountType: .passenger, coordinates: GeoPoint(latitude: 40.74688, longitude: 31.622133))
}
