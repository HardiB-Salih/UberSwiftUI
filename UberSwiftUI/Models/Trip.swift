//
//  Trip.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/10/24.
//

import Firebase

struct Trip: Codable, Identifiable {
    let id: String
    
    let passingerUid : String
    let passingerName: String
    let passingerLocation: GeoPoint

    let driverUid: String
    let driverName: String
    let driverLocation: GeoPoint
    
    let pickupName: String
    let pickupLocation: GeoPoint
    let pickupLocationAddress: String

    let dropoffName: String
    let dropoffLocation: GeoPoint

    let tripCost: Double
}

extension Trip {
    
}
