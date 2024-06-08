//
//  UberMapViewRepresentable.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI
import MapKit

struct UberMapViewRepresentable : UIViewRepresentable {
    let mapView = MKMapView()
    let locationManager = LocationManager()
    @EnvironmentObject private var viewModel : LocationSearchViewModel
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let coordinate =  viewModel.selectedLocationCoordinate2D {
            print("🗺️ the coordinate is selcted is \(coordinate)")
        }
    }
    
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
     
}

extension UberMapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent : UberMapViewRepresentable
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }

        // This method is called whenever the user's location is updated.
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // Extract the user's current coordinates from the userLocation object.
            let coordinate2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            // Define the map span, which determines the zoom level of the map.
            // A latitude and longitude delta of 0.05 covers a relatively small area.
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            // Create an MKCoordinateRegion object that combines the user's coordinates and the defined span.
            let region = MKCoordinateRegion(center: coordinate2D, span: coordinateSpan)
            
            // Set the map view to the specified region, with animation enabled for a smooth transition.
            parent.mapView.setRegion(region, animated: true)
        }
    }
}
