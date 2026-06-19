import SwiftUI

/// Primary action button used throughout PaperBrush.
/// Supports 4 styles: primary (teal), accent (coral), outline, and ghost.
struct PBButton: View {
    enum Style {
        case primary      // Rich Teal fill, white text
        case accent       // Sunset Coral fill, white text
        case outline      // Teal border, teal text, no fill
        case ghost        // No background, Soft Graphite text
    }

    let title: String
    let style: Style
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    init(
        _ title: String,
        style: Style = .primary,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: PBTokens.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(PBTokens.Typography.buttonLabel)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: PBTokens.CornerRadius.sm)
                    .stroke(borderColor, lineWidth: style == .outline ? 2 : 0)
            )
            .pbShadow(PBTokens.Shadows.level2)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(PBTokens.Animation.pressDown, value: isPressed)
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1.0)
        .pressEvents(onPress: { isPressed = true }, onRelease: { isPressed = false })
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return PBTokens.Colors.richTeal
        case .accent:  return PBTokens.Colors.sunsetCoral
        case .outline: return .clear
        case .ghost:   return .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary, .accent: return .white
        case .outline:          return PBTokens.Colors.richTeal
        case .ghost:            return PBTokens.Colors.softGraphite
        }
    }

    private var borderColor: Color {
        style == .outline ? PBTokens.Colors.richTeal : .clear
    }
}
