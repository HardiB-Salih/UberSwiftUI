//
//  LocationSearchActivationView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct LocationSearchActivationView: View {


    var body: some View {
        HStack {
            Rectangle()
                .fill(Color(.black))
                .frame(width: 8, height: 8)
                .padding(.horizontal)
            
            Text("Where to?")
                .foregroundStyle(Color(.systemGray))
            Spacer()
        }
        .padding(14)
//        .frame(width: UIScreen.main.bounds.width - 60, height: 44)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 20)

        

    }
}

#Preview {
    LocationSearchActivationView()
}
