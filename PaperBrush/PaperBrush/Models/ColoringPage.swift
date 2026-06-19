import Foundation

// CONTENT-001: Coloring page metadata loaded from bundled JSON
struct ColoringPage: Identifiable, Hashable {
    let id: String                    // e.g., "doodler-animals-happy-sun"
    let title: String
    let tier: AgeTier
    let category: ContentCategory
    let difficulty: Int               // 1–3
    let animationTemplateId: String
    let regionCount: Int              // number of fillable regions
    let strokeWeight: Float           // line thickness in points
    let isFree: Bool
    let isNew: Bool
    let svgPath: String               // path to SVG in bundle
    let packId: String?               // nil = base app, otherwise content pack ID

    /// SF Symbol placeholder until real SVG art is added
    var placeholderIcon: String {
        switch category {
        case .animals:  return "hare.fill"
        case .vehicles: return "car.fill"
        case .fantasy:  return "wand.and.stars"
        case .nature:   return "leaf.fill"
        case .holidays: return "gift.fill"
        case .patterns: return "circle.grid.3x3.fill"
        }
    }
}
