//
//  LocationSearchResultView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import SwiftUI
import MapKit

struct LocationSearchResultView: View {
    @StateObject var viewModel: LocationSearchViewModel
    let config : LocationViewResultConfig
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.results, id: \.self ) { result in
                    LocationSearchResultCell(title: result.title, subTitle: result.subtitle)
                        .onTapGesture {
                            viewModel.selectLocation(result, config: config)
                        }
                }
            }
        }
    }
}
