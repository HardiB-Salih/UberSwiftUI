//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import Foundation
import MapKit


import SwiftUI
import MapKit
import Combine

class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate2D : CLLocationCoordinate2D?
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: Lifecycle
    override init() {
        super.init()
        searchCompleter.delegate = self
    }
    
    // MARK: - Helper Methods
        
        /// Select a location based on the given MKLocalSearchCompletion.
        /// - Parameter localSearch: The MKLocalSearchCompletion object representing the selected location.
        func selectLocation(_ localSearch: MKLocalSearchCompletion) {
            locationSearch(forLocalSearchCompletion: localSearch) { [weak self ] response, error in
                guard let self else { return }
                if let error = error {
                    print("🙀 Location search faild with error \(error.localizedDescription)")
                    return
                }
                guard let item = response?.mapItems.first else { return }
                let coordinate = item.placemark.coordinate
                self.selectedLocationCoordinate2D = coordinate
//                print("🗺️ Location coordinate is \(coordinate)")
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
