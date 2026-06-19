# PaperBrush — Component Library

**Version 1.0 | March 2026 | Swift Code Reference for All Reusable UI Components**
**Every component uses design tokens from `PBTokens` — never hardcode values.**

---

## 1. Design Tokens (Swift Implementation)

These are the foundational constants every component references. Create these first.

### 1.1 Colors

```swift
// File: DesignSystem/Tokens/PBColors.swift
import SwiftUI

extension PBTokens {
    enum Colors {
        // Primary
        static let warmCream       = Color(hex: "FFF8F0")  // background
        static let softCanvas      = Color(hex: "FFFDF9")  // card surfaces
        static let richTeal        = Color(hex: "0EA5A0")  // primary action
        static let deepNavy        = Color(hex: "1B2A4A")  // text/headers
        static let sunsetCoral     = Color(hex: "F06449")  // accent/CTA

        // Supporting
        static let honeyGold       = Color(hex: "F5A623")  // warnings/stars
        static let softSage        = Color(hex: "7CB686")  // success/confirm
        static let lavenderMist    = Color(hex: "B8A9E8")  // Creator tier
        static let skyBlue         = Color(hex: "6BB8E8")  // Explorer tier
        static let peachBlush      = Color(hex: "FCBFA0")  // Starter tier
        static let softGraphite    = Color(hex: "666666")  // secondary text
        static let lightDivider    = Color(hex: "E8E0D8")  // borders/dividers

        // Functional
        static let scrim           = Color(hex: "1B2A4A").opacity(0.5) // modal overlay

        /// Returns the accent color for an age tier
        static func tierAccent(_ tier: AgeTier) -> Color {
            switch tier {
            case .starter:  return peachBlush
            case .explorer: return skyBlue
            case .creator:  return lavenderMist
            }
        }

        /// Returns the strong accent for an age tier (used for borders, highlights)
        static func tierStrongAccent(_ tier: AgeTier) -> Color {
            switch tier {
            case .starter:  return sunsetCoral
            case .explorer: return richTeal
            case .creator:  return deepNavy
            }
        }
    }
}
```

```swift
// File: Core/Extensions/Color+Hex.swift
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

### 1.2 Typography

```swift
// File: DesignSystem/Tokens/PBTypography.swift
import SwiftUI

extension PBTokens {
    enum Typography {
        // MARK: - Font Families
        static func nunito(_ weight: Font.Weight, size: CGFloat) -> Font {
            switch weight {
            case .bold:      return .custom("Nunito-Bold", size: size)
            case .heavy:     return .custom("Nunito-ExtraBold", size: size)
            case .semibold:  return .custom("Nunito-SemiBold", size: size)
            default:         return .custom("Nunito-Regular", size: size)
            }
        }

        static func nunitoSans(_ weight: Font.Weight, size: CGFloat) -> Font {
            switch weight {
            case .semibold:  return .custom("NunitoSans-SemiBold", size: size)
            case .regular:   return .custom("NunitoSans-Regular", size: size)
            default:         return .custom("NunitoSans-Regular", size: size)
            }
        }

        // MARK: - Semantic Styles (iPhone sizes — iPad sizes in layout modifiers)
        static let heroTitle       = nunito(.heavy, size: 36)     // iPad: 52pt
        static let screenHeader    = nunito(.bold, size: 24)      // iPad: 32pt
        static let sectionHeader   = nunito(.bold, size: 18)      // iPad: 24pt
        static let buttonLabel     = nunito(.bold, size: 16)      // iPad: 18pt
        static let body            = nunitoSans(.regular, size: 15) // iPad: 17pt
        static let caption         = nunitoSans(.regular, size: 12) // iPad: 14pt
        static let badge           = nunito(.bold, size: 10)       // iPad: 12pt

        // Specific use cases
        static let dialogTitle     = nunito(.bold, size: 22)
        static let dialogBody      = nunitoSans(.semibold, size: 18)
        static let toastText       = nunitoSans(.semibold, size: 14)
        static let reassurance     = nunitoSans(.regular, size: 13)
    }
}
```

### 1.3 Spacing

```swift
// File: DesignSystem/Tokens/PBSpacing.swift
import SwiftUI

extension PBTokens {
    enum Spacing {
        static let xs:  CGFloat = 4    // icon internal padding
        static let sm:  CGFloat = 8    // between related elements
        static let md:  CGFloat = 16   // component internal padding
        static let lg:  CGFloat = 24   // between sections
        static let xl:  CGFloat = 32   // screen margins iPhone
        static let xxl: CGFloat = 48   // screen margins iPad
        static let xxxl: CGFloat = 64  // major section separation

        /// Screen-appropriate horizontal margin
        static func screenMargin(isIPad: Bool) -> CGFloat {
            isIPad ? xxl : md
        }
    }
}
```

### 1.4 Corner Radii

```swift
// File: DesignSystem/Tokens/PBCornerRadius.swift
import SwiftUI

