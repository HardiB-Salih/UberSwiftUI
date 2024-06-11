//
//  TripCanceledView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/11/24.
//

import SwiftUI

struct TripCanceledView: View {
    let message: String
    @EnvironmentObject var homeVM : HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 50, height: 6)
                .padding(.top)
            
            
            Text(message)
                .font(.headline)
                .padding()
               
            
            
            
            Button(action: {
                guard let trip = homeVM.trip else { return }
                if homeVM.currentUser.accountType == .passenger {
                    if trip.state == .driverCanceled {
                        homeVM.deleteTrip()
                    } else if trip.state == .passangerCanceled {
                        homeVM.trip = nil
                    }
                } else {
                    if trip.state == .passangerCanceled {
                        homeVM.deleteTrip()
                    } else if trip.state == .driverCanceled {
                        homeVM.trip = nil
                    }
                }
                
            }, label: {
                Text("Ok")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBlue))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
            })
        }
        .padding()
        .frame(maxWidth: .infinity)
        .padding(.bottom, 30)
        .background(Color(.secondarySystemBackground))
        .clipShape(
            .rect(cornerRadii: RectangleCornerRadii(topLeading: 30, topTrailing: 30), style: .continuous)
        )
    }
}

#Preview {
    TripCanceledView(message: "Your trip Canceled")
}
