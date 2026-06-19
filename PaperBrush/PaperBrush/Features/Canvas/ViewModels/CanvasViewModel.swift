import SwiftUI
import Combine
import PencilKit

// BRUSH-001, GALLERY-003: ViewModel for the canvas screen (PencilKit-based)
final class CanvasViewModel: @preconcurrency ObservableObject {

    // MARK: - Published State
    @Published var currentUIColor: UIColor = .black
    @Published var selectedColorIndex: Int = 22
    @Published var currentBrushSize: CGFloat = 12.0
    @Published var currentBrushType: BrushType = .crayon
    @Published var canUndo: Bool = false
    @Published var canRedo: Bool = false
    @Published var isMuted: Bool = UserPreferences.shared.isMuted
    @Published var showOverflowMenu: Bool = false
    @Published var showSaveToast: Bool = false

    // MARK: - Stamp State
    @Published var selectedStampShape: StampShape = .star
    @Published var showStampPicker: Bool = false

    // MARK: - Color Picker State (COLOR-002)
    @Published var showColorPicker: Bool = false

    @Published var placedStamps: [PlacedStamp] = []

    // MARK: - Persistence State (GALLERY-003)
    var currentArtworkId: UUID?
    private var autoSaveTask: Task<Void, Never>?
    private var backgroundObserver: Any?
    private let persistence: PersistenceManagerProtocol

    // MARK: - Mode
    var isStampMode: Bool { currentBrushType == .stamp }
    var isEraser: Bool { currentBrushType == .eraser }

    // MARK: - PencilKit Bridge
    let canvasViewProvider = CanvasViewProvider()

    // MARK: - Page Info
    private(set) var pageId: String?
    let resumeArtworkId: UUID?

    /// Display title for the canvas toolbar — looks up from ContentStore, falls back to pageId
    var pageTitle: String {
        if let pageId, let page = ContentStore.shared.page(id: pageId) {
            return page.title
        }
        return pageId ?? "Canvas"
    }

