import UIKit

/// Protocol for artwork persistence (Core Data + file system).
/// Real implementation: PersistenceManager.shared. Tests inject mocks.
protocol PersistenceManagerProtocol {
    // Artworks (Core Data)
    func saveArtwork(_ artwork: Artwork) async throws
    func fetchArtworks() async throws -> [Artwork]
    func fetchArtwork(id: UUID) async throws -> Artwork?
    func deleteArtwork(id: UUID) async throws
    func updateArtwork(_ artwork: Artwork) async throws

    // Canvas data (file system)
    func saveCanvasData(_ data: Data, for artworkId: UUID) async throws
    func loadCanvasData(for artworkId: UUID) async throws -> Data
    func saveThumbnail(_ image: UIImage, for artworkId: UUID) async throws
    func loadThumbnail(for artworkId: UUID) async throws -> UIImage?

    // Undo history
    func saveUndoHistory(_ data: Data, for artworkId: UUID) async throws
    func loadUndoHistory(for artworkId: UUID) async throws -> Data?

    // Cleanup
    func cleanupExports() async
    func totalStorageUsed() async -> Int64
}
