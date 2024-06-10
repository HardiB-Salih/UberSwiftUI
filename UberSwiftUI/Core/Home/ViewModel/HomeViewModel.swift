//
//  HomeViewModel.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/10/24.
//

import Firebase
import FirebaseFirestoreSwift
import CoreLocation
import MapKit

enum LocationViewResultConfig {
    case ride
    case saveLocation(String)
}


class HomeViewModel: NSObject, ObservableObject {
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedUberLocation : UberLocation?
    @Published var pickupTime: String?
    @Published var dropOfTime: String?
    @Published var drivers : [UserItem] = []
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    var userLocation: CLLocationCoordinate2D?
    var currentUser: UserItem
    
    
    // MARK: Lifecycle
    init(currentUser: UserItem) {
        self.currentUser = currentUser
        super.init()
        searchCompleter.delegate = self
        ///If the current user's account type is not passenger, exit this initializer immediately.
        if currentUser.accountType == .passenger {
            Task { await fetchDriverUsers(currentUser) }
        }
        
        updateUserCity(forUsrrentUser: currentUser)
    }
    
    
    @MainActor
    func fetchDriverUsers(_ currentUser: UserItem) async {
        let currentUserLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude: currentUser.coordinates.longitude)
        do {
            self.drivers = try await UserService.fetchDriverUsers(currentUserLocation: currentUserLocation)
        } catch {
            print("🚖 Could not find a drivers")
        }
    }
    
    
    func updateUserCity(forUsrrentUser currentUser: UserItem) {
        Task {
            do {
                guard let userLocation = LocationManager.shared.userLocation else { return }
                let userLocationChange = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                let cityNameChange = try await  UserService.getCityName(from: userLocationChange)
//                print("Iam at \(cityNameChange)")
//                print("Iam at \(currentUser.city)")
                guard currentUser.city != cityNameChange else { return }
                // Update the users city name

            } catch {
                print("🚨 Faild to do \(error.localizedDescription)")
            }
            
           
        }
    }
}



// MARK: - MKLocalSearchCompleterDelegate
extension HomeViewModel: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Ensure UI updates are performed on the main thread
        DispatchQueue.main.async {
            self.results = completer.results
        }
    }
}


// MARK: - Helper Methods
extension HomeViewModel {
    
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
                // print("🗺️ Saved Location coordinate is \(key)")
                let savedLocation = SavedLocation(title: localSearch.title,
                                                  addess: localSearch.subtitle,
                                                  coordinates: GeoPoint(latitude: coordinate.latitude,
                                                                        longitude: coordinate.longitude))
                
                UserService.saveLocation(withKey: key, savedLocation: savedLocation)
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
    
    
    func getPlacemark(forLocation location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        }
    }
    
}

//MARK: - Passanger API
extension HomeViewModel {
    func requestTrip() {
        print("Debug: Request trip here ...")
        guard let driver = drivers.first else { return }
        guard let dropof = selectedUberLocation else { return }
        let dropoffLocation = GeoPoint(latitude: dropof.coordinate.latitude, longitude: dropof.coordinate.longitude)
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude:  currentUser.coordinates.longitude)
        let tripRef = Firestore.firestore().collection("trips").document()

        getPlacemark(forLocation: userLocation) { [ weak self ] placemark, _ in
            guard let placemark = placemark, let self = self else { return }
            print("Debug: placemark for user location  is \(placemark)")
            let trip = Trip(id: tripRef.documentID,
                            passingerUid: self.currentUser.uid,
                            passingerName: self.currentUser.fullname,
                            passingerLocation: self.currentUser.coordinates,
                            
                            driverUid: driver.uid,
                            driverName: driver.fullname,
                            driverLocation: driver.coordinates,
                            
                            pickupName: placemark.name ?? "Apple ",
                            pickupLocation: self.currentUser.coordinates,
                            pickupLocationAddress: "123 main street",
                            
                            dropoffName: dropof.title,
                            dropoffLocation: dropoffLocation,
                            
                            tripCost: 50)
            
            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else { return }
            tripRef.setData(encodedTrip) { _ in
                print("Debug: trip is been sent to firestore")

            }
        }
    }
}


//MARK: - Driver API
extension HomeViewModel {
    
}
