import Foundation

// BRUSH-001: All brush types available in the canvas
enum BrushType: String, CaseIterable, Codable, Hashable {
    case crayon
    case marker
    case watercolor
    case pencil
    case stamp
    case eraser
    // Spray, glitter, and fill deferred to post-launch

    var displayName: String {
        rawValue.capitalized
    }

    var iconName: String {
        "icon-brush-\(rawValue)"
    }

    /// Brushes available in Doodler tier (ages 3–5)
    static var doodlerBrushes: [BrushType] {
        [.crayon, .marker, .stamp, .eraser]
    }

    /// Default brush size in points
    var defaultSize: CGFloat {
        switch self {
        case .crayon:     return 12
        case .marker:     return 16
        case .watercolor: return 20
        case .pencil:     return 4
        case .stamp:      return 32
        case .eraser:     return 16
        }
    }
}
