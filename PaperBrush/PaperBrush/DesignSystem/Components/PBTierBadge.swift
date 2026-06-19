import SwiftUI

/// Small badge showing a colored dot and optional tier label.
/// Used on content browser cards, gallery cards, and settings.
struct PBTierBadge: View {
    let tier: AgeTier
    let showLabel: Bool

    init(_ tier: AgeTier, showLabel: Bool = true) {
        self.tier = tier
        self.showLabel = showLabel
    }

    var body: some View {
        HStack(spacing: PBTokens.Spacing.xs) {
            Circle()
                .fill(PBTokens.Colors.tierAccent(tier))
                .frame(width: 6, height: 6)

            if showLabel {
                Text(tier.displayName)
                    .font(PBTokens.Typography.nunitoSans(.regular, size: 11))
                    .foregroundColor(PBTokens.Colors.tierAccent(tier))
            }
        }
        .accessibilityLabel("\(tier.displayName) tier")
    }
}
