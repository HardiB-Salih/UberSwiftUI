//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import Foundation
import MapKit
import SwiftUI
import Combine
import Firebase

enum LocationViewResultConfig {
    case ride
    case saveLocation(String)
}


class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation : UberLocation?
    @Published var pickupTime: String?
    @Published var dropOfTime: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    
    // MARK: Lifecycle
    override init() {
        super.init()
        searchCompleter.delegate = self
    }
    
    
    
    
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Ensure UI updates are performed on the main thread
        DispatchQueue.main.async {
            self.results = completer.results
        }
    }
}


// MARK: - Helper Methods
extension LocationSearchViewModel {
    
    /// Select a location based on the given MKLocalSearchCompletion.
    /// - Parameter localSearch: The MKLocalSearchCompletion object representing the selected location.
    func selectLocation(_ localSearch: MKLocalSearchCompletion, config:  LocationViewResultConfig) {
        
        locationSearch(forLocalSearchCompletion: localSearch) { [weak self ] response, error in
            guard let self else { return }
            if let error = error {
                print("🙀 Location search faild with error \(error.localizedDescription)")
                return
            }
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            
            
            switch config {
            case .ride:
                self.selectedUberLocation = UberLocation(title: localSearch.title, coordinate: coordinate)
                // print("🗺️ Location coordinate is \(coordinate)")
            case .saveLocation(let key):
                print("🗺️ Saved Location coordinate is \(key)")
                let savedLocation = SavedLocation(title: localSearch.title,
                                       addess: localSearch.subtitle,
                                       coordinates: GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
                Task {
                    await AuthService.shared.saveLocation(withKey: key, savedLocation: savedLocation)
                }
            }
        }
    }
    
    /// Perform a location search based on the given MKLocalSearchCompletion.
    /// - Parameters:
    ///   - localSearch: The MKLocalSearchCompletion object representing the search query.
    ///   - completion: A completion handler called when the search results are available.
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "\(localSearch.title) \(localSearch.subtitle) \(localSearch.description)"
        
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
    
    
    /**
     Computes the total price of the ride based on the type of ride and the distance between the user's location and the selected destination.
     
     - Parameter type: The type of ride selected (e.g., uberX, uberBlack, uberXL).
     - Returns: The total price of the ride in the corresponding currency. If the user's location or selected destination is not available, returns 0.0.
     */
    func computeRidePrice(forType type: RideType) -> Double {
        guard let coordinate = selectedUberLocation?.coordinate else { return 0.0 }
        guard let userCordinate = self.userLocation else { return 0.0 }
        
        let destination = CLLocation(latitude: coordinate.latitude,
                                     longitude: coordinate.longitude)
        let userLocation = CLLocation(latitude: userCordinate.latitude, longitude: userCordinate.longitude)
        
        let tripDistanceinMeters = userLocation.distance(from: destination)
        return type.computePrice(for: tripDistanceinMeters)
    }
    
    /// Retrieves the route from the user's location to the destination coordinate.
    /// - Parameters:
    ///   - userLocation: The coordinate representing the user's location.
    ///   - destinationCoordinate: The coordinate representing the destination location.
    ///   - completion: A closure to be called with the calculated route.
    func getDestinationRoute(from userLocation: CLLocationCoordinate2D,
                             to destinationCoordinate: CLLocationCoordinate2D,
                             completion: @escaping (MKRoute) -> Void) {
        
        // Create placemarks for the user's location and destination
        let userPlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        // Create a directions request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        
        // Create a directions object and calculate the route
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                // Handle error if route calculation fails
                print("🙀 Failed to get direction with error: \(error.localizedDescription)")
                return
            }
            
            // Retrieve the first route from the response
            guard let route = response?.routes.first else {
                print("🛑 No routes found")
                return
            }
            self.configurePickupAndDropoffTime(with: route.expectedTravelTime)
            // Call the completion handler with the calculated route
            completion(route)
        }
    }
    
    func configurePickupAndDropoffTime(with expectedTravelTime: Double) {
        pickupTime = Date().formatted(.hhmmA)
        dropOfTime = (Date() + expectedTravelTime).formatted(.hhmmA)
    }
    
    
    
    
    
    
    
}
