import SwiftUI

// BRUSH-001: Stamp shapes available for the stamp tool
enum StampShape: String, CaseIterable, Codable {
    case star = "star.fill"
    case heart = "heart.fill"
    case circle = "circle.fill"
    case diamond = "diamond.fill"
    case moon = "moon.fill"
    case sun = "sun.max.fill"
    case cloud = "cloud.fill"
    case bolt = "bolt.fill"
    case flame = "flame.fill"
    case leaf = "leaf.fill"
    case flower = "camera.macro"
    case snowflake = "snowflake"
    case paw = "pawprint.fill"
    case bird = "bird.fill"
    case fish = "fish.fill"
    case hare = "hare.fill"
    case crown = "crown.fill"
    case bell = "bell.fill"
    case gift = "gift.fill"
    case balloon = "balloon.fill"

    var displayName: String {
        switch self {
        case .star: return "Star"
        case .heart: return "Heart"
        case .circle: return "Circle"
        case .diamond: return "Diamond"
        case .moon: return "Moon"
        case .sun: return "Sun"
        case .cloud: return "Cloud"
        case .bolt: return "Lightning"
        case .flame: return "Flame"
        case .leaf: return "Leaf"
        case .flower: return "Flower"
        case .snowflake: return "Snowflake"
        case .paw: return "Paw"
        case .bird: return "Bird"
        case .fish: return "Fish"
        case .hare: return "Bunny"
        case .crown: return "Crown"
        case .bell: return "Bell"
        case .gift: return "Gift"
        case .balloon: return "Balloon"
        }
    }
}

// MARK: - Stamp Shape Picker (shown when stamp tool is active)

struct StampShapePickerView: View {
    @Binding var selectedShape: StampShape
    @Binding var isPresented: Bool

    let columns = [GridItem(.adaptive(minimum: 56))]

    var body: some View {
        VStack(spacing: PBTokens.Spacing.md) {
            Text("Choose a Stamp")
                .font(PBTokens.Typography.sectionHeader)
                .foregroundColor(PBTokens.Colors.deepNavy)

            LazyVGrid(columns: columns, spacing: PBTokens.Spacing.md) {
                ForEach(StampShape.allCases, id: \.self) { shape in
                    Button {
                        selectedShape = shape
                        isPresented = false
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: shape.rawValue)
                                .font(.system(size: 28))
                                .foregroundColor(
                                    selectedShape == shape
                                        ? PBTokens.Colors.richTeal
                                        : PBTokens.Colors.deepNavy
                                )
                                .frame(width: 48, height: 48)
                                .background(
                                    selectedShape == shape
                                        ? PBTokens.Colors.richTeal.opacity(0.1)
                                        : Color.clear
                                )
                                .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.sm))

                            Text(shape.displayName)
                                .font(PBTokens.Typography.caption)
                                .foregroundColor(PBTokens.Colors.softGraphite)
                        }
                    }
                    .accessibilityLabel(shape.displayName)
                }
            }
            .padding(.horizontal, PBTokens.Spacing.md)
        }
        .padding(.vertical, PBTokens.Spacing.lg)
        .background(PBTokens.Colors.softCanvas)
    }
}

// MARK: - Stamp data for rendering

struct PlacedStamp: Identifiable, Codable {
    let id: UUID
    let shape: StampShape
    let position: CGPoint
    let size: CGFloat
    let colorHex: String // UIColor encoded as hex for Codable

    // Convenience computed property for UIColor access
    var color: UIColor {
        HexColorValidator.color(from: colorHex) ?? .black
    }

    init(id: UUID = UUID(), shape: StampShape, position: CGPoint, size: CGFloat, color: UIColor) {
        self.id = id
        self.shape = shape
        self.position = position
        self.size = size
        self.colorHex = color.hexString
    }
}

// MARK: - Stamp Overlay (transparent, placed on top of PencilKit canvas)

struct StampOverlayView: View {
    let stamps: [PlacedStamp]
    let isStampMode: Bool
    let isEraserMode: Bool
    let onTap: (CGPoint) -> Void
    let onEraseStamp: (UUID) -> Void

    var body: some View {
        ZStack {
            // Transparent tap area for stamp placement
            if isStampMode {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { location in
                        onTap(location)
                    }
            }

            // Render placed stamps — each is individually tappable in eraser mode
            ForEach(stamps) { stamp in
                Image(systemName: stamp.shape.rawValue)
                    .font(.system(size: stamp.size))
                    .foregroundColor(Color(stamp.color))
                    .position(stamp.position)
                    .if(isEraserMode) { view in
                        view.onTapGesture {
                            onEraseStamp(stamp.id)
                        }
                    }
            }
        }
        // Only block touches in stamp mode. In eraser mode, only individual stamps are tappable,
        // so PencilKit can still receive touches for stroke erasing everywhere else.
        .allowsHitTesting(isStampMode || isEraserMode)
    }
}
