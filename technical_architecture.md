# PaperBrush — Technical Architecture Specification

**Version 1.0 | March 2026 | Pre-Development Reference**
**For use alongside PRD v1 and Design Specs v1.1**

---

## 1. Technology Stack Decisions

### 1.1 UI Framework: SwiftUI (Primary) + UIKit (Canvas Only)

| Layer | Framework | Rationale |
|-------|-----------|-----------|
| All screens except Canvas | SwiftUI | Faster iteration with Claude, declarative layouts match the design spec's component-based structure |
| Canvas/Brush Engine | UIKit (UIView + Metal) | SwiftUI's Canvas view cannot handle real-time 60fps touch rendering with Metal textures. The brush engine needs raw touch event handling via UIKit. |
| Bridge | UIViewRepresentable | Wraps the UIKit canvas inside SwiftUI's navigation system |

**Why this matters for Claude:** Always specify which framework a view should use. Say "SwiftUI view" or "UIKit view wrapped in UIViewRepresentable" — never leave it ambiguous.

### 1.2 Minimum Deployment Target

- **iOS 16.0** (per PRD §5.1)
- This means: NavigationStack ✅, SwiftUI Charts ✅, StoreKit 2 ✅, Swift Concurrency ✅
- This means NO: Observable macro (iOS 17+), ScrollView phase changes (iOS 17+), MapKit SwiftUI (limited)

### 1.3 Swift Language Version

- **Swift 5.9+** (ships with Xcode 15+)
- Use structured concurrency (`async/await`) everywhere — no Combine, no completion handlers
- Use `@Observable` macro only if deployment target moves to iOS 17+ in future

### 1.4 Concurrency Model

**Rule: Use `async/await` for everything asynchronous. No Combine. No callbacks.**

```swift
// ✅ DO THIS
func loadGallery() async throws -> [Artwork] {
    let artworks = try await persistenceManager.fetchArtworks()
    return artworks.sorted { $0.lastModified > $1.lastModified }
}

// ❌ NOT THIS (Combine)
func loadGallery() -> AnyPublisher<[Artwork], Error> { ... }

// ❌ NOT THIS (callbacks)
func loadGallery(completion: @escaping (Result<[Artwork], Error>) -> Void) { ... }
```

**Exception:** The Metal rendering pipeline uses a `CADisplayLink` callback for frame rendering — this is unavoidable and is the only callback pattern in the app.

---

## 2. App Architecture: MVVM

### 2.1 Pattern Overview

```
┌─────────────────────────────────────────────────────┐
│                    SwiftUI View                      │
│  (reads state, sends user actions to ViewModel)     │
└────────────┬──────────────────────────┬──────────────┘
             │ observes                 │ calls methods
             ▼                          ▼
┌─────────────────────────────────────────────────────┐
│                   ViewModel                          │
│  (holds @Published state, coordinates services)     │
│  One ViewModel per screen. Owned by the View.       │
└────────────┬──────────────────────────┬──────────────┘
             │ calls                    │ calls
             ▼                          ▼
┌──────────────────┐     ┌──────────────────────────┐
│   Service Layer   │     │     Persistence Layer    │
│  (StoreKit, Audio,│     │  (Core Data, UserDefaults│
│   BrushEngine)    │     │   File Manager)          │
└──────────────────┘     └──────────────────────────┘
```

### 2.2 ViewModel Pattern (Beginner Guide)

Every screen gets one ViewModel. The ViewModel is a class that publishes state the View observes.

```swift
// PATTERN: Every ViewModel follows this structure
import SwiftUI

@MainActor
final class ContentBrowserViewModel: ObservableObject {
    // MARK: - Published State (View reads these)
    @Published var selectedCategory: ContentCategory = .animals
    @Published var pages: [ColoringPage] = []
    @Published var isLoading: Bool = false
    @Published var error: AppError?

    // MARK: - Dependencies (injected via init)
    private let contentStore: ContentStoreProtocol
    private let purchaseManager: PurchaseManagerProtocol

    init(
        contentStore: ContentStoreProtocol = ContentStore.shared,
        purchaseManager: PurchaseManagerProtocol = PurchaseManager.shared
    ) {
        self.contentStore = contentStore
        self.purchaseManager = purchaseManager
    }

    // MARK: - User Actions (View calls these)
    func selectCategory(_ category: ContentCategory) {
        selectedCategory = category
        Task { await loadPages() }
    }

    func loadPages() async {
        isLoading = true
        defer { isLoading = false }
        do {
            pages = try await contentStore.pages(for: selectedCategory)
        } catch {
            self.error = .contentLoadFailed
        }
    }
}
```

