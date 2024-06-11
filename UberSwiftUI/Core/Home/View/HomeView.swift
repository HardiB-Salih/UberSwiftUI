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
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var showAcceptTripView = false

    init(userItem: UserItem) {
        self.userItem = userItem
    }
    
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
                    LocationSearchView()
                }
                
                MapViewActionButton(mapState: $mapState, showSideMenu: $showSideMenu)
                    .padding(.leading)
                
            }
            
            
            //MARK: Passanger and Driver View
            switch userItem.accountType {
            case .passenger:
                handlePassangerViews()
            case .driver:
                handleDriveViews()
            }
            
        }
        .ignoresSafeArea(edges: .bottom)
        .onChange(of: homeViewModel.trip, { oldValue, newValue in
            guard userItem.accountType == .driver else { return }
            if newValue != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showAcceptTripView = true
                    }
                }
            }
        })
        .onReceive(homeViewModel.$selectedUberLocation) { location in
            if location != nil {
                withAnimation(.spring) {
                    self.mapState = .locationSelected
                }
            }
        }
        .onReceive(homeViewModel.$trip) { trip in
            guard let trip = trip else { return }
            withAnimation(.smooth) {
                switch trip.state {
                case .requested:
                    mapState = .tripRequested
                    print("🚀  onReceive requested")
                case .rejected:
                    mapState = .tripRejected
                    print("🚀  onReceive rejected")
                case .accepted:
                    mapState = .tripAccepted
                    print("🚀  onReceive accepted")
                }
            }
        }
    }

}

//MARK: - handlePassangerViews()
extension HomeView {
    @ViewBuilder
    func handlePassangerViews() -> some View {
        if mapState == .locationSelected || mapState == .polylineAdded {
            RideRequestView()
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .top)))
        } else if mapState == .tripRequested {
           // show trip Requested or Loading View
            TripLoadingView()
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .top)))
        } else if  mapState == .tripAccepted {
            // show trip Accepted view
            TripAcceptingView()
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .top)))
        } else if  mapState == .tripRejected {
            // show trip Rejected view
            TripRejectingView()
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .top)))
        }
    }
    
}

//MARK: - handleDriveViews
extension HomeView {
    @ViewBuilder
    func handleDriveViews() -> some View {
        if showAcceptTripView, let trip = homeViewModel.trip {
            AcceptTripView(trip: trip)
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .top)))
        }
    }
}

//#Preview {
//    HomeView(userItem: .placeholder)
//}
