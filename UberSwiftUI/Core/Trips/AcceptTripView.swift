//
//  AcceptTripView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/10/24.
//

import SwiftUI
import MapKit

struct AcceptTripView: View {
  @State private var cameraPosition : MapCameraPosition = .region(.userRegin)
 
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
                        Text("10").bold()
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
                        Text("JOHN DOE").fontWeight(.semibold)
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
                        Text("$22")
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
                        Text("Apple Campus")
                            .font(.headline)
                        Text("Infinit Loop 1, Santa Clara County")
                            .font(.subheadline)
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                    
                    Spacer()
                    
                    VStack{
                        Text("5.2")
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
                    Marker("Coffee", coordinate: .userLocation)
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
                Button(action: {}, label: {
                    Text("Reject")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemRed))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        
                })
                
                Button(action: {}, label: {
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

#Preview {
    AcceptTripView()
}

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

