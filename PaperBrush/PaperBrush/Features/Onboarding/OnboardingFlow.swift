import SwiftUI

/// Container for the onboarding sequence: Welcome → Age Tier Selection.
/// Shown only on first launch. Calls onComplete when finished.
struct OnboardingFlow: View {
    let onComplete: () -> Void

    @State private var showTierSelection = false

    var body: some View {
        if showTierSelection {
            AgeTierSelectionView { tier in
                UserPreferences.shared.selectedTier = tier
                onComplete()
            }
        } else {
            WelcomeSplashView(
                onGetStarted: {
                    showTierSelection = true
                },
                onSkip: {
                    // Skip sets Explorer as default tier
                    UserPreferences.shared.selectedTier = .explorer
                    onComplete()
                }
            )
        }
    }
}
