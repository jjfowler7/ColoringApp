# [App Name] — UX Design Specifications

**Version 1.1 | March 2026 | For use with Google Stitch mockup generation**
**Covers all P0 and P1 features from PRD v1 — updated with gap analysis states**

---

## 1. Design System

### 1.1 Visual Direction: "Paper Studio"

The aesthetic merges the tactile warmth of a child's art studio with the clean confidence of a premium iOS app. Think Montessori classroom meets Apple design language: warm wood tones, soft paper textures, and hand-crafted details balanced against precise geometry and generous whitespace. The app should feel like opening a beautiful box of art supplies — inviting, organized, and full of possibility.

**Core principles:**
- Tactile over digital: surfaces feel like real materials (paper grain, soft canvas, smooth wood)
- Confident simplicity: big touch targets, obvious affordances, zero clutter
- Celebration over instruction: the child's artwork is always the hero
- Age-adaptive chrome: UI complexity scales with tier selection, but the aesthetic stays unified

### 1.2 Color Palette

```
PRIMARY COLORS
─────────────────────────────────────────
Warm Cream (background):     #FFF8F0
Soft Canvas (card surfaces): #FFFDF9
Rich Teal (primary action):  #0EA5A0
Deep Navy (text/headers):    #1B2A4A
Sunset Coral (accent/CTA):   #F06449

SUPPORTING COLORS
─────────────────────────────────────────
Honey Gold (warnings/stars):  #F5A623
Soft Sage (success/confirm):  #7CB686
Lavender Mist (Creator tier): #B8A9E8
Sky Blue (Explorer tier):     #6BB8E8
Peach Blush (Starter tier):   #FCBFA0
Soft Graphite (secondary text):#666666
Light Divider:                #E8E0D8

AGE-TIER ACCENT COLORS
─────────────────────────────────────────
Starter (3–5):   Peach Blush #FCBFA0 with Coral #F06449 accents
Explorer (6–8):  Sky Blue #6BB8E8 with Teal #0EA5A0 accents
Creator (9–12):  Lavender #B8A9E8 with Navy #1B2A4A accents
```

### 1.3 Typography

```
DISPLAY / HEADERS
─────────────────────────────────────────
Family:    Nunito (Google Fonts) — rounded, friendly, highly legible
Weights:   Bold (700) for headers, ExtraBold (800) for hero text
Usage:     Section titles, button labels, screen headers

BODY / UI TEXT
─────────────────────────────────────────
Family:    Nunito Sans — clean companion to Nunito
Weights:   Regular (400) for body, SemiBold (600) for emphasis
Usage:     Descriptions, labels, metadata

MONO / DATA
─────────────────────────────────────────
Family:    SF Mono (system) — for hex codes in Creator tier color picker
```

**Type scale (points):**
| Usage | iPhone | iPad |
|---|---|---|
| Hero / splash title | 36pt | 52pt |
| Screen header (H1) | 24pt | 32pt |
| Section header (H2) | 18pt | 24pt |
| Button label | 16pt | 18pt |
| Body text | 15pt | 17pt |
| Caption / metadata | 12pt | 14pt |
| Badge / tag | 10pt | 12pt |

### 1.4 Spacing & Layout Grid

```
BASE UNIT: 8pt

Spacing tokens:
  xs:   4pt     (icon internal padding)
  sm:   8pt     (between related elements)
  md:   16pt    (component internal padding)
  lg:   24pt    (between sections)
  xl:   32pt    (screen margins on iPhone)
  2xl:  48pt    (screen margins on iPad)
  3xl:  64pt    (major section separation)

IPHONE LAYOUT
─────────────────────────────────────────
Screen width:    390pt (iPhone 14/15 baseline)
Safe margins:    16pt left/right
Content width:   358pt
Grid:            2-column for gallery, full-width for canvas
Nav bar height:  56pt
Tab bar height:  0pt (no tab bar — navigation via toolbar + back)
Bottom safe area: 34pt (home indicator)

IPAD LAYOUT
─────────────────────────────────────────
Screen width:    1024pt (iPad 10th gen landscape baseline)
Safe margins:    32pt left/right
Content width:   960pt
Grid:            4-column for gallery, full-width for canvas
Sidebar width:   280pt (content browser in landscape)
Bottom safe area: 20pt
```

### 1.5 Corner Radii

```
xs:    6pt    (small badges, tags)
sm:    10pt   (buttons, input fields)
md:    16pt   (cards, dialogs)
lg:    24pt   (panels, sheets)
xl:    32pt   (featured cards, hero images)
full:  9999pt (pills, avatar circles)
```

### 1.6 Shadows & Elevation

```
Level 0 (flat):      none
Level 1 (resting):   0 2pt 8pt rgba(27,42,74, 0.06)
Level 2 (raised):    0 4pt 16pt rgba(27,42,74, 0.10)
Level 3 (floating):  0 8pt 32pt rgba(27,42,74, 0.14)
Level 4 (modal):     0 16pt 48pt rgba(27,42,74, 0.18)
```

### 1.7 Iconography

Style: Rounded line icons, 2pt stroke weight, matching Nunito's rounded personality. Custom icons for brush types (crayon, marker, watercolor, etc.) should look like miniature illustrations of the actual tool. Use SF Symbols for standard iOS actions (share, settings, back).

Touch targets: minimum 44x44pt on all interactive elements. Brush type icons on canvas toolbar: 48x48pt on iPhone, 56x56pt on iPad.

### 1.8 Motion Principles

```
EASING
─────────────────────────────────────────
Default:       cubic-bezier(0.25, 0.1, 0.25, 1.0)  — smooth ease
Spring:        damping 0.7, stiffness 300           — playful bounce
Celebration:   damping 0.5, stiffness 200           — exaggerated joy

DURATIONS
─────────────────────────────────────────
Instant:       100ms   (button press feedback, tool switch)
Quick:         200ms   (panel slide, color swatch select)
Standard:      300ms   (screen transitions, sheet presentation)
Expressive:    500ms   (celebration animation start, page load)
Dramatic:      800ms+  (completion animation, onboarding reveal)

PAGE TRANSITIONS
─────────────────────────────────────────
Forward navigation:  slide from right + 20% scale up
Back navigation:     slide to right + 20% scale down
Modal presentation:  slide up from bottom with spring
Dismiss:             slide down with gravity ease
```

---

## 2. Screen Specifications

### 2.1 Onboarding Flow — ONBOARD-001

**Flow: Welcome → Age Selection → First Page (3 screens, under 15 seconds)**

#### Screen 2.1.1: Welcome Splash

```
PURPOSE:     First impression. Establish trust and tone.
ENTRY:       App cold launch (first time only)
EXIT:        Tap "Get Started" → Age Selection

LAYOUT (iPhone)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│         [status bar — hidden]       │
│                                     │
│                                     │
│          ┌─────────────┐            │
│          │   App Icon   │           │
│          │  (animated)  │           │
│          └─────────────┘            │
│                                     │
│          [App Name]                 │
│     "Where your art comes alive"    │
│                                     │
│                                     │
│   ┌───────────────────────────┐     │
│   │       Get Started         │     │
│   └───────────────────────────┘     │
│                                     │
│          Skip ›                     │
│                                     │
│    ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─      │
│    [safe area]                      │
└─────────────────────────────────────┘

LAYOUT (iPad landscape)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌──────────────────────────────────────────────────────┐
│                                                      │
│     ┌──────────────────┐  ┌────────────────────┐     │
│     │                  │  │                    │     │
│     │   Animated        │  │  [App Name]       │     │
│     │   illustration    │  │  Tagline text     │     │
│     │   of kids coloring│  │                    │     │
│     │                  │  │  [Get Started]     │     │
│     │                  │  │  Skip ›            │     │
│     └──────────────────┘  └────────────────────┘     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

**Specifications:**
- Background: Warm Cream #FFF8F0 with subtle paper texture overlay (5% opacity noise grain)
- App icon: 120x120pt, animated entrance — scales from 0 to 1 with spring easing over 600ms
- Title: Nunito ExtraBold 36pt (iPhone) / 52pt (iPad), Deep Navy #1B2A4A
- Tagline: Nunito Sans Regular 17pt, Soft Graphite #666666
- "Get Started" button: full-width (minus 32pt margins), 56pt height, Rich Teal #0EA5A0 fill, white Nunito Bold 18pt label, corner radius `sm` (10pt), Level 2 shadow
- "Skip" link: Nunito Sans SemiBold 15pt, Soft Graphite #666666, no underline
- "Skip" destination: navigates to Content Browser with Explorer tier pre-selected as the default. If no tier is set, Explorer is assumed until the user changes it in Settings.
- Animated detail: 3–4 tiny colored pencil marks float gently across background (CSS-only keyframe, 8s loop, very subtle)
- Status bar: hidden on this screen only

**Returning user behavior:**
- On subsequent launches (not first time), the app bypasses the Welcome Splash and Age Selection entirely.
- If the child had an in-progress artwork, the app opens directly to the Canvas with that artwork loaded.
- If no in-progress artwork exists, the app opens to the Content Browser with the previously selected tier.

#### Screen 2.1.2: Age Selection

```
PURPOSE:     Set content tier. Adaptive UI complexity depends on this choice.
ENTRY:       Tap "Get Started" from Welcome
EXIT:        Tap any tier card → First coloring page auto-opens

