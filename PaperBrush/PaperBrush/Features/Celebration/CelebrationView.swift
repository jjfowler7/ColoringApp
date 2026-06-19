import SwiftUI

// ANIM-001: Celebration screen — Screen 05
// Placeholder: full implementation in Sprint 3.4
struct CelebrationView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: PBTokens.Spacing.lg) {
            Spacer()
            Text("Amazing work!")
                .font(PBTokens.Typography.heroTitle)
                .foregroundColor(PBTokens.Colors.deepNavy)
            Text("Placeholder — Sprint 3.4")
                .font(PBTokens.Typography.body)
                .foregroundColor(PBTokens.Colors.softGraphite)
            Spacer()
            PBButton("Done") { dismiss() }
                .padding(.horizontal, PBTokens.Spacing.xl)
                .padding(.bottom, PBTokens.Spacing.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PBTokens.Colors.warmCream.ignoresSafeArea())
    }
}