```swift
// PATTERN: Every View connects to its ViewModel like this
struct ContentBrowserView: View {
    @StateObject private var viewModel = ContentBrowserViewModel()

    var body: some View {
        // ... UI reads viewModel.pages, viewModel.isLoading, etc.
    }
}
```

### 2.3 Dependency Injection Strategy

**Approach: Protocol-based with shared singletons, overridable for testing.**

Every service is defined as a protocol. The real implementation is a singleton accessed via `.shared`. ViewModels take the protocol in their `init`, defaulting to the singleton. Tests inject mocks.

```swift
// 1. Define the protocol
protocol PurchaseManagerProtocol {
    var isFullVersionUnlocked: Bool { get }
    func purchase() async throws
    func restorePurchases() async throws
}

// 2. Real implementation
final class PurchaseManager: PurchaseManagerProtocol {
    static let shared = PurchaseManager()
    // ... real StoreKit 2 implementation
}

// 3. Mock for tests
final class MockPurchaseManager: PurchaseManagerProtocol {
    var isFullVersionUnlocked = false
    func purchase() async throws { isFullVersionUnlocked = true }
    func restorePurchases() async throws { }
}

// 4. ViewModel uses protocol, defaults to real
final class IAPViewModel: ObservableObject {
    private let purchaseManager: PurchaseManagerProtocol

    init(purchaseManager: PurchaseManagerProtocol = PurchaseManager.shared) {
        self.purchaseManager = purchaseManager
    }
}
```

---

## 3. Project Structure

```
PaperBrush/
├── PaperBrushApp.swift              # App entry point
├── Info.plist                        # Permissions, app config
│
├── Core/                             # Shared utilities & extensions
│   ├── Extensions/                   # Swift extensions (Color+Hex, etc.)
│   ├── Modifiers/                    # Reusable SwiftUI ViewModifiers
│   └── Protocols/                    # Service protocols
│
├── DesignSystem/                     # All design tokens & reusable components
│   ├── Tokens/                       # Colors, Typography, Spacing, Shadows
│   ├── Components/                   # PBButton, PBCard, PBColorSwatch, etc.
│   └── Icons/                        # Custom icon assets
│
├── Features/                         # Feature modules (one folder per screen area)
│   ├── Onboarding/
│   │   ├── WelcomeSplashView.swift
│   │   ├── AgeTierSelectionView.swift
│   │   └── OnboardingViewModel.swift
│   │
│   ├── Canvas/
│   │   ├── Views/
│   │   │   ├── CanvasContainerView.swift       # SwiftUI wrapper
│   │   │   ├── CanvasMetalView.swift           # UIKit Metal canvas
│   │   │   ├── BrushToolbarView.swift
│   │   │   ├── ColorTrayView.swift
│   │   │   ├── ColorPickerSheetView.swift
│   │   │   └── CanvasTopToolbarView.swift
│   │   ├── ViewModels/
│   │   │   ├── CanvasViewModel.swift
│   │   │   └── BrushEngineViewModel.swift
│   │   └── Engine/
│   │       ├── BrushEngine.swift               # Metal rendering pipeline
│   │       ├── Shaders.metal                   # GPU shaders
│   │       ├── TileManager.swift               # 256x256 tile grid
│   │       ├── StrokeRenderer.swift            # Real-time stroke compositing
│   │       └── FloodFill.swift                 # GPU-accelerated fill
│   │
│   ├── ContentBrowser/
│   │   ├── ContentBrowserView.swift
│   │   ├── ContentBrowserViewModel.swift
│   │   ├── CategoryPillsView.swift
│   │   └── PageThumbnailCard.swift
│   │
│   ├── Gallery/
│   │   ├── GalleryGridView.swift
│   │   ├── GalleryFullscreenView.swift
│   │   ├── GalleryViewModel.swift
│   │   └── PDFExportView.swift
│   │
│   ├── Celebration/
│   │   ├── CelebrationView.swift
│   │   ├── CelebrationViewModel.swift
│   │   └── AnimationTemplates/
│   │
│   ├── IAP/
│   │   ├── IAPSheetView.swift
│   │   ├── PackStoreView.swift
│   │   └── IAPViewModel.swift
│   │
│   ├── PassAndPlay/
│   │   ├── PlayerSetupView.swift
│   │   ├── TurnHandoffView.swift
│   │   ├── PauseOverlayView.swift
│   │   └── PassAndPlayViewModel.swift
│   │
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── SettingsViewModel.swift
│   │
│   └── Safety/
│       ├── ParentalGateView.swift
│       └── ParentalGateViewModel.swift
│
├── Services/                          # Business logic & external integrations
│   ├── Persistence/
│   │   ├── PersistenceManager.swift   # Core Data stack
│   │   ├── PaperBrush.xcdatamodeld   # Core Data model
│   │   └── UserPreferences.swift      # UserDefaults wrapper
│   │
│   ├── Audio/
│   │   ├── AudioManager.swift         # AVFoundation sound playback
│   │   └── HapticManager.swift        # UIFeedbackGenerator
│   │
│   ├── Purchase/
│   │   └── PurchaseManager.swift      # StoreKit 2
│   │
│   ├── Content/
│   │   ├── ContentStore.swift         # Loads/filters coloring pages
│   │   └── ODRManager.swift           # On-Demand Resources for packs
│   │
│   └── Export/
│       ├── PDFGenerator.swift         # Art Comes Home PDF creation
│       └── ImageExporter.swift        # PNG export at 2048x2048
│
├── Models/                            # Data models (see data_model.md)
│   ├── ColoringPage.swift
│   ├── Artwork.swift
│   ├── BrushType.swift
│   ├── AgeTier.swift
│   ├── ContentCategory.swift
│   └── Player.swift
│
├── Navigation/                        # App-level navigation
│   ├── AppRouter.swift                # NavigationStack path management
│   └── Route.swift                    # Enum of all navigation destinations
│
├── Resources/
│   ├── Assets.xcassets                # Colors, icons, images
│   ├── Fonts/                         # Nunito, Nunito Sans
│   ├── Sounds/                        # Brush sounds, celebrations, UI
│   ├── Pages/                         # SVG coloring page bundles
│   └── Animations/                    # Lottie/SpriteKit animation data
│
└── Tests/
    ├── UnitTests/                     # ViewModel + Service tests
    └── UITests/                       # Critical flow tests
```

