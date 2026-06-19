import SwiftUI

// ONBOARD-001: Welcome splash — Screen 01 per design spec §2.1.1
struct WelcomeSplashView: View {
    let onGetStarted: () -> Void
    let onSkip: () -> Void

    @State private var iconVisible = false
    @State private var textVisible = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // App icon with spring entrance animation
            appIcon
                .padding(.bottom, PBTokens.Spacing.lg)

            // Title and tagline fade in after icon
            titleAndTagline

            Spacer()

            // Action buttons at the bottom
            actionButtons
                .padding(.bottom, PBTokens.Spacing.xl)
        }
        .padding(.horizontal, PBTokens.Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PBTokens.Colors.warmCream.ignoresSafeArea())
        .statusBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                iconVisible = true
            }
            withAnimation(PBTokens.Animation.expressive.delay(0.35)) {
                textVisible = true
            }
        }
    }

    // MARK: - Components

    private var appIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: PBTokens.CornerRadius.xl) // 32pt per spec
                .fill(PBTokens.Colors.richTeal)
                .frame(width: 120, height: 120)
                .pbShadow(PBTokens.Shadows.level2) // Level 2 per spec §2.1.1

            Image(systemName: "paintbrush.pointed.fill")
                .font(.system(size: 48))
                .foregroundColor(.white)
        }
        .scaleEffect(iconVisible ? 1.0 : 0.0)
        .accessibilityLabel("PaperBrush app icon")
    }

    private var titleAndTagline: some View {
        VStack(spacing: PBTokens.Spacing.sm) {
            Text("PaperBrush")
                .font(PBTokens.Typography.heroTitle)
                .foregroundColor(PBTokens.Colors.deepNavy)

            Text("Where your art comes alive")
                .font(PBTokens.Typography.nunitoSans(.regular, size: 17))
                .foregroundColor(PBTokens.Colors.softGraphite)
        }
        .opacity(textVisible ? 1.0 : 0.0)
        .offset(y: textVisible ? 0 : 10) // fadeUp per spec §2.1.1
    }

    private var actionButtons: some View {
        VStack(spacing: PBTokens.Spacing.md) {
            PBButton("Get Started") {
                onGetStarted()
            }
            .frame(maxWidth: 500) // caps button width on iPad

            Button {
                onSkip()
            } label: {
                HStack(spacing: PBTokens.Spacing.xs) {
                    Text("Skip")
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                }
                .font(PBTokens.Typography.nunitoSans(.semibold, size: 15))
                .foregroundColor(PBTokens.Colors.softGraphite)
            }
            .accessibilityLabel("Skip onboarding")
        }
        .opacity(textVisible ? 1.0 : 0.0)
    }
}
