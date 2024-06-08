//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var showLocationSearchView : Bool
    
    var body: some View {
        Button(action: {
            if showLocationSearchView {
                withAnimation (.spring()) {
                    showLocationSearchView.toggle()
                }
            }
            
            
        }, label: {
            Image(systemName: showLocationSearchView ? "arrow.left" : "line.3.horizontal")
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
}

#Preview {
    MapViewActionButton(showLocationSearchView: .constant(false))
}