### 3.1 Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| SwiftUI Views | `[Feature]View` | `GalleryGridView`, `IAPSheetView` |
| ViewModels | `[Feature]ViewModel` | `GalleryViewModel`, `CanvasViewModel` |
| Services | `[Domain]Manager` | `AudioManager`, `PurchaseManager` |
| Protocols | `[Domain]ManagerProtocol` | `PurchaseManagerProtocol` |
| Models | Bare noun | `Artwork`, `ColoringPage`, `Player` |
| Extensions | `[Type]+[Feature]` | `Color+DesignSystem`, `View+Haptics` |
| Design System | `PB[Component]` prefix | `PBButton`, `PBCard`, `PBColorSwatch` |
| Constants | `PBTokens.[Category]` | `PBTokens.Colors.richTeal` |
| Feature IDs | Match PRD IDs in comments | `// BRUSH-001: Freehand painting` |

### 3.2 File Naming

- One type per file
- File name matches type name exactly: `GalleryGridView.swift` contains `struct GalleryGridView: View`
- Exception: small related types (e.g., `Route` enum + `Route` extensions) can share a file

---

## 4. Rendering Pipeline Architecture

### 4.1 Overview

The brush engine is the highest technical risk. Here's the architecture:

```
Touch Input (UIKit)
    │
    ▼
StrokeRenderer (CPU: interpolate touch points → smooth bezier curves)
    │
    ▼
Metal Compute Shader (GPU: render brush texture along curve)
    │
    ▼
TileManager (manages 256×256 tile grid, only renders dirty tiles)
    │
    ▼
Metal Render Pass (composites tiles → display)
    │
    ▼
MTKView (UIKit view showing result at 60fps via CADisplayLink)
    │
    ▼
CanvasContainerView (SwiftUI wrapper via UIViewRepresentable)
```

### 4.2 Key Architectural Decisions

**Tile-Based Rendering:**
The canvas is divided into a grid of 256×256 pixel tiles. When the user draws a stroke, only the tiles the stroke touches are re-rendered. This keeps memory usage manageable on devices with 3GB RAM.

```
Canvas (4096×4096 working resolution)
┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┐
│    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │
│    │    │    │ 🟨 │ 🟨 │    │    │    │    │    │    │    │    │    │    │    │
│    │    │    │ 🟨 │ 🟨 │ 🟨 │    │    │    │    │    │    │    │    │    │    │
│    │    │    │    │    │ 🟨 │ 🟨 │    │    │    │    │    │    │    │    │    │
│    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │    │
└────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┴────┘
 🟨 = "dirty" tiles that need re-rendering after a stroke (only 7 of 256 tiles!)
```

**Undo System:**
Each action (stroke or fill) is stored as a command object. Undo reverts by replaying all commands except the last. For performance, we snapshot the tile state every 5 commands to avoid replaying from scratch.

