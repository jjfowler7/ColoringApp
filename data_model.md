# PaperBrush — Data Model & Persistence Specification

**Version 1.0 | March 2026 | Core Data Schema + UserDefaults + File System**

---

## 1. Persistence Strategy Overview

PaperBrush has no backend (PRD §5.2). All data is stored locally:

| Data Type | Storage | Why |
|-----------|---------|-----|
| Artworks (gallery metadata) | Core Data | Queryable, sortable, supports 500+ items |
| Canvas pixel data | File System (Documents/) | Binary data too large for Core Data |
| User preferences | UserDefaults | Simple key-value, small data |
| Coloring page assets | App Bundle + ODR | Read-only, shipped with app |
| Purchase state | StoreKit 2 (on-device) | Apple manages receipt verification |
| Parental gate grace period | In-memory only | Resets on app termination (intentional) |

---

## 2. Core Data Schema

### 2.1 Entity: `ArtworkEntity`

Stores metadata for every saved artwork in the gallery.

| Attribute | Type | Required | Default | Notes |
|-----------|------|----------|---------|-------|
| `id` | UUID | Yes | auto-generated | Primary identifier |
| `pageId` | String | Yes | — | References the coloring page (e.g., "starter-animals-happy-sun") |
| `title` | String | Yes | — | Display name (e.g., "Happy Sun") |
| `tier` | String | Yes | — | "starter" / "explorer" / "creator" |
| `category` | String | Yes | — | "animals" / "vehicles" / etc. |
| `isCompleted` | Bool | Yes | false | True when celebration triggered |
| `completionPercentage` | Float | Yes | 0.0 | Reserved for future use. Not used in v1 (completion is manual trigger only). |
| `createdAt` | Date | Yes | now | When the artwork was first started |
| `lastModified` | Date | Yes | now | Updated on every save/auto-save |
| `canvasDataPath` | String | Yes | — | Relative path to canvas binary in Documents/ |
| `thumbnailPath` | String | Yes | — | Relative path to thumbnail PNG |
| `undoHistoryPath` | String | No | nil | Relative path to serialized undo stack |
| `playerNames` | String | No | nil | Comma-separated names for Pass & Play artworks |
| `animationTemplateId` | String | No | nil | Links to celebration animation |

**Indexes:** `lastModified` (descending), `isCompleted`, `tier`, `category`

### 2.2 Entity: `ContentPackEntity`

Tracks downloaded content pack state.

| Attribute | Type | Required | Default | Notes |
|-----------|------|----------|---------|-------|
| `id` | String | Yes | — | Pack identifier (matches IAP product ID) |
| `title` | String | Yes | — | Display name |
| `isPurchased` | Bool | Yes | false | — |
| `isDownloaded` | Bool | Yes | false | ODR download complete |
| `downloadedAt` | Date | No | nil | — |
| `pageCount` | Int16 | Yes | 0 | Number of pages in pack |

### 2.3 Swift Model Structs

Core Data entities are accessed through plain Swift structs (the ViewModels never touch NSManagedObject directly):

```swift
// File: Models/Artwork.swift
import Foundation

struct Artwork: Identifiable, Hashable {
    let id: UUID
    let pageId: String
    let title: String
    let tier: AgeTier
    let category: ContentCategory
    var isCompleted: Bool
    var completionPercentage: Float
    let createdAt: Date
    var lastModified: Date
    let canvasDataPath: String
    let thumbnailPath: String
    var undoHistoryPath: String?
    var playerNames: [String]?       // parsed from comma-separated string
    var animationTemplateId: String?
}
```

```swift
// File: Models/ColoringPage.swift
import Foundation

struct ColoringPage: Identifiable, Hashable {
    let id: String                    // e.g., "starter-animals-happy-sun"
    let title: String
    let tier: AgeTier
    let category: ContentCategory
    let difficulty: Int               // 1-3
    let animationTemplateId: String
    let regionCount: Int              // number of fillable regions
    let strokeWeight: Float           // line thickness in points
    let isFree: Bool
    let isNew: Bool
    let svgPath: String               // path to SVG in bundle
    let packId: String?               // nil = base app, otherwise pack ID
}
```

