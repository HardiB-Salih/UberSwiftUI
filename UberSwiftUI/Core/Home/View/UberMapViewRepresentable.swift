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
    let locationManager = LocationManager.shared
    @Binding var mapState: MapViewState
    @EnvironmentObject private var viewModel : LocationSearchViewModel
    @EnvironmentObject private var homeViewModel : HomeViewModel

    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
//        print("🚀 map state is \(mapState)")
        
        switch mapState {
        case .noInput:
            context.coordinator.clearMapViewAndRecenterUserLoacation()
//            print("🚀 drivers on map \(homeViewModel.drivers)")
            context.coordinator.addDriversToMap(drivers: homeViewModel.drivers)
            break
        case .searchingForLocation:
            break
        case .locationSelected:
            print("🚀 add the Annotation")
            if let coordinate =  viewModel.selectedUberLocation?.coordinate {
                context.coordinator.addAndSelectAnnotation(withCoordinate: coordinate)
                context.coordinator.configurePolyline(withDestinationCoordinate: coordinate)
            }
            break
        case .polylineAdded:
            break
        }
    }
    
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
}

extension UberMapViewRepresentable {
    class MapCoordinator: NSObject, MKMapViewDelegate {
        //MARK: - Properties
        let parent : UberMapViewRepresentable
        var userLocationCoordinate : CLLocationCoordinate2D?
        var currentRegion : MKCoordinateRegion?
        
        //MARK: - INIT
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        //MARK: - MKMapViewDelegate
        // This method is called whenever the user's location is updated.
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            
            // Show User Location on map
            // Extract the user's current coordinates from the userLocation object.
            let coordinate2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            // Define the map span, which determines the zoom level of the map.
            // A latitude and longitude delta of 0.05 covers a relatively small area.
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            
            // Create an MKCoordinateRegion object that combines the user's coordinates and the defined span.
            let region = MKCoordinateRegion(center: coordinate2D, span: coordinateSpan)
            self.currentRegion = region
            
            // Set the map view to the specified region, with animation enabled for a smooth transition.
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = .systemBlue
            polyline.lineWidth = 6
            return polyline
        }
        
        
        //MARK: - Helpers
        
        /// Adds and selects a map annotation at the specified coordinate.
        /// - Parameter coordinate: The coordinate where the annotation will be placed.
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            // Remove all the annotations exsist befor add another
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            // Create a new MKPointAnnotation
            let annotation = MKPointAnnotation()
            // Set its coordinate
            annotation.coordinate = coordinate
            // Add the annotation to the map view
            parent.mapView.addAnnotation(annotation)
            // Select the annotation, causing it to be displayed with a callout
            parent.mapView.selectAnnotation(annotation, animated: true)
            
//            parent.mapView.showAnnotations(parent.mapView.annotations, animated: true)
        }
        
        
        
        /// Configures a polyline on the map view from the user's current location to the destination coordinate.
        /// - Parameter coordinate: The coordinate representing the destination location.
        ///
        /// After calling this function, you need to implement the `mapView(_:rendererFor:)` method of the `MKMapViewDelegate` protocol to display the overlay on the map.
        ///
        /// Example:
        /// ```swift
        /// func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        ///     // Implement rendering logic for the overlay here
        ///     let polyline = MKPolylineRenderer(overlay: overlay)
        ///     polyline.strokeColor = .systemRed
        ///     polyline.lineWidth = 6
        ///     return polyline
        /// }
        /// ```
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            // Ensure there's a valid user location coordinate
            guard let userLocationCoordinate = userLocationCoordinate else {
                print("🛑 No valid user location coordinate available.")
                return
            }
            
            
            // Retrieve the route from the user's location to the destination coordinate
            parent.viewModel.getDestinationRoute(from: userLocationCoordinate, to: coordinate) { route in
                // Add the route's polyline as an overlay on the map view
                //                self.parent.mapView.removeOverlays(self.parent.mapView.overlays)
                
                self.parent.mapView.addOverlay(route.polyline)
                self.parent.mapState = .polylineAdded
                // if we want to shift the map when some view show in the bottom of the map
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        
        //getDestinationRoute use to be here
        
        
        
        /// Clears all annotations and overlays from the map view and recenters to the user's current location if available.
        func clearMapViewAndRecenterUserLoacation() {
            // Remove all annotations from the map view
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            // Remove all overlays from the map view
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            // Recenter the map to the user's current location if available
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        
        //MARK: - Add Custom Annotation
        func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? DriverAnnotation {
                let identifier = "driver"
                guard let rideTypeImage = annotation.driver.rideTypeImage else { return nil }
                var view: MKAnnotationView
                if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
                } else {
                    view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    let driverAnnotationView = DriverAnnotationViewRepresentable(annotation: annotation, 
                                                                                 rideTypeImage: rideTypeImage)
                    let hostingController = UIHostingController(rootView: driverAnnotationView)
                    view.addSubview(hostingController.view)
                }
                
                return view
            }
            return nil
        }
        
        func addDriversToMap(drivers: [UserItem]) {
            let annotations = drivers.map({ DriverAnnotation(driver: $0)})
            self.parent.mapView.addAnnotations(annotations)
        }
    }
}
