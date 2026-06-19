import Foundation

/// Protocol for StoreKit 2 purchase operations.
/// Real implementation: PurchaseManager.shared. Tests inject mocks.
protocol PurchaseManagerProtocol {
    /// Whether the user has purchased the full unlock ($14.99 one-time)
    var isFullVersionUnlocked: Bool { get }

    /// Initiates the purchase flow for the full unlock
    func purchase() async throws

    /// Restores previous purchases from the App Store
    func restorePurchases() async throws
}
