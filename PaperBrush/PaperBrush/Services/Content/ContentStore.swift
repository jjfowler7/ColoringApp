import Foundation

// CONTENT-001: Provides bundled coloring page data for the Content Browser
final class ContentStore {
    static let shared = ContentStore()

    private let allPages: [ColoringPage]

    private init() {
        allPages = Self.generatePlaceholderPages()
    }

    // MARK: - Public API

    /// All pages for a given category, sorted by tier relevance
    func pages(for category: ContentCategory, tier: AgeTier) -> [ColoringPage] {
        allPages.filter { $0.category == category }
            .sorted { lhs, rhs in
                // Tier-matched pages first
                if lhs.tier == tier && rhs.tier != tier { return true }
                if lhs.tier != tier && rhs.tier == tier { return false }
                return lhs.title < rhs.title
            }
    }

    /// Pages matching the current tier (shown above the divider)
    func tierMatchedPages(for category: ContentCategory, tier: AgeTier) -> [ColoringPage] {
        allPages.filter { $0.category == category && $0.tier == tier }
    }

    /// Pages from other tiers (shown below the "More pages" divider)
    func otherTierPages(for category: ContentCategory, tier: AgeTier) -> [ColoringPage] {
        allPages.filter { $0.category == category && $0.tier != tier }
    }

    /// Find a specific page by ID
    func page(id: String) -> ColoringPage? {
        allPages.first { $0.id == id }
    }

    // MARK: - Placeholder Data (5-10 pages per category)

    private static func generatePlaceholderPages() -> [ColoringPage] {
        var pages: [ColoringPage] = []

        // Animals
        pages += [
            makePage("doodler-animals-happy-cat", "Happy Cat", .doodler, .animals, free: true, new: true),
            makePage("doodler-animals-puppy", "Playful Puppy", .doodler, .animals, free: true),
            makePage("explorer-animals-sea-turtle", "Sea Turtle", .explorer, .animals, free: true, new: true),
            makePage("explorer-animals-butterfly", "Butterfly Garden", .explorer, .animals, free: true),
            makePage("explorer-animals-owl", "Wise Owl", .explorer, .animals),
            makePage("creator-animals-horse", "Wild Horse", .creator, .animals, free: true),
            makePage("creator-animals-peacock", "Peacock Feathers", .creator, .animals),
            makePage("creator-animals-dolphin", "Dolphin Splash", .creator, .animals),
        ]

        // Vehicles
        pages += [
            makePage("doodler-vehicles-fire-truck", "Fire Truck", .doodler, .vehicles, free: true, new: true),
            makePage("doodler-vehicles-school-bus", "School Bus", .doodler, .vehicles, free: true),
            makePage("explorer-vehicles-rocket", "Rocket Ship", .explorer, .vehicles, free: true),
            makePage("explorer-vehicles-sailboat", "Sailboat", .explorer, .vehicles, free: true),
            makePage("explorer-vehicles-helicopter", "Helicopter", .explorer, .vehicles),
            makePage("creator-vehicles-steam-train", "Steam Train", .creator, .vehicles, free: true),
            makePage("creator-vehicles-submarine", "Submarine", .creator, .vehicles),
        ]

        // Fantasy
        pages += [
            makePage("doodler-fantasy-star", "Magic Star", .doodler, .fantasy, free: true),
            makePage("doodler-fantasy-rainbow", "Rainbow", .doodler, .fantasy, free: true, new: true),
            makePage("explorer-fantasy-dragon", "Friendly Dragon", .explorer, .fantasy, free: true),
            makePage("explorer-fantasy-unicorn", "Unicorn", .explorer, .fantasy, free: true),
            makePage("explorer-fantasy-castle", "Castle", .explorer, .fantasy),
            makePage("creator-fantasy-phoenix", "Phoenix Rising", .creator, .fantasy, free: true),
            makePage("creator-fantasy-wizard", "Wizard Tower", .creator, .fantasy),
        ]

        // Nature
        pages += [
            makePage("doodler-nature-flower", "Simple Flower", .doodler, .nature, free: true, new: true),
            makePage("doodler-nature-tree", "Big Tree", .doodler, .nature, free: true),
            makePage("explorer-nature-mountain", "Mountain Lake", .explorer, .nature, free: true),
            makePage("explorer-nature-garden", "Flower Garden", .explorer, .nature, free: true),
            makePage("explorer-nature-waterfall", "Waterfall", .explorer, .nature),
            makePage("creator-nature-coral-reef", "Coral Reef", .creator, .nature, free: true),
            makePage("creator-nature-forest", "Enchanted Forest", .creator, .nature),
        ]

        // Holidays
        pages += [
            makePage("doodler-holidays-pumpkin", "Pumpkin", .doodler, .holidays, free: true),
            makePage("doodler-holidays-snowman", "Snowman", .doodler, .holidays, free: true, new: true),
            makePage("explorer-holidays-christmas-tree", "Christmas Tree", .explorer, .holidays, free: true),
            makePage("explorer-holidays-easter-egg", "Easter Egg", .explorer, .holidays, free: true),
            makePage("explorer-holidays-fireworks", "Fireworks", .explorer, .holidays),
            makePage("creator-holidays-gingerbread", "Gingerbread House", .creator, .holidays, free: true),
            makePage("creator-holidays-lantern", "Lantern Festival", .creator, .holidays),
        ]

        // Patterns
        pages += [
            makePage("doodler-patterns-circles", "Circle Fun", .doodler, .patterns, free: true),
            makePage("doodler-patterns-zigzag", "Zigzag", .doodler, .patterns, free: true),
            makePage("explorer-patterns-mandala-simple", "Simple Mandala", .explorer, .patterns, free: true, new: true),
            makePage("explorer-patterns-mosaic", "Mosaic", .explorer, .patterns, free: true),
            makePage("explorer-patterns-waves", "Ocean Waves", .explorer, .patterns),
            makePage("creator-patterns-mandala", "Lotus Mandala", .creator, .patterns, free: true),
            makePage("creator-patterns-geometric", "Geometric Art", .creator, .patterns),
        ]

        return pages
    }

    private static func makePage(
        _ id: String, _ title: String, _ tier: AgeTier, _ category: ContentCategory,
        free: Bool = false, new: Bool = false
    ) -> ColoringPage {
        let difficulty: Int = {
            switch tier {
            case .doodler: return 1
            case .explorer: return 2
            case .creator: return 3
            }
        }()
        return ColoringPage(
            id: id,
            title: title,
            tier: tier,
            category: category,
            difficulty: difficulty,
            animationTemplateId: "\(category.rawValue)-default",
            regionCount: difficulty * 10,
            strokeWeight: tier == .doodler ? 4.0 : (tier == .explorer ? 2.5 : 1.5),
            isFree: free,
            isNew: new,
            svgPath: "", // placeholder — no real SVGs yet
            packId: nil
        )
    }
}
