import Foundation

// GALLERY-001: Artwork model — the gallery representation of a saved canvas
struct Artwork: Identifiable, Hashable {
    let id: UUID
    let pageId: String
    let title: String
    let tier: AgeTier
    let category: ContentCategory
    var isCompleted: Bool
    var completionPercentage: Float
    let createdAt: Date
    var lastModified: Date
    let canvasDataPath: String
    let thumbnailPath: String
    var undoHistoryPath: String?
    var playerNames: [String]?       // parsed from comma-separated string in Core Data
    var animationTemplateId: String?
}
