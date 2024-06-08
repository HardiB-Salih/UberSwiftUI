//
//  LocationSearchView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startLocationText = ""
    @Binding var mapState : MapViewState

    @EnvironmentObject private var viewModel : LocationSearchViewModel

    var body: some View {
        VStack (spacing: 40){
            //MARK: Header View
            HStack {
                VStack {
                    Circle().fill(Color(.systemGray3)).frame(width: 6, height: 6)
                    Rectangle().fill(Color(.systemGray3)).frame(width: 1, height: 24)
                    Rectangle().fill(Color(.label)).frame(width: 6, height: 6)
                }
                
                VStack {
                    TextField("Current Location", text: $startLocationText)
                        .frame(height: 32)
                        .padding(.horizontal, 10)
                        .background(Color(.systemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
                        .padding(.trailing)
                    TextField("Where to?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .padding(.horizontal, 10)
                        .background(Color(.systemGray4))
                        .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
                        .padding(.trailing)
                }
            }
            .padding(.top, 60)
            .padding(.horizontal)
            
            
            //MARK: List View
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.results, id: \.self ) { result in
                        LocationSearchResultCell(title: result.title, subTitle: result.subtitle)
                            .onTapGesture {
                                viewModel.selectLocation(result)
                                mapState = .locationSelected
                            }
                        
                    }
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    LocationSearchView(mapState: .constant(.noInput))
}
