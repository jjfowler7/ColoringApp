import SwiftUI

/// The main NavigationStack that hosts all push-based navigation.
/// Content Browser is the root screen (no back button).
struct MainNavigationView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            ContentBrowserView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .contentBrowser:
                        ContentBrowserView()

                    case .canvas(let pageId):
                        CanvasContainerView(pageId: pageId)

                    case .canvasResume(let artworkId):
                        CanvasContainerView(resumeArtworkId: artworkId)

                    case .gallery:
                        GalleryGridView()

                    case .galleryFullscreen(let artworkId):
                        GalleryFullscreenView(artworkId: artworkId)

                    case .packStore:
                        PackStoreView()

                    case .settings:
                        SettingsView()
                    }
                }
        }
    }
}
