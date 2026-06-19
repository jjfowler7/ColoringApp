import SwiftUI

// CONTENT-001: Content Browser — Screen 04 per design spec §2.3
// Root screen: category pills + page grid with tier filtering
struct ContentBrowserView: View {
    @EnvironmentObject private var router: AppRouter
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var selectedCategory: ContentCategory = .animals
    @State private var savedArtworks: [Artwork] = []
    @State private var showIAPPlaceholder = false

    private let tier = UserPreferences.shared.selectedTier
    private let store = ContentStore.shared
    private var isIPad: Bool { horizontalSizeClass == .regular }

    // Grid layout: 2-column iPhone, 4-column iPad
    private var gridColumns: [GridItem] {
        let count = isIPad ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Bar (no back button — root screen)
            topBar

            if isIPad {
                // iPad: sidebar + grid side-by-side
                HStack(spacing: 0) {
                    categorySidebar
                    pageGridContent
                }
            } else {
                // iPhone: pills row + grid stacked
                categoryPillsRow
                pageGridContent
            }
        }
        .background(PBTokens.Colors.warmCream.ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $showIAPPlaceholder) {
            iapPlaceholderSheet
        }
        .task {
            await loadSavedArtworks()
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Spacer()

            Text("PaperBrush")
                .font(PBTokens.Typography.nunito(.bold, size: 18))
                .foregroundColor(PBTokens.Colors.deepNavy)

            Spacer()

            // Pack Store icon
            Button { router.push(.packStore) } label: {
                Image(systemName: "shippingbox")
                    .font(.system(size: 18))
                    .foregroundColor(PBTokens.Colors.richTeal)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Pack Store")

            // Gallery icon
            Button { router.push(.gallery) } label: {
                Image(systemName: "photo.stack")
                    .font(.system(size: 18))
                    .foregroundColor(PBTokens.Colors.richTeal)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Gallery")

            // Settings icon (requires parental gate)
            Button { router.navigateToSettings() } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 18))
                    .foregroundColor(PBTokens.Colors.softGraphite)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Settings")
        }
        .padding(.horizontal, PBTokens.Spacing.sm)
        .frame(height: 44)
        .background(PBTokens.Colors.softCanvas)
        .overlay(alignment: .bottom) {
            Rectangle().fill(PBTokens.Colors.lightDivider).frame(height: 1)
        }
    }

    // MARK: - Category Pills (iPhone — horizontal scroll)

    private var categoryPillsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: PBTokens.Spacing.sm) {
                ForEach(ContentCategory.allCases, id: \.self) { category in
                    PBCategoryPill(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(PBTokens.Animation.quick) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, PBTokens.Spacing.md)
            .padding(.vertical, PBTokens.Spacing.sm)
        }
    }

    // MARK: - Category Sidebar (iPad — fixed 280pt)

    private var categorySidebar: some View {
        VStack(alignment: .leading, spacing: PBTokens.Spacing.xs) {
            ForEach(ContentCategory.allCases, id: \.self) { category in
                Button {
                    withAnimation(PBTokens.Animation.quick) {
                        selectedCategory = category
                    }
                } label: {
                    HStack(spacing: PBTokens.Spacing.sm) {
                        Image(systemName: sfSymbol(for: category))
                            .font(.system(size: 16))
                        Text(category.displayName)
                            .font(PBTokens.Typography.nunitoSans(.semibold, size: 15))
                    }
                    .foregroundColor(selectedCategory == category ? PBTokens.Colors.richTeal : PBTokens.Colors.deepNavy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, PBTokens.Spacing.md)
                    .padding(.vertical, PBTokens.Spacing.sm)
                    .background(
                        selectedCategory == category
                        ? PBTokens.Colors.richTeal.opacity(0.08)
                        : Color.clear
                    )
                    .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.sm))
                }
            }
            Spacer()
        }
        .padding(.top, PBTokens.Spacing.md)
        .padding(.horizontal, PBTokens.Spacing.sm)
        .frame(width: 280)
        .background(PBTokens.Colors.softCanvas)
        .overlay(alignment: .trailing) {
            Rectangle().fill(PBTokens.Colors.lightDivider).frame(width: 1)
        }
    }

    // MARK: - Page Grid Content

    private var pageGridContent: some View {
        let tierMatched = store.tierMatchedPages(for: selectedCategory, tier: tier)
        let otherTier = store.otherTierPages(for: selectedCategory, tier: tier)

        return Group {
            if tierMatched.isEmpty && otherTier.isEmpty {
                PBEmptyState(
                    systemImage: "questionmark.folder",
                    title: "Nothing here yet!",
                    subtitle: "Check back soon for new \(selectedCategory.displayName) pages"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 12) {
                        // Tier-matched pages first
                        ForEach(tierMatched, id: \.id) { page in
                            pageCard(for: page)
                        }

                        // "More pages" divider (if both sections have content)
                        if !tierMatched.isEmpty && !otherTier.isEmpty {
                            Section {
                                ForEach(otherTier, id: \.id) { page in
                                    pageCard(for: page)
                                }
                            } header: {
                                morePagesHeader
                                    .gridCellColumns(isIPad ? 4 : 2)
                            }
                        }

                        // If no tier-matched, show all other-tier pages directly
                        if tierMatched.isEmpty {
                            ForEach(otherTier, id: \.id) { page in
                                pageCard(for: page)
                            }
                        }
                    }
                    .padding(.horizontal, PBTokens.Spacing.md)
                    .padding(.top, PBTokens.Spacing.md)
                    .padding(.bottom, PBTokens.Spacing.xl)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - "More pages" divider

    private var morePagesHeader: some View {
        HStack {
            Rectangle().fill(PBTokens.Colors.lightDivider).frame(height: 1)
            Text("More pages")
                .font(PBTokens.Typography.nunitoSans(.regular, size: 13))
                .foregroundColor(PBTokens.Colors.softGraphite)
                .fixedSize()
                .padding(.horizontal, PBTokens.Spacing.sm)
            Rectangle().fill(PBTokens.Colors.lightDivider).frame(height: 1)
        }
        .padding(.vertical, PBTokens.Spacing.sm)
    }

    // MARK: - Page Card

    private func pageCard(for page: ColoringPage) -> some View {
        let inProgressArtwork = savedArtworks.first { $0.pageId == page.id && !$0.isCompleted }
        let isInProgress = inProgressArtwork != nil

        return PageThumbnailCard(
            page: page,
            isInProgress: isInProgress
        ) {
            if isInProgress, let artwork = inProgressArtwork {
                // Resume in-progress artwork
                router.push(.canvasResume(artworkId: artwork.id))
            } else if page.isFree {
                // Open canvas with this page
                router.push(.canvas(pageId: page.id))
            } else {
                // Locked — show IAP placeholder
                showIAPPlaceholder = true
            }
        }
    }

    // MARK: - IAP Placeholder Sheet

    private var iapPlaceholderSheet: some View {
        VStack(spacing: PBTokens.Spacing.lg) {
            Capsule()
                .fill(PBTokens.Colors.lightDivider)
                .frame(width: 36, height: 5)
                .padding(.top, 12)

            Image(systemName: "lock.open.fill")
                .font(.system(size: 48))
                .foregroundColor(PBTokens.Colors.richTeal)

            Text("Unlock Everything")
                .font(PBTokens.Typography.screenHeader)
                .foregroundColor(PBTokens.Colors.deepNavy)

            Text("Get all coloring pages for a one-time purchase of $14.99")
                .font(PBTokens.Typography.body)
                .foregroundColor(PBTokens.Colors.softGraphite)
                .multilineTextAlignment(.center)

            PBButton("Unlock Everything — $14.99") {
                // Sprint 4.1 — StoreKit 2 integration
            }
            .padding(.horizontal, PBTokens.Spacing.xl)

            Button("Restore Purchase") {
                // Sprint 4.1
            }
            .font(PBTokens.Typography.nunitoSans(.semibold, size: 14))
            .foregroundColor(PBTokens.Colors.richTeal)

            Spacer()
        }
        .padding(.horizontal, PBTokens.Spacing.lg)
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.hidden)
    }

    // MARK: - Helpers

    private func loadSavedArtworks() async {
        do {
            savedArtworks = try await PersistenceManager.shared.fetchArtworks()
        } catch {
            print("[ContentBrowser] Failed to load artworks: \(error)")
        }
    }

    private func sfSymbol(for category: ContentCategory) -> String {
        switch category {
        case .animals:  return "pawprint.fill"
        case .vehicles: return "car.fill"
        case .fantasy:  return "wand.and.stars"
        case .nature:   return "leaf.fill"
        case .holidays: return "gift.fill"
        case .patterns: return "circle.grid.3x3.fill"
        }
    }
}
