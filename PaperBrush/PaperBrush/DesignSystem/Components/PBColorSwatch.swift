import SwiftUI

// COLOR-001: Color palette swatch circle
struct PBColorSwatch: View {
    let color: Color
    let isSelected: Bool
    let isDoodler: Bool  // larger size for Doodler tier (40pt vs 32pt)
    let action: () -> Void

    private var size: CGFloat { isDoodler ? 40 : 32 }
    private var selectedSize: CGFloat { isDoodler ? 48 : 40 }

    /// Detects if the color is light (e.g., white, tan) so checkmark/border can use a dark contrast
    private var isLightColor: Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: nil)
        let luminance = 0.299 * r + 0.587 * g + 0.114 * b
        return luminance > 0.75
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: isSelected ? selectedSize : size,
                           height: isSelected ? selectedSize : size)
                    .pbShadow(isSelected ? PBTokens.Shadows.level2 : PBTokens.Shadows.level1)

                if isSelected {
                    Circle()
                        .stroke(.white, lineWidth: 3)
                        .frame(width: selectedSize, height: selectedSize)

                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(isLightColor ? .gray : .white)
                }
            }
            .animation(PBTokens.Animation.spring, value: isSelected)
        }
        .frame(width: selectedSize, height: selectedSize) // consistent 44pt+ hit target
        .accessibilityLabel("Color swatch")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
