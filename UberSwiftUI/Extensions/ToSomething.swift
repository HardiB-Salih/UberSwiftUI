//
//  ToSomething.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import Foundation

extension String {
    var isNotEmpty: Bool { return !self.isEmpty }
    var isNotEmptyAndWhiteSpace: Bool {
        return !self.isEmpty && !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isEmptyAndWhiteSpace: Bool {
        return self.isEmpty && !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func toInt() -> Int? { return Int(self) }
    func toDouble() -> Double? { return Double(self) }
    func toFloat() -> Float? { return Float(self) }
    func toBool() -> Bool? { return Bool(self) }

    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

extension Int {
    func toString() -> String { return String(self) }
    func toDouble() -> Double { return Double(self) }
    func toFloat() -> Float { return Float(self) }
    func toInt32() -> Int32 { return Int32(self) }
    func toInt64() -> Int64 { return Int64(self) }
}

extension Int32 {
    func toString() -> String { return String(self) }
    func toDouble() -> Double { return Double(self) }
    func toFloat() -> Float { return Float(self) }
    func toInt() -> Int { return Int(self) }
    func toInt64() -> Int64 { return Int64(self) }
}

extension Int64 {
    func toString() -> String { return String(self) }
    func toDouble() -> Double { return Double(self) }
    func toFloat() -> Float { return Float(self) }
    func toInt() -> Int { return Int(self) }
    func toInt32() -> Int32 { return Int32(self) }
}

extension Double {
    func toString() -> String { return String(self) }
    func toInt() -> Int { return Int(self) }
    func toFloat() -> Float { return Float(self) }
    func toInt32() -> Int32 { return Int32(self) }
    func toInt64() -> Int64 { return Int64(self) }
}

extension Float {
    func toString() -> String { return String(self) }
    func toInt() -> Int { return Int(self) }
    func toDouble() -> Double { return Double(self) }
    func toInt32() -> Int32 { return Int32(self) }
    func toInt64() -> Int64 { return Int64(self) }
}

extension Bool {
    func toString() -> String { return String(self) }
}

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension Array {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}
