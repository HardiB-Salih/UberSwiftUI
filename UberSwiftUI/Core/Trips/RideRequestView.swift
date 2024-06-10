//
//  RideRequestView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType : RideType = .uberX
    @EnvironmentObject var homeViewModel: HomeViewModel

    var body: some View {
        VStack {
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 50, height: 6)
                .padding(.top)
            
            
            //MARK: trip info view
            VStack (alignment: .leading, spacing: 0){
                HStack {
                    Circle().fill(Color(.systemGray3)).frame(width: 8, height: 8)
                        .padding(.trailing, 8)
                    Text("Current location")
                        .font(.subheadline)
                        .foregroundStyle(Color(.systemGray))
                    Spacer()
                     
                        Text(homeViewModel.pickupTime ?? "")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
                            .fontWeight(.semibold)
                    
                    
                    
                }
                Rectangle().fill(Color(.systemGray3)).frame(width: 2, height: 32)
                    .padding(.leading, 3)

                
                HStack {
                    Rectangle().fill(Color(.label)).frame(width: 8, height: 8)
                        .padding(.trailing, 8)
                    
                    if let location = homeViewModel.selectedUberLocation {
                        Text(location.title)
                            .font(.subheadline)
                    }
                    
                    
                    
                    Spacer()
                    Text( homeViewModel.dropOfTime ?? "" )
                        .font(.footnote)
                        .foregroundStyle(Color(.systemGray))
                        .fontWeight(.semibold)
                }
            }.padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            //MARK: ride type selection
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            ScrollView(.horizontal) {
                HStack (spacing: 12){
                    ForEach(RideType.allCases) { type in
                        VStack(alignment:.leading ) {
                            Image(type.imageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack (alignment: .leading, spacing: 4){
                                Text(type.description)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                
                                Text(homeViewModel.computeRidePrice(forType: type).toCurrency())
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 6)
                        }
                        .padding(type == selectedRideType ? 10 : 6)
                        .frame(width: 112, height: 140)
                        .foregroundStyle(Color( type == selectedRideType ? .white : .label))
                        .background( type == selectedRideType ? Color(.systemBlue) : Color.theme.secondaryBackgroundColor)
                        .scaleEffect(type == selectedRideType ? 1.2 : 1.0)
                        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 13, style: .continuous)
                                .stroke(Color(.systemGray5), lineWidth: 1.0)
                        }
                        
                        .onTapGesture {
                            withAnimation(.smooth) {
                                selectedRideType = type
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            //MARK: payment option view
            HStack {
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(Color(.systemBlue))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5 , style: .continuous))
                
                Text("****1234")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
            }
            .frame(height: 50)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12 , style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(.systemGray5), lineWidth: 1.0)
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            //MARK: request ride button
            Button(action: {
                homeViewModel.requestTrip()
            }, label: {
                Text("CONFIRM RIDE")
                    .fontWeight(.bold)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(Color(.systemBlue))
                    .clipShape(RoundedRectangle(cornerRadius: 12 , style: .continuous))
                    .padding(.horizontal)
                    
            })
        }
        .padding(.bottom, 30)
        .background(Color.theme.backgroundColor)
        .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 30, topTrailing: 30), style: .continuous))
    }
}

//#Preview {
//    RideRequestView()
//}
