# PaperBrush — Navigation Architecture

**Version 1.0 | March 2026 | Complete Navigation Graph + Routing Code**

---

## 1. Navigation Model

PaperBrush uses a **NavigationStack** with a typed path for push navigation, and **sheets/fullScreenCovers** for modal presentations. There is no tab bar.

### 1.1 Navigation Type Map

| Transition | Mechanism | Design Spec Animation |
|-----------|-----------|----------------------|
| Forward (screen to screen) | NavigationStack push | Slide from right |
| Back | NavigationStack pop | Slide to right |
| Modal sheets (IAP, color picker, PDF export, Pass&Play setup) | `.sheet` | Slide up from bottom with spring |
| Full-screen modals (celebration, parental gate, handoff) | `.fullScreenCover` | Slide up / custom |
| Dismiss modal | Environment dismiss | Slide down with gravity |
| Action sheet (canvas overflow menu) | `.confirmationDialog` | iOS native slide up |

---

## 2. Route Enum

```swift
// File: Navigation/Route.swift
import Foundation

enum Route: Hashable {
    // Main flow
    case contentBrowser
    case canvas(pageId: String)
    case canvasResume(artworkId: UUID)

    // Gallery
    case gallery
    case galleryFullscreen(artworkId: UUID)

    // Store
    case packStore

    // Settings (always preceded by parental gate)
    case settings
}
```

---

## 3. App Router

```swift
// File: Navigation/AppRouter.swift
import SwiftUI

@MainActor
final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()

    // Modal state
    @Published var showParentalGate: Bool = false
    @Published var showIAPSheet: Bool = false
    @Published var showColorPicker: Bool = false
    @Published var showCelebration: Bool = false
    @Published var showPassAndPlaySetup: Bool = false
    @Published var showTurnHandoff: Bool = false
    @Published var showPauseOverlay: Bool = false
    @Published var showPDFExport: Bool = false

    // Parental gate callback (what to do after gate passes)
    var parentalGateCompletion: (() -> Void)?

    // Grace period tracking (in-memory only, resets on app kill)
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

    /// Use this for any action requiring parental gate (IAP, share, settings, etc.)
    /// If within grace period, executes immediately. Otherwise shows gate first.
    func requireParentalGate(
        forceGate: Bool = false,
        then action: @escaping () -> Void
    ) {
        if isWithinGracePeriod && !forceGate {
            action()
        } else {
            parentalGateCompletion = {
                action()
            }
            showParentalGate = true
        }
    }

    func parentalGateSucceeded() {
        gateGracePeriodExpiry = Date().addingTimeInterval(5 * 60) // 5 min grace
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
        requireParentalGate { [weak self] in
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
    func requestShare(then action: @escaping () -> Void) {
        requireParentalGate(forceGate: true, then: action)
    }
}
```

---

## 4. Root View Structure

```swift
// File: PaperBrushApp.swift
import SwiftUI

@main
struct PaperBrushApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var preferences = UserPreferences.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
        }
    }
}
```

```swift
// File: Navigation/RootView.swift
import SwiftUI

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
        // Global modal presentations
        .fullScreenCover(isPresented: $router.showParentalGate) {
            PBParentalGate(
                onSuccess: { router.parentalGateSucceeded() },
                onCancel: { router.parentalGateCancelled() }
            )
        }
        .fullScreenCover(isPresented: $router.showCelebration) {
            CelebrationView()
        }
    }
}
```

```swift
// File: Navigation/MainNavigationView.swift
import SwiftUI

struct MainNavigationView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            // Default root: Content Browser (or resume canvas if in-progress)
            ContentBrowserView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .contentBrowser:
                        ContentBrowserView()

                    case .canvas(let pageId):
                        CanvasContainerView(pageId: pageId)

                    case .canvasResume(let artworkId):
                        CanvasContainerView(resumeArtworkId: artworkId)

                    case .gallery:
                        GalleryGridView()

                    case .galleryFullscreen(let artworkId):
                        GalleryFullscreenView(artworkId: artworkId)

                    case .packStore:
                        PackStoreView()

                    case .settings:
                        SettingsView()
                    }
                }
        }
    }
}
```

---

## 5. Complete Navigation Graph

