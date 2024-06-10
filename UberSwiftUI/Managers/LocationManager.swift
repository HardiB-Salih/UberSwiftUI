//
//  LocationManager.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import CoreLocation
import SwiftUI

class LocationManager : NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locateion = locations.first else { return }
        self.userLocation = locateion.coordinate
        
        locationManager.stopUpdatingLocation()
    }
}