```swift
// File: Models/AgeTier.swift
import Foundation

enum AgeTier: String, CaseIterable, Codable, Hashable {
    case starter  = "starter"
    case explorer = "explorer"
    case creator  = "creator"

    var displayName: String {
        switch self {
        case .starter:  return "Starter"
        case .explorer: return "Explorer"
        case .creator:  return "Creator"
        }
    }

    var ageRange: String {
        switch self {
        case .starter:  return "Ages 3–5"
        case .explorer: return "Ages 6–8"
        case .creator:  return "Ages 9–12"
        }
    }

    var tagline: String {
        switch self {
        case .starter:  return "Big shapes & bold colors"
        case .explorer: return "More detail & cool tools"
        case .creator:  return "Fine art & custom colors"
        }
    }

    /// Number of brushes shown for this tier
    var brushCount: Int {
        switch self {
        case .starter: return 4
        case .explorer, .creator: return 8
        }
    }

    /// Whether the custom color picker (+) is available
    var hasCustomColorPicker: Bool {
        self != .starter
    }

    /// Whether hex code input is shown in color picker
    var hasHexInput: Bool {
        self == .creator
    }
}
```

```swift
// File: Models/ContentCategory.swift
import Foundation

enum ContentCategory: String, CaseIterable, Codable, Hashable {
    case animals   = "animals"
    case vehicles  = "vehicles"
    case fantasy   = "fantasy"
    case nature    = "nature"
    case holidays  = "holidays"
    case patterns  = "patterns"

    var displayName: String {
        switch self {
        case .animals:  return "Animals"
        case .vehicles: return "Vehicles"
        case .fantasy:  return "Fantasy"
        case .nature:   return "Nature"
        case .holidays: return "Holidays"
        case .patterns: return "Patterns"
        }
    }

    var iconName: String {
        switch self {
        case .animals:  return "icon-category-animals"
        case .vehicles: return "icon-category-vehicles"
        case .fantasy:  return "icon-category-fantasy"
        case .nature:   return "icon-category-nature"
        case .holidays: return "icon-category-holidays"
        case .patterns: return "icon-category-patterns"
        }
    }
}
```

```swift
// File: Models/BrushType.swift
import Foundation

enum BrushType: String, CaseIterable, Codable, Hashable {
    case crayon
    case marker
    case watercolor
    case pencil
    case spray
    case glitter
    case stamp
    case eraser

    var displayName: String {
        rawValue.capitalized
    }

    var iconName: String {
        "icon-brush-\(rawValue)"
    }

    /// Brushes available in Starter tier
    static var starterBrushes: [BrushType] {
        [.crayon, .marker, .stamp, .eraser]
    }

    /// Default brush size (points)
    var defaultSize: CGFloat {
        switch self {
        case .crayon:     return 12
        case .marker:     return 16
        case .watercolor: return 20
        case .pencil:     return 4
        case .spray:      return 30
        case .glitter:    return 24
        case .stamp:      return 32
        case .eraser:     return 16
        }
    }
}
```

```swift
// File: Models/Player.swift
import Foundation

struct Player: Identifiable, Hashable {
    let id: UUID
    var name: String
    var avatarName: String   // "avatar-bear", "avatar-cat", etc.
    var turnDuration: Int    // seconds: 30, 60, or 90

    static let avatarOptions = [
        "avatar-bear", "avatar-cat", "avatar-owl", "avatar-fox",
        "avatar-rabbit", "avatar-penguin", "avatar-lion", "avatar-frog"
    ]
}
```

---

## 3. UserDefaults — `UserPreferences`

All UserDefaults access goes through this wrapper. Never read/write UserDefaults directly elsewhere.