```swift
// Undo architecture (simplified)
struct CanvasCommand {
    let type: CommandType       // .stroke, .fill, .erase
    let data: Data              // serialized stroke/fill data
    let affectedTiles: Set<TileCoordinate>
}

class UndoManager {
    private var commands: [CanvasCommand] = []
    private var redoStack: [CanvasCommand] = []
    private var snapshots: [Int: TileSnapshot] = [:]  // snapshot every 5 commands
    let maxUndoLevels: Int  // 5 (Starter), 10 (Explorer), 20 (Creator)
}
```

### 4.3 Brush Engine Prototyping Strategy

Per PRD §7 Risk #1, the brush engine is the first thing to build and test. Recommended prototyping order:

1. **Week 1-2:** Basic Metal rendering pipeline — just draw dots where fingers touch
2. **Week 2-3:** Stroke interpolation — smooth curves between touch points
3. **Week 3-4:** First 4 brush textures (crayon, marker, watercolor, pencil)
4. **Week 4-5:** Flood fill algorithm (GPU compute shader with CPU fallback)
5. **Week 5-6:** User-test with children, iterate on feel

### 4.4 Fallback Strategy

If Metal proves too complex for the timeline:

| Feature | Metal (Target) | Core Graphics (Fallback) | Impact |
|---------|---------------|-------------------------|---------|
| Stroke rendering | Compute shaders | CGContext drawing | Slower, but functional |
| Flood fill | GPU compute | Scanline fill algorithm | Slower (500ms vs 200ms) |
| Glitter/watercolor | Particle shaders | Pre-rendered overlays | Less dynamic |
| Performance on A13 | 60fps | 30-45fps | Noticeable but usable |

**Decision point:** If Metal isn't working well by Week 4, fall back to Core Graphics for v1 and plan Metal for v1.1.

---

## 5. Package Management & Dependencies

### 5.1 Package Manager: Swift Package Manager (SPM)

No CocoaPods. No Carthage. SPM only.

### 5.2 Third-Party Dependencies (Minimal by Design)

The PRD mandates zero third-party SDKs that touch user data (§5.2). The dependency list is intentionally small:

| Package | Purpose | Why Not Native |
|---------|---------|----------------|
| None for networking | No backend in v1 | — |
| None for analytics | COPPA compliance | — |
| None for crash reporting | Use Apple's native crash reports | COPPA §5.2 |

**All functionality built with Apple-native frameworks:**

| Framework | Used For |
|-----------|----------|
| SwiftUI | All UI except canvas |
| UIKit | Canvas view, touch handling |
| Metal | GPU-accelerated brush rendering |
| Core Graphics | PNG export, PDF generation, fallback rendering |
| Core Data | Artwork persistence, gallery storage |
| StoreKit 2 | IAP (full unlock + content packs) |
| AVFoundation | Sound effects (AVAudioPlayer), ambient music, audio session management |
| PDFKit | PDF export for Art Comes Home |
| SpriteKit (evaluate) | Celebration animations (alternative: Core Animation) |

**Audio implementation notes:**
- SFX use `AVAudioPlayer` with pre-loaded buffers for zero-latency playback
- Background music uses a separate `AVAudioPlayer` instance with `.mixWithOthers` category
- Color selection pitch-shifting uses `AVAudioEngine` with `AVAudioUnitTimePitch`
- See `data_model.md` §8 for the complete 30-file audio asset inventory and `AudioManagerProtocol`

### 5.3 Fonts

Nunito and Nunito Sans are Google Fonts, bundled in the app (not loaded at runtime):
- Add `.ttf` files to `Resources/Fonts/`
- Register in `Info.plist` under `UIAppFonts`
- Access via `Font.custom("Nunito-Bold", size: 16)`

---

## 6. Error Handling Conventions

### 6.1 Error Types

```swift
enum AppError: LocalizedError {
    // Canvas
    case canvasRenderingFailed
    case strokeDataCorrupted

    // Persistence
    case artworkSaveFailed
    case artworkLoadFailed
    case galleryCorrupted

    // Purchase
    case purchaseFailed(underlying: Error)
    case restoreFailed(underlying: Error)
    case noProductsFound

    // Content
    case contentPackDownloadFailed
    case pageDataCorrupted

    // Export
    case pdfGenerationFailed
    case photoLibraryPermissionDenied

    var errorDescription: String? {
        switch self {
        case .purchaseFailed: return "Something went wrong. Please try again."
        case .photoLibraryPermissionDenied: return "Couldn't save — check storage or permissions"
        // ... user-facing strings per design spec
        }
    }
}
```

