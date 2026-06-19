import SwiftUI

/// Feedback toast that appears briefly at the bottom of the screen.
/// Auto-dismisses after 2–4 seconds depending on context.
struct PBToast: View {
    enum Style {
        case success  // Soft Sage background
        case warning  // Honey Gold background
        case info     // Deep Navy background
    }

    let message: String
    let style: Style
    let actionLabel: String?
    let action: (() -> Void)?

    init(
        _ message: String,
        style: Style = .success,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.message = message
        self.style = style
        self.actionLabel = actionLabel
        self.action = action
    }

    var body: some View {
        HStack(spacing: PBTokens.Spacing.sm) {
            Text(message)
                .font(PBTokens.Typography.toastText)
                .foregroundColor(.white)

            if let actionLabel, let action {
                Button(actionLabel, action: action)
                    .font(PBTokens.Typography.toastText)
                    .foregroundColor(.white)
                    .underline()
            }
        }
        .padding(.horizontal, PBTokens.Spacing.md)
        .padding(.vertical, PBTokens.Spacing.sm)
        .background(backgroundColor)
        .clipShape(Capsule())
        .pbShadow(PBTokens.Shadows.level2)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private var backgroundColor: Color {
        switch style {
        case .success: return PBTokens.Colors.softSage
        case .warning: return PBTokens.Colors.honeyGold
        case .info:    return PBTokens.Colors.deepNavy
        }
    }
}
