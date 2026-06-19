import SwiftUI

/// Generic card container with soft canvas background and shadow.
/// Used for page thumbnails, gallery items, tier selection cards, and pack cards.
struct PBCard<Content: View>: View {
    let cornerRadius: CGFloat
    let shadowLevel: PBTokens.ShadowStyle
    let content: () -> Content

    init(
        cornerRadius: CGFloat = PBTokens.CornerRadius.md,
        shadowLevel: PBTokens.ShadowStyle = PBTokens.Shadows.level1,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.shadowLevel = shadowLevel
        self.content = content
    }

    @State private var isPressed = false

    var body: some View {
        content()
            .background(PBTokens.Colors.softCanvas)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .pbShadow(shadowLevel)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(PBTokens.Animation.pressDown, value: isPressed)
    }
}
