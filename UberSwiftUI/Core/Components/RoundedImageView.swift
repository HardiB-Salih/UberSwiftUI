//
//  RoundedImageView.swift
//  InstagramSwiftUI
//
//  Created by HardiB.Salih on 6/5/24.
//
// Kingfisher || https://github.com/onevcat/Kingfisher

import SwiftUI
import Kingfisher

struct RoundedImageView: View {
    //MARK: - Properties
    var profileImageUrl : String?
    var size: Size
    var shape: ImageShape
    var fallbackImage: String = "person.fill"
    var backgroundColor: UIColor = .systemGray6
    
    //MARK: - Computed Properties
    var cornerRadius : CGFloat {
        switch shape {
        case .rounded(let cornerRadius):
            return cornerRadius
        case .circle:
            return size.dimension / 2
        }
    }
    
    //MARK: - INIT
    init(_ profileImageUrl: String? = nil,
         size: Size,
         shape: ImageShape, fallbackImage: String = "person.fill",
         backgroundColor: UIColor = .systemGray6) {
        self.profileImageUrl = profileImageUrl
        self.size = size
        self.shape = shape
        self.fallbackImage = fallbackImage
        self.backgroundColor = backgroundColor
    }
    
    //MARK: - View
    var body: some View {
        if let profileImageUrl {
            KFImage(URL(string: profileImageUrl))
                .resizable()
                .placeholder({ ProgressView() })
                .scaledToFill()
                .background(Color(backgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .frame(width: size.dimension, height: size.dimension)
        } else {
            placeholderImageView()
        }
    }
    
    private func placeholderImageView() -> some View {
        ZStack {
            Color(.systemGray3)

            Image(systemName: fallbackImage)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .padding(8)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .frame(width: size.dimension, height: size.dimension)
        
        
    }
}
//MARK: - Preview
#Preview {
    RoundedImageView(size: .small, shape: .rounded(cornerRadius: 12))
}


//MARK: - ImageShape
enum ImageShape {
    case rounded(cornerRadius: CGFloat)
    case circle
}


// MARK: - Size

/**
 An enum representing different sizes with predefined and custom options.
 */
enum Size {
    /// Extra extra small size (30)
    case xxSmall
    /// Extra small size (40)
    case xSmall
    /// Small size (50)
    case small
    /// Medium size (60)
    case medium
    /// Large size (80)
    case large
    /// Extra large size (100)
    case xLarge
    /// Extra extra large size (120)
    case xxLarge
    /// Custom size with a specified value
    case custom(CGFloat)
    
    
    // MARK: - Computed Properties for Flexible Sizing
    
    /**
     The dimension value associated with the size.
     
     - Returns: A `CGFloat` representing the size's dimension.
     */
    var dimension: CGFloat {
        switch self {
        case .xxSmall:
            return SizeDimensions.xxSmall
        case .xSmall:
            return SizeDimensions.xSmall
        case .small:
            return SizeDimensions.small
        case .medium:
            return SizeDimensions.medium
        case .large:
            return SizeDimensions.large
        case .xLarge:
            return SizeDimensions.xLarge
        case .xxLarge:
            return SizeDimensions.xxLarge
        case .custom(let size):
            return size
        }
    }
}

// MARK: - SizeDimensions

/**
 A struct containing predefined dimension values for the `Size` enum.
 */
private struct SizeDimensions {
    /// Dimension for extra extra small size (30)
    static let xxSmall: CGFloat = 30
    /// Dimension for extra small size (40)
    static let xSmall: CGFloat = 40
    /// Dimension for small size (50)
    static let small: CGFloat = 50
    /// Dimension for medium size (60)
    static let medium: CGFloat = 60
    /// Dimension for large size (80)
    static let large: CGFloat = 80
    /// Dimension for extra large size (100)
    static let xLarge: CGFloat = 100
    /// Dimension for extra extra large size (120)
    static let xxLarge: CGFloat = 120
}

extension String {
    static let placeholderImageUrl = "https://i.ibb.co/PWpShpY/profile-pic.png"

}