```swift
// File: Services/Persistence/UserPreferences.swift
import Foundation

final class UserPreferences {
    static let shared = UserPreferences()
    private let defaults = UserDefaults.standard

    // MARK: - Keys
    private enum Key: String {
        case selectedTier           // AgeTier raw value
        case hasCompletedOnboarding // Bool
        case artistName             // String (for PDF export)
        case isSoundEffectsEnabled  // Bool
        case isBackgroundMusicEnabled // Bool
        case musicVolume            // Float (0.0–1.0)
        case isWatermarkEnabled     // Bool
        case isMuted                // Bool (global mute, AUDIO-001)
        case recentCustomColors     // [String] hex codes, max 8
        case brushSizes             // [String: CGFloat] per brush type
        case notifyForNewPacks      // Bool
        case lastUsedPageId         // String? (for returning-user resume)
        case hasInProgressArtwork   // Bool
        case inProgressArtworkId    // UUID string
    }

    // MARK: - Profile
    var selectedTier: AgeTier {
        get { AgeTier(rawValue: defaults.string(forKey: Key.selectedTier.rawValue) ?? "") ?? .explorer }
        set { defaults.set(newValue.rawValue, forKey: Key.selectedTier.rawValue) }
    }

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Key.hasCompletedOnboarding.rawValue) }
        set { defaults.set(newValue, forKey: Key.hasCompletedOnboarding.rawValue) }
    }

    var artistName: String {
        get { defaults.string(forKey: Key.artistName.rawValue) ?? "" }
        set { defaults.set(newValue, forKey: Key.artistName.rawValue) }
    }

    // MARK: - Audio (AUDIO-001, AUDIO-002, AUDIO-003)
    var isMuted: Bool {
        get { defaults.bool(forKey: Key.isMuted.rawValue) }
        set { defaults.set(newValue, forKey: Key.isMuted.rawValue) }
    }

    var isSoundEffectsEnabled: Bool {
        get { defaults.object(forKey: Key.isSoundEffectsEnabled.rawValue) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Key.isSoundEffectsEnabled.rawValue) }
    }

    var isBackgroundMusicEnabled: Bool {
        get { defaults.object(forKey: Key.isBackgroundMusicEnabled.rawValue) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Key.isBackgroundMusicEnabled.rawValue) }
    }

    var musicVolume: Float {
        get { defaults.object(forKey: Key.musicVolume.rawValue) as? Float ?? 0.7 }
        set { defaults.set(newValue, forKey: Key.musicVolume.rawValue) }
    }

    // MARK: - Display
    var isWatermarkEnabled: Bool {
        get { defaults.bool(forKey: Key.isWatermarkEnabled.rawValue) }
        set { defaults.set(newValue, forKey: Key.isWatermarkEnabled.rawValue) }
    }

    // MARK: - Color Picker
    var recentCustomColors: [String] {
        get { defaults.stringArray(forKey: Key.recentCustomColors.rawValue) ?? [] }
        set {
            let trimmed = Array(newValue.prefix(8))
            defaults.set(trimmed, forKey: Key.recentCustomColors.rawValue)
        }
    }

    // MARK: - Brush Sizes (persists per brush type, BRUSH-004)
    func brushSize(for brush: BrushType) -> CGFloat {
        let dict = defaults.dictionary(forKey: Key.brushSizes.rawValue) as? [String: CGFloat] ?? [:]
        return dict[brush.rawValue] ?? brush.defaultSize
    }

    func setBrushSize(_ size: CGFloat, for brush: BrushType) {
        var dict = defaults.dictionary(forKey: Key.brushSizes.rawValue) as? [String: CGFloat] ?? [:]
        dict[brush.rawValue] = size
        defaults.set(dict, forKey: Key.brushSizes.rawValue)
    }

    // MARK: - Session Resume
    var lastUsedPageId: String? {
        get { defaults.string(forKey: Key.lastUsedPageId.rawValue) }
        set { defaults.set(newValue, forKey: Key.lastUsedPageId.rawValue) }
    }

    var inProgressArtworkId: UUID? {
        get {
            guard let string = defaults.string(forKey: Key.inProgressArtworkId.rawValue) else { return nil }
            return UUID(uuidString: string)
        }
        set { defaults.set(newValue?.uuidString, forKey: Key.inProgressArtworkId.rawValue) }
    }

    // MARK: - Pack Store
    var notifyForNewPacks: Bool {
        get { defaults.bool(forKey: Key.notifyForNewPacks.rawValue) }
        set { defaults.set(newValue, forKey: Key.notifyForNewPacks.rawValue) }
    }
}
```

