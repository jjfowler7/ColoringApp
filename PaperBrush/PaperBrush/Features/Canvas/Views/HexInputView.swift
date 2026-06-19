import SwiftUI

// COLOR-002: Hex code input row for Creator tier
// Per mockup: Warm Cream bg, Light Divider border, 10pt radius,
// "Hex" label + monospace value field + copy button
struct HexInputView: View {
    @Binding var hue: CGFloat
    @Binding var saturation: CGFloat
    @Binding var brightness: CGFloat
    @Binding var opacity: CGFloat
    @Binding var hexText: String
    @Binding var isHexInvalid: Bool

    @FocusState private var isFieldFocused: Bool

    var body: some View {
        HStack(spacing: PBTokens.Spacing.sm) {
            // "Hex" label
            Text("Hex")
                .font(PBTokens.Typography.nunitoSans(.semibold, size: 13))
                .foregroundColor(PBTokens.Colors.softGraphite)

            // Editable hex value field (SF Mono / Courier)
            TextField("#0EA5A0", text: $hexText)
                .font(.system(size: 14, design: .monospaced).weight(.semibold))
                .foregroundColor(PBTokens.Colors.softGraphite)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .focused($isFieldFocused)
                .tint(PBTokens.Colors.richTeal) // teal caret color
                .onSubmit { applyHexToHSB() }
                .onChange(of: hexText) { _ in
                    if isHexInvalid { isHexInvalid = false }
                }

            Spacer()

            // Copy to clipboard button (28×28pt, 6pt radius, teal icon)
            Button {
                UIPasteboard.general.string = hexText.hasPrefix("#") ? hexText : "#\(hexText)"
            } label: {
                Image(systemName: "doc.on.clipboard")
                    .font(.system(size: 16))
                    .foregroundColor(PBTokens.Colors.richTeal)
                    .frame(width: 28, height: 28)
            }
            .accessibilityLabel("Copy hex color to clipboard")
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(PBTokens.Colors.warmCream)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isHexInvalid ? PBTokens.Colors.sunsetCoral : PBTokens.Colors.lightDivider,
                        lineWidth: isHexInvalid ? 2 : 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        // Sync hex from HSB when wheel/sliders change (but not while user is typing)
        .onChange(of: hue) { _ in syncHexFromHSB() }
        .onChange(of: saturation) { _ in syncHexFromHSB() }
        .onChange(of: brightness) { _ in syncHexFromHSB() }
    }

    private func syncHexFromHSB() {
        guard !isFieldFocused else { return }
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        hexText = "#\(color.hexString)"
    }

    private func applyHexToHSB() {
        let input = hexText.replacingOccurrences(of: "#", with: "")
        guard let color = HexColorValidator.color(from: input) else {
            isHexInvalid = true
            return
        }
        let hsb = color.hsbComponents
        hue = hsb.hue
        saturation = hsb.saturation
        brightness = hsb.brightness
        opacity = 1.0 // hex colors are always fully opaque
        hexText = "#\(color.hexString)"
        isHexInvalid = false
    }
}
