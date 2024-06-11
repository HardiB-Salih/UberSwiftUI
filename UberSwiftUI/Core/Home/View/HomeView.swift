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
            
            
            //MARK: Passanger and Driver Views
            switch userItem.accountType {
            case .passenger:
                handlePassangerViews(mapState)
            case .driver:
                handleDriveViews(mapState)
            }
            
        }
        .ignoresSafeArea(edges: .bottom)
        .onReceive(homeViewModel.$selectedUberLocation) { location in
            if location != nil {
                withAnimation(.spring) {
                    self.mapState = .locationSelected
                }
            }
        }
        .onReceive(homeViewModel.$trip) { trip in
            guard let trip = trip else {
                self.mapState = .noInput
                return
            }
            
            withAnimation(.smooth) {
                switch trip.state {
                case .requested:
                    mapState = .tripRequested
                case .rejected:
                    mapState = .tripRejected
                case .accepted:
                    mapState = .tripAccepted
                case .passangerCanceled:
                    mapState = .tripCancelledByPassenger
                case .driverCanceled:
                    mapState = .tripCancelledByDriver
                }
            }
        }
    }
}


//MARK: - handlePassangerViews()
extension HomeView {
    @ViewBuilder
    func handlePassangerViews(_ state: MapViewState) -> some View {
        Group {
            switch state {
            case .locationSelected, .polylineAdded:
                RideRequestView()
            case .tripRequested:
                TripLoadingView()
            case .tripRejected:
                TripRejectingView()
            case .tripAccepted:
                TripAcceptingView()
            case .tripCancelledByPassenger:
                TripCanceledView(message: "Your trip has been canceled.")
            case .tripCancelledByDriver:
                TripCanceledView(message: "Your driver Cancel this trip.")
            default:
                EmptyView()
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .top)))
        
    }  
}


//MARK: - handleDriveViews
extension HomeView {
    @ViewBuilder
    func handleDriveViews(_ state: MapViewState) -> some View {
        Group {
            switch state {
            case .tripRequested:
                if let trip = homeViewModel.trip {
                    AcceptTripView(trip: trip)
                }
            case .tripAccepted:
                PickupPassengerView()
            case .tripCancelledByPassenger:
                TripCanceledView(message: "The trip has been canceld by the passenger.")
            case .tripCancelledByDriver:
                TripCanceledView(message: "Your trip has been canceled.")
            default:
                EmptyView()
            }
        }
        .transition(.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .top)))
    }
}
