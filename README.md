# PaperBrush

A children's coloring app for iOS, built for ages 3–12. Zero ads, zero subscriptions, one-time unlock at $14.99.

Built entirely with [Claude Code](https://claude.ai/code) by a solo developer learning iOS and Swift.

**Target launch:** September 2026

---

## What it is

PaperBrush lets kids color hand-drawn pages using brushes, stamps, and a full color palette. Three age tiers adapt the UI complexity to the child:

| Tier | Ages | Features |
|------|------|----------|
| **Doodler** | 3–5 | 4 large brushes with labels, 2-row color palette, simple UI |
| **Explorer** | 6–8 | All 8 brushes, custom color picker (HSB wheel) |
| **Creator** | 9–12 | Everything + hex color input, advanced controls |

---

## Tech stack

- **Language:** Swift 5.9+
- **UI:** SwiftUI (all screens) + UIKit/PencilKit (canvas)
- **Architecture:** MVVM — `@MainActor final class` ViewModels with `@Published` state
- **Concurrency:** `async/await` throughout, no Combine
- **Persistence:** Core Data (artwork metadata) + file system (canvas data, thumbnails)
- **IAP:** StoreKit 2
- **Dependencies:** Zero — Apple-native frameworks only (COPPA compliance)
- **Minimum iOS:** 16.0

---

## Project structure

```
PaperBrush/
├── DesignSystem/
│   ├── Tokens/          # PBTokens — colors, typography, spacing, shadows
│   └── Components/      # PBButton, PBCard, PBToast, PBTierBadge, etc.
├── Features/
│   ├── Onboarding/      # Welcome splash + age tier selection
│   ├── Canvas/          # PencilKit canvas, brushes, color tray, toolbar
│   ├── ContentBrowser/  # Page discovery grid with category filtering
│   ├── Gallery/         # Saved artwork grid + fullscreen viewer
│   ├── Celebration/     # Post-completion animation screen
│   ├── IAP/             # Unlock sheet + pack store
│   ├── Safety/          # Parental gate (math challenge)
│   └── Settings/        # Tier picker, sound, display, purchases
├── Models/              # Artwork, ColoringPage, AgeTier, BrushType, etc.
├── Navigation/          # AppRouter, Route enum, RootView
├── Services/
│   ├── Content/         # ContentStore — bundled coloring page data
│   └── Persistence/     # PersistenceManager + Core Data stack
└── Core/
    ├── Extensions/      # Color+HSB, Color+Hex
    └── Protocols/       # AudioManagerProtocol, PersistenceManagerProtocol, etc.
```

---

## Build & run

1. Open `PaperBrush/PaperBrush.xcodeproj` in Xcode 16+
2. Select the `PaperBrush` scheme
3. Choose an iPhone or iPad simulator (iOS 16+)
4. Press ⌘R

No dependencies to install — SPM packages are Apple-only and resolve automatically.

---

## Milestone progress

| Milestone | Target | Status |
|-----------|--------|--------|
| M1 — Foundation + Brush Engine | April 2026 | ✅ Complete |
| M2 — Canvas Feature-Complete | May 2026 | ✅ Complete |
| M3 — Content, Gallery, Animations | June 2026 | 🔄 In progress (Sprint 3.2) |
| M4 — IAP, Safety, Audio, Pass & Play | July 2026 | Upcoming |
| M5 — Polish, Beta, App Store Prep | August 2026 | Upcoming |
| Launch | September 2026 | — |

---

## Repository layout

```
/
├── PaperBrush/          # Xcode project
├── Mockups/             # HTML screen mockups + design spec
├── CLAUDE.md            # AI coding instructions (source of truth for all conventions)
├── component_library.md # Design token + component reference
├── data_model.md        # Core Data schema + model reference
├── navigation_architecture.md
├── technical_architecture.md
└── prd_v1_updated.md    # Product requirements
```

---

## Design system

All colors, fonts, spacing, and corner radii live in `PBTokens`. Nothing is hardcoded.

Key colors: Warm Cream background · Rich Teal primary · Deep Navy text · Sunset Coral accent  
Typography: Nunito (headings) · Nunito Sans (body) · SF Mono (hex codes, Creator tier only)
