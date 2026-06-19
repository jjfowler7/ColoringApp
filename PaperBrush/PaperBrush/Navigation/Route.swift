import Foundation

/// All push-navigation destinations in PaperBrush.
/// Modals (sheets, fullScreenCovers) are managed by AppRouter's @Published booleans.
enum Route: Hashable {
    // Main flow
    case contentBrowser
    case canvas(pageId: String)
    case canvasResume(artworkId: UUID)

    // Gallery
    case gallery
    case galleryFullscreen(artworkId: UUID)

    // Store
    case packStore

    // Settings (always preceded by parental gate)
    case settings
}
