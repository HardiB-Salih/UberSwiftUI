//
//  SaveLocationSearchView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import SwiftUI

struct SaveLocationSearchView: View {
    @StateObject var viewModel = LocationSearchViewModel()
    let config : SaveLocationViewModel
    
    var body: some View {
        VStack {
            LocationSearchResultView(viewModel: viewModel, config: .saveLocation(config.key))
        }
        .navigationTitle(config.subtitle)
        .searchable(text: $viewModel.queryFragment,
                    placement: .toolbar, 
                    prompt: Text("Search for a location.."))
       
    }
}

//#Preview {
//    NavigationStack {
//        SaveLocationSearchView()
//    }
//}