extension PBTokens {
    enum CornerRadius {
        static let xs:   CGFloat = 6    // badges, tags
        static let sm:   CGFloat = 10   // buttons, inputs
        static let md:   CGFloat = 16   // cards, dialogs
        static let lg:   CGFloat = 24   // panels, sheets
        static let xl:   CGFloat = 32   // featured cards
        static let full: CGFloat = 9999 // pills, circles
    }
}
```

### 1.5 Shadows

```swift
// File: DesignSystem/Tokens/PBShadows.swift
import SwiftUI

extension PBTokens {
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

// Shadow view modifier
extension View {
    func pbShadow(_ style: PBTokens.ShadowStyle) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: 0, y: style.y)
    }
}
```

### 1.6 Animation Tokens

```swift
// File: DesignSystem/Tokens/PBAnimation.swift
import SwiftUI

extension PBTokens {
    enum Animation {
        static let instant:    SwiftUI.Animation = .easeOut(duration: 0.1)
        static let quick:      SwiftUI.Animation = .easeOut(duration: 0.2)
        static let standard:   SwiftUI.Animation = .easeInOut(duration: 0.3)
        static let expressive: SwiftUI.Animation = .easeOut(duration: 0.5)
        static let dramatic:   SwiftUI.Animation = .easeOut(duration: 0.8)

        static let spring:      SwiftUI.Animation = .spring(response: 0.3, dampingFraction: 0.7)
        static let celebration: SwiftUI.Animation = .spring(response: 0.5, dampingFraction: 0.5)

        // Button press
        static let pressDown:  SwiftUI.Animation = .easeOut(duration: 0.05)
        static let pressUp:    SwiftUI.Animation = .spring(response: 0.2, dampingFraction: 0.6)
    }
}
```

### 1.7 Tokens Namespace

```swift
// File: DesignSystem/Tokens/PBTokens.swift
import Foundation

/// Namespace for all design system tokens.
/// Usage: PBTokens.Colors.richTeal, PBTokens.Spacing.md, etc.
enum PBTokens { }
```

---

## 2. Reusable Components

### 2.1 PBButton — Primary Action Button

Used for: "Get Started", "Unlock Everything", "Start Coloring!", "Share / Print", "Continue"

```swift
// File: DesignSystem/Components/PBButton.swift
import SwiftUI

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
```

### 2.2 PBCard — Content Card

Used for: Page thumbnails, gallery items, tier selection cards, pack cards.

```swift
// File: DesignSystem/Components/PBCard.swift
import SwiftUI

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
```

### 2.3 PBToast — Feedback Toast

Used for: "Saved to Gallery ✓", "Couldn't save", "Artwork deleted".

```swift
// File: DesignSystem/Components/PBToast.swift
import SwiftUI

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
```

### 2.4 PBTierBadge — Age Tier Indicator

Used on: content browser cards, gallery cards, settings.

```swift
// File: DesignSystem/Components/PBTierBadge.swift
import SwiftUI

struct PBTierBadge: View {
    let tier: AgeTier
    let showLabel: Bool

    init(_ tier: AgeTier, showLabel: Bool = true) {
        self.tier = tier
        self.showLabel = showLabel
    }

    var body: some View {
        HStack(spacing: PBTokens.Spacing.xs) {
            Circle()
                .fill(PBTokens.Colors.tierAccent(tier))
                .frame(width: 6, height: 6)

            if showLabel {
                Text(tier.displayName)
                    .font(.custom("NunitoSans-Regular", size: 11))
                    .foregroundColor(PBTokens.Colors.tierAccent(tier))
            }
        }
        .accessibilityLabel("\(tier.displayName) tier")
    }
}
```

### 2.5 PBStatusBadge — Card Overlay Badges

Used for: "NEW", "CONTINUE", lock icon.

```swift
// File: DesignSystem/Components/PBStatusBadge.swift
import SwiftUI

struct PBStatusBadge: View {
    enum BadgeType {
        case new
        case inProgress
        case locked
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

        case .inProgress:
            Text("CONTINUE")
                .font(PBTokens.Typography.badge)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(PBTokens.Colors.richTeal)
                .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.xs))

        case .locked:
            Image(systemName: "lock.fill")
                .font(.system(size: 20))
                .foregroundColor(PBTokens.Colors.softGraphite.opacity(0.6))
        }
    }
}
```

### 2.6 PBColorSwatch — Color Palette Circle

```swift
// File: DesignSystem/Components/PBColorSwatch.swift
import SwiftUI

struct PBColorSwatch: View {
    let color: Color
    let isSelected: Bool
    let isStarter: Bool  // larger size for Starter tier
    let action: () -> Void

