import UIKit
import CoreData

// GALLERY-003: Persistence manager — Core Data for metadata, file system for canvas data
final class PersistenceManager: PersistenceManagerProtocol {
    static let shared = PersistenceManager()

    // MARK: - Core Data Stack

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PaperBrush")
        container.loadPersistentStores { _, error in
            if let error {
                // In production, handle gracefully. For development, crash to surface issues.
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    private var context: NSManagedObjectContext { persistentContainer.viewContext }

    // MARK: - File System Paths

    private var artworksDirectory: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent("artworks", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    private func artworkDirectory(for id: UUID) -> URL {
        let dir = artworksDirectory.appendingPathComponent(id.uuidString, isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    private func canvasDataURL(for id: UUID) -> URL {
        artworkDirectory(for: id).appendingPathComponent("canvas.pbdata")
    }

    private func thumbnailURL(for id: UUID) -> URL {
        artworkDirectory(for: id).appendingPathComponent("thumbnail.png")
    }

    private func undoHistoryURL(for id: UUID) -> URL {
        artworkDirectory(for: id).appendingPathComponent("undo_history.pbdata")
    }

    private func stampsURL(for id: UUID) -> URL {
        artworkDirectory(for: id).appendingPathComponent("stamps.json")
    }

    // MARK: - Artwork CRUD (Core Data)

    func saveArtwork(_ artwork: Artwork) async throws {
        try await context.perform { [context] in
            let entity = ArtworkEntity(context: context)
            entity.id = artwork.id
            entity.pageId = artwork.pageId
            entity.title = artwork.title
            entity.tier = artwork.tier.rawValue
            entity.category = artwork.category.rawValue
            entity.isCompleted = artwork.isCompleted
            entity.createdAt = artwork.createdAt
            entity.lastModified = artwork.lastModified
            entity.canvasDataPath = artwork.canvasDataPath
            entity.thumbnailPath = artwork.thumbnailPath
            entity.undoHistoryPath = artwork.undoHistoryPath
            entity.playerNames = artwork.playerNames?.joined(separator: ",")
            entity.animationTemplateId = artwork.animationTemplateId
            try context.save()
        }
    }

    func fetchArtworks() async throws -> [Artwork] {
        try await context.perform { [context] in
            let request = ArtworkEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
            let entities = try context.fetch(request)
            return entities.compactMap { self.artworkFromEntity($0) }
        }
    }

    func fetchArtwork(id: UUID) async throws -> Artwork? {
        try await context.perform { [context] in
            let request = ArtworkEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1
            let entity = try context.fetch(request).first
            return entity.flatMap { self.artworkFromEntity($0) }
        }
    }

    func deleteArtwork(id: UUID) async throws {
        try await context.perform { [context] in
            let request = ArtworkEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                try context.save()
            }
        }
        // Also delete files
        let dir = artworkDirectory(for: id)
        try? FileManager.default.removeItem(at: dir)
    }

    func updateArtwork(_ artwork: Artwork) async throws {
        try await context.perform { [context] in
            let request = ArtworkEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", artwork.id as CVarArg)
            if let entity = try context.fetch(request).first {
                entity.isCompleted = artwork.isCompleted
                entity.lastModified = artwork.lastModified
                entity.undoHistoryPath = artwork.undoHistoryPath
                entity.playerNames = artwork.playerNames?.joined(separator: ",")
                entity.animationTemplateId = artwork.animationTemplateId
                try context.save()
            }
        }
    }

    // MARK: - Canvas Data (File System)

    func saveCanvasData(_ data: Data, for artworkId: UUID) async throws {
        let url = canvasDataURL(for: artworkId)
        try data.write(to: url)
    }

    func loadCanvasData(for artworkId: UUID) async throws -> Data {
        let url = canvasDataURL(for: artworkId)
        return try Data(contentsOf: url)
    }

    func saveThumbnail(_ image: UIImage, for artworkId: UUID) async throws {
        guard let pngData = image.pngData() else {
            throw AppError.artworkSaveFailed
        }
        let url = thumbnailURL(for: artworkId)
        try pngData.write(to: url)
    }

    func loadThumbnail(for artworkId: UUID) async throws -> UIImage? {
        let url = thumbnailURL(for: artworkId)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return UIImage(data: data)
    }

    // MARK: - Stamps (JSON File)

    func saveStamps(_ stamps: [PlacedStamp], for artworkId: UUID) async throws {
        let data = try JSONEncoder().encode(stamps)
        let url = stampsURL(for: artworkId)
        try data.write(to: url)
    }

    func loadStamps(for artworkId: UUID) async throws -> [PlacedStamp] {
        let url = stampsURL(for: artworkId)
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([PlacedStamp].self, from: data)
    }

    // MARK: - Undo History

    func saveUndoHistory(_ data: Data, for artworkId: UUID) async throws {
        let url = undoHistoryURL(for: artworkId)
        try data.write(to: url)
    }

    func loadUndoHistory(for artworkId: UUID) async throws -> Data? {
        let url = undoHistoryURL(for: artworkId)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        return try Data(contentsOf: url)
    }

    // MARK: - Cleanup

    func cleanupExports() async {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let exportsDir = docs.appendingPathComponent("exports", isDirectory: true)
        try? FileManager.default.removeItem(at: exportsDir)
    }

    func totalStorageUsed() async -> Int64 {
        let dir = artworksDirectory
        guard let enumerator = FileManager.default.enumerator(at: dir, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }
        var total: Int64 = 0
        for case let fileURL as URL in enumerator {
            if let size = try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                total += Int64(size)
            }
        }
        return total
    }

    // MARK: - Entity Mapping

    private func artworkFromEntity(_ entity: ArtworkEntity) -> Artwork? {
        guard let id = entity.id,
              let pageId = entity.pageId,
              let title = entity.title,
              let tierStr = entity.tier,
              let categoryStr = entity.category,
              let createdAt = entity.createdAt,
              let lastModified = entity.lastModified else {
            return nil
        }
        // Use the renamed "doodler" for backwards compatibility
        let tier = AgeTier(rawValue: tierStr) ?? .explorer
        let category = ContentCategory(rawValue: categoryStr) ?? .animals

        return Artwork(
            id: id,
            pageId: pageId,
            title: title,
            tier: tier,
            category: category,
            isCompleted: entity.isCompleted,
            completionPercentage: 0,
            createdAt: createdAt,
            lastModified: lastModified,
            canvasDataPath: entity.canvasDataPath ?? "",
            thumbnailPath: entity.thumbnailPath ?? "",
            undoHistoryPath: entity.undoHistoryPath,
            playerNames: entity.playerNames?.components(separatedBy: ",").filter { !$0.isEmpty },
            animationTemplateId: entity.animationTemplateId
        )
    }
}
