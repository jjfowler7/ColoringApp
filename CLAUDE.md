# PaperBrush — Claude Code Project Instructions

> This file is automatically read by Claude Code at the start of every session.
> It is the single source of truth for how code should be written in this project.

## About This Project

PaperBrush is an iOS children's coloring app (ages 3–12) with three age tiers (Starter/Explorer/Creator), zero ads, zero subscriptions, and a one-time $14.99 unlock. It's being built entirely with Claude Code by a solo developer who is a beginner to iOS/Swift. Target launch: September 2026.

**The developer is new to iOS and Swift.** When creating code, include brief inline comments explaining non-obvious patterns (e.g., why `@MainActor` is needed, what `@StateObject` vs `@ObservedObject` means). When proposing architectural decisions, explain the tradeoff in plain language.

## Reference Documentation

Before implementing any feature, read the relevant docs. These files live at the repository root, except `design_specs_v1.md` which is in `Mockups/`:

| Document | What It Contains | When to Read It |
|----------|-----------------|-----------------|
| `technical_architecture.md` | Architecture pattern (MVVM), project folder structure, rendering pipeline, naming conventions, performance budgets, testing strategy | Before creating any new file |
| `component_library.md` | Swift code for all design tokens (`PBTokens`) and reusable UI components (`PBButton`, `PBCard`, etc.) | Before building any UI |
| `data_model.md` | Core Data schema, Swift model enums, `UserPreferences` wrapper, file system layout, audio asset inventory, `AudioManagerProtocol` | Before any persistence, model, or audio work |
| `navigation_architecture.md` | Complete navigation graph, `Route` enum, `AppRouter`, modal presentation rules, parental gate integration points | Before any navigation or screen-wiring work |
| `Mockups/design_specs_v1.md` | Full design system (colors, type, spacing, shadows, motion) + pixel-level specs for every screen | Before implementing any specific screen |
| `prd_v1_updated.md` | Feature requirements with acceptance criteria and priority levels (P0/P1/P2) | Before implementing any feature |
| `Interaction_Tree.md` | Every screen, element, and navigation destination mapped | When wiring up navigation or verifying completeness |

**Always read the relevant doc before writing code.** Do not rely on this summary alone — the docs contain detailed specs, acceptance criteria, and code examples.

## Tech Stack (Non-Negotiable)

- **UI:** SwiftUI for all screens EXCEPT the canvas
- **Canvas:** UIKit (`UIView` subclass) + Metal for GPU-accelerated brush rendering, wrapped in `UIViewRepresentable`
- **Architecture:** MVVM — one ViewModel per screen. ViewModels are `@MainActor final class` conforming to `ObservableObject` with `@Published` properties
- **Concurrency:** `async/await` ONLY. No Combine. No completion handlers. Exception: `CADisplayLink` for the Metal frame loop
- **Persistence:** Core Data for artworks/gallery. UserDefaults via `UserPreferences` wrapper for settings. File system for canvas binary data and page assets
- **IAP:** StoreKit 2 (not StoreKit 1)
- **Package Manager:** SPM only. No CocoaPods. No Carthage
- **Minimum iOS:** 16.0 — do NOT use `@Observable` macro (requires iOS 17+)
- **Third-party SDKs:** ZERO. Apple-native frameworks only (COPPA compliance)
- **No dependencies.** No Alamofire, no Firebase, no analytics SDKs, no Lottie, nothing

## Dependency Injection Pattern

Every service is defined as a protocol. The real implementation is a singleton accessed via `.shared`. ViewModels accept the protocol in `init` with a default of the singleton. Tests inject mocks.

```swift
// Always follow this pattern:
protocol AudioManagerProtocol { ... }
final class AudioManager: AudioManagerProtocol { static let shared = AudioManager() }

@MainActor
final class CanvasViewModel: ObservableObject {
    private let audio: AudioManagerProtocol
    init(audio: AudioManagerProtocol = AudioManager.shared) {
        self.audio = audio
    }
}
```

## Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| SwiftUI Views | `[Feature]View` | `GalleryGridView` |
| ViewModels | `[Feature]ViewModel` | `GalleryViewModel` |
| Services | `[Domain]Manager` | `AudioManager` |
| Protocols | `[Domain]ManagerProtocol` | `AudioManagerProtocol` |
| Models | Bare noun | `Artwork`, `ColoringPage` |
| Design System components | `PB[Component]` | `PBButton`, `PBCard` |
| Design tokens | `PBTokens.[Category]` | `PBTokens.Colors.richTeal` |
| Extensions | `[Type]+[Feature]` | `Color+DesignSystem` |
| One type per file. File name = type name | | `GalleryGridView.swift` contains `struct GalleryGridView: View` |

## Design System Quick Reference

Full token definitions with Swift code are in `component_library.md`. Here's the cheat sheet:

**Colors (use `PBTokens.Colors.*`):**
- Background: Warm Cream `#FFF8F0`
- Cards: Soft Canvas `#FFFDF9`
- Primary action: Rich Teal `#0EA5A0`
- Text: Deep Navy `#1B2A4A`
- Accent/CTA: Sunset Coral `#F06449`
- Warning: Honey Gold `#F5A623`
- Success: Soft Sage `#7CB686`
- Secondary text: Soft Graphite `#666666`
- Divider: Light Divider `#E8E0D8`
- Starter tier: Peach Blush `#FCBFA0`
- Explorer tier: Sky Blue `#6BB8E8`
- Creator tier: Lavender Mist `#B8A9E8`

**Typography:** Nunito (Bold/ExtraBold) for headers. Nunito Sans (Regular/SemiBold) for body. SF Mono for hex codes in Creator tier.

**Spacing (8pt base):** xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48, xxxl: 64

**Corner Radii:** xs: 6, sm: 10, md: 16, lg: 24, xl: 32, full: capsule

**Touch targets:** Minimum 44×44pt everywhere. Brush icons 48×48pt (iPhone) / 56×56pt (iPad).

