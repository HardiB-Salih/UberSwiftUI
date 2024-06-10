//
//  DriverAnnotationView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/10/24.
//

import Foundation
import SwiftUI
import MapKit

struct DriverAnnotationView: View {
    let rideTypeImage : String
    var body: some View {
        Image(rideTypeImage)
            .resizable()
            .scaledToFit()
            .frame(width: 50)
    }
}

#Preview {
    DriverAnnotationView(rideTypeImage: "uber-xl")
}



struct DriverAnnotationViewRepresentable: UIViewRepresentable {
    let annotation: MKAnnotation
    let rideTypeImage: String
    
    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: DriverAnnotationView(rideTypeImage: rideTypeImage))
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No need to update the view here since it's static
    }
}

