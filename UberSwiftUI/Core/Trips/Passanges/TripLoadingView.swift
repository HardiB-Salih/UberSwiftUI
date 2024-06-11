//
//  TripLoadingView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/11/24.
//

import SwiftUI

struct TripLoadingView : View {
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 50, height: 6)
                .padding(.top)
            HStack {
                VStack (alignment: .leading, spacing: 6){
                    Text("Connecting you to a driver")
                        .font(.headline)
                    
//                    Text("Arriving at 1:30 PM")
//                        .font(.subheadline)
//                        .fontWeight(.semibold)
//                        .foregroundStyle(Color(.systemBlue))
                }
                
                Spacer()
                
                Spinner(lineWidth: 4, height: 50, width: 50)
            }
            .padding()
        }
        .padding(.bottom, 50)
        .background(Color(.secondarySystemBackground))
        .clipShape(
            .rect(cornerRadii: RectangleCornerRadii(topLeading: 30, topTrailing: 30), style: .continuous)
        )
    }
        
}

#Preview {
    TripLoadingView()
}
