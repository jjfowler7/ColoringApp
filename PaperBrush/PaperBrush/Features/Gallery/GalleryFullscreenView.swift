import SwiftUI
import UIKit

// GALLERY-001: Gallery fullscreen viewer — Screen 07 per design spec §2.5.2
struct GalleryFullscreenView: View {
    let artworkId: UUID

    @EnvironmentObject private var router: AppRouter
    @State private var artworks: [Artwork] = []
    @State private var thumbnails: [UUID: UIImage] = [:]
    @State private var currentIndex: Int = 0
    @State private var isLoading = true

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            if isLoading {
                ProgressView()
            } else if artworks.isEmpty {
                Text("Artwork not found")
                    .foregroundColor(PBTokens.Colors.softGraphite)
            } else {
                artworkPager
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .task { await loadArtworks() }
    }

    // MARK: - Artwork Pager (horizontal TabView for swipe)

    private var artworkPager: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(Array(artworks.enumerated()), id: \.offset) { index, artwork in
                    artworkPage(for: artwork)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            // Overlaid controls — sit on top of all pages
            if !artworks.isEmpty {
                let artwork = artworks[currentIndex]

                // Top bar (semi-transparent, navy 40%)
                VStack {
                    topBar(for: artwork)
                    Spacer()
                }
                .ignoresSafeArea(edges: .top)

                // Bottom info strip
                VStack {
                    Spacer()
                    bottomInfoStrip(for: artwork)
                }
                .ignoresSafeArea(edges: .bottom)

                // Swipe hint chevrons — visible when multiple artworks
                if artworks.count > 1 {
                    swipeHints
                }
            }
        }
    }

    // MARK: - Single Artwork Page

    private func artworkPage(for artwork: Artwork) -> some View {
        ZStack {
            Color.white

            if let image = thumbnails[artwork.id] {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding(24)
            } else {
                // Placeholder while thumbnail loads
                ZStack {
                    RoundedRectangle(cornerRadius: PBTokens.CornerRadius.md)
                        .fill(PBTokens.Colors.warmCream)
                        .padding(24)
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundColor(PBTokens.Colors.lightDivider)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Top Bar (overlaid, semi-transparent)

    private func topBar(for artwork: Artwork) -> some View {
        HStack(spacing: 0) {
            // ✕ Close
            Button {
                router.pop()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .padding(.leading, PBTokens.Spacing.sm)
            }
            .accessibilityLabel("Close")

            Spacer()

            // ↻ Replay (completed only — Sprint 3.4)
            Button {
                // Sprint 3.4 — replay celebration
            } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Replay celebration")
            .opacity(artwork.isCompleted ? 1 : 0.4)
            .disabled(!artwork.isCompleted)

            // 📤 Share
            Button {
                shareArtwork(artwork)
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Share artwork")

            // 🖨 Print — Sprint 5.1
            Button {
                // Sprint 5.1 — PDF export
            } label: {
                Image(systemName: "printer")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .padding(.trailing, PBTokens.Spacing.xs)
            }
            .accessibilityLabel("Print artwork")
        }
        .frame(height: 44)
        .background(
            // Semi-transparent navy overlay per mockup
            Color(red: 0.106, green: 0.165, blue: 0.290)
                .opacity(0.40)
                .background(.ultraThinMaterial)
        )
        // Add safe area padding on top
        .padding(.top, safeAreaTopInset)
    }

    // MARK: - Bottom Info Strip

    private func bottomInfoStrip(for artwork: Artwork) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Gradient from transparent → Warm Cream
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: PBTokens.Colors.warmCream.opacity(0.70), location: 0.30),
                    .init(color: PBTokens.Colors.warmCream.opacity(0.96), location: 0.60),
                    .init(color: PBTokens.Colors.warmCream, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 120)
            .overlay(alignment: .bottomLeading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(artwork.title)
                            .font(PBTokens.Typography.nunito(.bold, size: 18))
                            .foregroundColor(PBTokens.Colors.deepNavy)

                        Text(metadataString(for: artwork))
                            .font(PBTokens.Typography.nunitoSans(.regular, size: 13))
                            .foregroundColor(PBTokens.Colors.softGraphite)

                        // Status
                        HStack(spacing: 6) {
                            Circle()
                                .fill(artwork.isCompleted ? PBTokens.Colors.softSage : PBTokens.Colors.richTeal)
                                .frame(width: 8, height: 8)
                            Text(artwork.isCompleted ? "Completed" : "In Progress")
                                .font(PBTokens.Typography.nunitoSans(.semibold, size: 13))
                                .foregroundColor(PBTokens.Colors.softGraphite)
                        }
                    }

                    Spacer()

                    // "Continue Coloring" button — in-progress only
                    if !artwork.isCompleted {
                        Button {
                            router.push(.canvasResume(artworkId: artwork.id))
                        } label: {
                            Text("Continue Coloring")
                                .font(PBTokens.Typography.nunito(.bold, size: 14))
                                .foregroundColor(.white)
                                .padding(.horizontal, PBTokens.Spacing.md)
                                .frame(height: 40)
                                .background(PBTokens.Colors.richTeal)
                                .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.sm))
                        }
                        .accessibilityLabel("Continue coloring \(artwork.title)")
                    }
                }
                .padding(.horizontal, PBTokens.Spacing.lg)
                .padding(.bottom, safeAreaBottomInset + PBTokens.Spacing.lg)
            }
        }
    }

    // MARK: - Swipe Hints

    private var swipeHints: some View {
        HStack {
            if currentIndex > 0 {
                swipeChevron(direction: .left)
            }
            Spacer()
            if currentIndex < artworks.count - 1 {
                swipeChevron(direction: .right)
            }
        }
        .allowsHitTesting(false)
    }

    private func swipeChevron(direction: ChevronDirection) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 999)
                .fill(Color(red: 0.106, green: 0.165, blue: 0.290).opacity(0.38))
                .background(.ultraThinMaterial.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 999))
                .frame(width: 36, height: 64)

            Image(systemName: direction == .left ? "chevron.left" : "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))
        }
        .padding(.horizontal, 10)
    }

    private enum ChevronDirection { case left, right }

    // MARK: - Data Loading

    private func loadArtworks() async {
        do {
            let all = try await PersistenceManager.shared.fetchArtworks()
            artworks = all
            // Set current index to the requested artwork
            if let idx = artworks.firstIndex(where: { $0.id == artworkId }) {
                currentIndex = idx
            }
        } catch {
            print("[GalleryFullscreen] Failed to load artworks: \(error)")
        }
        isLoading = false

        // Load thumbnails
        for artwork in artworks {
            if let image = try? await PersistenceManager.shared.loadThumbnail(for: artwork.id) {
                thumbnails[artwork.id] = image
            }
        }
    }

    // MARK: - Helpers

    private func metadataString(for artwork: Artwork) -> String {
        let tierName = artwork.tier.displayName
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return "\(tierName) tier · \(formatter.string(from: artwork.lastModified))"
    }

    private func shareArtwork(_ artwork: Artwork) {
        guard let thumbnail = thumbnails[artwork.id] else { return }
        let activityVC = UIActivityViewController(
            activityItems: [thumbnail],
            applicationActivities: nil
        )
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            // iPad requires a sourceView anchor to avoid popover crash
            activityVC.popoverPresentationController?.sourceView = window
            activityVC.popoverPresentationController?.sourceRect = CGRect(
                x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0
            )
            activityVC.popoverPresentationController?.permittedArrowDirections = []
            rootVC.present(activityVC, animated: true)
        }
    }

    // MARK: - Safe Area

    private var safeAreaTopInset: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first?.safeAreaInsets.top ?? 44
    }

    private var safeAreaBottomInset: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first?.safeAreaInsets.bottom ?? 34
    }
}
