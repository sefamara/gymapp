import SwiftUI

/// Shared spacing/radius/typography tokens so every screen reads as one system
/// instead of ad-hoc numbers scattered across views.
enum Theme {
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
    }

    enum Radius {
        static let card: CGFloat = 24
        static let control: CGFloat = 16
    }
}
