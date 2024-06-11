//
//  TripRejectingView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/11/24.
//

import SwiftUI

struct TripRejectingView : View {
    var body: some View {
        VStack {
            Text("Trip Rejecting View ...")
                .padding(.vertical, 100)
        }
        .padding(.bottom, 30)
        .background(Color(.secondarySystemBackground))
        .clipShape(
            .rect(cornerRadii: RectangleCornerRadii(topLeading: 30, topTrailing: 30), style: .continuous)
        )
    }
        
}
