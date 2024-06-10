//
//  UserService.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/10/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import CoreLocation

typealias CompletionHandler<T> = (T) -> Void
typealias SimpleCompletionHandler = () -> Void
typealias ResultCompletion<T> = (Result<T, Error>) -> Void
typealias UploadResultCompletion<T, E: Error> = (Result<T, E>) -> Void


enum CityError: Error {
    case locationError
    case cityNameNotFound
}

let UserService = _UserService()
class _UserService {
    
    //MARK: saveLocation For Home or work
    func saveLocation(withKey key: String, savedLocation: SavedLocation) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let encodeSavedLocation = try? Firestore.Encoder().encode(savedLocation) else { return }
        
        let USER_REF = Firestore.firestore().collection("users")
        USER_REF.document(currentUid).updateData([key: encodeSavedLocation]) { error in
            if let error = error {
                print("🔐 Failed to update user location info: \(error.localizedDescription)")
                return
            }
        }
    }
    

//    //MARK: Locally Check for a distance
//    func fetchDriverUsers(currentUserLocation: CLLocation, completion: @escaping ResultCompletion<[UserItem]>) {
//        let USER_REF = Firestore.firestore().collection("users")
//        let query = USER_REF.whereField("accountType", isEqualTo: AccountType.driver.rawValue)
//
//        query.getDocuments { snapshot, error in
//            if let error = error {
//                print("Could not retrieve drivers: \(error)")
//                completion(.failure(error))
//                return
//            }
//
//            guard let documents = snapshot?.documents else { return }
//            let drivers = documents.compactMap { try? $0.data(as: UserItem.self) }
//            
//            // Filter drivers within 1000 meters
//            let nearbyDrivers = drivers.filter { driver in
//                let driverLocation = CLLocation(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
//                let distance = currentUserLocation.distance(from: driverLocation)
//                return distance <= 1000 // Distance in meters
//            }
//            
//            completion(.success(nearbyDrivers))
//        }
//    }
    

    /// Fetches driver users asynchronously based on the current user's location.
    ///
    /// - Parameters:
    ///   - currentUserLocation: The CLLocation object representing the current user's location.
    /// - Returns: An array of UserItem objects representing the driver users within the same city as the current user.
    /// - Throws: An error if there is a problem with fetching the driver users, such as a Firestore query error or if the city name cannot be retrieved.
    @available(iOS 15.0, *)
    func fetchDriverUsers(currentUserLocation: CLLocation) async throws -> [UserItem] {
        // Use the city name to filter drivers in Firestore query
        let USER_REF = Firestore.firestore().collection("users")
        
        do {
            let cityName = try await getCityName(from: currentUserLocation)
            let query = USER_REF.whereField("accountType", isEqualTo: AccountType.driver.rawValue).whereField("city", isEqualTo: cityName)
            let snapshot = try await query.getDocuments()
            return snapshot.documents.compactMap { try? $0.data(as: UserItem.self) }
        } catch  {
            throw error
        }
    }



    /// Retrieves the city name asynchronously from the given location.
    ///
    /// - Parameters:
    ///   - location: The CLLocation object representing the location for which the city name is to be retrieved.
    /// - Returns: A string containing the name of the city if successful.
    /// - Throws: An error of type CityError if the city name cannot be retrieved, such as if the location is invalid or if the city name is not found.
    @available(iOS 15.0, *)
    func getCityName(from location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first, let cityName = placemark.locality else {
                throw CityError.cityNameNotFound
            }
            return cityName
        } catch {
            throw CityError.locationError
        }
    }

    
}