LAYOUT (iPhone)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│ [status bar]                        │
│                                     │
│    "Who's coloring today?"          │
│                                     │
│   ┌───────────────────────────┐     │
│   │  🖍  [crayon illustration] │     │
│   │    Starter                 │     │
│   │    Ages 3–5                │     │
│   │    Big shapes & bold colors│     │
│   └───────────────────────────┘     │
│                                     │
│   ┌───────────────────────────┐     │
│   │  🎨  [palette illustration]│     │
│   │    Explorer                │     │
│   │    Ages 6–8                │     │
│   │    More detail & cool tools│     │
│   └───────────────────────────┘     │
│                                     │
│   ┌───────────────────────────┐     │
│   │  ✏️  [pen illustration]    │     │
│   │    Creator                 │     │
│   │    Ages 9–12               │     │
│   │    Fine art & custom colors│     │
│   └───────────────────────────┘     │
│                                     │
│  "You can always change this later" │
│                                     │
└─────────────────────────────────────┘

LAYOUT (iPad landscape)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌──────────────────────────────────────────────────────┐
│                                                      │
│             "Who's coloring today?"                   │
│                                                      │
│   ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│   │  Starter │  │ Explorer │  │ Creator  │          │
│   │  3–5     │  │  6–8     │  │  9–12    │          │
│   │  [illust]│  │ [illust] │  │ [illust] │          │
│   │  desc    │  │  desc    │  │  desc    │          │
│   └──────────┘  └──────────┘  └──────────┘          │
│                                                      │
│          "You can always change this later"           │
└──────────────────────────────────────────────────────┘
```

**Specifications:**
- Header: Nunito Bold 28pt (iPhone) / 36pt (iPad), Deep Navy, centered
- Tier cards: full-width stacked (iPhone), 3-across (iPad), corner radius `lg` (24pt), Level 2 shadow
  - Starter card: Peach Blush #FCBFA0 background at 20% opacity, Coral border-left 4pt
  - Explorer card: Sky Blue #6BB8E8 background at 20% opacity, Teal border-left 4pt
  - Creator card: Lavender #B8A9E8 background at 20% opacity, Navy border-left 4pt
- Each card: 100pt height (iPhone) / 160pt height (iPad)
  - Illustration: 56x56pt custom icon on left (crayon / palette / fine pen), colored per tier
  - Tier name: Nunito Bold 20pt, Deep Navy
  - Age range: Nunito Sans SemiBold 14pt, tier accent color
  - Description: Nunito Sans Regular 14pt, Soft Graphite
- Reassurance text: Nunito Sans Regular 13pt, Soft Graphite, centered, 16pt below last card
- Cards animate in staggered: 100ms delay between each, slide up 20pt + fade in, spring easing
- On tap: selected card scales to 1.05 briefly (100ms) then triggers page transition

#### Screen 2.1.3: First Page (Auto-open)

```
PURPOSE:     Immediately drop child into coloring. Zero friction.
ENTRY:       Tier selection from Age Screen
EXIT:        N/A — this IS the canvas (see Section 2.2)
NOTE:        This is the Canvas screen (2.2) with ONBOARD-002 tooltip overlay
```

The first page auto-loads a curated "best first impression" page for the selected tier. The canvas toolbar appears, and contextual tooltips (ONBOARD-002) appear during the first session.

---

### 2.2 Canvas & Coloring Screen — BRUSH-001–005, COLOR-001–002, AUDIO-001

**The primary screen. Children spend 90%+ of their time here.**

#### 2.2.1 Canvas Layout

```
LAYOUT (iPhone — Portrait)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│ ◀ │ Page Title        │ 🔇 ⋯ │ 44pt│  ← Top toolbar
├─────────────────────────────────────┤
│                                     │
│                                     │
│                                     │
│         [CANVAS AREA]               │
│     Coloring page fills             │
│     maximum available space.        │
│     Pinch to zoom (2x–10x).        │
│     Two-finger pan.                 │
│                                     │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│ [brush icons row]              │56pt│  ← Brush toolbar
│  🖍 🖊 💧 ✏️ 🌫 ✨ ⭐ ◻️          │    │
├─────────────────────────────────────┤
│ ○○○○○○○○○○○○○○○○○○○○○○○○ [+] │48pt│  ← Color tray
├─────────────────────────────────────┤
│ [  ↩  ] [size ━━━━●━━━] [  ↪  ]│40pt│  ← Undo/size/redo bar
├─────────────────────────────────────┤
│            [safe area]         │34pt│
└─────────────────────────────────────┘

LAYOUT (iPad — Landscape)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌──────────────────────────────────────────────────────┐
│  ◀ │ Page Title                    │ 🔇 ⋯ │        │ ← Top bar
├────┬─────────────────────────────────────────┬───────┤
│    │                                         │ 🖍    │
│    │                                         │ 🖊    │
│    │                                         │ 💧    │
│    │          [CANVAS AREA]                  │ ✏️    │
│    │       Full remaining space              │ 🌫    │
│    │                                         │ ✨    │
│    │                                         │ ⭐    │
│    │                                         │ ◻️    │
│    │                                         │──────│
│    │                                         │[size]│
│    │                                         │──────│
│    │                                         │ ↩ ↪  │
├────┴─────────────────────────────────────────┴───────┤
│  ○○○○○○○○○○○○○○○○○○○○○○○○ [+]                       │ ← Color tray
└──────────────────────────────────────────────────────┘
```

#### 2.2.1b Canvas Zoom Interaction

ZOOM CONTROLS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  GESTURE:     Pinch to zoom (2x minimum, 10x maximum)
               Two-finger pan when zoomed in

  ZOOM INDICATOR:
    Appears:   Bottom-right of canvas area, 8pt inset from edges
    Style:     Pill shape, Deep Navy at 60%, white text
    Content:   "2.0x" / "5.0x" etc. — Nunito SemiBold 12pt
    Show/hide: Fades in on zoom gesture start, fades out 2s after gesture ends (300ms fade)

  RESET ZOOM BUTTON:
    Appears:   Only visible when zoom > 1.0x, next to zoom indicator
    Style:     Pill shape, Rich Teal fill, white "1:1" label
    Touch:     44x44pt minimum target
    Action:    Animates canvas back to 1.0x fit-to-screen (300ms spring)

  EDGE BEHAVIOR:
    Pan is bounded to canvas edges — cannot scroll beyond the artwork.
    Elastic overscroll: 16pt max overshoot with rubber-band spring back.

**iPad difference:** Brush toolbar moves to a vertical sidebar on the right (64pt wide), freeing horizontal canvas space. Color tray remains at bottom. Undo/redo and size slider integrate into the right sidebar below the brushes.

#### 2.2.2 Top Toolbar

```
HEIGHT:    44pt (iPhone), 52pt (iPad)
BACKGROUND: Soft Canvas #FFFDF9 with 1pt bottom border Light Divider #E8E0D8

LEFT:      Back arrow (SF Symbol "chevron.left"), 44x44pt touch target
           Teal #0EA5A0, navigates to Content Browser

CENTER:    Page title — Nunito SemiBold 16pt, Deep Navy, truncated with "..."
           Tap to see full title in a tooltip bubble

PAGE TITLE TOOLTIP:
  Trigger:     Tap on center title text
  Appearance:  Dark pill bubble (same style as ONBOARD-002 tooltips)
               Deep Navy #1B2A4A at 90%, Warm Cream text
  Content:     Full untruncated page title
  Position:    Below the toolbar, centered, with 8pt arrow pointing up
  Dismiss:     Auto-dismiss after 3 seconds, or tap anywhere
  Animation:   Fade in 200ms, fade out 300ms

RIGHT (icons, left to right, 44x44pt each):
  - Mute toggle (AUDIO-001): SF Symbol "speaker.wave.2" / "speaker.slash"
    Teal when active, Soft Graphite when muted
  - More menu "⋯" (SF Symbol "ellipse.circle"):
    Opens action sheet with: "Save to Gallery", "Play Together" (FAMILY-001),
    "Done! ✓" (ANIM-001 manual trigger), "Settings"

MORE MENU ACTION SHEET:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PRESENTATION:  iOS action sheet, slides up from bottom
  BACKGROUND:    White with corner radius `lg` (24pt) top corners
  SCRIM:         50% Dark Navy overlay behind sheet

  MENU ITEMS (top to bottom):
    1. "Save to Gallery"    — SF Symbol "square.and.arrow.down"
       Action: Saves current canvas state to Gallery immediately.
       Feedback: Brief Soft Sage checkmark toast "Saved!" (1.5s, bottom of screen)
    2. "Play Together"      — SF Symbol "person.2"
       Action: Opens Pass-and-Play setup sheet (Section 2.7).
       Requires: Parental gate if first time in session.
    3. "Done! ✓"            — SF Symbol "checkmark.circle"
       Action: Triggers completion celebration (Section 2.4).
       State: Always available. This is the sole trigger for the celebration animation.
       No automatic completion detection — the child decides when they are done.
    4. "Settings"           — SF Symbol "gearshape"
       Action: Parental gate (Section 2.8.1) → Settings screen (Section 2.8.2)

  CANCEL BUTTON: Standard iOS cancel row at bottom, Soft Graphite text.
  ANIMATION: Slides up 300ms with spring easing.
