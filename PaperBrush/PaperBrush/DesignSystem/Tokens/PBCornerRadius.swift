import SwiftUI

extension PBTokens {
    enum CornerRadius {
        static let xs:   CGFloat = 6     // badges, tags
        static let sm:   CGFloat = 10    // buttons, inputs
        static let md:   CGFloat = 16    // cards, dialogs
        static let lg:   CGFloat = 24    // panels, sheets
        static let xl:   CGFloat = 32    // featured cards
        static let full: CGFloat = 9999  // pills, circles (use with Capsule() when possible)
    }
}
