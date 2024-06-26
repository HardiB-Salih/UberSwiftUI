//
//  AcceptTripView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/10/24.
//

import SwiftUI
import MapKit

struct AcceptTripView: View {
    let trip : Trip
    @State private var cameraPosition : MapCameraPosition
    @EnvironmentObject private var homeVM: HomeViewModel
    
    init(trip : Trip) {
        self.trip = trip
        let center = trip.pickupLocation.toCLLocationCoordinate2D()
        self._cameraPosition = State(initialValue: MapCameraPosition.region(.regionCreatorWithKilometers(center: center)))
    }
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 50, height: 6)
                .padding(.top)
            
            
            //MARK: would you like to pickup view
            VStack {
                HStack {
                    Text("Would you like to pickup this passinger")
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
            
            //MARK: pickup location info view
            VStack {
                HStack {
                    VStack (alignment: .leading, spacing: 6){
                        Text(trip.pickupName)
                            .font(.headline)
                        Text(trip.pickupLocationAddress)
                            .font(.subheadline)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    
                    Spacer()
                    
                    VStack{
                        Text(trip.distanceToPassinger.distanceInMiles())
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text("mi")
                            .font(.subheadline)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
                .padding(.horizontal)
                
                //Map
                Map(position: $cameraPosition) {
                    Marker(trip.pickupName, coordinate: trip.pickupLocation.toCLLocationCoordinate2D())
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                        .stroke(Color(.systemGray5), lineWidth: 2)
                }
                .padding(.horizontal)
                
            }
            
            //MARK: action buttons
            HStack {
                Button(action: {
                    homeVM.rejectTrip()
                }, label: {
                    Text("Reject")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemRed))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                })
                
                Button(action: {
                    homeVM.acceptTrip()
                }, label: {
                    Text("Accept")
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
            
        }
        .padding(.bottom, 30)
        .background(Color(.secondarySystemBackground))
        .clipShape(
            .rect(cornerRadii: RectangleCornerRadii(topLeading: 30, topTrailing: 30), style: .continuous)
        )
        
    }
}

//#Preview {
//    AcceptTripView(trip: .placeholder)
//}

extension CLLocationCoordinate2D {
    static var userLocation : CLLocationCoordinate2D {
        return .init(latitude: 37.3346, longitude: -122.0090)
    }
}


extension MKCoordinateRegion {
    static var userRegin: MKCoordinateRegion {
        return .init(center: .userLocation,
                     latitudinalMeters: 10000,
                     longitudinalMeters: 10000)
    }
}

