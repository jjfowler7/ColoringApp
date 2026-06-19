import SwiftUI

// COLOR-002: Reusable gradient slider for brightness and opacity
// Per mockup: label (22pt) + track (flex×8pt, pill) + thumb (18pt white circle)
struct ColorSliderView: View {
    let label: String
    let gradientColors: [Color]
    let hasCheckerboard: Bool
    @Binding var value: CGFloat // 0...1

    private let trackHeight: CGFloat = 8
    private let thumbSize: CGFloat = 18

    var body: some View {
        HStack(spacing: 10) {
            // Label ("B" or "α")
            Text(label)
                .font(PBTokens.Typography.nunitoSans(.semibold, size: 12))
                .foregroundColor(PBTokens.Colors.softGraphite)
                .frame(width: 22, alignment: .trailing)

            // Track with gesture
            GeometryReader { geo in
                let trackWidth = geo.size.width

                ZStack(alignment: .leading) {
                    // Checkerboard background (for opacity slider)
                    if hasCheckerboard {
                        checkerboardPattern()
                            .frame(height: trackHeight)
                            .clipShape(Capsule())
                    }

                    // Gradient fill
                    Capsule()
                        .fill(LinearGradient(colors: gradientColors, startPoint: .leading, endPoint: .trailing))
                        .frame(height: trackHeight)

                    // Thumb
                    Circle()
                        .fill(.white)
                        .frame(width: thumbSize, height: thumbSize)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 0.106, green: 0.165, blue: 0.29).opacity(0.08), lineWidth: 1)
                        )
                        .shadow(color: Color(red: 0.106, green: 0.165, blue: 0.29).opacity(0.18),
                                radius: 8, x: 0, y: 2) // radius 8 per spec
                        .position(x: value * trackWidth, y: geo.size.height / 2)
                }
                .frame(height: geo.size.height)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { drag in
                            value = max(0, min(1, drag.location.x / trackWidth))
                        }
                )
            }
            .frame(height: max(thumbSize, trackHeight))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label) slider")
        .accessibilityValue("\(Int(value * 100))%")
    }

    // Simple checkerboard pattern for the opacity slider background
    private func checkerboardPattern() -> some View {
        Canvas { context, size in
            let cellSize: CGFloat = 8 // 8pt cells per spec
            let cols = Int(ceil(size.width / cellSize))
            let rows = Int(ceil(size.height / cellSize))
            for row in 0..<rows {
                for col in 0..<cols {
                    if (row + col) % 2 == 0 {
                        let rect = CGRect(x: CGFloat(col) * cellSize,
                                          y: CGFloat(row) * cellSize,
                                          width: cellSize, height: cellSize)
                        context.fill(Path(rect), with: .color(Color(white: 0.87)))
                    }
                }
            }
        }
    }
}
