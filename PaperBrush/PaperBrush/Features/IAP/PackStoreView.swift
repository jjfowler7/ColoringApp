import SwiftUI

// IAP-003: Pack store — Screen 13
// Placeholder: full implementation in Sprint 4.1
struct PackStoreView: View {
    var body: some View {
        PBEmptyState(
            systemImage: "gift.fill",
            title: "New packs coming soon!",
            subtitle: "We're working on exciting new content packs."
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PBTokens.Colors.warmCream.ignoresSafeArea())
    }
}