```

#### 2.2.3 Brush Toolbar — BRUSH-003

```
IPHONE:   Horizontal row, 56pt height, Soft Canvas background
IPAD:     Vertical sidebar, 64pt width, Soft Canvas background

8 BRUSH TYPE BUTTONS (shown in order):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. Crayon     — icon: small crayon illustration, warm yellow tone
  2. Marker     — icon: chisel-tip marker, bold red tone
  3. Watercolor — icon: round brush with water drop, blue tone
  4. Pencil     — icon: sharpened pencil, graphite tone
  5. Spray      — icon: spray can, green tone
  6. Glitter    — icon: sparkle cluster, gold/shimmer tone
  7. Stamp      — icon: star stamp, purple tone
  8. Eraser     — icon: pink eraser block, pink tone

BUTTON STATES:
  Default:   48x48pt (iPhone) / 52x52pt (iPad), 4pt padding
             Icon at 32x32pt, Soft Graphite tint, no background
  Selected:  Circular background in current tier accent color at 15%
             Icon tinted to Rich Teal #0EA5A0
             Scale: 1.1x with spring animation (100ms)
  Pressed:   Scale 0.95 (50ms), then spring back

STARTER TIER ADAPTATION:
  Only show 4 brushes (crayon, marker, stamp, eraser)
  Buttons enlarge to 64x64pt with labels below each icon
  Labels: Nunito Bold 11pt, Soft Graphite
```

#### 2.2.4 Color Tray — COLOR-001

```
HEIGHT:         48pt (iPhone), 56pt (iPad)
BACKGROUND:     Soft Canvas #FFFDF9
BORDER:         1pt top border Light Divider #E8E0D8

SWATCH LAYOUT:
  - 24 color circles in horizontally scrollable row
  - Circle diameter: 32pt (iPhone) / 40pt (iPad)
  - Spacing between circles: 8pt
  - Organized: spectral rainbow order, then brown, skin tones, black, white
  - Overflow: scrollable with subtle fade-out gradient on edges

SWATCH STATES:
  Default:    Filled circle, no border, Level 1 shadow
  Selected:   Circle scales to 40pt (iPhone) / 48pt (iPad)
              White checkmark overlay centered
              White 3pt border ring
              Level 2 shadow
              Scale animation: spring, 150ms

STARTER TIER: Same 24 colors with larger 40pt swatches and 10pt spacing.
              Single-row horizontal scroll (same as Explorer/Creator, just bigger swatches).
              Tray height stays within 56pt. No "+" button shown.

THE 24 COLORS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Row: Red, Red-Orange, Orange, Amber, Yellow, Yellow-Green,
       Green, Emerald, Teal, Cyan, Sky Blue, Blue,
       Indigo, Purple, Violet, Magenta, Pink, Rose,
       Brown, Tan, Peach, Light Skin, Dark Skin, Black, White

"+" BUTTON (at end of tray):
  - 32pt circle, dashed 2pt border in Soft Graphite
  - "+" symbol centered
  - Tap opens custom color picker (COLOR-002)
  - Hidden for Starter tier
```

#### 2.2.5 Custom Color Picker — COLOR-002 (P1, Explorer/Creator only)

```
PRESENTATION:  Bottom sheet, slides up, 60% screen height (iPhone)
               Popover anchored to "+" button (iPad)
BACKGROUND:    White with corner radius `lg` (24pt) top corners
DRAG HANDLE:   Centered 36x5pt rounded pill, Light Divider color

LAYOUT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│            [drag handle]            │
│                                     │
│    ┌─────────────────────────┐      │
│    │                         │      │
│    │    HSB Color Wheel      │      │
│    │    (240x240pt circle)   │      │
│    │                         │      │
│    └─────────────────────────┘      │
│                                     │
│    [Saturation/Brightness square]   │
│    120x120pt, right of wheel        │
│                                     │
│    Hex: #FF6B35 (Creator only)      │
│                                     │
│    ┌──────────────────────────┐     │
│    │ Recent: ○ ○ ○ ○ ○ ○ ○ ○ │     │
│    └──────────────────────────┘     │
│                                     │
│    [    Select Color    ]           │
│                                     │
└─────────────────────────────────────┘

HSB WHEEL:
  - Circular hue ring, 24pt ring width
  - Draggable handle: 20pt white circle with Level 3 shadow
  - Inner area: saturation/brightness gradient square
  - Selected color preview: 48x48pt rounded square, top-right corner

RECENT COLORS:
  - Row of 8 circles, 28pt diameter, 6pt spacing
  - Persists across sessions
  - Tap to re-select

