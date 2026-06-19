import SwiftUI

/// Empty state placeholder used for empty gallery, empty category, and "coming soon" screens.
struct PBEmptyState: View {
    let systemImage: String     // SF Symbol name (until custom illustrations are added)
    let title: String
    let subtitle: String
    let actionLabel: String?
    let action: (() -> Void)?

    init(
        systemImage: String,
        title: String,
        subtitle: String,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
        self.actionLabel = actionLabel
        self.action = action
    }

    var body: some View {
        VStack(spacing: PBTokens.Spacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundColor(PBTokens.Colors.lightDivider)

            Text(title)
                .font(PBTokens.Typography.dialogTitle)
                .foregroundColor(PBTokens.Colors.deepNavy)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(PBTokens.Typography.body)
                .foregroundColor(PBTokens.Colors.softGraphite)
                .multilineTextAlignment(.center)

            if let actionLabel, let action {
                PBButton(actionLabel, action: action)
                    .padding(.horizontal, PBTokens.Spacing.xxxl)
                    .padding(.top, PBTokens.Spacing.sm)
            }
        }
        .padding(PBTokens.Spacing.xl)
    }
}
