import SwiftUI

extension PBTokens {
    enum Colors {
        // MARK: - Primary
        static let warmCream       = Color(hex: "FFF8F0")  // background
        static let softCanvas      = Color(hex: "FFFDF9")  // card surfaces
        static let richTeal        = Color(hex: "0EA5A0")  // primary action
        static let deepNavy        = Color(hex: "1B2A4A")  // text/headers
        static let sunsetCoral     = Color(hex: "F06449")  // accent/CTA

        // MARK: - Supporting
        static let honeyGold       = Color(hex: "F5A623")  // warnings/stars
        static let softSage        = Color(hex: "7CB686")  // success/confirm
        static let lavenderMist    = Color(hex: "B8A9E8")  // Creator tier
        static let skyBlue         = Color(hex: "6BB8E8")  // Explorer tier
        static let peachBlush      = Color(hex: "FCBFA0")  // Doodler tier
        static let softGraphite    = Color(hex: "666666")  // secondary text
        static let lightDivider    = Color(hex: "E8E0D8")  // borders/dividers

        // MARK: - Functional
        static let scrim           = Color(hex: "1B2A4A").opacity(0.5) // modal overlay

        /// Returns the accent color for an age tier
        static func tierAccent(_ tier: AgeTier) -> Color {
            switch tier {
            case .doodler:  return peachBlush
            case .explorer: return skyBlue
            case .creator:  return lavenderMist
            }
        }

        /// Returns the strong accent for an age tier (used for borders, highlights)
        static func tierStrongAccent(_ tier: AgeTier) -> Color {
            switch tier {
            case .doodler:  return sunsetCoral
            case .explorer: return richTeal
            case .creator:  return deepNavy
            }
        }
    }
}
