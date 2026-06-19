import SwiftUI

// COLOR-001: Scrollable 24-color palette + custom colors from picker
struct ColorTrayView: View {
    @ObservedObject var viewModel: CanvasViewModel

    private let tier = UserPreferences.shared.selectedTier
    private var isDoodler: Bool { tier == .doodler }
    // Custom colors displayed in the tray — separate from picker's "Recent" row.
    // Removing here does NOT affect the picker's recent colors list.
    @State private var trayCustomColors: [String] = UserPreferences.shared.recentCustomColors
    private let maxTrayCustomColors = 8

    /// 24 UIColors in spectral order using standard system UIColor
    static let paletteUIColors: [UIColor] = [
        .systemRed,                                                     // red
        UIColor(red: 0.957, green: 0.318, blue: 0.118, alpha: 1),     // red-orange
        .systemOrange,                                                  // orange
        UIColor(red: 1.000, green: 0.702, blue: 0.000, alpha: 1),     // amber
        .systemYellow,                                                  // yellow
        UIColor(red: 0.753, green: 0.792, blue: 0.200, alpha: 1),     // lime
        .systemGreen,                                                   // green
        .systemTeal,                                                    // teal
        .systemCyan,                                                    // cyan
        UIColor(red: 0.012, green: 0.608, blue: 0.898, alpha: 1),     // sky blue
        .systemBlue,                                                    // blue
        .systemIndigo,                                                  // indigo
        UIColor(red: 0.369, green: 0.208, blue: 0.694, alpha: 1),     // violet
        .systemPurple,                                                  // purple
        UIColor(red: 0.847, green: 0.106, blue: 0.376, alpha: 1),     // magenta
        .systemPink,                                                    // pink
        UIColor(red: 0.941, green: 0.384, blue: 0.573, alpha: 1),     // hot pink
        .brown,                                                         // brown
        UIColor(red: 0.843, green: 0.800, blue: 0.784, alpha: 1),     // tan
        UIColor(red: 1.000, green: 0.800, blue: 0.737, alpha: 1),     // skin light
        UIColor(red: 0.737, green: 0.667, blue: 0.643, alpha: 1),     // skin medium
        UIColor(red: 0.365, green: 0.251, blue: 0.216, alpha: 1),     // skin dark
        .black,                                                         // black
        .white,                                                         // white
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: isDoodler ? 10 : PBTokens.Spacing.sm) { // Spec: Doodler 10pt, others 8pt
                ForEach(Array(Self.paletteUIColors.enumerated()), id: \.offset) { index, uiColor in
                    let swiftUIColor = Color(uiColor)
                    PBColorSwatch(
                        color: swiftUIColor,
                        isSelected: viewModel.selectedColorIndex == index,
                        isDoodler: isDoodler
                    ) {
                        viewModel.selectColor(uiColor: uiColor, index: index)
                    }
                }

                if tier.hasCustomColorPicker {
                    // "+" button → opens color picker
                    Button {
                        viewModel.showColorPicker = true
                    } label: {
                        Circle()
                            .stroke(PBTokens.Colors.lightDivider, style: StrokeStyle(lineWidth: 2, dash: [4]))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(PBTokens.Colors.softGraphite)
                            )
                    }
                    .accessibilityLabel("Add custom color")
                    .sheet(isPresented: $viewModel.showColorPicker, onDismiss: {
                        trayCustomColors = UserPreferences.shared.recentCustomColors
                    }) {
                        ColorPickerSheetView(
                            initialColor: viewModel.currentUIColor,
                            tier: tier,
                            onColorSelected: { viewModel.applyCustomColor($0) }
                        )
                        .presentationDetents([.fraction(tier == .creator ? 0.82 : 0.65)])
                        .presentationDragIndicator(.hidden)
                    }

                    // Custom colors — newest first (left to right), max 8
                    // Long-press to remove from tray (does not affect picker's Recent row)
                    ForEach(Array(trayCustomColors.prefix(maxTrayCustomColors).enumerated()), id: \.element) { idx, hex in
                        let uiColor = HexColorValidator.color(from: hex) ?? .gray
                        let customIndex = Self.paletteUIColors.count + idx

                        PBColorSwatch(
                            color: Color(uiColor),
                            isSelected: viewModel.selectedColorIndex == customIndex,
                            isDoodler: isDoodler
                        ) {
                            viewModel.selectColor(uiColor: uiColor, index: customIndex)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                removeCustomColor(hex: hex)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, PBTokens.Spacing.md)
        }
        .padding(.vertical, PBTokens.Spacing.sm)
        .frame(maxWidth: .infinity)
        .background(PBTokens.Colors.softCanvas)
    }

    private func removeCustomColor(hex: String) {
        // Only removes from the tray display — does NOT affect picker's "Recent" row
        trayCustomColors.removeAll { $0.uppercased() == hex.uppercased() }
    }
}
