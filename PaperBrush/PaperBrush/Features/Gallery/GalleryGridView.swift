import SwiftUI
import UIKit
import Combine

// GALLERY-001: Gallery grid — Screen 06 per design spec §2.5.1
@MainActor
final class GalleryViewModel: @preconcurrency ObservableObject {
    @Published var artworks: [Artwork] = []
    @Published var thumbnails: [UUID: UIImage] = [:]
    @Published var isLoading = true
    @Published var artworkToDelete: Artwork?
    @Published var showDeleteConfirm = false
    @Published var showDeletedToast = false

    private let persistence: PersistenceManagerProtocol

    init(persistence: PersistenceManagerProtocol = PersistenceManager.shared) {
        self.persistence = persistence
    }

    func load() async {
        isLoading = true
        do {
            artworks = try await persistence.fetchArtworks()
        } catch {
            print("[Gallery] Failed to load artworks: \(error)")
        }
        isLoading = false

        // Load thumbnails asynchronously after artworks are shown
        for artwork in artworks {
            if let image = try? await persistence.loadThumbnail(for: artwork.id) {
                thumbnails[artwork.id] = image
            }
        }
    }

    func deleteArtwork(_ artwork: Artwork) {
        artworkToDelete = artwork
        showDeleteConfirm = true
    }

    func confirmDelete() async {
        guard let artwork = artworkToDelete else { return }
        do {
            try await persistence.deleteArtwork(id: artwork.id)
            withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) {
                artworks.removeAll { $0.id == artwork.id }
                thumbnails.removeValue(forKey: artwork.id)
            }
            artworkToDelete = nil
            showDeletedToast = true
        } catch {
            print("[Gallery] Failed to delete artwork: \(error)")
            artworkToDelete = nil
        }
        // Auto-dismiss toast after 2 seconds
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        showDeletedToast = false
    }
}

struct GalleryGridView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @StateObject private var viewModel = GalleryViewModel()

    private var isIPad: Bool { horizontalSizeClass == .regular }
    private var gridColumns: [GridItem] {
        let count = isIPad ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.artworks.isEmpty {
                emptyState
            } else {
                gridContent
            }
        }
        .background(PBTokens.Colors.warmCream.ignoresSafeArea())
        .navigationBarHidden(true)
        .task { await viewModel.load() }
        .overlay(alignment: .bottom) {
            if viewModel.showDeletedToast {
                PBToast("Artwork deleted", style: .info)
                    .padding(.bottom, PBTokens.Spacing.xl)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .alert("Delete this artwork?", isPresented: $viewModel.showDeleteConfirm) {
            Button("Cancel", role: .cancel) {
                viewModel.artworkToDelete = nil
            }
            Button("Delete", role: .destructive) {
                Task { await viewModel.confirmDelete() }
            }
        } message: {
            if let artwork = viewModel.artworkToDelete {
                Text("This will remove '\(artwork.title)' from your gallery. This can't be undone.")
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            // Back button
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(PBTokens.Colors.richTeal)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Back")

            Spacer()

            Text("My Gallery")
                .font(PBTokens.Typography.nunito(.bold, size: 20))
                .foregroundColor(PBTokens.Colors.deepNavy)

            Spacer()

            // Browse pages button — opens content browser
            Button {
                router.pop()  // Gallery sits on top of Content Browser
            } label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 22))
                    .foregroundColor(PBTokens.Colors.richTeal)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Browse pages")
        }
        .padding(.horizontal, PBTokens.Spacing.sm)
        .frame(height: 44)
        .background(PBTokens.Colors.softCanvas)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(PBTokens.Colors.lightDivider)
                .frame(height: 1)
        }
    }

    // MARK: - Grid Content

    private var gridContent: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(viewModel.artworks) { artwork in
                    GalleryArtworkCard(
                        artwork: artwork,
                        thumbnail: viewModel.thumbnails[artwork.id],
                        onTap: {
                            router.push(.galleryFullscreen(artworkId: artwork.id))
                        }
                    )
                    .contextMenu {
                        Button {
                            shareArtwork(artwork)
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }

                        Button {
                            // Sprint 5.1 — PDF export
                        } label: {
                            Label("Print", systemImage: "printer")
                        }

                        Button(role: .destructive) {
                            viewModel.deleteArtwork(artwork)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, PBTokens.Spacing.md)
            .padding(.top, PBTokens.Spacing.md)
            .padding(.bottom, PBTokens.Spacing.xl)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: PBTokens.Spacing.md) {
            Spacer()

            // Placeholder illustration (160×160pt per spec)
            ZStack {
                RoundedRectangle(cornerRadius: PBTokens.CornerRadius.lg)
                    .fill(
                        LinearGradient(
                            colors: [
                                PBTokens.Colors.peachBlush.opacity(0.35),
                                PBTokens.Colors.skyBlue.opacity(0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 160, height: 160)

                VStack(spacing: PBTokens.Spacing.sm) {
                    Image(systemName: "easel")
                        .font(.system(size: 52))
                        .foregroundColor(PBTokens.Colors.softGraphite.opacity(0.5))
                    Image(systemName: "paintbrush.pointed")
                        .font(.system(size: 24))
                        .foregroundColor(PBTokens.Colors.richTeal.opacity(0.45))
                        .offset(x: 28, y: -8)
                }
            }

            VStack(spacing: PBTokens.Spacing.xs) {
                Text("Your gallery is empty!")
                    .font(PBTokens.Typography.nunito(.bold, size: 22))
                    .foregroundColor(PBTokens.Colors.deepNavy)
                    .multilineTextAlignment(.center)

                Text("Start coloring to fill it up")
                    .font(PBTokens.Typography.nunitoSans(.regular, size: 15))
                    .foregroundColor(PBTokens.Colors.softGraphite)
                    .multilineTextAlignment(.center)
            }

            // Browse Pages button — 48pt height per spec
            PBButton("Browse Pages") {
                router.pop()
            }
            .padding(.horizontal, PBTokens.Spacing.xl)
            .padding(.top, PBTokens.Spacing.md)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Helpers

    private func shareArtwork(_ artwork: Artwork) {
        Task {
            guard let thumbnail = viewModel.thumbnails[artwork.id] else { return }
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
    }
}
