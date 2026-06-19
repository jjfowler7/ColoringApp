import SwiftUI

// COLOR-002: Custom color picker sheet
// Per mockup (screen-03c-canvas-creator.html): vertical stack with
// drag handle → title → HSB wheel → brightness slider → opacity slider →
// hex row (Creator) → recent colors → Apply button
struct ColorPickerSheetView: View {
    let initialColor: UIColor
    let tier: AgeTier
    let onColorSelected: (UIColor) -> Void

    @State private var hue: CGFloat
    @State private var saturation: CGFloat
    @State private var brightness: CGFloat
    @State private var opacity: CGFloat
    @State private var hexText: String
    @State private var isHexInvalid: Bool = false
    @State private var recentColors: [String]

    @Environment(\.dismiss) private var dismiss

    init(initialColor: UIColor, tier: AgeTier, onColorSelected: @escaping (UIColor) -> Void) {
        self.initialColor = initialColor
        self.tier = tier
        self.onColorSelected = onColorSelected

        let hsb = initialColor.hsbComponents
        _hue = State(initialValue: hsb.hue)
        _saturation = State(initialValue: hsb.saturation)
        // If brightness is very low (e.g. black), default to full brightness
        // so the preview matches what the wheel visually shows
        _brightness = State(initialValue: hsb.brightness < 0.1 ? 1.0 : hsb.brightness)
        _opacity = State(initialValue: hsb.alpha)
        _hexText = State(initialValue: "#\(initialColor.hexString)")
        _recentColors = State(initialValue: UserPreferences.shared.recentCustomColors)
    }

    /// The color derived from current HSB + opacity state
    private var currentColor: UIColor {
        UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: opacity)
    }

    /// The fully-saturated hue color (for slider gradients)
    private var pureHueColor: Color {
        Color(hue: Double(hue), saturation: Double(saturation), brightness: 1)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Drag handle — 36×5pt pill, Light Divider, 12pt top / 16pt below
            Capsule()
                .fill(PBTokens.Colors.lightDivider)
                .frame(width: 36, height: 5)
                .padding(.top, 12)
                .padding(.bottom, 16)

            // Title + live color preview
            HStack(spacing: PBTokens.Spacing.md) {
                Spacer()

                Text("Custom Color")
                    .font(PBTokens.Typography.nunito(.bold, size: 16))
                    .foregroundColor(PBTokens.Colors.deepNavy)

                Spacer()

                // Live preview swatch — 48×48pt, updates in real-time
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hue: Double(hue), saturation: Double(saturation),
                                brightness: Double(brightness), opacity: Double(opacity)))
                    .frame(width: 48, height: 48)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(PBTokens.Colors.lightDivider, lineWidth: 1)
                    )
                    .shadow(color: Color(red: 0.106, green: 0.165, blue: 0.29).opacity(0.12),
                            radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)

            // HSB Wheel — 180×180pt
            HSBWheelView(hue: $hue, saturation: $saturation)
                .padding(.bottom, 12)

            // Brightness slider — label "B", gradient: black → current hue color
            ColorSliderView(
                label: "B",
                gradientColors: [.black, pureHueColor],
                hasCheckerboard: false,
                value: $brightness
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 12)

            // Opacity slider — label "α", checkerboard + gradient: transparent → current color
            ColorSliderView(
                label: "α",
                gradientColors: [
                    Color(hue: Double(hue), saturation: Double(saturation),
                          brightness: Double(brightness)).opacity(0),
                    Color(hue: Double(hue), saturation: Double(saturation),
                          brightness: Double(brightness))
                ],
                hasCheckerboard: true,
                value: $opacity
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 16)

            // Hex input — Creator tier only
            if tier.hasHexInput {
                HexInputView(
                    hue: $hue,
                    saturation: $saturation,
                    brightness: $brightness,
                    opacity: $opacity,
                    hexText: $hexText,
                    isHexInvalid: $isHexInvalid
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }

            // Recent colors row — scrollable to show all saved colors
            if !recentColors.isEmpty {
                HStack(spacing: 0) {
                    Text("RECENT")
                        .font(PBTokens.Typography.nunitoSans(.semibold, size: 11))
                        .foregroundColor(PBTokens.Colors.softGraphite)
                        .tracking(0.4)
                        .padding(.trailing, 8)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) { // 6pt per spec §2.2.5
                            ForEach(recentColors, id: \.self) { hex in
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 24, height: 24)
                                    .shadow(color: Color(red: 0.106, green: 0.165, blue: 0.29).opacity(0.12),
                                            radius: 2, x: 0, y: 1)
                                    .onTapGesture {
                                        applyRecentColor(hex)
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }

            Spacer()

            // Select Color button — Deep Navy bg, 48pt, 10pt radius
            Button {
                applyColor()
            } label: {
                Text("Select Color")
                    .font(PBTokens.Typography.nunito(.bold, size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(PBTokens.Colors.richTeal) // Rich Teal per spec §2.2.5
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color(red: 0.106, green: 0.165, blue: 0.29).opacity(0.18),
                            radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(PBTokens.Colors.softCanvas)
    }

    // MARK: - Actions

    private func applyColor() {
        // Validate hex if Creator tier
        if tier.hasHexInput && isHexInvalid {
            return
        }

        let uiColor = currentColor
        let hex = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1).hexString

        // Save to recent colors (avoid duplicates, UserPreferences handles the max limit)
        var recents = UserPreferences.shared.recentCustomColors
        recents.removeAll { $0.uppercased() == hex.uppercased() }
        recents.insert(hex, at: 0)
        UserPreferences.shared.recentCustomColors = recents
        recentColors = UserPreferences.shared.recentCustomColors

        onColorSelected(uiColor)
        dismiss()
    }

    private func applyRecentColor(_ hex: String) {
        guard let color = HexColorValidator.color(from: hex) else { return }
        let hsb = color.hsbComponents
        hue = hsb.hue
        saturation = hsb.saturation
        brightness = hsb.brightness
        hexText = "#\(hex.uppercased())"
    }
}