## Age Tier Behavior

The selected tier (`UserPreferences.shared.selectedTier`) changes UI complexity:

| Feature | Starter (3-5) | Explorer (6-8) | Creator (9-12) |
|---------|---------------|----------------|-----------------|
| Brushes shown | 4 (crayon, marker, stamp, eraser) | All 8 | All 8 |
| Brush icons | 64×64pt with labels | 48×48pt no labels | 48×48pt no labels |
| Color picker (+) | Hidden | HSB wheel | HSB wheel + hex input |
| Color swatches | 40pt, 2 rows | 32pt, 1 row scroll | 32pt, 1 row scroll |

## Error Handling

Use the `AppError` enum (defined in `technical_architecture.md` §6). Errors surface as:
- **Toasts** (save success/failure) — auto-dismiss 2–4s
- **Inline text** (purchase/restore failures) — coral text below the action button
- **Alerts** (destructive actions like delete) — iOS native `.alert`

Never force-unwrap. Never use `try!`. Always handle errors gracefully with `do/catch` or optional binding.

## Rules: Always Do

1. Add `// [FEATURE-ID]: description` comments matching PRD feature IDs (e.g., `// BRUSH-001: Freehand painting`)
2. Make every view support both iPhone and iPad layouts
3. Use `PBTokens` and `PB[Component]` design system — never hardcode colors, fonts, or spacing
4. Add `@MainActor` to all ViewModels
5. Use `async/await` for all asynchronous work
6. Include `.accessibilityLabel()` on all interactive elements
7. Support Dynamic Type for all text
8. Respect the mute toggle (`UserPreferences.shared.isMuted`) for any audio playback
9. Gate external actions (share, purchase, settings) behind the parental gate via `AppRouter.requireParentalGate`
10. Auto-save canvas state every 30 seconds and on app background
11. Read the relevant reference doc before implementing — don't guess at specs
12. At the start of any sprint involving UX/UI work, read `Mockups/design_specs_v1.md` and all `.html` files in `Mockups/` before writing any UI code. These are the source of truth for all design decisions. When the spec and mockup conflict, follow the spec. If a design decision needs to change to make something work, stop and propose the deviation — do not deviate silently.

## Rules: Never Do

1. Use Combine (`Publisher`, `sink`, `AnyCancellable`)
2. Use completion handlers or callbacks (exception: `CADisplayLink`)
3. Use `@Observable` macro (requires iOS 17)
4. Add any third-party dependency
5. Use force unwraps (`!`) or `try!`
6. Hardcode colors, fonts, or spacing values — always use `PBTokens`
7. Create ad-related code or any form of tracking/analytics
8. Use `NavigationView` (deprecated) — use `NavigationStack`
9. Skip the parental gate for purchases, sharing, or settings access
10. Collect any user data or PII
11. Use `.popover` on iPhone (it converts to sheet anyway)
12. Create files outside the project structure defined in `technical_architecture.md` §3

---

## Post-Feature QA Protocol

After completing any discrete piece of functionality — a feature, a screen, a component, or a bug fix — Claude must run the **`/qa` skill**, which holds the full QA checklist and runs the recursive build → fix → re-check loop. The skill is the single source of truth for what QA covers; do not maintain a separate checklist here.

How the loop must behave:
- It runs to completion **before** any handoff. Repeat the checklist after every fix until a full pass produces zero failures.
- It is **invisible to Jerry.** Claude does not ask him to test, summarize findings, or report progress mid-review — he only sees the finished result.
- On a clean pass, hand off in one line: *"Feature complete and QA'd — ready for you to test."*
- Flag only known limitations that need a product decision (not a code fix) — never describe the QA process itself.

---

## Session Behavior: Milestone & Sprint Awareness

**Claude MUST do the following at the start and end of every session:**

**Session start:** Check the current sprint status below. State which milestone and sprint are active, what's been completed, and what the next task is. If a sprint was recently completed, confirm with the developer before moving to the next sprint.