### 6.2 Error Surfacing Patterns

Per design specs, errors surface via toasts, inline messages, or alerts — never crashes.

| Error Context | UI Treatment | Design Spec Reference |
|--------------|-------------|----------------------|
| Save to gallery fails | Honey Gold warning toast, 4s | §2.4 Celebration |
| Purchase fails | Inline coral text below button | §2.6.1 IAP Sheet |
| Restore fails | Inline coral text | §2.6.1 IAP Sheet |
| Canvas crash | Auto-save should prevent data loss; show recovery dialog | Not in spec (add) |
| Content load fail | Empty state with retry button | §2.3.3 |

---

## 7. Performance Budgets

From PRD §5.3 and PERF-001/002:

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Cold launch → interactive | <3s (iPhone 12+), <5s (iPhone SE 2) | Instruments Time Profiler |
| Stroke input → render | <16ms (60fps) | Metal GPU profiler |
| Fill bucket completion | <200ms | Instruments |
| Undo action | <100ms | Instruments |
| Gallery load (500 items) | <1s | Instruments |
| Memory during coloring | <300MB | Instruments Allocations |
| App install size | <200MB | Xcode archive |
| Auto-save interval | Every 30s during active coloring | Timer |

---

## 8. Testing Strategy

### 8.1 What to Test

| Layer | What | How | Priority |
|-------|------|-----|----------|
| ViewModels | State transitions, business logic | XCTest unit tests | High |
| Services | Persistence, StoreKit, Audio | XCTest with mocks | High |
| Brush Engine | Stroke rendering correctness | Visual snapshot tests | Medium |
| Navigation | Critical user flows | XCUITest | Medium |
| Performance | Frame rate, memory | XCTest performance tests | Medium |

### 8.2 Mock Strategy

Every service has a protocol. Tests inject mock implementations:

```swift
class GalleryViewModelTests: XCTestCase {
    func test_loadGallery_showsArtworksSortedByDate() async {
        let mockPersistence = MockPersistenceManager()
        mockPersistence.stubbedArtworks = [
            Artwork(title: "Cat", lastModified: .now),
            Artwork(title: "Dog", lastModified: .distantPast)
        ]
        let viewModel = GalleryViewModel(persistence: mockPersistence)

        await viewModel.loadGallery()

        XCTAssertEqual(viewModel.artworks.first?.title, "Cat")
    }
}
```

### 8.3 Device Testing Matrix

| Device | Why | Priority |
|--------|-----|----------|
| iPhone SE 2nd gen | Baseline (A13, smallest supported) | P0 |
| iPhone 14/15 | Primary user device | P0 |
| iPad 10th gen | Landscape layout, sidebar UI | P0 |
| iPad mini 5th gen | Smallest iPad, A12 | P1 |
| iPad + Apple Pencil | Pressure sensitivity | P1 |

---

## 9. Build Configuration

### 9.1 Schemes

| Scheme | Purpose | Configuration |
|--------|---------|--------------|
| PaperBrush-Debug | Development | Debug build, verbose logging, mock StoreKit |
| PaperBrush-Release | App Store | Optimized, StoreKit production |

### 9.2 Environment Variables

```swift
enum AppEnvironment {
    static let isDebug: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()

    // StoreKit Configuration
    static let storeKitConfigFile = "StoreKit_Config" // for testing
}
```

### 9.3 Bundle Identifiers

| Target | Bundle ID |
|--------|-----------|
| App | `com.[yourname].paperbrush` |
| On-Demand Resources | Managed by Xcode |

---

## 10. Content Pipeline

### 10.1 Coloring Page Format

Each page is a vector SVG with metadata:

```
Pages/
├── starter/
│   ├── animals/
│   │   ├── happy-sun.svg
│   │   ├── happy-sun.json          # metadata
│   │   └── happy-sun-anim.json     # animation template reference
│   └── vehicles/
├── explorer/
└── creator/
```

**Metadata JSON:**
```json
{
    "id": "starter-animals-happy-sun",
    "title": "Happy Sun",
    "tier": "starter",
    "category": "animals",
    "difficulty": 1,
    "animationTemplateId": "nature-bloom",
    "regions": 12,
    "strokeWeight": 6.0,
    "isFree": true,
    "isNew": false
}
```

### 10.2 On-Demand Resources (ODR)

Content packs use Apple's ODR framework:
- Base app bundles 50 free pages + 150 paid pages (under 200MB budget)
- Future content packs download as tagged ODR bundles
- Download progress shown in Pack Store UI

---

End of Technical Architecture Specification.