    init(pageId: String? = nil, resumeArtworkId: UUID? = nil,
         persistence: PersistenceManagerProtocol = PersistenceManager.shared) {
        self.pageId = pageId
        self.resumeArtworkId = resumeArtworkId
        self.persistence = persistence

        // If resuming, set the artwork ID
        if let resumeId = resumeArtworkId {
            self.currentArtworkId = resumeId
        }

        // Listen for app going to background to trigger save
        backgroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            Task { await self.saveCanvas() }
        }
    }

    deinit {
        autoSaveTask?.cancel()
        if let observer = backgroundObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // MARK: - PencilKit Tool Mapping

    var pkInkType: PKInkingTool.InkType {
        switch currentBrushType {
        case .crayon:
            if #available(iOS 17.0, *) { return .crayon } else { return .pen }
        case .marker:     return .marker
        case .watercolor:
            if #available(iOS 17.0, *) { return .watercolor } else { return .pen }
        case .pencil:     return .pencil
        case .stamp:      return .pen
        case .eraser:     return .pen
        }
    }

    var uiColor: UIColor { currentUIColor }

    func selectColor(uiColor: UIColor, index: Int) {
        currentUIColor = uiColor
        selectedColorIndex = index
    }

    /// Applies a custom color from the picker (COLOR-002).
    func applyCustomColor(_ uiColor: UIColor) {
        currentUIColor = uiColor
        selectedColorIndex = -1
    }

    // MARK: - Stamp Actions

    func placeStamp(at position: CGPoint) {
        let stamp = PlacedStamp(
            shape: selectedStampShape,
            position: position,
            size: currentBrushSize * 2,
            color: currentUIColor
        )
        placedStamps.append(stamp)
    }

    func eraseStamp(id: UUID) {
        placedStamps.removeAll { $0.id == id }
    }

    // MARK: - Undo/Redo

    func undo() {
        if !placedStamps.isEmpty && currentBrushType == .stamp {
            placedStamps.removeLast()
        } else {
            canvasViewProvider.undo()
        }
    }

    func redo() {
        canvasViewProvider.redo()
    }

    func toggleMute() {
        isMuted.toggle()
        UserPreferences.shared.isMuted = isMuted
    }

    // MARK: - Persistence (GALLERY-003)

    /// Start the 30-second auto-save timer
    func startAutoSave() {
        autoSaveTask?.cancel()
        autoSaveTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 30_000_000_000) // 30 seconds
                guard !Task.isCancelled else { break }
                await self?.saveCanvas()
            }
        }
    }

    /// Save current canvas state (PKDrawing + stamps + thumbnail + metadata)
    func saveCanvas() async {
        guard let drawingData = canvasViewProvider.getDrawingData() else { return }

        // Create or reuse artwork ID
        let artworkId: UUID
        if let existing = currentArtworkId {
            artworkId = existing
        } else {
            artworkId = UUID()
            currentArtworkId = artworkId
        }

        // Save canvas drawing data
        do {
            try await persistence.saveCanvasData(drawingData, for: artworkId)
        } catch {
            print("[Save] Failed to save canvas data: \(error)")
            return
        }

        // Save stamps
        if !placedStamps.isEmpty {
            do {
                if let pm = persistence as? PersistenceManager {
                    try await pm.saveStamps(placedStamps, for: artworkId)
                }
            } catch {
                print("[Save] Failed to save stamps: \(error)")
            }
        }

        // Generate and save thumbnail
        if let thumbnail = canvasViewProvider.generateThumbnail() {
            try? await persistence.saveThumbnail(thumbnail, for: artworkId)
        }

        // Save or update artwork metadata in Core Data
        let tier = UserPreferences.shared.selectedTier
        let artwork = Artwork(
            id: artworkId,
            pageId: pageId ?? "unknown",
            title: pageId ?? "Untitled",
            tier: tier,
            category: .animals, // placeholder — real category comes from content browser
            isCompleted: false,
            completionPercentage: 0,
            createdAt: Date(), // Will be overwritten if updating
            lastModified: Date(),
            canvasDataPath: "artworks/\(artworkId.uuidString)/canvas.pbdata",
            thumbnailPath: "artworks/\(artworkId.uuidString)/thumbnail.png"
        )

        do {
            // Check if artwork already exists
            if let _ = try await persistence.fetchArtwork(id: artworkId) {
                try await persistence.updateArtwork(artwork)
            } else {
                try await persistence.saveArtwork(artwork)
            }
        } catch {
            print("[Save] Failed to save artwork metadata: \(error)")
        }

        // Store as in-progress for session resume
        UserPreferences.shared.inProgressArtworkId = artworkId
    }

    /// Manual "Save to Gallery" action from overflow menu
    func saveToGallery() {
        Task {
            await saveCanvas()
            await MainActor.run {
                showSaveToast = true
            }
            // Auto-dismiss toast after 2 seconds
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await MainActor.run {
                showSaveToast = false
            }
        }
    }

    /// Attempts to load a saved canvas — checks resume ID first, then looks for
    /// an existing artwork matching this pageId
    func loadCanvasIfAvailable() async {
        // If we already have an artwork ID (from explicit resume), load it directly
        if let artworkId = currentArtworkId ?? resumeArtworkId {
            self.currentArtworkId = artworkId
            // Resolve pageId from saved artwork metadata if not already set
            if pageId == nil {
                if let artwork = try? await persistence.fetchArtwork(id: artworkId) {
                    await MainActor.run { self.pageId = artwork.pageId }
                }
            }
            await loadCanvasData(for: artworkId)
            return
        }

        // Otherwise, check if there's a saved artwork for this pageId
        guard let pageId else { return }
        do {
            let allArtworks = try await persistence.fetchArtworks()
            if let existing = allArtworks.first(where: { $0.pageId == pageId }) {
                self.currentArtworkId = existing.id
                await loadCanvasData(for: existing.id)
            }
        } catch {
            print("[Load] Failed to search for existing artwork: \(error)")
        }
    }

    /// Load drawing data and stamps for a specific artwork ID
    private func loadCanvasData(for artworkId: UUID) async {
        // Load drawing data
        do {
            let data = try await persistence.loadCanvasData(for: artworkId)
            await MainActor.run {
                canvasViewProvider.setDrawing(from: data)
            }
        } catch {
            print("[Load] No saved canvas data for \(artworkId): \(error)")
        }

        // Load stamps
        do {
            if let pm = persistence as? PersistenceManager {
                let stamps = try await pm.loadStamps(for: artworkId)
                await MainActor.run {
                    placedStamps = stamps
                }
            }
        } catch {
            print("[Load] Failed to load stamps: \(error)")
        }
    }
}
