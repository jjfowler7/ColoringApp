import SwiftUI

/// Horizontal filter pill for content categories in the Content Browser.
struct PBCategoryPill: View {
    let category: ContentCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: PBTokens.Spacing.xs) {
                // Category icon — uses SF Symbol fallback until custom icons are added
                Image(systemName: iconFallback)
                    .font(.system(size: 16))

                Text(category.displayName)
                    .font(PBTokens.Typography.nunitoSans(.semibold, size: 13))
            }
            .padding(.horizontal, PBTokens.Spacing.md)
            .frame(height: 44) // minimum touch target
            .foregroundColor(isSelected ? .white : PBTokens.Colors.deepNavy)
            .background(isSelected ? PBTokens.Colors.richTeal : PBTokens.Colors.softCanvas)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : PBTokens.Colors.lightDivider, lineWidth: 1)
            )
            .pbShadow(PBTokens.Shadows.level1)
        }
        .accessibilityLabel(category.displayName)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    /// SF Symbol fallback until custom category icons are added to Assets
    private var iconFallback: String {
        switch category {
        case .animals:  return "pawprint.fill"
        case .vehicles: return "car.fill"
        case .fantasy:  return "wand.and.stars"
        case .nature:   return "leaf.fill"
        case .holidays: return "gift.fill"
        case .patterns: return "circle.grid.3x3.fill"
        }
    }
}