---

## 4. File System Layout

```
Documents/                              ← persists across app updates
├── artworks/
│   ├── {uuid}/
│   │   ├── canvas.pbdata               ← serialized tile data (binary)
│   │   ├── thumbnail.png               ← 256×256 gallery thumbnail
│   │   └── undo_history.pbdata         ← serialized undo stack (optional)
│   └── {uuid}/
│       └── ...
│
└── exports/                            ← temporary, cleaned periodically
    └── {uuid}.pdf                      ← generated PDF for sharing
```

**Important rules:**
- Canvas data files use a custom `.pbdata` extension (serialized binary)
- Thumbnails regenerated from canvas data if missing
- The `exports/` directory is cleaned on app launch (temp files only)
- Total artwork storage should be monitored; warn if approaching device limits

---

## 5. Persistence Manager Interface

```swift
// File: Core/Protocols/PersistenceManagerProtocol.swift

protocol PersistenceManagerProtocol {
    // Artworks
    func saveArtwork(_ artwork: Artwork) async throws
    func fetchArtworks() async throws -> [Artwork]
    func fetchArtwork(id: UUID) async throws -> Artwork?
    func deleteArtwork(id: UUID) async throws
    func updateArtwork(_ artwork: Artwork) async throws

    // Canvas data (file system)
    func saveCanvasData(_ data: Data, for artworkId: UUID) async throws
    func loadCanvasData(for artworkId: UUID) async throws -> Data
    func saveThumbnail(_ image: UIImage, for artworkId: UUID) async throws
    func loadThumbnail(for artworkId: UUID) async throws -> UIImage?

    // Undo history
    func saveUndoHistory(_ data: Data, for artworkId: UUID) async throws
    func loadUndoHistory(for artworkId: UUID) async throws -> Data?

    // Cleanup
    func cleanupExports() async
    func totalStorageUsed() async -> Int64  // bytes
}
```

---

## 6. StoreKit 2 Product IDs

```swift
// File: Services/Purchase/ProductIDs.swift

enum ProductID {
    static let fullUnlock = "com.paperbrush.fullunlock"  // $14.99 non-consumable

    // Content packs (infrastructure in v1, first pack ships ~60 days post-launch)
    static let packPrefix = "com.paperbrush.pack."
    // e.g., "com.paperbrush.pack.ocean-adventures"
}
```

---

## 7. Data Flow Diagrams

### 7.1 Auto-Save Flow (GALLERY-003)

```
User draws stroke
    │
    ├─→ Stroke renders to canvas (immediate, 60fps)
    │
    └─→ Every 30 seconds (or on app background):
         │
         ├─ Serialize current tile data → canvas.pbdata
         ├─ Generate thumbnail → thumbnail.png
         ├─ Serialize undo stack → undo_history.pbdata
         └─ Update ArtworkEntity.lastModified in Core Data
```

### 7.2 Gallery Load Flow

```
GalleryView appears
    │
    ▼
GalleryViewModel.loadGallery()
    │
    ▼
PersistenceManager.fetchArtworks()
    │ (Core Data fetch, sorted by lastModified DESC)
    ▼
For each artwork: load thumbnail from file system
    │
    ▼
Display in grid (lazy loading, max 500 items in <1s)
```

### 7.3 Purchase Flow

