import SwiftUI

// CONTENT-001: Page thumbnail card for the Content Browser grid
// Per spec §2.3: 3:3.6 aspect ratio, md (16pt) corners, Level 1 shadow
// States: free, locked (50% opacity + lock), new (coral badge), in-progress (teal badge)
struct PageThumbnailCard: View {
    let page: ColoringPage
    let isInProgress: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Thumbnail area
                thumbnailArea

                // Info strip: title + tier badge
                VStack(alignment: .leading, spacing: 3) {
                    Text(page.title)
                        .font(PBTokens.Typography.nunitoSans(.semibold, size: 13))
                        .foregroundColor(PBTokens.Colors.deepNavy)
                        .lineLimit(1)

                    PBTierBadge(page.tier)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, PBTokens.Spacing.sm)
                .padding(.vertical, PBTokens.Spacing.sm)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.md))
            .pbShadow(PBTokens.Shadows.level1)
        }
        .buttonStyle(CardButtonStyle())
        .accessibilityLabel("\(page.title), \(page.tier.displayName) tier\(isInProgress ? ", continue coloring" : "")\(!page.isFree ? ", locked" : "")")
    }

    // MARK: - Thumbnail Area

    private var thumbnailArea: some View {
        ZStack {
            // Placeholder thumbnail (SF Symbol until real SVGs)
            Rectangle()
                .fill(Color.white)
                .aspectRatio(3.0 / 3.6, contentMode: .fit)
                .overlay {
                    Image(systemName: page.placeholderIcon)
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(PBTokens.Colors.lightDivider)
                }

            // Locked overlay: 50% opacity dimming + centered lock icon
            if !page.isFree {
                Rectangle()
                    .fill(Color.white.opacity(0.5))

                PBStatusBadge(type: .locked)
            }

            // Status badges (top-right, -4pt inset)
            if page.isNew && page.isFree && !isInProgress {
                VStack {
                    HStack {
                        Spacer()
                        PBStatusBadge(type: .new)
                            .padding(PBTokens.Spacing.sm)
                    }
                    Spacer()
                }
            }

            if isInProgress {
                VStack {
                    HStack {
                        Spacer()
                        PBStatusBadge(type: .inProgress)
                            .padding(PBTokens.Spacing.sm)
                    }
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Card press animation (scale 0.97)

private struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(PBTokens.Animation.pressDown, value: configuration.isPressed)
    }
}
