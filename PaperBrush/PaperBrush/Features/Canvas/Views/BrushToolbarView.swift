import SwiftUI

// BRUSH-003: Horizontal brush picker, tier-aware
struct BrushToolbarView: View {
    @ObservedObject var viewModel: CanvasViewModel

    @State private var tooltipName: String?
    @State private var tooltipVisible = false

    private let tier = UserPreferences.shared.selectedTier
    private var brushes: [BrushType] {
        tier == .doodler ? BrushType.doodlerBrushes : BrushType.allCases
    }
    private var iconSize: CGFloat { tier == .doodler ? 64 : 48 }
    private var showLabels: Bool { tier == .doodler }

    var body: some View {
        ZStack(alignment: .top) {
            // Floating tooltip pill — appears above the brush row on selection
            if tooltipVisible, let name = tooltipName {
                Text(name)
                    .font(PBTokens.Typography.nunito(.bold, size: 13))
                    .foregroundColor(.white)
                    .padding(.horizontal, PBTokens.Spacing.md)
                    .padding(.vertical, PBTokens.Spacing.xs)
                    .background(PBTokens.Colors.deepNavy.opacity(0.85))
                    .clipShape(Capsule())
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .offset(y: -36)
                    .zIndex(1)
            }

            // Brush icons row — scrollable when many brushes on small screen
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: PBTokens.Spacing.sm) {
                    ForEach(brushes, id: \.self) { brush in
                        brushButton(brush)
                    }
                }
                .padding(.horizontal, PBTokens.Spacing.md)
                .padding(.vertical, PBTokens.Spacing.sm)
            }
            .frame(maxWidth: .infinity)
        }
        .background(PBTokens.Colors.softCanvas)
    }

    private func brushButton(_ brush: BrushType) -> some View {
        let isSelected = viewModel.currentBrushType == brush

        return Button {
            viewModel.currentBrushType = brush
            showTooltip(brush.displayName)
            // Show stamp picker when stamp is selected
            if brush == .stamp {
                viewModel.showStampPicker = true
            }
        } label: {
            VStack(spacing: 2) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(PBTokens.Colors.tierAccent(tier).opacity(0.15))
                            .frame(width: iconSize, height: iconSize)
                    }

                    Image(systemName: sfSymbol(for: brush))
                        .font(.system(size: iconSize * 0.45))
                        .foregroundColor(isSelected ? PBTokens.Colors.richTeal : PBTokens.Colors.softGraphite)
                }
                .frame(width: iconSize, height: iconSize)

                if showLabels {
                    Text(brush.displayName)
                        .font(PBTokens.Typography.nunito(.bold, size: 11))
                        .foregroundColor(PBTokens.Colors.softGraphite)
                }
            }
        }
        .accessibilityLabel("\(brush.displayName) brush")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func showTooltip(_ name: String) {
        tooltipName = name
        withAnimation(PBTokens.Animation.quick) {
            tooltipVisible = true
        }
        // Auto-dismiss after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(PBTokens.Animation.standard) {
                tooltipVisible = false
            }
        }
    }

    private func sfSymbol(for brush: BrushType) -> String {
        switch brush {
        case .crayon:     return "pencil.tip"
        case .marker:     return "highlighter"
        case .watercolor: return "drop.fill"
        case .pencil:     return "pencil"
        case .stamp:      return "star.fill"
        case .eraser:     return "eraser.fill"
        }
    }
}