```
User taps locked page → IAP sheet appears
    │
    ▼
User taps "Unlock Everything $14.99"
    │
    ▼
Parental Gate modal
    │ (correct math answer)
    ▼
PurchaseManager.purchase()
    │ (StoreKit 2 payment sheet)
    ▼
    ├─ Success: Update entitlements, dismiss sheet, animate unlock
    ├─ Cancelled: Sheet stays, no action
    └─ Failure: Inline error, retry available
```

---

## 8. Audio Asset Inventory

Audio is defined across three PRD features (AUDIO-001, AUDIO-002, AUDIO-003) and celebration sounds (ANIM-003). This section specifies every audio file the app needs, organized by category.

### 8.1 File Format & Technical Requirements

| Property | Specification | Rationale |
|----------|--------------|-----------|
| Format | `.caf` (Core Audio Format) or `.m4a` (AAC) | Native iOS, small files, hardware-decoded |
| Sample rate | 44.1kHz | Standard, overkill for SFX but needed for music |
| Bit depth | 16-bit | Sufficient for all use cases |
| Channels | Mono (SFX), Stereo (music) | Mono SFX saves 50% file size |
| Max duration | SFX: <500ms, Music: 2–4 minutes (loopable) | PRD AUDIO-002: "All sounds <500ms" |
| Total audio budget | ~10–15MB | Part of the 200MB install budget |

### 8.2 Sound Effects — Brush Strokes (AUDIO-002)

Each brush produces a distinct tactile sound on stroke. These are NOT looping — they play once per stroke start, with subtle pitch/timing variation.

| File Name | Brush | Description | Duration | Priority |
|-----------|-------|-------------|----------|----------|
| `sfx-brush-crayon.caf` | Crayon | Dry, waxy scratch on paper — like dragging a real crayon | ~200ms | P1 |
| `sfx-brush-marker.caf` | Marker | Smooth, slightly squeaky glide — chisel tip on smooth paper | ~200ms | P1 |
| `sfx-brush-watercolor.caf` | Watercolor | Soft, wet bristle swish — brush loaded with water | ~250ms | P1 |
| `sfx-brush-pencil.caf` | Pencil | Light, scratchy graphite — finer and quieter than crayon | ~150ms | P1 |
| `sfx-brush-spray.caf` | Spray | Short aerosol hiss — gentle, not aggressive | ~300ms | P1 |
| `sfx-brush-glitter.caf` | Glitter | Bright shimmer/sparkle cascade — magical tinkle | ~300ms | P1 |
| `sfx-brush-stamp.caf` | Stamp | Soft thump — rubber stamp pressing on paper | ~150ms | P1 |
| `sfx-brush-eraser.caf` | Eraser | Soft rubbery scrub — eraser on textured paper | ~200ms | P1 |

### 8.3 Sound Effects — UI Interactions (AUDIO-002)

| File Name | Trigger | Description | Duration | Priority |
|-----------|---------|-------------|----------|----------|
| `sfx-ui-tool-switch.caf` | Tap brush/tool icon | Brief click/snap — tactile tool selection | ~100ms | P1 |
| `sfx-ui-color-select.caf` | Tap color swatch | Soft tone — pitch varies by hue position (warm=lower, cool=higher). Ship 1 base file; pitch-shift in code. | ~150ms | P1 |
| `sfx-ui-page-open.caf` | Open a coloring page | Paper unfolding/page turn — satisfying "new canvas" feel | ~300ms | P1 |
| `sfx-ui-gallery-open.caf` | Open gallery | Soft whoosh + subtle camera shutter undertone | ~250ms | P1 |
| `sfx-ui-save.caf` | Save to gallery | Soft positive chime — "confirmed" feel | ~200ms | P1 |
| `sfx-ui-button-tap.caf` | Generic button press | Subtle, soft tap — used as fallback for unlisted buttons | ~80ms | P1 |
| `sfx-ui-sheet-present.caf` | Sheet slides up (IAP, color picker, etc.) | Gentle slide/swoosh up | ~200ms | P1 |
| `sfx-ui-undo.caf` | Undo action | Quick reverse swoosh — "stepping back" | ~150ms | P1 |
| `sfx-ui-redo.caf` | Redo action | Quick forward swoosh — "stepping forward" | ~150ms | P1 |

