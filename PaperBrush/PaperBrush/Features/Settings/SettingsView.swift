import SwiftUI

// Settings — Screen 12
// Placeholder: full implementation in Sprint 4.3
struct SettingsView: View {
    var body: some View {
        VStack(spacing: PBTokens.Spacing.lg) {
            Text("Settings")
                .font(PBTokens.Typography.screenHeader)
                .foregroundColor(PBTokens.Colors.deepNavy)
            Text("Placeholder — Sprint 4.3")
                .font(PBTokens.Typography.body)
                .foregroundColor(PBTokens.Colors.softGraphite)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PBTokens.Colors.warmCream.ignoresSafeArea())
    }
}
