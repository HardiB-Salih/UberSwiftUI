//
//  SaveLocationSearchView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import SwiftUI

struct SaveLocationSearchView: View {
    let userItem : UserItem
    @StateObject var viewModel : HomeViewModel
    let config : SaveLocationViewModel
    @Environment(\.dismiss) private var dismiss

    
    init(userItem: UserItem, config: SaveLocationViewModel) {
        self.userItem = userItem
        self.config = config
        self._viewModel = StateObject(wrappedValue: HomeViewModel(currentUser: userItem))
    }
    
    var body: some View {
        VStack {
            LocationSearchResultView(viewModel: viewModel, config: .saveLocation(config.key)) { result in
                print("The Location I cliked is \(result.title) and \(result.subtitle)")
                viewModel.queryFragment = ""
                dismiss()
            }
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
