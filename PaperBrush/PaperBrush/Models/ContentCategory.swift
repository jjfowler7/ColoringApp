import Foundation

enum ContentCategory: String, CaseIterable, Codable, Hashable {
    case animals   = "animals"
    case vehicles  = "vehicles"
    case fantasy   = "fantasy"
    case nature    = "nature"
    case holidays  = "holidays"
    case patterns  = "patterns"

    var displayName: String {
        switch self {
        case .animals:  return "Animals"
        case .vehicles: return "Vehicles"
        case .fantasy:  return "Fantasy"
        case .nature:   return "Nature"
        case .holidays: return "Holidays"
        case .patterns: return "Patterns"
        }
    }

    /// Asset name for the category icon (to be added to Assets.xcassets)
    var iconName: String {
        switch self {
        case .animals:  return "icon-category-animals"
        case .vehicles: return "icon-category-vehicles"
        case .fantasy:  return "icon-category-fantasy"
        case .nature:   return "icon-category-nature"
        case .holidays: return "icon-category-holidays"
        case .patterns: return "icon-category-patterns"
        }
    }
}
