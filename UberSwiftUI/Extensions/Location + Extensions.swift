//
//  Location + Extensions .swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/11/24.
//

import Firebase
import CoreLocation
import MapKit

extension GeoPoint {
    // Convert GeoPoint to CLLocationCoordinate2D
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

extension CLLocationCoordinate2D {
    // Convert CLLocationCoordinate2D to GeoPoint
    func toGeoPoint() -> GeoPoint {
        return GeoPoint(latitude: self.latitude, longitude: self.longitude)
    }
}



extension MKCoordinateRegion {
    static func regionCreatorWithMeters(center: CLLocationCoordinate2D,
                                        latitudinalMeters: Double = 2000,
                                        longitudinalMeters: Double = 2000) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: center, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
    }

    static func regionCreatorWithKilometers(center: CLLocationCoordinate2D,
                                            latitudinalKilometers: Double = 2,
                                            longitudinalKilometers: Double = 2) -> MKCoordinateRegion {
        let latitudinalMeters = latitudinalKilometers * 1000
        let longitudinalMeters = longitudinalKilometers * 1000
        return MKCoordinateRegion(center: center, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
    }

    static func regionCreatorWithMiles(center: CLLocationCoordinate2D,
                                       latitudinalMiles: Double = 1,
                                       longitudinalMiles: Double = 1) -> MKCoordinateRegion {
        let metersPerMile = 1609.34
        let latitudinalMeters = latitudinalMiles * metersPerMile
        let longitudinalMeters = longitudinalMiles * metersPerMile
        return MKCoordinateRegion(center: center, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
    }
    
    
    static func regionCreator(center: CLLocationCoordinate2D) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.040, longitudeDelta: 0.040))
    }
}
