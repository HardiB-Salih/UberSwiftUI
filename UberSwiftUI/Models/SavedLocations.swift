//
//  SavedLocations.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation
import Firebase

struct SavedLocation: Codable {
    let title : String
    let addess : String
    let coordinates : GeoPoint
}
