//
//  Double.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import Foundation

extension Double {
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
        
    }
    
    func toCurrency() -> String {
        return currencyFormatter.string(from: self as NSNumber) ?? ""
    }
    
    
    
}
