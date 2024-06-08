//
//  LocationSearchResultCell.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title: String
    let subTitle: String
    
    var body: some View {
        HStack (alignment: .top , spacing: 12){
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundStyle(Color(.systemBlue))
                .tint(.white)
                .frame(width: 40, height: 40)
            
            VStack (alignment : .leading) {
                Text(title)
                    .font(.headline)
                
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundStyle(Color(.systemGray))
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    LocationSearchResultCell(title: "Coffee", subTitle: "123 Main Street")
}
