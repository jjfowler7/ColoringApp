import SwiftUI

extension PBTokens {
    enum Typography {
        // MARK: - Font Families

        /// Nunito font with specified weight. Used for headers and emphasis.
        static func nunito(_ weight: Font.Weight, size: CGFloat) -> Font {
            switch weight {
            case .bold:      return .custom("Nunito-Bold", size: size)
            case .heavy:     return .custom("Nunito-ExtraBold", size: size)
            case .semibold:  return .custom("Nunito-SemiBold", size: size)
            default:         return .custom("Nunito-Regular", size: size)
            }
        }

        /// Nunito Sans font with specified weight. Used for body text.
        /// Uses a variable font file, so weight is applied via SwiftUI's .weight() modifier.
        static func nunitoSans(_ weight: Font.Weight, size: CGFloat) -> Font {
            .custom("Nunito Sans", size: size).weight(weight)
        }

        // MARK: - Semantic Styles (iPhone sizes — iPad sizes applied via layout modifiers)
        static let heroTitle       = nunito(.heavy, size: 36)       // iPad: 52pt
        static let screenHeader    = nunito(.bold, size: 24)        // iPad: 32pt
        static let sectionHeader   = nunito(.bold, size: 18)        // iPad: 24pt
        static let buttonLabel     = nunito(.bold, size: 16)        // iPad: 18pt
        static let body            = nunitoSans(.regular, size: 15) // iPad: 17pt
        static let caption         = nunitoSans(.regular, size: 12) // iPad: 14pt
        static let badge           = nunito(.bold, size: 10)        // iPad: 12pt

        // MARK: - Specific Use Cases
        static let dialogTitle     = nunito(.bold, size: 22)
        static let dialogBody      = nunitoSans(.semibold, size: 18)
        static let toastText       = nunitoSans(.semibold, size: 14)
        static let reassurance     = nunitoSans(.regular, size: 13)
    }
}
