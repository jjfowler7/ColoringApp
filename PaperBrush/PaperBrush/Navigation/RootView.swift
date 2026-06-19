import SwiftUI

/// Root view that switches between onboarding and the main app.
/// Also hosts global modal presentations (parental gate, celebration).
struct RootView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var hasCompletedOnboarding = UserPreferences.shared.hasCompletedOnboarding

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainNavigationView()
            } else {
                OnboardingFlow(onComplete: {
                    UserPreferences.shared.hasCompletedOnboarding = true
                    hasCompletedOnboarding = true
                })
            }
        }
        // Global modal presentations — attached at the root so they work from any screen
        .fullScreenCover(isPresented: $router.showParentalGate) {
            ParentalGateView(
                onSuccess: { router.parentalGateSucceeded() },
                onCancel: { router.parentalGateCancelled() }
            )
        }
        .fullScreenCover(isPresented: $router.showCelebration) {
            CelebrationView()
        }
    }
}
