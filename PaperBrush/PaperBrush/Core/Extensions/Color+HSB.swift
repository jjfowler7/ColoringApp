import SwiftUI

// COLOR-002: HSB conversion utilities for the custom color picker

extension UIColor {
    /// Returns the HSB components of this color (all values 0...1).
    var hsbComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }

    /// Returns a 6-character uppercase hex string (no # prefix).
    var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return String(format: "%02X%02X%02X",
                      Int((r * 255).rounded()),
                      Int((g * 255).rounded()),
                      Int((b * 255).rounded()))
    }
}

/// Validates and normalizes hex color strings for the Creator tier hex input.
enum HexColorValidator {
    /// Returns a normalized 6-char uppercase hex string (no #), or nil if invalid.
    static func normalize(_ input: String) -> String? {
        let stripped = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        guard stripped.allSatisfy({ $0.isHexDigit }) else { return nil }
        switch stripped.count {
        case 3:
            return stripped.map { "\($0)\($0)" }.joined().uppercased()
        case 6:
            return stripped.uppercased()
        default:
            return nil
        }
    }

    /// Converts a validated hex string to UIColor.
    static func color(from hex: String) -> UIColor? {
        guard let normalized = normalize(hex) else { return nil }
        var int: UInt64 = 0
        Scanner(string: normalized).scanHexInt64(&int)
        let r = CGFloat((int >> 16) & 0xFF) / 255.0
        let g = CGFloat((int >> 8) & 0xFF) / 255.0
        let b = CGFloat(int & 0xFF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
