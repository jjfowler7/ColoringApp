import SwiftUI

extension PBTokens {
    enum Spacing {
        static let xs:   CGFloat = 4    // icon internal padding
        static let sm:   CGFloat = 8    // between related elements
        static let md:   CGFloat = 16   // component internal padding
        static let lg:   CGFloat = 24   // between sections
        static let xl:   CGFloat = 32   // screen margins iPhone
        static let xxl:  CGFloat = 48   // screen margins iPad
        static let xxxl: CGFloat = 64   // major section separation

        /// Returns the appropriate horizontal screen margin for the device type
        static func screenMargin(isIPad: Bool) -> CGFloat {
            isIPad ? xxl : md
        }
    }
}
