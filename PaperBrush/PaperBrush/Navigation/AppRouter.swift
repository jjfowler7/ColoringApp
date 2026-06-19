import SwiftUI
import Combine

/// Centralized navigation state for PaperBrush.
/// Manages the NavigationStack path and all modal presentations.
/// Note: implicitly @MainActor via Swift 6.2 default actor isolation.
final class AppRouter: @preconcurrency ObservableObject {
    @Published var path = NavigationPath()

    // MARK: - Modal State
    @Published var showParentalGate: Bool = false
    @Published var showIAPSheet: Bool = false
    @Published var showColorPicker: Bool = false
    @Published var showCelebration: Bool = false
    @Published var showPassAndPlaySetup: Bool = false
    @Published var showTurnHandoff: Bool = false
    @Published var showPauseOverlay: Bool = false
    @Published var showPDFExport: Bool = false

    // Parental gate callback — what to do after gate passes
    var parentalGateCompletion: (@MainActor @Sendable () -> Void)?

    // Grace period tracking — in-memory only, resets on app termination (SAFETY-002)
    private var gateGracePeriodExpiry: Date?

    var isWithinGracePeriod: Bool {
        guard let expiry = gateGracePeriodExpiry else { return false }
        return Date() < expiry
    }

    // MARK: - Push Navigation

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    // MARK: - Gated Navigation

    /// Use for any action requiring parental gate (IAP, share, settings, etc.).
    /// If within the 5-minute grace period and forceGate is false, executes immediately.
    func requireParentalGate(
        forceGate: Bool = false,
        then action: @escaping @MainActor @Sendable () -> Void
    ) {
        if isWithinGracePeriod && !forceGate {
            action()
        } else {
            parentalGateCompletion = action
            showParentalGate = true
        }
    }

    func parentalGateSucceeded() {
        gateGracePeriodExpiry = Date().addingTimeInterval(5 * 60) // 5-minute grace
        showParentalGate = false
        parentalGateCompletion?()
        parentalGateCompletion = nil
    }

    func parentalGateCancelled() {
        showParentalGate = false
        parentalGateCompletion = nil
    }

    // MARK: - Convenience Actions

    func navigateToSettings() {
        requireParentalGate { @MainActor [weak self] in
            self?.push(.settings)
        }
    }

    func navigateToIAP() {
        showIAPSheet = true
    }

    func triggerCelebration() {
        showCelebration = true
    }

    /// Share actions ALWAYS require gate, even within grace period (design spec §2.4)
    func requestShare(then action: @escaping @MainActor @Sendable () -> Void) {
        requireParentalGate(forceGate: true, then: action)
    }
}