```
APP LAUNCH
    │
    ├─ First time? → OnboardingFlow
    │   ├─ Screen 01: WelcomeSplashView
    │   │   ├─ "Get Started" → push AgeTierSelectionView
    │   │   └─ "Skip" → set Explorer, mark onboarding done → ContentBrowserView
    │   │
    │   └─ Screen 02: AgeTierSelectionView
    │       └─ Tap tier card → set tier, mark onboarding done →
    │          push Canvas with curated "first page" for selected tier
    │
    └─ Returning user? → MainNavigationView
        ├─ Has in-progress artwork? → push Canvas (resume)
        └─ No in-progress? → ContentBrowserView (root)


CONTENT BROWSER (Screen 04)                    ← NavigationStack root
    ├─ Pack Store icon     → push PackStoreView
    ├─ Gallery icon        → push GalleryGridView
    ├─ Settings icon       → parentalGate → push SettingsView
    ├─ Category pill tap   → filter pages (no navigation)
    ├─ Free page card tap  → push CanvasContainerView(pageId:)
    ├─ Locked page card    → sheet: IAPSheetView
    └─ In-progress card    → push CanvasContainerView(resumeArtworkId:)


CANVAS (Screen 03)                             ← pushed onto stack
    ├─ Back ‹              → pop to ContentBrowser
    ├─ Mute toggle         → toggle (no navigation)
    ├─ Overflow ⋯          → confirmationDialog:
    │   ├─ "Save to Gallery"   → save action, toast
    │   ├─ "Play Together"     → parentalGate → sheet: PlayerSetupView
    │   ├─ "Done! ✓"          → fullScreenCover: CelebrationView
    │   ├─ "Settings"         → parentalGate → push SettingsView
    │   └─ "Cancel"           → dismiss
    └─ Color "+" button    → sheet: ColorPickerSheetView


CELEBRATION (Screen 05)                        ← fullScreenCover
    ├─ Replay ↻            → replay animation (no navigation)
    ├─ Save 💾             → save action, toast
    ├─ Share 📤            → parentalGate(forceGate) → iOS share sheet
    └─ "Color another"     → dismiss celebration → pop to ContentBrowser


GALLERY (Screen 06)                            ← pushed onto stack
    ├─ Back ‹              → pop to ContentBrowser
    ├─ "+" button          → pop to ContentBrowser
    ├─ Card tap            → push GalleryFullscreenView
    └─ Long-press card     → context menu:
        ├─ "Share"         → parentalGate(forceGate) → iOS share sheet
        ├─ "Print"         → parentalGate → sheet: PDFExportView
        └─ "Delete"        → parentalGate → alert: delete confirmation


GALLERY FULLSCREEN (Screen 07)                 ← pushed onto stack
    ├─ Close ✕             → pop to Gallery
    ├─ Replay ↻            → replay animation (no navigation)
    ├─ Share 📤            → parentalGate(forceGate) → iOS share sheet
    ├─ Print 🖨            → parentalGate → sheet: PDFExportView
    ├─ "Continue Coloring" → pop to gallery, push CanvasContainerView(resume)
    └─ Swipe L/R           → page to prev/next artwork


IAP SHEET (Screen 08)                          ← .sheet
    ├─ "Unlock Everything" → parentalGate → StoreKit purchase flow
    ├─ "Restore Purchase"  → StoreKit restore
    ├─ "No thanks"         → dismiss sheet
    └─ Drag down           → dismiss sheet


PASS & PLAY SETUP (Screen 14)                  ← .sheet
    └─ "Start Coloring!"  → dismiss sheet → enter Pass & Play mode on canvas


PASS & PLAY IN-GAME
    ├─ Timer expires       → fullScreenCover: TurnHandoffView
    ├─ Pause ⏸            → fullScreenCover: PauseOverlayView
    │   ├─ "Resume"        → dismiss overlay, resume timer
    │   └─ "End Game"      → alert: end confirmation
    │       ├─ "Keep Playing" → dismiss alert
    │       └─ "End & Save"  → CelebrationView → ContentBrowser
    └─ Tap handoff screen  → dismiss, start next turn


SETTINGS (Screen 12)                           ← pushed onto stack
    ├─ Back ‹              → pop
    ├─ Tier picker         → change tier (alert confirmation)
    ├─ Restore Purchases   → StoreKit restore
    ├─ Pack Store          → push PackStoreView
    └─ Privacy Policy      → in-app web view (.sheet)


PDF EXPORT (Screen 11b)                        ← .sheet
    ├─ Frame style picker  → select style (no navigation)
    ├─ Name input          → edit text (no navigation)
    └─ "Share / Print"     → iOS share sheet → dismiss on completion
```

---

## 6. Deep Link / URL Scheme

Not required for v1. No URL scheme registered. Placeholder for v2:

```swift
// Future: Handle deep links if needed
// paperbrush://page/{pageId}
// paperbrush://gallery/{artworkId}
```

---

## 7. Returning User Launch Logic

```swift
// File: Navigation/LaunchRouter.swift
import Foundation

struct LaunchRouter {
    static func determineInitialRoute() -> Route? {
        let prefs = UserPreferences.shared

        guard prefs.hasCompletedOnboarding else {
            return nil // show onboarding flow (handled by RootView)
        }

        // If there's an in-progress artwork, resume it
        if let artworkId = prefs.inProgressArtworkId {
            return .canvasResume(artworkId)
        }

        // Otherwise, content browser (default root, no push needed)
        return nil
    }
}
```

---

## 8. Modal Presentation Rules

| Presentation | When to Use | SwiftUI API |
|-------------|-------------|-------------|
| `.sheet` | Non-blocking overlays the user can drag to dismiss: IAP, color picker, PDF export, Pass&Play setup, privacy policy | `.sheet(isPresented:)` |
| `.fullScreenCover` | Immersive experiences or gates: celebration, parental gate, turn handoff, pause overlay | `.fullScreenCover(isPresented:)` |
| `.confirmationDialog` | Quick action lists: canvas overflow menu, gallery context menu | `.confirmationDialog(title:isPresented:actions:)` |
| `.alert` | Destructive confirmations: delete artwork, end game, tier change | `.alert(title:isPresented:actions:message:)` |

**Rule:** Never use `.popover` on iPhone (it converts to a sheet anyway). Use `.popover` on iPad only for the color picker anchored to the "+" button.

---

## 9. Parental Gate Integration Points

Reference for every place the gate is required (from PRD SAFETY-002 and design spec §2.8.1):

| Action | Gate Required | Force Gate (ignore grace)? | Design Spec Ref |
|--------|:------------:|:-------------------------:|-----------------|
| Purchase (Unlock / Pack) | ✅ | No | §2.6.1 |
| Restore Purchases | ✅ | No | §2.6.1 |
| Share via share sheet | ✅ | **Yes** | §2.4, §2.5.2 |
| Print My Art (PDF export) | ✅ | **Yes** | §2.5.3 |
| Open Settings | ✅ | No | §2.8.2 |
| Start Pass & Play | ✅ | No | §2.7 |
| Delete artwork | ✅ | No | §2.5.2b |
| Any external link navigation | ✅ | **Yes** | PRD SAFETY-002 |

---

End of Navigation Architecture.