    private var size: CGFloat { isStarter ? 40 : 32 }
    private var selectedSize: CGFloat { isStarter ? 48 : 40 }

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
                        .foregroundColor(.white)
                }
            }
            .animation(PBTokens.Animation.spring, value: isSelected)
        }
        .frame(width: selectedSize, height: selectedSize) // consistent hit target
        .accessibilityLabel("Color swatch")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
```

### 2.7 PBCategoryPill — Content Browser Filter

```swift
// File: DesignSystem/Components/PBCategoryPill.swift
import SwiftUI

struct PBCategoryPill: View {
    let category: ContentCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: PBTokens.Spacing.xs) {
                Image(category.iconName)
                    .resizable()
                    .frame(width: 24, height: 24)

                Text(category.displayName)
                    .font(.custom("Nunito-SemiBold", size: 13))
            }
            .padding(.horizontal, PBTokens.Spacing.md)
            .frame(height: 44)
            .foregroundColor(isSelected ? .white : PBTokens.Colors.deepNavy)
            .background(isSelected ? PBTokens.Colors.richTeal : PBTokens.Colors.softCanvas)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : PBTokens.Colors.lightDivider, lineWidth: 1)
            )
            .pbShadow(isSelected ? PBTokens.Shadows.level1 : PBTokens.Shadows.level1)
        }
        .accessibilityLabel(category.displayName)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
```

### 2.8 PBEmptyState — Empty State Placeholder

Used for: empty gallery, empty category, pack store "coming soon".

```swift
// File: DesignSystem/Components/PBEmptyState.swift
import SwiftUI

struct PBEmptyState: View {
    let imageName: String       // Custom illustration asset name
    let title: String
    let subtitle: String
    let actionLabel: String?
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing: PBTokens.Spacing.md) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)

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
```

### 2.9 PBParentalGate — Math Challenge Modal

```swift
// File: DesignSystem/Components/PBParentalGate.swift
import SwiftUI

struct PBParentalGate: View {
    @StateObject private var viewModel = ParentalGateViewModel()
    let onSuccess: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            // Scrim
            PBTokens.Colors.scrim
                .ignoresSafeArea()
                .onTapGesture { } // blocks tap-through

            // Dialog
            VStack(spacing: PBTokens.Spacing.lg) {
                Text("Grown-ups only!")
                    .font(PBTokens.Typography.dialogTitle)
                    .foregroundColor(PBTokens.Colors.deepNavy)

                Text(viewModel.questionText)
                    .font(PBTokens.Typography.dialogBody)
                    .foregroundColor(PBTokens.Colors.softGraphite)

                TextField("", text: $viewModel.answer)
                    .font(.custom("Nunito-Bold", size: 24))
                    .foregroundColor(PBTokens.Colors.deepNavy)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .frame(width: 120, height: 48)
                    .background(PBTokens.Colors.warmCream)
                    .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.sm))
                    .overlay(
                        RoundedRectangle(cornerRadius: PBTokens.CornerRadius.sm)
                            .stroke(PBTokens.Colors.lightDivider, lineWidth: 1)
                    )

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(PBTokens.Typography.reassurance)
                        .foregroundColor(PBTokens.Colors.sunsetCoral)
                }

                PBButton("Continue", isDisabled: !viewModel.canSubmit) {
                    if viewModel.checkAnswer() {
                        onSuccess()
                    }
                }

                Button("Cancel") { onCancel() }
                    .font(.custom("NunitoSans-SemiBold", size: 15))
                    .foregroundColor(PBTokens.Colors.softGraphite)
            }
            .padding(PBTokens.Spacing.lg)
            .frame(width: 300)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.lg))
            .pbShadow(PBTokens.Shadows.level4)
            .offset(x: viewModel.shakeOffset)
        }
    }
}
```

---

## 3. Shared View Modifiers

### 3.1 Press Events Modifier

```swift
// File: Core/Modifiers/PressEventsModifier.swift
import SwiftUI

struct PressEventsModifier: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in onRelease() }
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressEventsModifier(onPress: onPress, onRelease: onRelease))
    }
}
```

### 3.2 Conditional Modifier

```swift
// File: Core/Modifiers/ConditionalModifier.swift
import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
```

---

## 4. Component State Matrix

Quick reference for which states each component must support:

| Component | Default | Selected | Pressed | Disabled | Loading | Error |
|-----------|---------|----------|---------|----------|---------|-------|
| PBButton | ✅ | — | ✅ (scale 0.97) | ✅ (50% opacity) | ✅ (spinner) | — |
| PBCard | ✅ | — | ✅ (scale 0.97) | — | — | — |
| PBColorSwatch | ✅ | ✅ (enlarged + check) | — | — | — | — |
| PBCategoryPill | ✅ | ✅ (teal fill) | — | — | — | — |
| PBStatusBadge | ✅ | — | — | — | — | — |
| PBToast | — | — | — | — | — | ✅ (warning style) |
| PBParentalGate | ✅ | — | — | ✅ (continue btn) | — | ✅ (shake + message) |

---

End of Component Library.