HEX CODE (Creator tier only):
  - Always visible below the color wheel (not hidden behind a tap)
  - SF Mono 14pt, Soft Graphite, displays current color as "#RRGGBB"
  - Tappable: becomes editable text field for direct hex input
  - Accepts 3-char (#F00) and 6-char (#FF0000) format, with or without #
  - Validation: on "Select Color" tap, invalid hex shows field border in Sunset Coral;
    color doesn't change until valid hex entered
  - Copy button (SF Symbol "doc.on.clipboard") copies current hex to clipboard

"Select Color" button: full-width, 48pt, Rich Teal, white label
```

#### 2.2.6 Brush Size Slider — BRUSH-004

```
IPHONE:   Horizontal bar below color tray, 40pt height
IPAD:     Vertical slider in right sidebar, below brush icons

TRACK:    200pt wide (iPhone) / 160pt tall (iPad)
          6pt thick, rounded caps
          Fill left of thumb: current brush color
          Fill right of thumb: Light Divider #E8E0D8

THUMB:    24pt circle, white, Level 2 shadow
          Shows current brush diameter as a preview circle
          centered above/beside the thumb while dragging

PREVIEW CIRCLE:
  - Appears at cursor/finger position on canvas during drag
  - Diameter matches current brush size (2px–80px)
  - 50% opacity fill in current color, 1pt border at full opacity
  - Fades in/out: 150ms

SIZE RANGE:  2px minimum → 80px maximum
PERSISTENCE: Size per brush type stored locally
```

#### 2.2.7 Undo/Redo — BRUSH-005

```
IPHONE:   Flanking the size slider — Undo left, Redo right
IPAD:     Below size slider in right sidebar, side by side

BUTTONS:  44x44pt touch targets
ICONS:    SF Symbols "arrow.uturn.backward" / "arrow.uturn.forward"
          24pt icon size, Rich Teal when available, Light Divider when disabled

STATES:
  Available:   Teal icon, tap triggers action in <100ms
  Disabled:    Light Divider color, 40% opacity, non-interactive
  Pressed:     Scale 0.9 (50ms), spring back

FEEDBACK: Subtle haptic (UIImpactFeedbackGenerator, light) on each undo/redo

INITIAL STATE:  On canvas load, both Undo and Redo start in Disabled state.
                Undo enables after first brush stroke. Redo enables after first undo.
MOCKUP NOTE:    Mockups show both buttons in Available state for visual clarity;
                implementations must respect the Disabled state rules above.
```

#### 2.2.8 Contextual Tooltips — ONBOARD-002 (P1)

```
APPEARANCE:  Dark pill-shaped bubble, Warm Cream text
BACKGROUND:  Deep Navy #1B2A4A at 90% opacity
CORNER:      full radius (pill shape)
PADDING:     12pt horizontal, 8pt vertical
TEXT:         Nunito Sans SemiBold 14pt, Warm Cream #FFF8F0
ARROW:        8pt equilateral triangle pointing to relevant element
ANIMATION:   Fade in over 200ms, auto-dismiss after 3 seconds, fade out 300ms
DISMISS:     Tap anywhere dismisses immediately

TOOLTIP TRIGGERS (first session only):
  1. After first brush stroke → tooltip on size slider: "Drag to change brush size"
  2. After first color pick → tooltip on "+" button: "Tap + for more colors"
     (Explorer/Creator only)
  3. On first completed page → overlay: "You did it! Tap to save" with
     arrow pointing to gallery save button
```

---

### 2.3 Content Browser — CONTENT-001–003

**Where children discover and choose coloring pages.**

#### 2.3.1 Content Browser Layout

```
ENTRY:     Canvas back button, Gallery "New Page" button, or app launch (root screen).
           This is the NavigationStack root — there is no back button on this screen.
STRUCTURE: Top-level categories → Page grid within category

LAYOUT (iPhone)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│  [App Name]         📦 🖼 ⚙️  │44pt│ ← Pack Store + Gallery + Settings (no back button)
├─────────────────────────────────────┤
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐      │
│  │🐾  │ │🚗  │ │🐉  │ │🌿  │ ··· │ ← Category pills (scrollable)
│  │Anim│ │Vehi│ │Fant│ │Natu│      │
│  └────┘ └────┘ └────┘ └────┘      │
├─────────────────────────────────────┤
│                                     │
│  "Animals"                          │
│  ┌─────┐  ┌─────┐                  │
│  │     │  │     │                  │
│  │ 🦁  │  │ 🐶  │  ← 2-col grid   │
│  │     │  │     │                  │
│  │Lion │  │Puppy│                  │
│  └─────┘  └─────┘                  │
│  ┌─────┐  ┌─────┐                  │
│  │     │  │ 🔒  │  ← Locked page   │
│  │ 🐱  │  │ 🦊  │    (translucent)  │
│  │     │  │     │                  │
│  │Cat  │  │Fox  │                  │
│  └─────┘  └─────┘                  │
│  ...                               │
└─────────────────────────────────────┘

LAYOUT (iPad landscape)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌──────────────────────────────────────────────────────┐
│  [App Name]                          🖼 ⚙️  │       │
├──────────┬───────────────────────────────────────────┤
│          │                                           │
│ 🐾 Animals│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐       │
│ 🚗 Vehicles│ │     │ │     │ │     │ │     │       │
│ 🐉 Fantasy│  │ 🦁  │ │ 🐶  │ │ 🐱  │ │ 🦊  │       │
│ 🌿 Nature │  │     │ │     │ │     │ │ 🔒  │       │
│ 🎄 Holiday│  │Lion │ │Puppy│ │Cat  │ │Fox  │       │
│ 🔷 Pattern│  └─────┘ └─────┘ └─────┘ └─────┘       │
│          │  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐       │
│          │  │     │ │     │ │     │ │     │       │
│          │  ...                                     │
│          │                                           │
└──────────┴───────────────────────────────────────────┘
iPad: Fixed sidebar (280pt) + scrollable 4-column grid
```

#### 2.3.2 Category Pills

```
LAYOUT:    Horizontally scrollable row (iPhone), vertical sidebar list (iPad)
HEIGHT:    44pt (iPhone pill), 48pt (iPad list row)
SPACING:   8pt between pills

EACH PILL:
  Icon:      Custom category illustration, 24x24pt
  Label:     Nunito SemiBold 13pt
  Background:
    Default: Soft Canvas #FFFDF9, 1pt border Light Divider
    Selected: Rich Teal #0EA5A0 fill, white text, Level 1 shadow
  Corner radius: full (pill)

THE 6 CATEGORIES:
  🐾 Animals    — paw print icon
  🚗 Vehicles   — car icon
  🐉 Fantasy    — dragon/magic icon
  🌿 Nature     — leaf icon
  🎄 Holidays   — star/ornament icon
  🔷 Patterns   — geometric shape icon
```

#### 2.3.3 Page Thumbnail Cards

```
SIZE:      iPhone: (width - 48pt) / 2 columns = ~155pt wide, 3:4 aspect ratio
           iPad: (960pt - sidebar - spacing) / 4 columns = ~155pt wide

CARD STRUCTURE:
  ┌─────────────────┐
  │                 │
  │   Coloring page │ ← Thumbnail preview (vector render of page)
  │   preview       │    Page art shown as light gray outlines on white
  │                 │
  ├─────────────────┤
  │ Page Title      │ ← Nunito SemiBold 13pt, Deep Navy
  │ ● Explorer      │ ← Tier badge dot + label, 11pt, tier accent color
  └─────────────────┘

  Corner radius: md (16pt)
  Shadow: Level 1
  Background: White

CARD STATES:
  Free (available):   Normal render, full opacity
  Locked (paid):      Thumbnail at 50% opacity with frosted overlay
                      Single lock icon (SF Symbol "lock.fill") centered
                      20x20pt, Soft Graphite at 60%
                      NO aggressive upsell text or price overlay
  New:               "NEW" badge, 6pt radius, Sunset Coral fill,
                      white Nunito Bold 9pt, positioned top-right, -4pt offset
  In progress:       "Continue" badge, same style, Rich Teal fill

TAP BEHAVIOR:
  Free page:     Scale 0.97 (50ms) → open canvas with page loaded
  Locked page:   Scale 0.97 → show unlock prompt (see IAP section 2.6)
  In progress:   Scale 0.97 → resume canvas with saved state (GALLERY-003)

AGE TIER FILTERING (CONTENT-002):
  - Selected tier's pages shown first in each category
  - Other tiers' pages appear below a subtle divider line:
    "More pages" — Nunito Sans 13pt, Soft Graphite
  - No hard gate: all pages browsable regardless of tier

  TIER DIVIDER SPECIFICATION:
    Position:    Full-width, between tier-matched pages and other-tier pages
    Layout:      1pt Light Divider line with centered label
    Label:       "More pages" — Nunito Sans 13pt, Soft Graphite, 8pt vertical padding
    Background:  Warm Cream #FFF8F0 behind label text (to interrupt the line)
    Spacing:     16pt above divider, 16pt below before next card row

EMPTY CATEGORY STATE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Trigger:     Category selected with zero available pages (e.g., all pages locked, or
               no content in that category for the selected tier before purchase)
  Layout:      Centered in grid area
  Illustration: 120x120pt line drawing of an empty easel with a question mark
  Title:       "Nothing here yet!" — Nunito Bold 18pt, Deep Navy, centered
  Subtitle:    "Check back soon for new [Category] pages" — Nunito Sans 14pt,
               Soft Graphite, centered
  Action:      [Browse Other Categories] — Rich Teal text link, 15pt
               Scrolls pill bar to next category with available content
```

---

### 2.4 Animation-on-Completion — ANIM-001–003

```
TRIGGER:     Manual "Done ✓" tap from canvas overflow menu (sole trigger — no automatic detection)
DELAY:       Celebration starts within 500ms of trigger
DURATION:    3–5 seconds, then holds final frame

COMPLETION TRIGGER:
  - No automatic completion detection or progress tracking
  - "Done ✓" in overflow menu is always available and always triggers the celebration
  - The child decides when their artwork is finished — no minimum fill required

CELEBRATION SEQUENCE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  0ms:     Canvas tools fade out (200ms)
  200ms:   Artwork scales to fit screen with 32pt padding (300ms, spring)
  500ms:   Category-specific animation begins on the artwork:

  ANIMATION TYPES BY CATEGORY (ANIM-002):
    Animals:    Character bounces/walks across bottom of artwork, leaves footprints
    Vehicles:   Vehicle drives/flies across, leaving a sparkle trail
    Fantasy:    Starburst from center, magic sparkles orbit artwork
    Nature:     Flowers bloom at edges, butterflies appear
    Holidays:   Confetti rain from top, snowflakes or fireworks
    Patterns:   Kaleidoscope rotation effect on the artwork, prismatic glow

  SOUND (ANIM-003 — P1):
    Each category has unique celebratory sound
    Animals: playful xylophone melody
    Vehicles: whoosh + cheerful horn
    Fantasy: magical chime cascade
    Nature: gentle wind chime + birds
    Holidays: party horn + sparkle
    Patterns: ascending tone scale

  3000ms:  Animation settles, artwork holds at center

POST-ANIMATION OVERLAY:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│                                     │
│        [Completed artwork           │
│         with animation              │
│         holding final frame]        │
│                                     │
│         "Amazing work!" ⭐          │
│                                     │
│   ┌──────────┐   ┌──────────┐      │
│   │ Save 💾  │   │ Share 📤 │      │
│   └──────────┘   └──────────┘      │
│                                     │
│         Color another ›             │
│                                     │
└─────────────────────────────────────┘

"Amazing work!": Nunito ExtraBold 28pt, Deep Navy, centered
  Rotates between: "Amazing work!", "Beautiful!", "You're an artist!",
  "Wow, look at that!", "Masterpiece!"

Buttons: side-by-side, each 50% width minus spacing
  "Save": Rich Teal fill, white label, saves to gallery
  "Share": Sunset Coral fill, white label, triggers parental gate → share sheet
  Both: 48pt height, corner radius sm, Nunito Bold 16pt

"Color another": Nunito Sans SemiBold 15pt, Soft Graphite, tappable link
  Returns to content browser

Replay button: small "↻" icon top-right of artwork, 36pt, Rich Teal
  Replays the celebration animation

REPLAY BEHAVIOR:
  Tap "↻":  Action buttons and "Color another" link fade out (200ms).
            Celebration animation replays from the 500ms mark (skips tool fade-out).
            On animation settle (3000ms), buttons fade back in.
            Replay can be triggered multiple times.

SAVE FEEDBACK STATES:
  Success:   Brief Soft Sage checkmark toast at bottom of screen:
             "Saved to Gallery ✓" — Nunito Sans SemiBold 14pt, white on Soft Sage
             Auto-dismiss after 2 seconds. Save button dims to 40% after successful save.
  Failure:   If device storage is full or photo library permission denied:
             Honey Gold warning toast: "Couldn't save — check storage or permissions"
             Toast persists for 4 seconds. Save button remains active for retry.
             If photo library permission needed: include "Open Settings" text link in toast.

SHARE GATE:
  The Share button ALWAYS triggers the parental gate (Section 2.8.1) before
  opening the iOS share sheet, even within the 5-minute grace period.
  This is intentional — sharing is an externally-facing action.
```

---

### 2.5 Gallery — GALLERY-001–003, EXPORT-001

#### 2.5.1 Gallery Grid

```
ENTRY:      Gallery icon (🖼) from Content Browser top bar, or post-completion flow
NAV TITLE:  "My Gallery" — Nunito Bold 20pt

LAYOUT (iPhone)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│  ◀        My Gallery        [+]    │ ← [+] opens Content Browser
├─────────────────────────────────────┤
│                                     │
│  ┌─────┐  ┌─────┐                  │
│  │▶ 🎨 │  │  🖍 │  ← 2-col grid   │
│  │     │  │     │                  │
│  │Lion │  │Dog  │                  │
│  │Today│  │Yest.│                  │
│  └─────┘  └─────┘                  │
│  ┌─────┐  ┌─────┐                  │
│  │     │  │ ⏸  │  ← In-progress   │
│  │Cat  │  │Fox  │    has "Continue" │
│  │Mon  │  │     │    badge          │
│  └─────┘  └─────┘                  │
│  ...                               │
│                                     │
└─────────────────────────────────────┘

iPad: 4-column grid

GALLERY CARD:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Same dimensions as Content Browser cards
  Shows completed artwork (full color, not line art)

  Bottom overlay (gradient from transparent to #1B2A4A at 70%):
    Title: Nunito SemiBold 12pt, white
    Date:  Nunito Sans 10pt, white at 70%

  Tier badge: 6pt colored dot matching tier color, top-left, 8pt inset

  BADGES:
    In-progress: "Continue" pill, Rich Teal, top-right
                 Nunito Bold 9pt, white
    Completed:   No badge (default state)

SORT: Most recent first. Load within 1 second for up to 500 items.
EMPTY STATE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Trigger:     Gallery opened with zero saved artworks
  Layout:      Centered vertically and horizontally in grid area
  Illustration: 160x160pt line drawing of a blank canvas on an easel
                with a paintbrush leaning against it. Light watercolor
                wash in Peach Blush and Sky Blue around edges.
  Title:       "Your gallery is empty!" — Nunito Bold 22pt, Deep Navy, centered
  Subtitle:    "Start coloring to fill it up" — Nunito Sans 15pt, Soft Graphite, centered
               16pt below title
  Button:      [Browse Pages] — full-width (minus 64pt margins), 48pt height,
               Rich Teal fill, white Nunito Bold 16pt label, corner radius sm
               Navigates to Content Browser.
               32pt below subtitle.
  MOCKUP NOTE: This state requires its own mockup (currently missing from set).
```

#### 2.5.2 Gallery Full-Screen View

```
ENTRY:       Tap any gallery card
TRANSITION:  Card expands to full screen (shared element transition, 300ms)

LAYOUT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│ ✕                    ↻  📤  🖨   │ ← Close, Replay, Share, Print
├─────────────────────────────────────┤
│                                     │
│                                     │
│      [Full-screen artwork]          │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│ "Lion in the Jungle"               │
│ Explorer tier · March 15, 2026     │
│ ● Completed                        │
└─────────────────────────────────────┘

SWIPE:  Left/right to navigate between artworks (horizontal paging)

TOP BAR (overlaid on image, semi-transparent):
  ✕ Close:     SF Symbol "xmark", 44pt target, white with shadow
  ↻ Replay:    Replays celebration animation (completed items only)
  📤 Share:    SF Symbol "square.and.arrow.up" — triggers parental gate → share sheet
  🖨 Print:    "Print My Art" (EXPORT-001) — triggers parental gate → PDF export flow

BOTTOM INFO:
  Background: gradient overlay, transparent → Warm Cream
  Title: Nunito Bold 18pt, Deep Navy
  Metadata: Nunito Sans 13pt, Soft Graphite
  Status: "Completed" (green dot) or "In Progress" (teal dot)

  IN-PROGRESS CONTINUE BUTTON:
    Visible:   Only when viewing an in-progress artwork
    Label:     "Continue Coloring" — Nunito Bold 14pt, white
    Style:     Rich Teal fill, corner radius sm, 40pt height, auto-width with 24pt h-padding
    Position:  Right-aligned in bottom info strip, vertically centered with metadata
    Action:    Opens Canvas with saved artwork state (GALLERY-003)

TOP BAR PARENTAL GATES:
  📤 Share:    Triggers parental gate (Section 2.8.1) → iOS share sheet.
               Gate required even within 5-minute grace period (externally-facing action).
  🖨 Print:    Triggers parental gate → Frame Picker sheet (Section 2.5.3).
               Gate required even within 5-minute grace period.
  ↻ Replay:    No gate required (internal action only).
```

#### 2.5.2b Gallery Artwork Management

DELETE / MANAGE ARTWORKS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ENTRY:       Long-press any gallery card (500ms hold)
  GATE:        Parental gate required before delete action

  CONTEXT MENU (iOS native context menu style):
    "Share"       — SF Symbol "square.and.arrow.up" → parental gate → share sheet
    "Print"       — SF Symbol "printer" → parental gate → frame picker
    "Delete"      — SF Symbol "trash", Sunset Coral text → parental gate → confirmation

  DELETE CONFIRMATION:
    Presentation: iOS alert dialog (not custom modal)
    Title:        "Delete this artwork?"
    Message:      "This will remove 'Page Title' from your gallery. This can't be undone."
    Buttons:      "Cancel" (default, bold) | "Delete" (destructive, Sunset Coral)
    On confirm:   Card shrinks to 0 with spring animation (200ms), grid reflows.
                  Brief toast: "Artwork deleted" — Soft Graphite, 2 seconds.

  BATCH DELETE (future consideration):
    Not included in v1. Single-item delete only.

#### 2.5.3 Art Comes Home — PDF Export — EXPORT-001 (P1)

```
TRIGGER:    "Print My Art" (🖨) button in gallery full-screen view
GATE:       Parental gate first (see SAFETY-002, Section 2.8)

FLOW:
  1. Parental gate verification
  2. Frame style picker
  3. Name input (if not previously set)
  4. Preview → Share

FRAME PICKER SHEET:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│            [drag handle]            │
│                                     │
│    "Choose a frame"                 │
│    Nunito Bold 20pt, Deep Navy      │
│                                     │
│  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐    │
│  │Cla│ │Nat│ │Sta│ │Rai│ │Min│    │ ← 5 frame style thumbnails
│  │   │ │   │ │   │ │   │ │   │    │    Horizontally scrollable
│  └───┘ └───┘ └───┘ └───┘ └───┘    │    80x100pt each
│  Classic Nature Stars Rainbow Min   │
│                                     │
│    "Artist name"                    │
│    [  Child's name input  ]         │
│    (stored locally, persists)       │
│                                     │
│    ┌──────────────────────────┐     │
│    │    [PDF PREVIEW]         │     │
│    │    8.5x11 page with      │     │
│    │    artwork + frame +     │     │
│    │    name + date           │     │
│    └──────────────────────────┘     │
│                                     │
│    [     Share / Print     ]        │ ← Opens iOS share sheet
│                                     │
└─────────────────────────────────────┘

FRAME STYLES:
  Classic:   Thin gold double-line border, serif "By [Name]" text
  Nature:    Illustrated vine/leaf border, earthy green tones
  Stars:     Star pattern border, navy + gold
  Rainbow:   Gradient rainbow border, colorful
  Minimal:   Single thin line, modern, lots of white space

PDF OUTPUT:
  - 8.5" x 11" portrait, 300 DPI
  - Artwork centered, max 7" wide
  - Frame border: per selected style
  - Below artwork: child's name (Nunito Bold 16pt) + date (Nunito Sans 12pt)
  - Optional app watermark (very small, toggleable in Settings)
```

---

### 2.6 IAP & Monetization — IAP-001–003

#### 2.6.1 Locked Page Tap → Unlock Prompt

```
TRIGGER:   Child taps a locked page thumbnail in Content Browser

PRESENTATION: Bottom sheet (NOT a full-screen paywall)
              Gentle, non-aggressive, parent-facing language

LAYOUT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│            [drag handle]            │
│                                     │
│    🎨 "Unlock all the colors!"      │
│                                     │
│    Get 200+ coloring pages,         │
│    all brushes, and animations.     │
│    One payment. No subscriptions.   │
│    No ads. Ever.                    │
│                                     │
│   ┌───────────────────────────┐     │
│   │  Unlock Everything $14.99 │     │ ← Parental gate first
│   └───────────────────────────┘     │
│                                     │
│    "Restore Purchase"               │ ← Nunito Sans 14pt, teal link
│                                     │
│    ✕ No thanks, keep exploring free │
│                                     │
└─────────────────────────────────────┘

HEADER:     Nunito Bold 22pt, Deep Navy
BODY:       Nunito Sans 16pt, Soft Graphite, center-aligned
UNLOCK BTN: Full-width, 56pt, Sunset Coral #F06449, white Nunito Bold 18pt
            Corner radius sm, Level 2 shadow
            Tap triggers parental gate → Apple StoreKit 2 purchase flow
RESTORE:    Nunito Sans SemiBold 14pt, Rich Teal, centered
DISMISS:    Nunito Sans 14pt, Soft Graphite, centered

NOTE: No subscription option. No trial timer. No urgency language.
The pitch is factual: here's what you get, here's the price, once.
```

**Purchase flow states:**

POST-PURCHASE STATES:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  PURCHASE SUCCESS:
    1. Apple StoreKit 2 payment sheet completes
    2. IAP sheet dismisses with slide-down animation (300ms)
    3. Success overlay appears on Content Browser:
       ┌─────────────────────────────────────┐
       │                                     │
       │          🎉                          │
       │    "Everything is unlocked!"         │
       │                                     │
       │    All locked cards animate to       │
       │    full opacity simultaneously       │
       │    (lock icons fade out, 400ms)      │
       │                                     │
       └─────────────────────────────────────┘
       Title: Nunito ExtraBold 24pt, Deep Navy
       Auto-dismiss after 3 seconds, or tap anywhere
       Confetti particles (same style as celebration, 2 seconds)

  PURCHASE CANCELLED:
    User dismissed Apple payment sheet without completing:
    IAP bottom sheet remains visible — no additional feedback needed.
    User can re-tap "Unlock" or dismiss the sheet normally.

  PURCHASE FAILURE:
    StoreKit reports an error (network, payment method, etc.):
    IAP sheet remains visible.
    Inline error message appears below the Unlock button:
    "Something went wrong. Please try again." — Nunito Sans 14pt, Sunset Coral
    Unlock button re-enables for retry.

  RESTORE SUCCESS:
    1. "Restore Purchase" completes via StoreKit
    2. Same success overlay as purchase: "Everything is unlocked!"
    3. Locked content animates to full opacity

  RESTORE — NOTHING FOUND:
    Inline message below "Restore Purchase" link:
    "No previous purchases found for this Apple ID."
    Nunito Sans 14pt, Soft Graphite. Persists until sheet dismissed.

  RESTORE FAILURE:
    Inline error: "Couldn't reach the App Store. Check your connection and try again."
    Nunito Sans 14pt, Sunset Coral.

  LOADING STATE (applies to both purchase and restore):
    Button shows spinner (20pt, white) replacing text label.
    Button disabled during transaction. Scrim remains interactive for dismiss.

#### 2.6.2 Content Pack Store — IAP-003 (P1)

```
ENTRY:      "Pack Store" tab in Content Browser header, or Settings

LAYOUT (same grid as Content Browser):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│  ◀        Pack Store                │
├─────────────────────────────────────┤
│                                     │
│  ┌──────────────────────────────┐   │
│  │  [Pack hero image]           │   │  ← Featured pack (full-width card)
│  │  "Ocean Adventures"          │   │
│  │  50 pages · All ages         │   │
│  │                    $2.99     │   │
│  └──────────────────────────────┘   │
│                                     │
│  ┌─────────┐  ┌─────────┐          │
│  │ Pack 2  │  │ Pack 3  │          │  ← Grid of pack cards
│  │ [image] │  │ [image] │          │
│  │ $3.99   │  │ $4.99   │          │
│  └─────────┘  └─────────┘          │
│                                     │
└─────────────────────────────────────┘

PACK CARD:
  Preview: 4 sample thumbnails in 2x2 mini-grid
  Title: Nunito Bold 16pt, Deep Navy
  Meta: "50 pages · All ages" — Nunito Sans 13pt, Soft Graphite
  Price: Nunito Bold 16pt, Sunset Coral, bottom-right
  Purchased: Green checkmark replaces price, "Installed" label

NOTE: Infrastructure ships in v1 even if no packs available at launch.

COMING SOON STATE (v1 launch):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Layout:      Centered in grid area (same pattern as Gallery empty state)
  Illustration: 160x160pt line drawing of a gift box with a paintbrush ribbon
  Title:       "New packs coming soon!" — Nunito Bold 22pt, Deep Navy, centered
  Subtitle:    "We're creating more amazing coloring pages for you."
               Nunito Sans 15pt, Soft Graphite, centered
  Button:      [Notify Me] — Rich Teal outline (2pt border, no fill), Teal text
               Nunito Bold 16pt, 48pt height, full-width minus 64pt margins
               Tap toggles to filled state: "You'll be notified ✓" (Soft Sage fill)
               Stores a local flag only — no email or account required.
```

---

### 2.7 Pass-and-Play — FAMILY-001 (P1)

```
ENTRY:       Canvas overflow menu → "Play Together"
             OR dedicated button on canvas toolbar (iPad only, space permitting)

FLOW: Player Setup → Timer Config → Play → Handoff → Repeat → Done

PLAYER SETUP SHEET:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│            [drag handle]            │
│                                     │
│    "Who's playing?"                 │
│    Nunito Bold 24pt, Deep Navy      │
│                                     │
│    Player 1:                        │
│    [Avatar picker ○○○○○○]           │ ← 8 simple animal avatars
│    [ Name input field    ]          │
│                                     │
│    Player 2:                        │
│    [Avatar picker ○○○○○○]           │
│    [ Name input field    ]          │
│                                     │
│    [+ Add player]  (up to 4)        │
│                                     │
│    Turn time:                       │
│    [ 30s ]  [ 60s ]  [ 90s ]        │ ← Segmented control
│                                     │
│    [    Start Coloring!    ]        │
│                                     │
└─────────────────────────────────────┘

AVATARS: 8 simple, colorful animal faces (bear, cat, owl, fox, rabbit,
         penguin, lion, frog). 40x40pt each, selected has teal ring.

NAME INPUT: Nunito Sans 16pt, placeholder "Player 1", max 12 chars
            No keyboard auto-correct (kid names are unique)

TURN TIME: Segmented control, Nunito SemiBold 14pt
           Default: 60s. Teal fill for selected segment.

DURING PLAY:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AUDIO BEHAVIOR:
    Background music continues during turns (provides continuity).
    Music pauses during handoff screen (natural break between players).
    Music resumes when next player taps to start their turn.
    Countdown beeps play over music in final 3 seconds (if not muted).

  - Turn indicator bar at top of canvas (replaces normal top toolbar)
    Height: 48pt
    Background: current player's avatar color (muted pastel)
    Content: [Avatar] "Player 1's turn" [Timer: 0:42] [⏸ Pause]

  - Timer: circular countdown, Nunito Bold 20pt
    Last 10 seconds: timer turns Sunset Coral, pulses gently
    Last 3 seconds: subtle audio countdown beeps (if not muted)

HANDOFF SCREEN:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│                                     │
│                                     │
│         [Avatar 2]                  │
│                                     │
│    "Your turn, Sarah!"              │
│    Nunito Bold 32pt, Deep Navy      │
│                                     │
│    Animated pass-the-device          │
│    illustration (hands passing iPad) │
│                                     │
│    [  Tap to start your turn  ]     │
│                                     │
│                                     │
└─────────────────────────────────────┘

  Full-screen overlay, player's tier accent background at 15%
  Avatar: 80x80pt, centered, bounces in with spring animation
  Tap anywhere or tap button to begin next turn

COMPLETION:
  When all players agree to finish (any player taps "Done"):
  - Standard celebration animation plays
  - Gallery save credits all players: "By Sarah & Max"
  - Artwork metadata stores all player names
```

**Missing state specifications:**

PLAYER SETUP VALIDATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Minimum: 2 players required. "Start Coloring!" disabled until Player 2 has a name.
  Maximum: 4 players. [+ Add player] button hidden when 4 players reached.
  Remove:  Swipe-left on Player 3/4 row to reveal "Remove" button (red).
           Players 1 and 2 cannot be removed.
  Names:   If left blank, defaults to "Player 1", "Player 2", etc.

IN-GAME TURN INDICATOR BAR:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ┌─────────────────────────────────────────┐
  │ [Avatar] "Sarah's turn"  [0:42]  [⏸]   │
  └─────────────────────────────────────────┘
  Height:       48pt
  Background:   Current player's avatar accent color at 15% opacity
  Avatar:       32x32pt, left-aligned with 12pt left margin
  Name:         "Sarah's turn" — Nunito Bold 16pt, Deep Navy
  Timer:        Circular countdown ring (28pt diameter) with time inside
                Nunito Bold 14pt, Deep Navy
  Pause:        SF Symbol "pause.circle", 32pt, Soft Graphite, right-aligned

  This bar REPLACES the normal top toolbar (back, title, mute, overflow).
  The back button is NOT available during a Pass & Play turn.
  Mute toggle moves into the Pause overlay.

TIMER STATES:
  Normal (>10s remaining):   Deep Navy text, Rich Teal ring fill
  Warning (≤10s remaining):  Sunset Coral text, Sunset Coral ring fill
                             Timer text pulses gently (scale 1.0 → 1.05, 1s loop)
  Final countdown (≤3s):     Audio beeps (if not muted): short, soft chime per second
                             Haptic: light impact per second
  Time up:                   Ring completes. Brief "Time's up!" overlay (500ms).
                             Auto-transitions to Handoff screen.

PAUSE OVERLAY:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Trigger:     Tap ⏸ Pause button on turn indicator bar
  Presentation: Full-screen overlay, Deep Navy at 80% opacity
  Content:     Centered vertically:
               "Paused" — Nunito Bold 32pt, white
               Timer frozen at current value, displayed large (Nunito Bold 48pt, white)
  Buttons:     [Resume] — Rich Teal, full-width minus 64pt, 56pt height
               [End Game] — text link below, Sunset Coral, Nunito Sans SemiBold 15pt
  Mute toggle: Below End Game link, "Sound: On/Off" — toggle switch

  Resume:      Overlay fades out (200ms), timer resumes from paused value.
  End Game:    Triggers end-session confirmation.

END SESSION FLOW:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Trigger:     "End Game" from Pause overlay
  Confirmation: iOS alert dialog
    Title:     "End this session?"
    Message:   "The artwork will be saved to the gallery."
    Buttons:   "Keep Playing" (default, bold) | "End & Save" (teal)
  On confirm:  Standard celebration animation plays.
               Gallery save credits all participating players: "By Sarah & Max"
               Returns to Content Browser after celebration dismiss.
  On cancel:   Returns to Pause overlay.

HANDOFF SCREEN DIFFERENTIATION:
  Screen 10 (first turn):  Shows session info — "Turn 1 of [total turns]"
                           Player 1's avatar and name. No "previous player" note.
  Screen 11 (subsequent):  Shows "Player 1 just colored for 60s" above turn counter.
                           Next player's avatar and name.
                           "Turn N of [total turns]" counter.
  Both screens:            "Tap to start your turn" button is the only interactive element.
                           Tap ANYWHERE on screen also starts the turn (full-screen touch target).

---

### 2.8 Safety & Settings — SAFETY-001–003, AUDIO-002–003

#### 2.8.1 Parental Gate — SAFETY-002

```
TRIGGER:    Before any IAP, share sheet, external link, or Settings access

PRESENTATION: Centered modal dialog with semi-transparent dark overlay

LAYOUT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────────┐
│         ██████████████████          │ ← Dark overlay 50% opacity
│         █                █          │
│         █  "Grown-ups    █          │
│         █   only!"       █          │
│         █                █          │
│         █  What is       █          │
│         █  24 × 7?       █          │
│         █                █          │
│         █  [    168    ]  █          │
│         █                █          │
│         █  [  Continue  ] █          │
│         █                █          │
│         █  Cancel         █          │
│         █                █          │
│         ██████████████████          │
└─────────────────────────────────────┘

DIALOG:
  Background: White, corner radius lg (24pt), Level 4 shadow
  Size: 300pt x auto (iPhone), 360pt x auto (iPad), centered

TITLE:    "Grown-ups only!" — Nunito Bold 22pt, Deep Navy
PROBLEM:  "What is 24 × 7?" — Nunito Sans SemiBold 18pt, Soft Graphite
          Multiplication using 2-digit × 1-digit numbers
          (not trivially solvable by young children)
          Regenerates on each presentation
INPUT:    Centered number field, 120pt wide, 48pt height
          Nunito Bold 24pt, Deep Navy, centered text
          Numeric keyboard only
CONTINUE: Rich Teal, full dialog width - 32pt, 48pt height
          Disabled until correct answer entered
          On wrong answer: gentle shake animation (200ms), field clears
CANCEL:   Nunito Sans SemiBold 15pt, Soft Graphite

WRONG ANSWER STATE:
  Trigger:     User enters incorrect value and taps Continue/Go
  Animation:   Modal shakes horizontally (±8pt, 200ms, 3 oscillations)
  Field:       Input clears to empty. Placeholder reappears.
  Message:     "Try again" — Nunito Sans 13pt, Sunset Coral, below input field
               Fades in 150ms, persists until next attempt
  New problem: Math question does NOT regenerate on wrong answer (prevents brute-force
               by cycling to an easier problem). Same question persists for this session.

RATE LIMITING:
  After 3 consecutive wrong answers:
    Continue button disabled for 30 seconds.
    Timer message replaces "Try again": "Wait 30s before trying again"
    Nunito Sans 13pt, Soft Graphite
    Countdown updates every second. Button re-enables at 0.
  After 6 consecutive wrong answers:
    Gate locks for 5 minutes. Message: "Too many attempts. Try again in 5 minutes."
    Cancel button remains available. Timer counts down.
    Counter resets on successful verification or after the 5-minute lockout expires.

GRACE PERIOD: 5 minutes after successful verification
              (no re-prompt for subsequent gated actions within the same session)

GRACE PERIOD INDICATOR:
  No explicit UI indicator shown to the child.
  Settings gear icon in Content Browser shows a subtle teal dot badge (6pt)
  when the grace period is active, visible only to parents who know to look.
  Dot disappears when grace period expires.
```

#### 2.8.2 Settings Screen

```
ENTRY:    Gear icon (⚙️) from Content Browser, or overflow menu in Canvas
GATE:     Parental gate required before showing Settings.
          If gate is within grace period, Settings opens immediately.
          If gate is not within grace period, parental gate modal appears first.
          MOCKUP NOTE: No mockup currently shows this gating in the navigation flow.

LAYOUT:  Standard iOS grouped table view style

SECTIONS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  SECTION: "Profile"
    Age tier:          [Starter ▾]  ← Picker to change tier (see confirmation below)
    Artist name:       [           ] ← Text input (for Print My Art)

  SECTION: "Sound" (AUDIO-001, AUDIO-002, AUDIO-003)
    Sound effects:     [toggle ON ]  ← Brush sounds, UI sounds
    Background music:  [toggle ON ]  ← Ambient tracks
    Music volume:      [━━━●━━━━━━]  ← Independent slider

  SECTION: "Display"
    Watermark on exports: [toggle OFF] ← App name watermark on both PNG shares and PDF exports

  SECTION: "Purchases"
    Restore Purchases    [→]  ← Triggers StoreKit restore
    Pack Store           [→]  ← Navigates to pack store

  SECTION: "About"
    Privacy Policy       [→]  ← In-app web view (plain language)
    Version              1.0.0

STYLING:
  Section headers: Nunito SemiBold 13pt, Soft Graphite, uppercase
  Row labels: Nunito Sans 16pt, Deep Navy
  Row height: 48pt
  Toggle: iOS native UISwitch, tinted Rich Teal
  Grouped background: Warm Cream #FFF8F0
  Card background: White
  Separator: Light Divider #E8E0D8
```

**Tier change confirmation:**

TIER CHANGE FLOW:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Trigger:    User selects a different tier from the Age Tier picker
  Confirmation: iOS alert dialog
    Title:    "Switch to [Tier Name]?"
    Message:  "The app will adjust tools and content for ages [range].
               Your saved artworks won't be affected."
    Buttons:  "Cancel" (default) | "Switch" (Rich Teal)
  On confirm: Picker updates. Canvas toolbar adapts on next canvas open.
              Content Browser re-sorts pages for new tier.
              No artwork data is lost.
  On cancel:  Picker reverts to previous value.

RESTORE PURCHASES FEEDBACK (in Settings context):
  Same states as IAP section (Section 2.6.1 post-purchase states).
  Success:   Inline "Purchases restored ✓" text, Soft Sage, below the row.
  Not found: Inline "No previous purchases found" text, Soft Graphite.
  Failure:   Inline "Couldn't connect. Try again." text, Sunset Coral.
  Loading:   Spinner replaces chevron in the row during transaction.

---

### 2.9 Global States & Error Handling

#### 2.9.1 Loading States

CONTENT LOADING:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Content Browser grid:  Skeleton cards — rounded rectangles at card dimensions,
                         Light Divider fill, subtle shimmer animation (left-to-right
                         gradient sweep, 1.5s loop). Show 4 skeleton cards (2x2 grid).
  Gallery grid:          Same skeleton card pattern as Content Browser.
  Canvas page load:      Center-screen spinner — 32pt circular, Rich Teal, rotating.
                         Below spinner: "Loading..." — Nunito Sans 14pt, Soft Graphite.
                         Canvas area shows Warm Cream background until image loads.
  Performance target:    All loading states should resolve within 1 second for local
                         content. Network-dependent operations (IAP, restore) may take longer.

  Canvas page load FAILURE (edge case — corrupted SVG or missing file):
    If a bundled coloring page fails to load after 3 seconds:
    Show empty state illustration (easel with question mark) centered on canvas area.
    Title: "Oops! This page didn't load" — Nunito Bold 18pt, Deep Navy.
    Button: [Try Another Page] — Rich Teal, navigates back to Content Browser.
    Log error silently for debugging (no crash, no alert).

#### 2.9.2 Error & Offline States

NETWORK ERROR (IAP, Restore, Privacy Policy):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Trigger:     Any network-dependent action fails due to connectivity
  Presentation: Inline error within the current screen (not a separate screen)
  Message:     "No internet connection" — Nunito Sans 14pt, Sunset Coral
  Sub-message: "Check your connection and try again" — Nunito Sans 13pt, Soft Graphite
  Retry:       [Try Again] text button, Rich Teal, below error message

  NOTE: Core coloring functionality (brush, canvas, save to local gallery)
        works entirely offline. Network errors only affect IAP, restore,
        pack store, and privacy policy web view.

PRIVACY POLICY OFFLINE:
  If in-app web view fails to load:
  Show centered error with: "Can't load Privacy Policy right now."
  [Try Again] button + "Visit [url] in Safari" text link as fallback.

#### 2.9.3 Accessibility Rendering Notes

REDUCE MOTION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  All spring animations:      Replace with 200ms dissolve (cross-fade)
  Celebration animation:      Replace with static congratulations screen
                              (artwork centered, "Amazing work!" text, no particle effects)
  Card press animations:      Replace scale with opacity change (100% → 80% → 100%)
  Confetti / sparkle effects: Hidden entirely
  Tooltip auto-dismiss:       Still 3 seconds, but no fade — instant appear/disappear
  Loading shimmer:            Replace with static Light Divider fill (no animation)

HIGH CONTRAST MODE:
  All borders:               Increase from 1pt to 2pt
  Shadow opacity:            Increase by 50% (e.g., Level 1: 0.06 → 0.09)
  Disabled state opacity:    Increase from 40% to 55%
  Color swatch borders:      Add 1pt Deep Navy border to all swatches (not just selected)
  Toggle switches:           Add 2pt border ring in current state color

DYNAMIC TYPE:
  Supported elements:        All body text, labels, button text, metadata
  Maximum:                   xxxLarge (per iOS accessibility settings)
  NOT scaled:                Navigation icons, color swatches, brush tool icons
  Layout adaptation:         At xxLarge+, brush toolbar labels (Starter tier) wrap to
                             two lines. Gallery card metadata truncates with "...".
                             Settings rows expand height to accommodate larger text.

VOICEOVER LABELS:
  Color swatches:            "[Color name]" (e.g., "Red", "Sky Blue")
  Selected swatch:           "[Color name], selected"
  Brush tools:               "[Tool name] brush" (e.g., "Crayon brush")
  Selected tool:             "[Tool name] brush, selected"
  Locked content card:       "[Page name], locked, requires purchase"
  Gallery card:              "[Page name], [status], [date]"
  Undo/Redo (disabled):      "Undo, dimmed" / "Redo, dimmed"
  Timer (Pass & Play):       "42 seconds remaining" (updates every 10 seconds)

MOCKUP NOTE: No accessibility-specific mockups exist in the current set.
             Recommend creating at least one Reduce Motion variant of the
             Celebration screen and one Dynamic Type (xxLarge) variant of Settings.

---

## 3. Responsive Breakpoint Summary

| Component | iPhone (390pt) | iPad Portrait (810pt) | iPad Landscape (1024pt+) |
|---|---|---|---|
| Canvas tools | Bottom bars stacked | Bottom + right sidebar | Right sidebar only |
| Content browser | 2-col grid, top pills | 3-col grid, top pills | 4-col + left sidebar |
| Gallery | 2-col grid | 3-col grid | 4-col grid |
| Color tray | Bottom, 1 row scroll | Bottom, 1 row scroll | Bottom, wider |
| Brush toolbar | Bottom horizontal | Right vertical sidebar | Right vertical sidebar |
| Onboarding tiers | Stacked cards | 3-across cards | 3-across cards |
| Dialogs/sheets | Full-width bottom sheet | Centered sheet (480pt) | Centered sheet (480pt) |
| Pass-and-play bar | Top, compact | Top, full-width | Top, full-width |

---

## 4. Age-Tier UI Adaptations — CONTENT-002

The UI chrome itself adapts based on selected tier, not just content:

| Element | Starter (3–5) | Explorer (6–8) | Creator (9–12) |
|---|---|---|---|
| Brush count | 4 (crayon, marker, stamp, eraser) | All 8 | All 8 |
| Brush icon size | 64x64pt with labels | 48x48pt no labels | 48x48pt no labels |
| Color picker "+" | Hidden | Visible (HSB wheel) | Visible (HSB + hex code) |
| Color swatch size | 40pt | 32pt | 32pt |
| Button text size | 18pt | 16pt | 16pt |
| Touch target min | 52x52pt | 44x44pt | 44x44pt |
| Tier accent color | Peach Blush #FCBFA0 | Sky Blue #6BB8E8 | Lavender #B8A9E8 |
| Content complexity | Thick outlines, large regions | Medium detail | Fine detail, intricate |
| Toolbar labels | Shown (text below icons) | Hidden | Hidden |
| Undo levels shown | 5 (simpler) | 10 | 20 |

---

## 5. Accessibility Notes

- All interactive elements: minimum 44x44pt touch target (52pt for Starter tier)
- Color is never the sole indicator of state (always paired with shape/icon/label)
- VoiceOver labels on all buttons, swatches (color name), and toolbar items
- Dynamic Type support for body text and labels (up to xxxLarge)
- Reduce Motion: replaces spring animations with dissolve transitions, disables celebration motion (shows static congratulations screen)
- High contrast mode: increases border widths to 2pt, deepens shadow opacity

---

## 6. Screen Inventory (Complete List)

| # | Screen / State | Features Covered | Priority | Mockup Status |
|---|---|---|---|---|
| 1 | Welcome Splash | ONBOARD-001 | P0 | ✓ Exists (screen-01-welcome-splash) |
| 2 | Age Selection | ONBOARD-001, CONTENT-002 | P0 | ✓ Exists (screen-01/02) |
| 3 | Canvas (Explorer) | BRUSH-001–005, COLOR-001, AUDIO-001 | P0 | ✓ Exists (screen-03) |
| 4 | Canvas (Starter variant) | BRUSH-003 adaptation, CONTENT-002 | P0 | ✓ Exists (screen-03b) |
| 5 | Canvas (Creator, collapsed picker) | BRUSH-001–005, COLOR-001 | P0 | ✓ Exists (screen-03c-collapsed) |
| 6 | Canvas (Creator, expanded picker) | COLOR-002 | P1 | ✓ Exists (screen-03c) |
| 7 | Canvas — Overflow Menu Action Sheet | FAMILY-001, ANIM-001, AUDIO-001 | P0 | ✓ Exists (screen-07c-canvas-overflow-menu) |
| 8 | Canvas — Zoom Indicator + Reset | BRUSH-001 | P0 | ✓ Exists (screen-08c-canvas-zoom) |
| 9 | Canvas — Contextual Tooltips | ONBOARD-002 | P1 | ✓ Exists (screen-09c-canvas-tooltips) |
| 10 | Content Browser | CONTENT-001, CONTENT-003, IAP-001 | P0 | ✓ Exists (screen-04) |
| 11 | Content Browser — Empty Category | CONTENT-001 | P0 | ✓ Exists (screen-04b-content-browser-states) |
| 12 | Content Browser — In-Progress Card Badge | CONTENT-001, GALLERY-003 | P0 | ✓ Exists (screen-04b-content-browser-states) |
| 13 | Content Browser (iPad sidebar) | CONTENT-001, CONTENT-003 | P0 | ⚠ iPhone only — iPad layout deferred |
| 14 | Completion Celebration | ANIM-001, ANIM-002, ANIM-003 | P0/P1 | ✓ Exists (screen-05) |
| 15 | Celebration — Replay State | ANIM-001 | P1 | ✓ Exists (screen-05b-celebration-states) |
| 16 | Celebration — Save Error Toast | GALLERY-001 | P0 | ✓ Exists (screen-05b-celebration-states) |
| 17 | Gallery Grid | GALLERY-001, GALLERY-003 | P0 | ✓ Exists (screen-06) |
| 18 | Gallery Empty State | GALLERY-001 | P0 | ✓ Exists (screen-06b-gallery-empty) |
| 19 | Gallery Full-Screen | GALLERY-002 | P0 | ✓ Exists (screen-07) |
| 20 | Gallery Full-Screen — In-Progress with Continue | GALLERY-003 | P0 | ✓ Exists (screen-07b-gallery-fullscreen-states) |
| 21 | Gallery — Delete Confirmation | GALLERY-001 | P1 | ✓ Exists (screen-07b-gallery-fullscreen-states) |
| 22 | Art Comes Home (frame picker) | EXPORT-001 | P1 | ✓ Exists (screen-11b-pdf-export) |
| 23 | Unlock Prompt (IAP Sheet) | IAP-001, IAP-002 | P0 | ✓ Exists (screen-08) |
| 24 | IAP — Purchase Success Overlay | IAP-001 | P0 | ✓ Exists (screen-08b-iap-states) |
| 25 | IAP — Purchase/Restore Error States | IAP-001 | P0 | ✓ Exists (screen-08b-iap-states) |
| 26 | Pack Store | IAP-003 | P1 | ✓ Exists (screen-13-pack-store) |
| 27 | Pack Store — Coming Soon State | IAP-003 | P1 | ✓ Exists (screen-13-pack-store) |
| 28 | Pass-and-Play Setup Sheet | FAMILY-001 | P1 | ✓ Exists (screen-14-pass-and-play-setup) |
| 29 | Pass-and-Play In-Game Turn Bar | FAMILY-001 | P1 | ✓ Exists (screen-15-pass-and-play-ingame) |
| 30 | Pass-and-Play Timer Warning States | FAMILY-001 | P1 | ✓ Exists (screen-15-pass-and-play-ingame) |
| 31 | Pass-and-Play Pause Overlay | FAMILY-001 | P1 | ✓ Exists (screen-16-pass-and-play-pause) |
| 32 | Pass-and-Play End Session Confirm | FAMILY-001 | P1 | ✓ Exists (screen-16-pass-and-play-pause) |
| 33 | Pass-and-Play Handoff | FAMILY-001 | P1 | ✓ Exists (screen-10/11) |
| 34 | Parental Gate | SAFETY-002 | P0 | ✓ Exists (screen-09) |
| 35 | Parental Gate — Wrong Answer State | SAFETY-002 | P0 | ✓ Exists (screen-09b-parental-gate-states) |
| 36 | Parental Gate — Rate Limit Lockout | SAFETY-002 | P0 | ✓ Exists (screen-09b-parental-gate-states) |
| 37 | Settings | AUDIO-001–003, SAFETY, CONTENT-002 | P0/P1 | ✓ Exists (screen-12) |
| 38 | Settings — Tier Change Confirmation | CONTENT-002 | P0 | ✓ Exists (screen-12b-settings-states) |
| 39 | Global — Loading Skeleton States | — | P0 | ✓ Exists (screen-17-loading-states) |
| 40 | Global — Network/Offline Error | — | P0 | ✓ Exists (screen-18-error-states) |
| 41 | Accessibility — Reduce Motion Variants | — | P1 | ✓ Exists (screen-18-error-states, variant 3) |
| 42 | Accessibility — Dynamic Type Variants | — | P1 | ⚠ Deferred — no mockup yet |

---

*End of Design Specifications — [App Name] v1.1*
*42 distinct screens/states covering all P0 and P1 features*
*32 mockups exist across 18 files; 40 of 42 states are now represented*
*Optimized for Google Stitch mockup generation*
