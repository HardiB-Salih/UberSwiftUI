//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState : MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        Button(action: {
            withAnimation (.spring) {
                actionForState(mapState)
            }
            
        }, label: {
            Image(systemName: mapState == .noInput ?  "line.3.horizontal" : "arrow.left")
                .font(.title)
                .foregroundStyle(.black)
                .frame(width: 50, height: 50)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color(.systemGray4), lineWidth: 1.0)
                })
        })
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("☎️ noInput")
            Task { try? await AuthService.shared.logOut() }
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .polylineAdded:
            print("☎️ Clear the Map View")
            mapState = .noInput
            viewModel.selectedUberLocation = nil
        }
    }
    
    
}

#Preview {
    MapViewActionButton(mapState: .constant(.noInput))
}
