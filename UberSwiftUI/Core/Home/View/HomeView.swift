//
//  HomeView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct HomeView: View {
    let userItem: UserItem
    @State private var showSideMenu = false
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.backgroundColor
                    .ignoresSafeArea()
                
                SideMenuView(userItem: userItem)
                    .opacity(showSideMenu ? 1 : 0)
                    .offset(x: showSideMenu ? 0 : -100)
                
                mapView
                    .overlay(
                        Rectangle()
                            .opacity(showSideMenu ? 0.2 : 0)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    showSideMenu.toggle()
                                }
                            }
                    )
                    .offset(x: showSideMenu ? 320 : 0)
            }
            .onAppear {
                showSideMenu = false
            }
        }
    }
}


extension HomeView {
    var mapView : some View {
        ZStack (alignment: .bottom) {
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
                } else if mapState == .searchingForLocation  {
                    LocationSearchView(mapState: $mapState)
                }
                
                MapViewActionButton(mapState: $mapState, showSideMenu: $showSideMenu)
                    .padding(.leading)
                
            }
            
            
            if mapState == .locationSelected  || mapState == .polylineAdded  {
                RideRequestView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .move(edge: .top)))
            }
            
        }
        .ignoresSafeArea(edges: .bottom)
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location {
                locationViewModel.userLocation = location
            }
        }
    }
}

//#Preview {
//    HomeView(userItem: .placeholder)
//}
