import SwiftUI

// ONBOARD-001: Age tier selection — Screen 02 per design spec §2.1.2
struct AgeTierSelectionView: View {
    let onTierSelected: (AgeTier) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var cardsVisible = false
    @State private var tappedTier: AgeTier?

    private var isIPad: Bool { horizontalSizeClass == .regular }

    var body: some View {
        VStack(spacing: PBTokens.Spacing.lg) {
            Spacer()

            // Header
            Text("Who's coloring today?")
                .font(isIPad
                    ? PBTokens.Typography.nunito(.bold, size: 36)
                    : PBTokens.Typography.nunito(.bold, size: 28))
                .foregroundColor(PBTokens.Colors.deepNavy)
                .multilineTextAlignment(.center)
                .opacity(cardsVisible ? 1.0 : 0.0)

            // Tier cards
            if isIPad {
                // iPad: 3-across
                HStack(spacing: PBTokens.Spacing.md) {
                    ForEach(Array(AgeTier.allCases.enumerated()), id: \.element) { index, tier in
                        tierCard(tier: tier, index: index)
                    }
                }
                .padding(.horizontal, PBTokens.Spacing.xxl)
            } else {
                // iPhone: stacked vertically
                VStack(spacing: PBTokens.Spacing.md) {
                    ForEach(Array(AgeTier.allCases.enumerated()), id: \.element) { index, tier in
                        tierCard(tier: tier, index: index)
                    }
                }
                .padding(.horizontal, PBTokens.Spacing.xl)
            }

            // Reassurance text
            Text("You can always change this later")
                .font(PBTokens.Typography.reassurance)
                .foregroundColor(PBTokens.Colors.softGraphite)
                .opacity(cardsVisible ? 1.0 : 0.0)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PBTokens.Colors.warmCream.ignoresSafeArea())
        .onAppear {
            // Staggered card entrance
            withAnimation(PBTokens.Animation.spring) {
                cardsVisible = true
            }
        }
    }

    // MARK: - Tier Card

    private func tierCard(tier: AgeTier, index: Int) -> some View {
        Button {
            tappedTier = tier
            // Brief scale feedback, then navigate
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 100ms per spec §2.1.2
                onTierSelected(tier)
            }
        } label: {
            HStack(spacing: PBTokens.Spacing.md) {
                // Tier icon
                Image(systemName: tier.iconName)
                    .font(.system(size: 32))
                    .foregroundColor(PBTokens.Colors.tierStrongAccent(tier))
                    .frame(width: 56, height: 56)
                    .accessibilityHidden(true)

                // Text content
                VStack(alignment: .leading, spacing: PBTokens.Spacing.xs) {
                    Text(tier.displayName)
                        .font(PBTokens.Typography.nunito(.bold, size: 20))
                        .foregroundColor(PBTokens.Colors.deepNavy)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text(tier.ageRange)
                        .font(PBTokens.Typography.nunitoSans(.semibold, size: 14))
                        .foregroundColor(PBTokens.Colors.tierAccent(tier))

                    Text(tier.tagline)
                        .font(PBTokens.Typography.nunitoSans(.regular, size: 14))
                        .foregroundColor(PBTokens.Colors.softGraphite)
                }

                Spacer()

                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(PBTokens.Colors.softGraphite)
                    .opacity(0.35) // Per spec §2.1.2
            }
            .padding(PBTokens.Spacing.md)
            .frame(maxWidth: .infinity)
            .frame(minHeight: isIPad ? 160 : 100)
            .background(PBTokens.Colors.tierAccent(tier).opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.lg))
            // Left colored border
            .overlay(alignment: .leading) {
                RoundedRectangle(cornerRadius: PBTokens.CornerRadius.lg)
                    .fill(PBTokens.Colors.tierStrongAccent(tier))
                    .frame(width: 4)
            }
            .pbShadow(PBTokens.Shadows.level2)
            .scaleEffect(tappedTier == tier ? 1.05 : 1.0)
            .animation(PBTokens.Animation.instant, value: tappedTier)
        }
        .accessibilityLabel("\(tier.displayName), \(tier.ageRange), \(tier.tagline)")
        // Staggered entrance: slide up + fade in, 100ms delay per card
        .opacity(cardsVisible ? 1.0 : 0.0)
        .offset(y: cardsVisible ? 0 : 20)
        .animation(
            PBTokens.Animation.spring.delay(Double(index) * 0.1),
            value: cardsVisible
        )
    }
}
