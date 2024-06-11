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
    @Published var trip: Trip?
    
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
            addTripObserverForPassenger()
        } else {
            fetchTrips()
           
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
        let userLocation = CLLocation(latitude: userCordinate.latitude, 
                                      longitude: userCordinate.longitude)
        
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
    
    
//    func getPlacemark(forLocation location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            
//            guard let placemark = placemarks?.first else { return }
//            completion(placemark, nil)
//        }
//    }
    /// Retrieves a `CLPlacemark` for the given location using reverse geocoding.
    ///
    /// This function performs a reverse geocoding operation to convert a
    /// `CLLocation` into a `CLPlacemark`. It uses a completion handler to return
    /// the result asynchronously.
    ///
    /// - Parameters:
    ///   - location: The `CLLocation` object representing the location to be reverse geocoded.
    ///   - completion: A closure to be executed once the reverse geocoding completes.
    ///     The closure takes two parameters:
    ///     - `CLPlacemark?`: The resulting placemark, or `nil` if an error occurred.
    ///     - `Error?`: An error object if an error occurred, or `nil` if the operation was successful.
    func getPlacemark(forLocation location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let placemark = placemarks?.first
            completion(placemark, nil)
        }
    }
    
//    func adressFromPlacemark(_ placemark: CLPlacemark) -> String{
//        var result = ""
//        
//        if let thoroughfare = placemark.thoroughfare {
//            result += thoroughfare
//        }
//        
//        if let subThoroughfare = placemark.subThoroughfare {
//            result += " \(subThoroughfare)"
//        }
//        
//        if let subAdministrativeArea = placemark.subAdministrativeArea {
//            result += ", \(subAdministrativeArea)"
//        }
//        
//        return result
//    }

    /// Converts a `CLPlacemark` into a formatted address string.
    ///
    /// This function constructs an address string using the thoroughfare,
    /// sub-thoroughfare, and sub-administrative area properties of the given
    /// `CLPlacemark`.
    ///
    /// - Parameter placemark: The `CLPlacemark` to extract the address from.
    /// - Returns: A formatted address string containing the thoroughfare,
    ///   sub-thoroughfare, and sub-administrative area, if available.
    func addressFromPlacemark(_ placemark: CLPlacemark) -> String {
        var components: [String] = []
        
        if let thoroughfare = placemark.thoroughfare {
            components.append(thoroughfare)
        }
        
        if let subThoroughfare = placemark.subThoroughfare {
            components.append(subThoroughfare)
        }
        
        if let subAdministrativeArea = placemark.subAdministrativeArea {
            components.append(subAdministrativeArea)
        }
        
        return components.joined(separator: ", ")
    }
    
}

//MARK: - Passanger API
extension HomeViewModel {


    func addTripObserverForPassenger() {
        print("🫣 Adding trip observer for passenger")
        let tripRef = Firestore.firestore().collection("trips")
        let query = tripRef.whereField(.passingerUid, isEqualTo: currentUser.uid)
        
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print("🫣 Error fetching trip updates: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("🫣 No snapshot data")
                return
            }
            
            
            for change in snapshot.documentChanges {
//                switch change.type {
//                case .added:
//                    print("🫣 Trip added")
//                case .modified:
//                    print("🫣 Trip modified")
//                case .removed:
//                    print("🫣 Trip removed")
//                }

                do {
                    let trip = try change.document.data(as: Trip.self)
                    self.trip = trip
                    print("🫣 Updated trip state is \(trip.state)")
                } catch let error {
                    print("🫣 Error decoding trip: \(error)")
                }
            }
        }
    }
    
    
    
    func requestTrip(type: RideType = .uberX) {
        print("Debug: Request trip here ...")
        guard let driver = drivers.first else { return }
        guard let dropof = selectedUberLocation else { return }
        let dropoffLocation = GeoPoint(latitude: dropof.coordinate.latitude, longitude: dropof.coordinate.longitude)
        let userLocation = CLLocation(latitude: currentUser.coordinates.latitude, longitude:  currentUser.coordinates.longitude)
        let tripRef = Firestore.firestore().collection("trips").document()
        let tripCost = self.computeRidePrice(forType: type)
        print("Cost is \(tripCost)")
        getPlacemark(forLocation: userLocation) { [ weak self ] placemark, _ in
            guard let placemark = placemark, let self = self else { return }
            print("Debug: placemark for user location  is \(placemark)")
            
            
            let pickupLocationAddress = self.addressFromPlacemark(placemark)

            
            let trip = Trip(id: tripRef.documentID,
                            passingerUid: self.currentUser.uid,
                            passingerName: self.currentUser.fullname,
                            passingerLocation: self.currentUser.coordinates,
                            
                            driverUid: driver.uid,
                            driverName: driver.fullname,
                            driverLocation: driver.coordinates,
                            
                            pickupName: placemark.name ?? "Current Location",
                            pickupLocation: self.currentUser.coordinates,
                            pickupLocationAddress: pickupLocationAddress,
                            
                            dropoffName: dropof.title,
                            dropoffLocation: dropoffLocation,
                            
                            tripCost: tripCost,
                            distanceToPassinger: 0,
                            travelToPassinger: 0,
                            state: .requested
            )
            
            guard let encodedTrip = try? Firestore.Encoder().encode(trip) else { return }
            tripRef.setData(encodedTrip) { _ in
                print("Debug: trip is been sent to firestore")

            }
        }
    }
}


//MARK: - Driver API
extension HomeViewModel {
    
    func fetchTrips() {
//        guard currentUser.accountType == .driver else { return }
        let tripRef = Firestore.firestore().collection("trips")
        let query = tripRef.whereField("driverUid", isEqualTo: currentUser.uid)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("🙀 Faild to get trip becase \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            guard var trip = try? documents.first?.data(as: Trip.self) else { return }
            
            
            self.getDestinationRoute(from: trip.driverLocation.toCLLocationCoordinate2D(),
                                     to: trip.pickupLocation.toCLLocationCoordinate2D()) { route in
                trip.distanceToPassinger = route.distance
                trip.travelToPassinger = route.expectedTravelTime.toMin
                self.trip = trip
//                print("🙋‍♂️ route.expectedTravelTime is \(route.expectedTravelTime / 60)") //min
//                print("🙋‍♂️ route.distance \(route.distance.distanceInMiles())") //Meter
            }
        }
    }
    
    
    func rejectTrip(){
        updateTripState(withTripState: .rejected)
    }
    
    func acceptTrip(){
        updateTripState(withTripState: .accepted)
    }
    
    
    func updateTripState(withTripState state: TripState) {
        guard let trip = trip else { return }
        let tripRef = Firestore.firestore().collection("trips")
        let data : [String: Any] = [ .state : state.rawValue ]
        tripRef.document(trip.id).updateData(data) { _ in
            print("🫣 Did Update trip with state \(state)")
        }
    }
    
    
}
