import SwiftUI

/// Card overlay badges for page/artwork status.
struct PBStatusBadge: View {
    enum BadgeType {
        case new         // coral "NEW" pill
        case inProgress  // teal "CONTINUE" pill
        case locked      // gray lock icon
    }

    let type: BadgeType

    var body: some View {
        switch type {
        case .new:
            Text("NEW")
                .font(PBTokens.Typography.badge)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(PBTokens.Colors.sunsetCoral)
                .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.xs))
                .accessibilityLabel("New")

        case .inProgress:
            Text("CONTINUE")
                .font(PBTokens.Typography.badge)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(PBTokens.Colors.richTeal)
                .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.xs))
                .accessibilityLabel("Continue coloring")

        case .locked:
            Image(systemName: "lock.fill")
                .font(.system(size: 20))
                .foregroundColor(PBTokens.Colors.softGraphite.opacity(0.6))
                .accessibilityLabel("Locked")
        }
    }
}
