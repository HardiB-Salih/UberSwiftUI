//
//  UberLocation.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import Foundation
import CoreLocation

struct UberLocation  : Identifiable{
    let id: String = UUID().uuidString
    let title: String
    let coordinate: CLLocationCoordinate2D
}