### 8.4 Sound Effects — Celebration (ANIM-003)

Each content category has a unique celebration sound. These are longer and more expressive.

| File Name | Category | Description | Duration | Priority |
|-----------|----------|-------------|----------|----------|
| `sfx-celebrate-animals.caf` | Animals | Playful xylophone melody — bouncy, bright, ascending | ~2s | P1 |
| `sfx-celebrate-vehicles.caf` | Vehicles | Whoosh + cheerful horn/beep — movement energy | ~2s | P1 |
| `sfx-celebrate-fantasy.caf` | Fantasy | Magical chime cascade — enchanted, sparkly, descending arpeggiate | ~2.5s | P1 |
| `sfx-celebrate-nature.caf` | Nature | Gentle wind chime + bird chirps — peaceful, organic | ~2.5s | P1 |
| `sfx-celebrate-holidays.caf` | Holidays | Party horn + sparkle pop — festive, confetti-feel | ~2s | P1 |
| `sfx-celebrate-patterns.caf` | Patterns | Ascending tone scale — geometric, satisfying, precise | ~2s | P1 |

### 8.5 Sound Effects — Pass & Play (FAMILY-001)

| File Name | Trigger | Description | Duration | Priority |
|-----------|---------|-------------|----------|----------|
| `sfx-pnp-countdown-beep.caf` | Last 3 seconds of turn | Soft chime — one per second, ascending pitch | ~200ms | P1 |
| `sfx-pnp-times-up.caf` | Timer reaches zero | Gentle bell/gong — "turn over" without being alarming | ~500ms | P1 |
| `sfx-pnp-handoff.caf` | Handoff screen appears | Playful swoosh — "your turn!" energy | ~400ms | P1 |

### 8.6 Ambient Background Music (AUDIO-003)

2–3 gentle, non-distracting instrumental tracks that loop seamlessly.

| File Name | Description | Duration | BPM | Key | Priority |
|-----------|-------------|----------|-----|-----|----------|
| `music-ambient-01.m4a` | Gentle piano + soft strings — calm, focused, Montessori-classroom feel | 2–3 min (loop) | 70–80 | C major | P1 |
| `music-ambient-02.m4a` | Soft marimba + light percussion — slightly more playful, warm | 2–3 min (loop) | 80–90 | G major | P1 |
| `music-ambient-03.m4a` | Acoustic guitar + ambient pads — dreamy, contemplative | 2–3 min (loop) | 65–75 | F major | P1 |

**Music behavior (from PRD AUDIO-003):**
- Volume independent of SFX volume (separate slider in Settings)
- Fades out 500ms on app background; fades in 500ms on return
- Auto-pauses if system media is playing (respects `AVAudioSession` category)
- Loops seamlessly (files must have clean loop points, no silence at start/end)

### 8.7 AudioManager Interface

