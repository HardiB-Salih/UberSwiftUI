//
//  MapViewState.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import Foundation

enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
    case polylineAdded
    case tripRequested
    case tripRejected
    case tripAccepted
}
