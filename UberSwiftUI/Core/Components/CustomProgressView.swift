//
//  CustomProgressView.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/9/24.
//

import SwiftUI

/// A view that displays a customizable progress indicator with an optional text label.
///
/// The `CustomProgressView` presents a circular `ProgressView` along with an optional
/// text label below it. This view is intended to be used as an overlay during loading
/// or processing states.
///
/// Example usage:
/// ```swift
/// import SwiftUI
///
/// struct SomeView: View {
///     @State private var isLoading: Bool = false
///
///     var body: some View {
///         ZStack {
///             // Your main content goes here
///
///             // Show the CustomProgressView when isLoading is true
///             if isLoading {
///                 CustomProgressView(text: "Uploading")
///                     .transition(.asymmetric(
///                         insertion: .opacity.combined(with: .offset(y: 10)),
///                         removal: .opacity.combined(with: .offset(y: -10))
///                     ))
///                     .zIndex(1) // Ensure it appears on top of other content
///             }
///         }
///         .animation(.easeInOut, value: isLoading)
///     }
/// }
/// ```
///
/// - Parameters:
///   - text: An optional text string to be displayed below the progress indicator.
struct CustomProgressView: View {
    let text: String?
    @Environment(\.colorScheme) private var colorScheme
    
    init(text: String? = nil) {
        self.text = text
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            ProgressView()
                .progressViewStyle(.circular)
                .imageScale(.large)
            
            if let text = text {
                Text(text)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
        .padding(12)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .overlay(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color(colorScheme == .dark ? .systemBackground : .systemGray6))
                            .frame(width: max(80, geometry.size.width), height: max(80, geometry.size.width))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .stroke(Color(.systemGray4), lineWidth: 1.0)
                            )
                    )
            }
        )
    }
}

#Preview {
    ZStack {
        CustomProgressView(text: nil)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
           
    }
    .background(Color.theme.backgroundColor)
    
}