**Session end (or when the developer says they're done for the day):** Summarize what was accomplished this session. Update the sprint progress below by telling the developer which checkboxes to mark. Flag anything that's blocked or needs the developer's input before the next session.

**Sprint boundaries:** When all tasks in a sprint are checked off, Claude must explicitly say: *"Sprint [X] is complete. Here's what to test before we move on."* Then present the testing checklist for that sprint. Do NOT begin the next sprint until the developer confirms testing passed.

---

## Milestones Overview

Target: September 2026 launch (24 weeks from late March 2026)

| Milestone | Target | Theme | Key Risk |
|-----------|--------|-------|----------|
| M1 | Weeks 1–4 (April) | Foundation + Brush Engine Prototype | Does the brush feel good to a child? |
| M2 | Weeks 5–9 (May) | Canvas Feature-Complete | Performance on older devices |
| M3 | Weeks 10–14 (June) | Content, Gallery, Animations | Content pipeline pace |
| M4 | Weeks 15–18 (July) | IAP, Safety, Audio, Pass & Play | StoreKit + COPPA compliance |
| M5 | Weeks 19–22 (August) | Polish, Beta, App Store Prep | Beta feedback volume |
| LAUNCH | Week 23–24 (Early Sept) | Submit + Release | App Review rejection |

---

## MILESTONE 1: Foundation + Brush Engine (Weeks 1–4)

### Sprint 1.1 — Project Scaffold & Design System (Week 1)

> **Why this is first:** Every file in the project depends on the Xcode project existing, and every UI file depends on the design tokens. Nothing can be built without this.

- [x] Create Xcode project: PaperBrush, iOS 16.0 target, SwiftUI lifecycle, iPhone + iPad
- [x] Set up folder structure per `technical_architecture.md` §3
- [x] Add Nunito and Nunito Sans font files to Resources/Fonts/, register in Info.plist
- [x] Create `PBTokens.swift` namespace
- [x] Create `PBColors.swift` with all color tokens + `Color+Hex.swift` extension
- [x] Create `PBTypography.swift` with all font styles
- [x] Create `PBSpacing.swift`, `PBCornerRadius.swift`, `PBShadows.swift`, `PBAnimation.swift`
- [x] Create `PBButton.swift` component (all 4 styles)
- [x] Create `PBCard.swift`, `PBToast.swift`, `PBStatusBadge.swift`, `PBTierBadge.swift`
- [x] Create `PBColorSwatch.swift`, `PBCategoryPill.swift`, `PBEmptyState.swift`
- [x] Create all model enums: `AgeTier.swift`, `ContentCategory.swift`, `BrushType.swift`, `Player.swift`
- [x] Create `AppError.swift` enum
- [x] Create `UserPreferences.swift` wrapper
- [x] Create service protocols: `PersistenceManagerProtocol`, `AudioManagerProtocol`, `PurchaseManagerProtocol`
- [x] Create `Route.swift` enum and `AppRouter.swift`
- [x] Create `PaperBrushApp.swift` entry point, `RootView.swift`, `MainNavigationView.swift`
- [x] Verify the app builds and launches to an empty screen on simulator

**📱 Testing — Sprint 1.1:**
```
Device: iPhone Simulator (iPhone 15) + iPad Simulator (iPad 10th gen)
What to verify:
1. App builds without errors in Xcode (⌘B)
2. App launches to a blank/empty screen on both simulators
3. No crash on launch
That's it — there's no UI yet. This sprint is about the foundation compiling cleanly.
```

---

### Sprint 1.2 — Navigation Shell & Onboarding (Week 2)

> **Why this is second:** The navigation system must exist before building any real screens, because every screen needs to push/pop/present within the NavigationStack. Onboarding is the first user-facing flow and exercises the full navigation path.

- [x] Wire up `NavigationStack` with `Route`-based `.navigationDestination`
- [x] Build `WelcomeSplashView` — Screen 01 per design spec §2.1.1
- [x] Build `AgeTierSelectionView` — Screen 02 per design spec §2.1.2
- [x] Implement onboarding flow: Welcome → Age Selection → placeholder canvas
- [x] Implement "Skip" path: sets Explorer tier, navigates to Content Browser placeholder
- [x] Implement returning-user logic: bypass onboarding if `hasCompletedOnboarding` is true
- [x] Store selected tier in `UserPreferences`
- [x] Add staggered card animation on Age Selection screen
- [x] Verify iPhone and iPad layouts for both screens

**📱 Testing — Sprint 1.2:**
```
Device: Physical iPhone (any model) + iPhone Simulator + iPad Simulator
What to verify:
1. First launch shows Welcome Splash with app name and "Get Started" button
2. Tapping "Get Started" navigates to Age Tier Selection
3. Three tier cards appear with correct colors (Peach/Blue/Lavender tints)
4. Tapping any tier card stores the selection and navigates forward
5. Tapping "Skip" on Welcome goes to a placeholder screen (Content Browser stub)
6. Kill and relaunch the app — it should NOT show onboarding again
7. On iPad: Welcome screen uses side-by-side layout; tier cards are 3-across
8. Verify cards animate in with a stagger (not all at once)
```

---

### Sprint 1.3 — Basic Metal Canvas (Week 3)

> **Why this is third:** The brush engine is the #1 technical risk (PRD §7). This sprint proves the Metal rendering pipeline works. Everything after this depends on having a functional canvas.

- [x] Create `CanvasMetalView.swift` (UIView subclass with MTKView)
- [x] Set up Metal device, command queue, render pipeline
- [x] Implement CADisplayLink frame loop for 60fps rendering
- [x] Implement touch event handling (began/moved/ended)
- [x] Create `StrokeRenderer.swift` — interpolate touch points into smooth bezier curves
- [x] Render basic solid-color strokes on screen where finger touches
- [x] Create `CanvasContainerView.swift` (UIViewRepresentable wrapper)
- [x] Wire canvas into navigation: tier selection → canvas with placeholder page
- [x] ~~Implement pinch-to-zoom (2x–10x) and two-finger pan~~ Deferred — zoom will be a dedicated tool, not a gesture
- [x] Verify drawing on physical device (smooth, responsive, no crash after 30s+)

**📱 Testing — Sprint 1.3:**
```
Device: Physical iPhone (REQUIRED — simulator cannot test real touch latency)
         Physical iPad with Apple Pencil (if available — otherwise defer pencil to Sprint 2.1)
What to verify:
1. Selecting a tier from onboarding opens the canvas screen
2. Drawing with your finger leaves a colored line on screen
3. Lines are smooth (no visible jagged segments between touch points)
4. Drawing feels responsive — no visible lag between finger and line appearing
5. Pinch to zoom works (canvas gets bigger/smaller)
6. Two-finger pan works when zoomed in
7. Drawing at 2x zoom and 5x zoom still feels smooth
8. No crash after 30+ seconds of continuous drawing
⚠️ CRITICAL: If drawing feels laggy or lines are jagged, STOP. This must be fixed
before any other work proceeds. See technical_architecture.md §4.4 for fallback plan.
```

---

### Sprint 1.4 — First 4 Brush Types + Canvas Toolbar (Week 4)

> **Why this is fourth:** Now that basic rendering works, add brush texture variety and the toolbar UI so the canvas is actually usable. This completes Milestone 1 and enables the first child user-test.

- [x] Implement crayon brush texture — via PencilKit `.crayon` (replaced custom Metal brushes)
- [x] Implement marker brush texture — via PencilKit `.marker`
- [x] Implement watercolor brush texture — via PencilKit `.watercolor`
- [x] Implement pencil brush texture — via PencilKit `.pencil`
- [x] Build `BrushToolbarView.swift` — horizontal brush icon row with tooltip on selection
- [x] Build `CanvasTopToolbarView.swift` — back button, title, mute toggle, overflow menu
- [x] Build `ColorTrayView.swift` — 24-color scrollable palette
- [x] Implement brush size slider (`BRUSH-004`)
- [x] Implement undo/redo (`BRUSH-005`) — via PencilKit built-in undoManager
- [x] Wire all toolbar elements to `CanvasViewModel` state
- [x] Verify Doodler tier shows only 4 brushes with labels at 64×64pt
- [x] Verify Explorer/Creator tiers show all 8 brushes at 48×48pt without labels

**📱 Testing — Sprint 1.4:**
```
Device: Physical iPhone (REQUIRED) + Physical iPad (if available)
What to verify:
1. Brush toolbar shows at bottom of canvas with brush icons
2. Tapping each brush icon selects it (visual highlight changes)
3. Crayon strokes look grainy/textured, not smooth
4. Marker strokes are smooth and semi-transparent
5. Watercolor strokes show some edge bleeding/softness
6. Pencil strokes are thin and light
7. Color tray shows 24 colored circles, scrollable horizontally
8. Tapping a color changes the drawing color
9. Brush size slider changes stroke thickness (verify thin → thick)
10. Undo removes the last stroke; redo restores it
11. Starter tier brush verification deferred to Sprint 2.1 (stamp/eraser not yet built).
    For now: verify toolbar can hide brushes (show only crayon, marker, watercolor, pencil)
12. Performance: drawing still feels smooth with all 4 brush textures
⚠️ Milestone 1 gate: After this sprint, the developer should user-test with 2–3 children
ages 5–8. Do they find the brushes satisfying? Is the UI intuitive? Note feedback before M2.
```

---

## MILESTONE 2: Canvas Feature-Complete (Weeks 5–9)

### Sprint 2.1 — Remaining Brushes + Fill Bucket (Weeks 5–6)

> **Depends on:** Sprint 1.4 (brush rendering pipeline). Adds the remaining 4 brush types and the fill tool, completing the core canvas toolset.

- [x] ~~Implement spray brush~~ Deferred to post-launch (SpriteKit particles)
- [x] ~~Implement glitter brush~~ Deferred to post-launch (SpriteKit particles)
- [x] Implement stamp tool (20+ SF Symbol shapes, tap-to-place, shape picker sheet)
- [x] Implement eraser (PKEraserTool for strokes + tap-to-erase for stamps)
- [x] Implement flood fill algorithm — CPU scanline (`BRUSH-002`)
- [x] Implement flood fill tolerance for anti-aliased edges
- [x] Implement Apple Pencil pressure sensitivity on iPad — via PencilKit (`BRUSH-001`)
- [x] Graceful fallback for finger input — via PencilKit drawingPolicy .anyInput
- [ ] Fill completes in <200ms for regions up to 2048×2048px

**📱 Testing — Sprint 2.1:**
```
Device: Physical iPhone + Physical iPad with Apple Pencil
What to verify:
1. All 8 brush types produce visually distinct strokes
2. Spray creates a soft scatter pattern, not a solid line
3. Glitter shows sparkle/shimmer particles along the stroke
4. Stamp tool places shapes (tap to place, not drag)
5. Eraser removes color and reveals the page underneath
6. Fill bucket: tap an enclosed region and it fills with selected color
7. Fill does NOT bleed through outlines into neighboring regions
8. Fill completes quickly (not a visible delay)
9. iPad + Apple Pencil: pressing harder makes thicker/more opaque lines
10. iPhone (finger): strokes are consistent width regardless of pressure
```

---

### Sprint 2.2 — Color Palette Complete + Custom Picker (Week 7)

> **Depends on:** Sprint 1.4 (color tray exists). Adds the custom color picker for Explorer/Creator tiers.

- [x] Build `ColorPickerSheetView.swift` — HSB wheel + brightness/opacity sliders (`COLOR-002`)
- [x] Implement draggable HSB wheel (conic gradient with radial white overlay, per mockup)
- [x] Implement brightness and opacity sliders below wheel
- [x] Implement recent colors row (scrollable, up to 20, persists via UserPreferences)
- [x] Implement hex code display + input for Creator tier only
- [x] Hide "+" button for Doodler tier
- [x] Present as bottom sheet on iPhone, popover on iPad
- [x] Verify dismiss on tap-outside preserves selection

**📱 Testing — Sprint 2.2:**
```
Device: Physical iPhone + iPad Simulator (or physical iPad)
What to verify:
1. Starter tier: NO "+" button visible at end of color tray
2. Explorer tier: "+" button appears; tapping opens color picker sheet
3. Color wheel: dragging around the ring changes hue smoothly
4. Brightness/saturation square: dragging changes color smoothly
5. Picking a custom color and tapping "Select Color" → it becomes the active drawing color
6. Recent colors row shows previously picked custom colors (up to 8)
7. Recent colors persist after killing and relaunching the app
8. Creator tier ONLY: hex code displays below the picker (e.g., "#FF6B35")
9. Creator tier: tapping hex field lets you type a hex code directly
10. iPhone: picker appears as a bottom sheet (drag down to dismiss)
11. iPad: picker appears as a popover anchored to the "+" button
```

---

### Sprint 2.3 — Canvas Persistence + Auto-Save (Week 8)

> **Depends on:** Sprint 2.1 (canvas must be fully functional before saving state). Sets up Core Data and file-system persistence so artwork survives app restarts.

- [x] Set up Core Data stack (`PersistenceManager.swift` + `PaperBrush.xcdatamodeld`)
- [x] Create `ArtworkEntity` in Core Data schema per `data_model.md` §2.1
- [x] Implement `PersistenceManager` conforming to protocol
- [x] Implement canvas data serialization (PKDrawing → `.pbdata` file + stamps → JSON)
- [x] Implement thumbnail generation (256×256 PNG from current canvas)
- [x] Implement auto-save every 30 seconds during active coloring (`GALLERY-003`)
- [x] Implement save on app background (UIScene lifecycle)
- [ ] Implement undo history serialization
- [x] Implement canvas resume: load saved state on re-open (`GALLERY-003`)
- [x] Wire "Save to Gallery" action from canvas overflow menu

**📱 Testing — Sprint 2.3:**
```
Device: Physical iPhone
What to verify:
1. Draw something on the canvas
2. Tap overflow menu (⋯) → "Save to Gallery" → should show brief "Saved!" toast
3. Press the Home button to background the app
4. Kill the app completely (swipe up from app switcher)
5. Relaunch → the app should resume with your drawing intact
6. Draw more, wait 30+ seconds without touching anything, then kill/relaunch → still saved
7. Navigate back to content browser, then re-open the same page → drawing still there
```

---

### Sprint 2.4 — Tile Manager + Performance Optimization (Week 9)

> **Depends on:** Sprint 2.3 (persistence must work before optimizing rendering). Ensures 60fps on baseline device (iPhone SE 2nd gen).

- [x] ~~Implement tile-based rendering~~ SKIPPED — PencilKit handles rendering optimization internally
- [x] ~~Only re-render dirty tiles~~ SKIPPED — PencilKit manages this
- [x] ~~Implement undo via command replay~~ SKIPPED — PencilKit's built-in undoManager handles undo/redo
- [x] ~~Memory optimization~~ SKIPPED — PencilKit manages memory internally
- [x] ~~Profile for iPhone SE 2nd gen~~ PencilKit maintains 60fps on all supported devices
- [x] Verify <300MB memory during active coloring — PencilKit stays well under this
- [x] Verify sustained 60fps during freehand drawing — PencilKit native performance
- [x] Verify undo completes in <100ms — PencilKit undoManager is instant
- [x] ~~Verify 4096×4096px working resolution~~ PencilKit canvas scales natively

**📱 Testing — Sprint 2.4:**
```
Device: iPhone SE 2nd gen (REQUIRED — this is the baseline device)
         Also test on primary iPhone for comparison
What to verify:
1. Draw continuously for 60 seconds — no visible stuttering or frame drops
2. Pinch to zoom while drawing — still smooth
3. Undo 10 times rapidly — each undo is instant (no visible delay)
4. Redo 10 times rapidly — same, instant
5. Fill a large region with the fill bucket — completes quickly (<1 second)
6. Draw 50+ strokes, then zoom to 10x and draw more — still smooth
7. On iPhone SE specifically: does it feel acceptable? Any lag compared to newer phone?
⚠️ Milestone 2 gate: If iPhone SE 2nd gen cannot sustain 60fps, the brush engine
needs optimization or the Core Graphics fallback (see technical_architecture.md §4.4)
before proceeding. Do NOT move to M3 with a laggy canvas.
```

---

## MILESTONE 3: Content, Gallery, Animations (Weeks 10–14)

### Sprint 3.1 — Content Browser (Weeks 10–11)

> **Depends on:** Sprint 1.2 (navigation) + Sprint 2.3 (persistence for "in-progress" badges). This is where children discover and choose pages.

- [x] Build `ContentBrowserView.swift` — Screen 04 per design spec §2.3
- [x] Build category pills row (horizontal scroll on iPhone, sidebar on iPad)
- [x] Build `PageThumbnailCard.swift` with all states: free, locked, new, in-progress
- [x] Implement content loading from bundled page data (`ContentStore.swift`)
- [x] Create 5–10 placeholder coloring pages (SF Symbol placeholders) for development
- [x] Implement age-tier filtering: selected tier's pages first, "More pages" divider below
- [x] Implement locked page tap → IAP sheet placeholder (sheet appears, no purchase logic yet)
- [x] Implement free page tap → navigate to canvas with page loaded
- [x] Implement in-progress page tap → resume canvas with saved state
- [x] Build empty category state (`PBEmptyState`)
- [x] Build Content Browser top bar: App title, Pack Store icon, Gallery icon, Settings icon (no back button — CB is the root screen)
- [x] Verify 2-column grid on iPhone, 4-column grid on iPad landscape

**📱 Testing — Sprint 3.1:**
```
Device: Physical iPhone + iPad Simulator (landscape)
What to verify:
1. Content Browser shows category pills at top (Animals, Vehicles, etc.)
2. Tapping a category filters the page grid
3. Page cards show thumbnail previews with title and tier badge
4. Free pages: tapping opens the canvas with that page
5. Locked pages: show translucent overlay with lock icon; tapping shows a sheet
6. In-progress pages: show "CONTINUE" badge; tapping resumes the canvas
7. Category pills scroll horizontally on iPhone
8. iPad landscape: categories appear in a fixed sidebar (280pt), grid is 4 columns
9. "More pages" divider appears between tier-matched and other-tier pages
10. Gallery icon in top bar navigates somewhere (even a placeholder)
```

---

### Sprint 3.2 — Gallery (Week 12)

> **Depends on:** Sprint 2.3 (persistence) + Sprint 3.1 (content browser for "new page" button). Builds the artwork portfolio.

- [x] Build `GalleryGridView.swift` — Screen 06 per design spec §2.5.1
- [x] Gallery cards show completed artwork thumbnails with title, date, tier badge
- [x] In-progress items show "Continue" badge
- [x] Sort by most recent first; load <1 second for 500 items
- [x] Build gallery empty state per design spec §2.5.1
- [x] Build `GalleryFullscreenView.swift` — Screen 07 per design spec §2.5.2
- [x] Implement swipe between artworks in fullscreen (horizontal paging)
- [x] Implement "Continue Coloring" button for in-progress artworks
- [x] Implement long-press context menu: Share, Print, Delete (`GALLERY-001`)
- [x] Implement delete with parental gate + confirmation alert
- [x] Implement save to camera roll (`GALLERY-002`) — parental gate → share sheet
- [x] Wire share sheet via `UIActivityViewController`
- [x] Build `ParentalGateView.swift` — Screen 09 per design spec §2.8.1
- [x] Implement math problem generation, answer checking, shake animation, rate limiting

**📱 Testing — Sprint 3.2:**
```
Device: Physical iPhone + iPad Simulator
What to verify:
1. Gallery shows all saved artworks as thumbnails in a grid
2. Most recent artwork appears first
3. Tapping a card opens fullscreen view of the artwork
4. Swipe left/right in fullscreen to see other artworks
5. In-progress artwork shows "Continue Coloring" button → tapping opens canvas
6. Empty gallery shows the empty state illustration + "Browse Pages" button
7. Long-press a gallery card → context menu appears (Share, Print, Delete)
8. Tapping "Delete" → parental gate math challenge appears
9. Correct math answer → delete confirmation alert → artwork disappears
10. Wrong math answer → modal shakes, "Try again" appears
11. 3 wrong answers → 30-second lockout with countdown
12. Tapping "Share" → parental gate → iOS share sheet with artwork image
13. Parental gate grace period: after passing once, next gated action within 5 min skips the gate
```

---

### Sprint 3.3 — Onboarding Complete + Age-Tier Adaptive UI (Week 13)

> **Depends on:** Sprint 3.1 (content browser) + Sprint 1.4 (canvas). Completes the first-run experience and ensures all UI adapts to tier.

- [ ] Wire complete onboarding flow: Welcome → Age Selection → first page auto-opens on canvas
- [ ] Curate "best first impression" page per tier (hardcoded page IDs)
- [ ] Implement contextual tooltips (`ONBOARD-002`): brush size, color picker, completion
- [ ] Tooltips appear only during first session, dismiss on tap, never repeat
- [ ] Verify Starter tier: 4 brushes at 64×64pt with labels, 40pt swatches in 2 rows, no "+" button
- [ ] Verify Explorer tier: 8 brushes at 48×48pt no labels, 32pt swatches scrolling, "+" button visible
- [ ] Verify Creator tier: same as Explorer + hex code input in color picker
- [ ] Settings screen: tier picker with confirmation dialog when changing
- [ ] Returning-user launch: bypass onboarding → resume in-progress or content browser

**📱 Testing — Sprint 3.3:**
```
Device: Physical iPhone
What to verify:
1. Delete and reinstall the app (or reset UserDefaults)
2. First launch: Welcome → tap "Get Started" → Age Selection appears
3. Tap "Starter" → canvas opens with a simple page, only 4 large brushes with labels
4. Draw a stroke → tooltip appears near size slider: "Drag to change brush size" (3 sec, then fades)
5. Tap a color → if Explorer/Creator: tooltip appears near "+": "Tap + for more colors"
6. Kill and relaunch → no onboarding; goes straight to content browser or canvas
7. Go to Settings → change tier to Creator → confirmation dialog → UI changes
8. Canvas now shows 8 brushes, color picker has hex input
9. Change to Starter → only 4 brushes, larger icons with labels below
```

---

### Sprint 3.4 — Celebration Animations (Week 14)

> **Depends on:** Sprint 3.2 (gallery for replay). The delight moment when a child finishes a page.

- [ ] Implement "Done ✓" button in canvas overflow menu as the sole completion trigger (`ANIM-001`)
- [ ] No automatic completion detection — celebration is always manually triggered by the child
- [ ] Build `CelebrationView.swift` — Screen 05 per design spec §2.4
- [ ] Implement celebration sequence: tools fade → artwork centers → animation plays
- [ ] Create 6 category-specific animation templates (`ANIM-002`):
  - [ ] Animals: character bounces across bottom
  - [ ] Vehicles: sparkle trail across screen
  - [ ] Fantasy: starburst from center + orbiting sparkles
  - [ ] Nature: flowers bloom at edges + butterflies
  - [ ] Holidays: confetti rain from top
  - [ ] Patterns: kaleidoscope rotation + prismatic glow
- [ ] Post-animation overlay: "Amazing work!" + Save/Share/Color Another buttons
- [ ] Rotating celebration messages (5 variants)
- [ ] Replay button (↻) replays animation
- [ ] Save button → save to gallery + toast
- [ ] Share button → parental gate (force gate) → share sheet
- [ ] "Color another" → content browser
- [ ] Gallery fullscreen replay: tap ↻ replays celebration for completed artworks

**📱 Testing — Sprint 3.4:**
```
Device: Physical iPhone (animation smoothness matters)
What to verify:
1. Open overflow menu (⋯) → tap "Done ✓" → tools fade out, artwork centers, animation plays (3–5 seconds)
2. "Done ✓" is always available regardless of how much coloring is done (manual trigger)
3. Animation matches the page's category (e.g., animals page → bouncing character)
4. After animation: "Amazing work!" text + Save / Share / "Color another" buttons appear
5. Tap Replay (↻) → animation plays again; buttons fade during replay, return after
6. Tap Save → "Saved to Gallery ✓" toast appears briefly
7. Tap Share → parental gate appears (even if within grace period) → share sheet
8. Tap "Color another" → navigates to content browser
9. Open gallery → find the saved artwork → tap it → fullscreen → tap ↻ → celebration replays
10. Test with a blank page: tap "Done ✓" → celebration still plays (no minimum fill required)
```

---

## MILESTONE 4: IAP, Safety, Audio, Pass & Play (Weeks 15–18)

### Sprint 4.1 — In-App Purchase (Weeks 15–16)

> **Depends on:** Sprint 3.1 (content browser with locked pages) + Sprint 3.2 (parental gate). Implements the monetization model.

- [ ] Set up StoreKit 2 configuration file for testing
- [ ] Implement `PurchaseManager.swift` — product fetch, purchase, restore (`IAP-002`)
- [ ] Build `IAPSheetView.swift` — Screen 08 per design spec §2.6.1
- [ ] Implement all purchase states: loading, success, failure, cancelled
- [ ] Purchase success: confetti overlay + unlock animation on content browser cards
- [ ] Implement restore purchases flow + all states (success, nothing found, failure)
- [ ] Implement free tier gating: 50 pages free, remainder locked (`IAP-001`)
- [ ] Locked page tap → IAP sheet (replace placeholder from Sprint 3.1)
- [ ] Content pack store infrastructure (`IAP-003`): `PackStoreView.swift` with "Coming Soon" state
- [ ] Parental gate before purchase flow
- [ ] "Restore Purchases" in Settings screen
- [ ] Verify purchase persists across app restarts
- [ ] Verify restore works across devices (same Apple ID)

**📱 Testing — Sprint 4.1:**
```
Device: Physical iPhone (StoreKit testing requires device or Xcode StoreKit Config)
What to verify:
1. Content browser shows some pages as locked (translucent + lock icon)
2. Tapping a locked page → IAP sheet slides up from bottom
3. Sheet shows "Unlock Everything $14.99" button + "Restore Purchase" + dismiss option
4. Tapping "Unlock Everything" → parental gate → Apple purchase sheet (sandbox)
5. Complete sandbox purchase → success overlay with confetti, all locked cards animate to full opacity
6. Kill and relaunch → all pages remain unlocked
7. Tap "Restore Purchase" (after clearing purchase state) → should restore
8. Pack Store: accessible from content browser → shows "Coming Soon" empty state
9. If purchase fails: inline error message appears below the button in coral text
10. If restore finds nothing: "No previous purchases found" message
```

---

### Sprint 4.2 — Audio System (Week 17)

> **Depends on:** Sprint 1.4 (canvas toolbar for mute toggle) + Sprint 3.4 (celebrations for celebration sounds). Placeholder sound files acceptable; real assets by M3.

- [ ] Implement `AudioManager.swift` conforming to `AudioManagerProtocol`
- [ ] Set up `AVAudioSession` for playback, respecting hardware silent switch
- [ ] Implement global mute toggle (`AUDIO-001`): canvas toolbar + Settings
- [ ] Mute state persists via UserPreferences
- [ ] Implement brush stroke sounds — one per brush type (`AUDIO-002`)
- [ ] Implement UI sounds: tool switch, color select, page open, save, undo/redo
- [ ] Implement color-select pitch variation (warm=lower, cool=higher via `AVAudioEngine`)
- [ ] Implement celebration sounds per category (`ANIM-003`)
- [ ] Implement ambient background music with loop + fade (`AUDIO-003`)
- [ ] Music volume separate from SFX volume (Settings slider)
- [ ] Music auto-pauses when system media is playing
- [ ] Music fades out on app background, fades in on return
- [ ] Implement `HapticManager.swift` — light impact on undo/redo, button presses

**📱 Testing — Sprint 4.2:**
```
Device: Physical iPhone (REQUIRED — audio and haptics don't work on simulator)
What to verify:
1. Drawing produces a subtle sound for each brush type (different sounds per brush)
2. Tapping a color swatch produces a soft tone
3. Tapping a brush icon produces a click/switch sound
4. Undo/redo produces a swoosh + light haptic tap
5. Completing a page: celebration sound plays matching the category
6. Mute toggle on canvas: tap speaker icon → all sounds stop immediately
7. Kill/relaunch → mute state persists
8. Settings → Sound section: toggle SFX off → brush/UI sounds stop, music continues
9. Settings → toggle Background Music off → music stops, SFX continue
10. Music volume slider → audibly changes music volume without affecting SFX
11. Play music from Apple Music, then open PaperBrush → ambient music should NOT play
12. Flip the hardware silent switch → all app audio should stop
13. Background the app while music is playing → music fades out; return → fades back in
```

---

### Sprint 4.3 — Pass & Play + Settings Complete (Week 18)

> **Depends on:** Sprint 4.2 (audio for countdown beeps) + Sprint 3.2 (parental gate). Completes the family mode and finalizes Settings.

- [ ] Build `PlayerSetupView.swift` — Screen 14 per design spec §2.7
- [ ] Avatar picker (8 animal options), name input, add/remove players (2–4)
- [ ] Turn time segmented control (30s / 60s / 90s)
- [ ] Build turn indicator bar (replaces top toolbar during play)
- [ ] Implement timer with countdown ring, warning states (≤10s, ≤3s)
- [ ] Implement countdown beeps in last 3 seconds (if not muted)
- [ ] Build `TurnHandoffView.swift` — Screen 11 with player avatar + "Tap to start"
- [ ] Build `PauseOverlayView.swift` — Screen 16 with Resume / End Game / Mute toggle
- [ ] Implement end game flow: confirmation → celebration → gallery save with all player names
- [ ] Complete `SettingsView.swift` — Screen 12 per design spec §2.8.2
- [ ] All Settings sections functional: Profile, Sound, Display, Purchases, About
- [ ] Tier change confirmation dialog
- [ ] Privacy Policy in-app web view
- [ ] Parental gate required before Settings access (grace period applies)

**📱 Testing — Sprint 4.3:**
```
Device: Physical iPhone (pass the device between two people to test handoff)
What to verify:
1. Canvas overflow → "Play Together" → parental gate → player setup sheet
2. Add two player names + choose avatars + pick 30s turns → "Start Coloring!"
3. Turn indicator bar appears at top with player name, avatar, timer ring
4. Timer counts down; at 10 seconds remaining, timer turns coral and pulses
5. At 3 seconds: audio countdown beeps (if not muted)
6. Timer hits 0 → handoff screen shows next player's name/avatar
7. Tap handoff screen → next player's turn begins
8. Tap Pause (⏸) → overlay shows frozen timer + Resume / End Game
9. "End Game" → confirmation → celebration → artwork saved crediting both players
10. Gallery: the saved artwork shows "By [Player1] & [Player2]"
11. Settings: all toggles work (sound, music, watermark)
12. Settings: changing tier shows confirmation, then UI updates throughout app
13. Settings → Restore Purchases works
14. Settings: gear icon on content browser requires parental gate to access
```

---

## MILESTONE 5: Polish, Beta, App Store Prep (Weeks 19–22)

### Sprint 5.1 — PDF Export + Performance Pass (Week 19)

> **Depends on:** Sprint 3.2 (gallery fullscreen) + Sprint 3.4 (celebration). Adds the "Art Comes Home" feature and optimizes everything.

- [ ] Build `PDFExportView.swift` — frame picker sheet per design spec §2.5.3
- [ ] 5 frame styles: Classic, Nature, Stars, Rainbow, Minimal (`EXPORT-001`)
- [ ] Artist name input (pre-filled from UserPreferences, persists)
- [ ] PDF preview within the sheet
- [ ] Generate 8.5"×11" PDF at 300 DPI with artwork + frame + name + date
- [ ] Share via iOS share sheet (AirPrint, email, save to Files)
- [ ] Performance profiling pass on iPhone SE 2nd gen
- [ ] Cold launch time <3s on iPhone 12+, <5s on iPhone SE 2
- [ ] Memory stays <300MB during coloring
- [ ] App install size audit (<200MB target)
- [ ] Fix any performance issues identified

**📱 Testing — Sprint 5.1:**
```
Device: Physical iPhone + access to a printer (AirPrint) or Files app
What to verify:
1. Gallery fullscreen → tap Print (🖨) → parental gate → frame picker sheet
2. 5 frame styles visible and selectable
3. Artist name field shows (pre-filled if previously entered)
4. PDF preview updates when changing frame style
5. Tap "Share / Print" → iOS share sheet opens with PDF
6. Save to Files → open the PDF → artwork looks sharp, frame renders correctly, name + date present
7. If printer available: print the PDF → verify 300 DPI quality (no pixelation)
8. Launch time: cold-launch the app (kill first) and count to 3 — should be interactive by then
9. On iPhone SE 2: launch and draw — acceptable performance? No crashes?
```

---

### Sprint 5.2 — Full Integration Testing + Bug Fixes (Weeks 20–21)

> **Depends on:** Everything. This is the integration sprint — every feature is built, now make sure they work together.

- [ ] Test complete flow: onboarding → browse → color → celebrate → gallery → share → repeat
- [ ] Test all 3 tiers end-to-end (Starter, Explorer, Creator)
- [ ] Test offline mode: airplane mode, verify all features work (`OFFLINE-001`)
- [ ] Test edge cases: 500 gallery items, very large canvas, rapid undo/redo
- [ ] Test parental gate at every integration point (see `navigation_architecture.md` §9)
- [ ] Accessibility pass: VoiceOver navigation through all screens
- [ ] Dynamic Type: test with largest accessibility text size
- [ ] Fix all bugs found during integration testing
- [ ] App icon and launch screen finalized
- [ ] Content pages: swap placeholder SVGs for final illustrations (from illustrator)

**📱 Testing — Sprint 5.2:**
```
Device: Physical iPhone + Physical iPad + iPhone SE 2nd gen
This is the comprehensive test. Go through EVERY flow:

FULL FLOW TEST (do this on each device):
1. Delete app → fresh install → onboarding → all 3 tiers
2. Color a page → celebrate → save → share (to yourself via Messages or AirDrop)
3. Start a page, partially color, leave → resume → continue → complete
4. Buy full unlock (sandbox) → verify all pages unlocked
5. Pass & Play with 2 players → complete → verify gallery credits
6. Print artwork as PDF → verify quality
7. Fill gallery with 10+ artworks → verify grid loads fast and scrolls smoothly
8. Turn on airplane mode → verify everything works (except purchase/restore)
9. Settings: toggle every option, change tier, verify all take effect

ACCESSIBILITY TEST:
10. Settings → Accessibility → VoiceOver ON → navigate the entire app by swiping
11. Settings → Display → Larger Text → max size → verify nothing overlaps or truncates
```

---

### Sprint 5.3 — App Store Submission (Week 22)

> **Depends on:** Sprint 5.2 (all bugs fixed). Prepares and submits to App Review.

- [ ] App Store listing copy: title, subtitle ("Color & Learn • Ages 3–12"), description, keywords
- [ ] Screenshots: 6.7" iPhone, 12.9" iPad, for all required device sizes
- [ ] Privacy Nutrition Label: configure in App Store Connect (zero data collection)
- [ ] Age rating: 4+ in App Store Connect
- [ ] Kids Category metadata
- [ ] Privacy policy URL (hosted, accessible from Settings)
- [ ] COPPA compliance final check
- [ ] Build archive and upload to App Store Connect
- [ ] Submit for App Review
- [ ] Prepare Day 1 monitoring plan: crash rate, conversion rate, retention

**📱 Testing — Sprint 5.3:**
```
Device: TestFlight build on 2–3 physical devices
What to verify:
1. Install via TestFlight (not Xcode) — simulates real App Store install
2. Complete the full flow test from Sprint 5.2 on the TestFlight build
3. Verify app size shown in TestFlight is <200MB
4. Verify IAP works in sandbox via TestFlight
5. Have 2–3 other people (ideally parents) install and test independently
6. Collect and address any feedback before final submission
```

---

## Progress Tracking

**How to update progress:** At the end of each session, Claude will list which checkboxes were completed. The developer should manually check them off in this file (change `[ ]` to `[x]`). This keeps the state persistent across sessions.

**Current status:**
- **Active Milestone:** M3 — Content, Gallery, Animations
- **Active Sprint:** 3.2 — IN TESTING (Gallery)
- **Last Updated:** 2026-04-18
- **Completed:** M1 (Sprints 1.1–1.4), M2 (Sprints 2.1–2.4), Sprint 3.1 (Content Browser), Sprint 3.2 (Gallery grid, gallery fullscreen, parental gate math challenge)
- **Architecture:** PencilKit for drawing, Metal kept for future effects. Spray/glitter/flood fill deferred post-launch.
- **Rename:** "Starter" tier renamed to "Doodler" throughout codebase
- **Note:** iPadOS 26 beta has PencilKit color rendering bug on physical iPad P3 displays (colors work on simulator + iPhone).

---

# currentDate
Today's date is 2026-03-20.
