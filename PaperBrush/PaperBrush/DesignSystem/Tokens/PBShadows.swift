import SwiftUI

extension PBTokens {
    /// Shadow intensity levels for elevation hierarchy.
    /// level1 = subtle card shadow, level4 = prominent modal shadow.
    enum Shadows {
        static let level1 = ShadowStyle(color: PBTokens.Colors.deepNavy.opacity(0.06), radius: 8, y: 2)
        static let level2 = ShadowStyle(color: PBTokens.Colors.deepNavy.opacity(0.10), radius: 16, y: 4)
        static let level3 = ShadowStyle(color: PBTokens.Colors.deepNavy.opacity(0.14), radius: 32, y: 8)
        static let level4 = ShadowStyle(color: PBTokens.Colors.deepNavy.opacity(0.18), radius: 48, y: 16)
    }

    struct ShadowStyle {
        let color: Color
        let radius: CGFloat
        let y: CGFloat
    }
}

// MARK: - View Modifier

extension View {
    /// Applies a PaperBrush shadow style to the view.
    func pbShadow(_ style: PBTokens.ShadowStyle) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: 0, y: style.y)
    }
}
