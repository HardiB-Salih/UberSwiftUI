//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showLocationSearchView = false
    
    
    var body: some View {
        ZStack (alignment: .top){
            UberMapViewRepresentable()
                .ignoresSafeArea()
            
            
            if !showLocationSearchView {
                LocationSearchActivationView()
                    .padding(.horizontal)
                    .padding(.top, 60)
                    .onTapGesture {
                        withAnimation (.spring()) {
                            showLocationSearchView.toggle()
                        }
                    }
            } else {
                LocationSearchView(showLocationSearchView: $showLocationSearchView)
            }
            
            
            MapViewActionButton(showLocationSearchView: $showLocationSearchView)
                .padding(.leading)
        }
        
    }
}

#Preview {
    HomeView()
}
