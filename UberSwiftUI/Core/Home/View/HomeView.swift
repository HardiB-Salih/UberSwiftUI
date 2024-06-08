//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    
    var body: some View {
        ZStack (alignment: .top){
            UberMapViewRepresentable(mapState: $mapState)
                .ignoresSafeArea()
            
            
            if mapState == .noInput {
                LocationSearchActivationView()
                    .padding(.horizontal)
                    .padding(.top, 60)
                    .onTapGesture {
                        withAnimation (.spring()) {
                            mapState = .searchingForLocation
                        }
                    }
            } else if mapState == .searchingForLocation {
                LocationSearchView(mapState: $mapState)
            }

            MapViewActionButton(mapState: $mapState)
                .padding(.leading)

        }
        
    }
}

#Preview {
    HomeView()
}