```swift
// File: Core/Protocols/AudioManagerProtocol.swift

protocol AudioManagerProtocol {
    // Global state
    var isMuted: Bool { get set }
    var isSoundEffectsEnabled: Bool { get set }
    var isBackgroundMusicEnabled: Bool { get set }
    var musicVolume: Float { get set }

    // Sound effects
    func playBrushSound(_ brush: BrushType)
    func playUISound(_ sound: UISound)
    func playCelebrationSound(for category: ContentCategory)
    func playPassAndPlaySound(_ sound: PassAndPlaySound)

    // Music
    func startBackgroundMusic()
    func stopBackgroundMusic()
    func fadeOutMusic(duration: TimeInterval)
    func fadeInMusic(duration: TimeInterval)

    // Color-pitched tone (AUDIO-002: color selection pitch varies by hue)
    func playColorSelectTone(hue: CGFloat)  // 0.0–1.0
}

enum UISound: String {
    case toolSwitch     = "sfx-ui-tool-switch"
    case colorSelect    = "sfx-ui-color-select"
    case pageOpen       = "sfx-ui-page-open"
    case galleryOpen    = "sfx-ui-gallery-open"
    case save           = "sfx-ui-save"
    case buttonTap      = "sfx-ui-button-tap"
    case sheetPresent   = "sfx-ui-sheet-present"
    case undo           = "sfx-ui-undo"
    case redo           = "sfx-ui-redo"
}

enum PassAndPlaySound: String {
    case countdownBeep  = "sfx-pnp-countdown-beep"
    case timesUp        = "sfx-pnp-times-up"
    case handoff        = "sfx-pnp-handoff"
}
```

### 8.8 Audio File System Layout

```
Resources/
└── Sounds/
    ├── Brushes/
    │   ├── sfx-brush-crayon.caf
    │   ├── sfx-brush-marker.caf
    │   ├── sfx-brush-watercolor.caf
    │   ├── sfx-brush-pencil.caf
    │   ├── sfx-brush-spray.caf
    │   ├── sfx-brush-glitter.caf
    │   ├── sfx-brush-stamp.caf
    │   └── sfx-brush-eraser.caf
    ├── UI/
    │   ├── sfx-ui-tool-switch.caf
    │   ├── sfx-ui-color-select.caf
    │   ├── sfx-ui-page-open.caf
    │   ├── sfx-ui-gallery-open.caf
    │   ├── sfx-ui-save.caf
    │   ├── sfx-ui-button-tap.caf
    │   ├── sfx-ui-sheet-present.caf
    │   ├── sfx-ui-undo.caf
    │   └── sfx-ui-redo.caf
    ├── Celebrations/
    │   ├── sfx-celebrate-animals.caf
    │   ├── sfx-celebrate-vehicles.caf
    │   ├── sfx-celebrate-fantasy.caf
    │   ├── sfx-celebrate-nature.caf
    │   ├── sfx-celebrate-holidays.caf
    │   └── sfx-celebrate-patterns.caf
    ├── PassAndPlay/
    │   ├── sfx-pnp-countdown-beep.caf
    │   ├── sfx-pnp-times-up.caf
    │   └── sfx-pnp-handoff.caf
    └── Music/
        ├── music-ambient-01.m4a
        ├── music-ambient-02.m4a
        └── music-ambient-03.m4a
```

**Total files: 30** (20 SFX + 6 celebrations + 3 Pass&Play + 3 music tracks)

### 8.9 Sourcing Strategy

These audio files need to be created or licensed before the audio features can be implemented:

| Option | Pros | Cons | Cost Estimate |
|--------|------|------|---------------|
| **Royalty-free sound libraries** (Artlist, Epidemic Sound, Pixabay) | Fast, wide selection, pre-mixed | May need editing for duration/loop points, generic feel | $0–$200/yr |
| **Custom sound designer** (Fiverr, freelance) | Unique to your app, exact specs met, cohesive aesthetic | Longer lead time (2–4 weeks), iteration cycles | $500–$2,000 |
| **AI-generated audio** (Suno, Udio for music; ElevenLabs SFX) | Fast iteration, cheap, custom to spec | Quality varies, licensing terms evolving, may sound artificial | $20–$50 |
| **Hybrid** (recommended) | Music custom, SFX from libraries | Balanced time/cost/quality | $200–$800 |

**Recommended approach:** Source SFX from royalty-free libraries (faster, good enough for v1), commission the 3 ambient music tracks custom (music quality matters more for sustained listening). Plan to upgrade SFX to custom in a post-launch polish pass if needed.

**Timeline:** Audio assets should be sourced by M3 (June 2026) when the audio system is integrated. Placeholder beeps can be used during development.

---

End of Data Model & Persistence Specification.
