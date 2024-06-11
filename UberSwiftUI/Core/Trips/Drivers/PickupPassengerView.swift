//
//  PickupPassengerView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/11/24.
//

import SwiftUI

struct PickupPassengerView: View {
    //    let trip : Trip
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 50, height: 6)
                .padding(.top)
            
            
            if let trip = homeViewModel.trip {
                //MARK: would you like to pickup view
                VStack {
                    HStack {
                        Text("Pick up \(trip.passingerName) at \(trip.dropoffName)")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        VStack {
                            Text(trip.travelTimeToPassinger.toString()).bold()
                            Text("min").bold()
                        }
                        
                        .frame(width: 56, height: 56)
                        .foregroundStyle(.white)
                        .background(Color(.systemBlue))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .padding()
                    
                    Divider()
                }
                
                //MARK: user info view
                VStack {
                    HStack {
                        RoundedImageView(.placeholderImageUrl, size: .large, shape: .circle, backgroundColor: .systemBlue)
                            .overlay {
                                Circle().stroke(Color(.systemGray4), lineWidth: 2)
                                
                            }
                        VStack (alignment: .leading, spacing: 4){
                            Text(trip.passingerName).fontWeight(.semibold)
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundStyle(Color(.systemYellow))
                                    .imageScale(.small)
                                Text("4.8")
                                    .font(.footnote)
                                    .foregroundStyle(Color(.secondaryLabel))
                            }
                        }
                        
                        Spacer()
                        
                        VStack (spacing: 6){
                            Text("Earning")
                            Text(trip.tripCost.toCurrency())
                                .font(.system(size: 24, weight: .semibold))
                        }
                    }
                    Divider()
                }
                .padding()
            }
            
            Button(action: {
                homeViewModel.cancelTripAsDriver()
            }, label: {
                Text("Cancel Trip")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemRed))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
            })
            .padding()
        }
        .padding(.bottom, 30)
        .background(Color(.secondarySystemBackground))
        .clipShape(
            .rect(cornerRadii: RectangleCornerRadii(topLeading: 30, topTrailing: 30), style: .continuous)
        )
    }
}

#Preview {
    PickupPassengerView()
}
