//
//  RideType.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import Foundation

enum RideType : Int, CaseIterable, Identifiable{
    case uberX
    case uberBlack
    case uberXL
    
    var id: Int { rawValue }
    
    var description: String {
        switch self {
        case .uberX: return "Uber X"
        case .uberBlack: return "Uber Black"
        case .uberXL: return "Ubar XL"
        }
    }
    
    var imageName: String {
        switch self {
        case .uberX: return "uber-x"
        case .uberBlack: return "uber-black"
        case .uberXL: return "uber-xl"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX: return 5
        case .uberBlack: return 5
        case .uberXL: return 5
        }
    }
    
    /**
     Computes the price of the ride based on the distance traveled.
     
     - Parameter distanceInMeter: The distance of the ride in meters.
     - Returns: The total price of the ride in the corresponding currency.
     */
    func computePrice(for distanceInMeter: Double) -> Double {
        let distanceInMiles = distanceInMeter / 1600
        
        switch self {
        case .uberX: return distanceInMiles * 1.5 + baseFare
        case .uberBlack: return distanceInMiles * 2.0 + baseFare
        case .uberXL: return distanceInMiles * 1.75 + baseFare
        }
    }
    
    
}
