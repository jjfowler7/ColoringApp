import SwiftUI

extension PBTokens {
    enum Animation {
        // MARK: - Duration-Based
        static let instant:    SwiftUI.Animation = .easeOut(duration: 0.1)
        static let quick:      SwiftUI.Animation = .easeOut(duration: 0.2)
        static let standard:   SwiftUI.Animation = .easeInOut(duration: 0.3)
        static let expressive: SwiftUI.Animation = .easeOut(duration: 0.5)
        static let dramatic:   SwiftUI.Animation = .easeOut(duration: 0.8)

        // MARK: - Spring-Based
        static let spring:      SwiftUI.Animation = .spring(response: 0.3, dampingFraction: 0.7)
        static let celebration: SwiftUI.Animation = .spring(response: 0.5, dampingFraction: 0.5)

        // MARK: - Button Press
        static let pressDown:  SwiftUI.Animation = .easeOut(duration: 0.05)
        static let pressUp:    SwiftUI.Animation = .spring(response: 0.2, dampingFraction: 0.6)
    }
}
