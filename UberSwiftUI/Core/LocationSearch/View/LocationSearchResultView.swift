//
//  LocationSearchResultView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import SwiftUI
import MapKit

struct LocationSearchResultView: View {
    @StateObject var viewModel: HomeViewModel
    let config: LocationViewResultConfig
    var onTapped: (MKLocalSearchCompletion) -> Void  =  { _ in }
    

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.results, id: \.self) { result in
                    LocationSearchResultCell(title: result.title, subTitle: result.subtitle)
                        .onTapGesture {
                            viewModel.selectLocation(result, config: config)
                            onTapped(result)
                            // Call the closure only if it's not nil
                        }
                }
            }
        }
    }
}
