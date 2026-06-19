import SwiftUI

// IAP-001: In-app purchase sheet — Screen 08
// Placeholder: full implementation in Sprint 4.1
struct IAPSheetView: View {
    var body: some View {
        VStack(spacing: PBTokens.Spacing.lg) {
            Text("Unlock Everything")
                .font(PBTokens.Typography.screenHeader)
                .foregroundColor(PBTokens.Colors.deepNavy)
            Text("$14.99 — One-time purchase")
                .font(PBTokens.Typography.body)
                .foregroundColor(PBTokens.Colors.softGraphite)
            Text("Placeholder — Sprint 4.1")
                .font(PBTokens.Typography.caption)
                .foregroundColor(PBTokens.Colors.softGraphite)
        }
        .padding(PBTokens.Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PBTokens.Colors.softCanvas.ignoresSafeArea())
    }
}
