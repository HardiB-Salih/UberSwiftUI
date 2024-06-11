//
//  TripAcceptingView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/11/24.
//

import SwiftUI

struct TripAcceptingView : View {
    @State private var rotationAngle: Double = 20
    @State private var toggleRotation: Bool = false
    @EnvironmentObject var homeViewModel: HomeViewModel

    
    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 50, height: 6)
                .padding(.top)
            
            if let trip = homeViewModel.trip {
                //MARK: Meet your driver
                VStack {
                    HStack {
                        Text("Meet your driver at \(trip.pickupName) for your trip to \(trip.dropoffName)")
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
                
                //MARK: driver info view
                VStack {
                    HStack {
                        RoundedImageView(.placeholderImageUrl, size: .large, shape: .circle, backgroundColor: .systemBlue)
                            .overlay {
                                Circle().stroke(Color(.systemGray4), lineWidth: 2)
                            }
                            .rotationEffect(.degrees(rotationAngle))
                            .onAppear {
                                startRotationAnimation()
                            }
                        VStack (alignment: .leading, spacing: 4){
                            Text(trip.driverName).fontWeight(.semibold)
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
                        
                        
                        VStack {
                            Image(RideType.uberBlack.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 60)
                                        .rotationEffect(.degrees(-20))
                                        
                            
                            HStack {
                                Text("Mercedes S - ")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(.secondaryLabel)) +
                                Text("G5K448")
                                    .fontWeight(.semibold)
                            }
                            .font(.footnote)
                        }
                    }
                    Divider()
                }
                .padding()
                // End of if
            }
            
            //MARK: cancel button
            Button(action: {
                homeViewModel.cancelTripAsPassanger()
            }, label: {
                Text("CANCEL TRIP")
                    .fontWeight(.bold)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(Color(.systemRed))
                    .clipShape(RoundedRectangle(cornerRadius: 12 , style: .continuous))
                    .padding(.horizontal)
                    
            })
            
        }
        .padding(.bottom, 50)
        .background(Color(.secondarySystemBackground))
        .clipShape(
            .rect(cornerRadii: RectangleCornerRadii(topLeading: 30, topTrailing: 30), style: .continuous)
        )
    }
    
    func startRotationAnimation() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 2.0)) {
                rotationAngle = toggleRotation ? 20 : -20
                toggleRotation.toggle()
            }
        }
    }
        
}


#Preview {
    TripAcceptingView()
}
