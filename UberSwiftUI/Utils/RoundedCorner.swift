//
//  RoundedCorner.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    var style: RoundedCornerStyle = .continuous
    
    func path(in rect: CGRect) -> Path {
        let path: UIBezierPath
        switch style {
        case .circular:
            path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        case .continuous:
            let continuousPath = UIBezierPath()
            let rectPath = CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil)
            continuousPath.cgPath = rectPath
            path = continuousPath
        }
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner, style: RoundedCornerStyle = .continuous) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners, style: style))
    }
    
    func glow(color: Color = .red, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
            .shadow(color: color, radius: radius / 3)
    }
}

