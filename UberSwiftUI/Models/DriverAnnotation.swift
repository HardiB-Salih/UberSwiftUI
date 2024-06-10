//
//  DriverAnnotation.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/10/24.
//

import MapKit
import Firebase


class DriverAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let driver: UserItem
    
    init(driver: UserItem) {
        self.coordinate = CLLocationCoordinate2D(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
        self.driver = driver
    }
    
}
