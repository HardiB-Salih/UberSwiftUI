//
//  Trip.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/10/24.
//

import Firebase

enum TripState : Int, Codable{
    case requested
    case rejected
    case accepted
    case passangerCanceled
    case driverCanceled

}


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
    
    //Update the trip
    var distanceToPassinger : Double
    var travelTimeToPassinger : Int
    var state: TripState
}

extension Trip : Equatable { }

extension Trip {
    static var placeholder: Trip {
        return .init(id: "cOqRhtizNJLZhCfCWuFf",
                     passingerUid: "IuQfilR9Ure27s44Q8huxgamtA82",
                     passingerName: "HardiB Salih",
                     passingerLocation: GeoPoint(latitude: 40.746880, longitude: 31.622133),
                     driverUid: "kOmb0aj3LWSKAbnUOJOJUqb5X6l2",
                     driverName: "Ginga Papa",
                     driverLocation: GeoPoint(latitude: 40.749193, longitude:  31.615726),
                     pickupName: "Ucar Sk. 18",
                     pickupLocation: GeoPoint(latitude: 40.746880, longitude: 31.622133),
                     pickupLocationAddress: "123 main street",
                     dropoffName: "Burger King",
                     dropoffLocation: GeoPoint(latitude: 40.732748, longitude: 31.607795),
                     tripCost: 50.0, 
                     distanceToPassinger: 1000,
                     travelTimeToPassinger: 24,
                     state: .requested)
    }
    
    static var johnDoe : Trip {
        return .init(id: "1",
                     passingerUid: "passenger123",
                     passingerName: "John Doe",
                     passingerLocation: GeoPoint(latitude: 37.7749, longitude: -122.4194),
                     driverUid: "driver123",
                     driverName: "Jane Smith",
                     driverLocation: GeoPoint(latitude: 37.7749, longitude: -122.4194),
                     pickupName: "Pickup Location",
                     pickupLocation: GeoPoint(latitude: 37.7749, longitude: -122.4194),
                     pickupLocationAddress: "123 Main St, San Francisco, CA",
                     dropoffName: "Dropoff Location",
                     dropoffLocation: GeoPoint(latitude: 37.7849, longitude: -122.4094),
                     tripCost: 25.50,
                     distanceToPassinger: 1000,
                     travelTimeToPassinger: 24,
                     state: .accepted)
    }
}

extension String {
    static let state = "state"
    static let passingerUid = "passingerUid"
    static let driverUid = "driverUid"
    static let distanceToPassinger = "distanceToPassinger"
    static let travelTimeToPassinger = "travelTimeToPassinger"
}
