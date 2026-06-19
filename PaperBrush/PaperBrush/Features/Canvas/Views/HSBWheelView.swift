import SwiftUI

// COLOR-002: Full conic-gradient HSB wheel with draggable selector
// Per mockup: 180×180pt circle, conic gradient with radial white overlay,
// 20pt selector dot with 3pt white border
struct HSBWheelView: View {
    @Binding var hue: CGFloat       // 0...1 (angle on wheel)
    @Binding var saturation: CGFloat // 0...1 (distance from center)

    private let wheelSize: CGFloat = 240 // 240pt per spec §2.2.5
    private let selectorSize: CGFloat = 20
    private var radius: CGFloat { wheelSize / 2 }

    // 13 hue stops at 30° intervals matching the mockup's conic-gradient
    private var hueStops: [Color] {
        stride(from: 0.0, through: 360.0, by: 30.0).map { deg in
            Color(hue: deg / 360.0, saturation: 1, brightness: 1)
        }
    }

    /// The currently selected color (for the selector dot fill)
    private var selectedColor: Color {
        Color(hue: Double(hue), saturation: Double(saturation), brightness: 1)
    }

    /// Selector position on the wheel surface
    private var selectorPosition: CGPoint {
        // Angle: hue maps to angle, 0=right (3 o'clock) in atan2 space
        // The conic gradient starts at top by default in SwiftUI, so we offset
        let angle = hue * 2 * .pi - .pi / 2
        let dist = saturation * (radius - selectorSize / 2) // keep dot inside wheel
        return CGPoint(
            x: radius + dist * cos(angle),
            y: radius + dist * sin(angle)
        )
    }

    var body: some View {
        ZStack {
            // Layer 1: Conic hue gradient (full 360° spectrum)
            Circle()
                .fill(
                    AngularGradient(
                        gradient: Gradient(colors: hueStops),
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    )
                )
                .frame(width: wheelSize, height: wheelSize)

            // Layer 2: Radial white overlay (creates saturation falloff toward center)
            // Per mockup: rgba(255,255,255,0.92) at center → transparent at 70%
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white.opacity(0.92), location: 0),
                            .init(color: Color.white.opacity(0), location: 0.7)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: radius
                    )
                )
                .frame(width: wheelSize, height: wheelSize)

            // Layer 3: Subtle shadow ring for depth
            Circle()
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                .frame(width: wheelSize, height: wheelSize)

            // Layer 4: Selector dot — 20pt circle, 3pt white border, shadow
            Circle()
                .fill(selectedColor)
                .frame(width: selectorSize, height: selectorSize)
                .overlay(
                    Circle()
                        .stroke(.white, lineWidth: 3)
                )
                .shadow(color: Color(red: 0.106, green: 0.165, blue: 0.29).opacity(0.3),
                        radius: 4, x: 0, y: 2)
                .position(selectorPosition)
        }
        .frame(width: wheelSize, height: wheelSize)
        // Shadow on the wheel itself (per mockup: 0 4px 16px rgba(27,42,74,0.12))
        .shadow(color: Color(red: 0.106, green: 0.165, blue: 0.29).opacity(0.12),
                radius: 8, x: 0, y: 4)
        .gesture(wheelDragGesture)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Color wheel. Drag to select hue and saturation.")
    }

    // MARK: - Gesture

    private var wheelDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let loc = value.location
                let dx = loc.x - radius
                let dy = loc.y - radius
                let dist = hypot(dx, dy)

                // Only respond to touches within the wheel circle
                guard dist <= radius else { return }

                // Hue from angle (0 at top / 12 o'clock)
                var angle = atan2(dy, dx) + .pi / 2
                if angle < 0 { angle += 2 * .pi }
                hue = max(0, min(1, angle / (2 * .pi)))

                // Saturation from distance to center (0=center, 1=edge)
                saturation = max(0, min(1, dist / radius))
            }
    }
}
