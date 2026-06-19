import Foundation

// ONBOARD-001: Age tier selection drives UI complexity throughout the app
enum AgeTier: String, CaseIterable, Codable, Hashable {
    case doodler  = "doodler"
    case explorer = "explorer"
    case creator  = "creator"

    var displayName: String {
        switch self {
        case .doodler:  return "Doodler"
        case .explorer: return "Explorer"
        case .creator:  return "Creator"
        }
    }

    var ageRange: String {
        switch self {
        case .doodler:  return "Ages 3–5"
        case .explorer: return "Ages 6–8"
        case .creator:  return "Ages 9–12"
        }
    }

    var tagline: String {
        switch self {
        case .doodler:  return "Big shapes & bold colors"
        case .explorer: return "More detail & cool tools"
        case .creator:  return "Fine art & custom colors"
        }
    }

    /// Number of brushes shown for this tier
    var brushCount: Int {
        switch self {
        case .doodler: return 4
        case .explorer, .creator: return 8
        }
    }

    /// Whether the custom color picker (+) button is available
    var hasCustomColorPicker: Bool {
        self != .doodler
    }

    /// Whether hex code input is shown in the color picker
    var hasHexInput: Bool {
        self == .creator
    }

    /// SF Symbol icon name for onboarding cards
    var iconName: String {
        switch self {
        case .doodler:  return "crayon.fill"
        case .explorer: return "paintpalette.fill"
        case .creator:  return "pencil.and.ruler.fill"
        }
    }
}
