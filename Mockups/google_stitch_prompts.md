### Google Stitch Prompts — [App Name]

**How to use:** Paste the Master System Prompt first to establish the design system, then paste each Screen Prompt one at a time in order. Do not skip screens or reorder them.

---

## MASTER SYSTEM PROMPT
*(Paste this first, before any individual screen prompts)*

```
You are building a children's iOS coloring app called [App Name]. Build every screen exactly according to the following design system. Do not deviate from these specifications — do not substitute colors, fonts, corner radii, or layout patterns with your own defaults.

━━━━━━━━━━━━━━━━━━━━━━━
VISUAL DIRECTION: "Paper Studio"
━━━━━━━━━━━━━━━━━━━━━━━
Aesthetic: Montessori classroom meets Apple design language. Warm, tactile, and premium. Surfaces feel like paper and canvas. The child's artwork is always the visual hero. No cluttered UI chrome.

━━━━━━━━━━━━━━━━━━━━━━━
COLOR PALETTE — use ONLY these hex values
━━━━━━━━━━━━━━━━━━━━━━━
Background (Warm Cream):     #FFF8F0
Card surface (Soft Canvas):  #FFFDF9
Primary action (Rich Teal):  #0EA5A0
Text/headers (Deep Navy):    #1B2A4A
CTA accent (Sunset Coral):   #F06449
Warning/stars (Honey Gold):  #F5A623
Success (Soft Sage):         #7CB686
Creator tier accent:         #B8A9E8
Explorer tier accent:        #6BB8E8
Starter tier accent:         #FCBFA0
Secondary text:              #666666
Dividers/borders:            #E8E0D8

━━━━━━━━━━━━━━━━━━━━━━━
TYPOGRAPHY — use ONLY these fonts
━━━━━━━━━━━━━━━━━━━━━━━
Headers/buttons: Nunito, Bold (700) or ExtraBold (800)
Body/labels:     Nunito Sans, Regular (400) or SemiBold (600)
No other fonts. No Inter, Roboto, SF Pro, or system defaults.

Type scale (iPhone / iPad):
  Hero title:     36pt / 52pt — Nunito ExtraBold
  Screen header:  24pt / 32pt — Nunito Bold
  Section H2:     18pt / 24pt — Nunito Bold
  Button label:   16pt / 18pt — Nunito Bold
  Body text:      15pt / 17pt — Nunito Sans Regular
  Caption:        12pt / 14pt — Nunito Sans Regular
  Badge text:     10pt / 12pt — Nunito Bold

━━━━━━━━━━━━━━━━━━━━━━━
SPACING & LAYOUT
━━━━━━━━━━━━━━━━━━━━━━━
Base unit: 8pt. All spacing is multiples of 8.
iPhone screen: 390pt wide, 16pt side margins
iPad landscape: 1024pt wide, 32pt side margins
Minimum touch target: 44x44pt (52x52pt for Starter tier)
No tab bar anywhere in the app. Navigation uses back arrows and toolbar icons only.

━━━━━━━━━━━━━━━━━━━━━━━
CORNER RADII — use these exact values
━━━━━━━━━━━━━━━━━━━━━━━
Badges/tags:        6pt
Buttons/inputs:     10pt
Cards/dialogs:      16pt
Panels/sheets:      24pt
Featured cards:     32pt
Pills/avatars:      9999pt (fully rounded)

━━━━━━━━━━━━━━━━━━━━━━━
ELEVATION / SHADOWS
━━━━━━━━━━━━━━━━━━━━━━━
Cards (resting):    0 2pt 8pt rgba(27,42,74,0.06)
Raised elements:    0 4pt 16pt rgba(27,42,74,0.10)
Floating panels:    0 8pt 32pt rgba(27,42,74,0.14)
Modals:             0 16pt 48pt rgba(27,42,74,0.18)

━━━━━━━━━━━━━━━━━━━━━━━
RULES — follow strictly
━━━━━━━━━━━━━━━━━━━━━━━
- Use ONLY the hex colors listed above. No purple gradients, no white backgrounds, no gray defaults.
- Use ONLY Nunito and Nunito Sans. No substitutions.
- No tab bar navigation. No hamburger menus.
- No ads, banners, or promotional overlays anywhere.
- All buttons are 48–56pt tall with 10pt corner radius.
- Primary buttons: Rich Teal #0EA5A0 fill, white Nunito Bold label.
- CTA/purchase buttons: Sunset Coral #F06449 fill, white Nunito Bold label.
- Locked content shows a single small lock icon at 60% opacity — NO price overlay, NO "UNLOCK NOW" banners.
- Build iPhone portrait first, then iPad landscape.
```

---

## SCREEN 1 — Welcome Splash
*(ONBOARD-001, Screen 1 of 3)*

```
Build Screen 1 of 3 of the onboarding flow: the Welcome Splash screen for iPhone portrait (390pt wide).

LAYOUT:
- Full-screen background: Warm Cream #FFF8F0 with a very subtle paper grain texture (5% opacity noise)
- Hide the iOS status bar on this screen only
- Vertically centered content stack with generous spacing

CONTENT (top to bottom):
1. App icon: 120x120pt rounded square (32pt radius), centered, with a gentle drop shadow (Level 2). Leave a placeholder illustration of a colorful crayon or paintbrush.
2. App name "[App Name]": Nunito ExtraBold 36pt, Deep Navy #1B2A4A, centered, 24pt below icon
3. Tagline "Where your art comes alive": Nunito Sans Regular 17pt, Soft Graphite #666666, centered, 8pt below app name
4. 48pt vertical gap
5. "Get Started" button: full width minus 32pt margins, 56pt tall, Rich Teal #0EA5A0 fill, white Nunito Bold 18pt label, 10pt corner radius, Level 2 shadow
6. 16pt gap
7. "Skip ›" text link: Nunito Sans SemiBold 15pt, Soft Graphite #666666, centered, no underline

DECORATIVE DETAIL:
Add 3–4 small colored pencil mark shapes floating softly across the background — very subtle, light opacity (~20%), in Peach Blush, Sky Blue, and Honey Gold. These should feel like faint crayon strokes, not icons.

DO NOT add: navigation bars, tab bars, headers, back buttons, or any other chrome. This is a pure splash screen.
```

---

## SCREEN 2 — Age Selection
*(ONBOARD-001, Screen 2 of 3)*

```
Build Screen 2 of 3 of the onboarding flow: the Age Tier Selection screen for iPhone portrait (390pt wide).

LAYOUT:
- Background: Warm Cream #FFF8F0
- Standard iOS status bar (light content)
- No navigation bar, no back button

CONTENT (top to bottom, 24pt top padding below status bar):
1. Header: "Who's coloring today?" — Nunito Bold 28pt, Deep Navy #1B2A4A, centered
2. 32pt gap
3. Three tier selection cards, stacked vertically, 16pt gap between each, 16pt left/right margins:

CARD 1 — STARTER:
- Height: 100pt, corner radius 24pt, Level 2 shadow
- Background: #FCBFA0 at 20% opacity (Peach Blush tint)
- Left border: 4pt solid Sunset Coral #F06449
- Left section (80pt wide): custom crayon illustration icon, 48x48pt, Sunset Coral tint
- Center: Tier name "Starter" — Nunito Bold 20pt, Deep Navy. Age range "Ages 3–5" — Nunito Sans SemiBold 14pt, #F06449. Description "Big shapes & bold colors" — Nunito Sans Regular 14pt, Soft Graphite #666666
- Card background: white (#FFFDF9)

CARD 2 — EXPLORER:
- Same dimensions and structure as Starter card
- Background tint: #6BB8E8 at 20% opacity (Sky Blue)
- Left border: 4pt solid Rich Teal #0EA5A0
- Icon: palette/paintbrush illustration, 48x48pt, Teal tint
- Name: "Explorer" — Nunito Bold 20pt, Deep Navy
- Age: "Ages 6–8" — Nunito Sans SemiBold 14pt, #0EA5A0
- Description: "More detail & cool tools"

CARD 3 — CREATOR:
- Same dimensions and structure
- Background tint: #B8A9E8 at 20% opacity (Lavender)
- Left border: 4pt solid Deep Navy #1B2A4A
- Icon: fine pen/pencil illustration, 48x48pt, Navy tint
- Name: "Creator" — Nunito Bold 20pt, Deep Navy
- Age: "Ages 9–12" — Nunito Sans SemiBold 14pt, #1B2A4A
- Description: "Fine art & custom colors"

4. 24pt gap below last card
5. Reassurance text: "You can always change this later" — Nunito Sans Regular 13pt, Soft Graphite #666666, centered

DO NOT add: a Next/Continue button. Tapping the card itself advances the flow. The card is the action. No tab bars, no navigation bars.
```

---

## SCREEN 3 — Canvas: Main Coloring Screen
*(BRUSH-001–005, COLOR-001, AUDIO-001)*

```
Build the main Canvas coloring screen — the primary screen of the app — for iPhone portrait (390pt wide). This is the Explorer tier variant (default).

LAYOUT ZONES (top to bottom):
1. TOP TOOLBAR — 44pt tall, Soft Canvas #FFFDF9 background, 1pt bottom border #E8E0D8
2. CANVAS AREA — fills all remaining space between top toolbar and brush toolbar
3. BRUSH TOOLBAR — 56pt tall, Soft Canvas background, 1pt top border #E8E0D8
4. COLOR TRAY — 48pt tall, Soft Canvas background, 1pt top border #E8E0D8
5. UNDO/SIZE/REDO BAR — 40pt tall, Soft Canvas background
6. Bottom safe area: 34pt

TOP TOOLBAR (left to right):
- Back chevron "‹" (SF Symbol chevron.left): Rich Teal #0EA5A0, 44x44pt touch target, 8pt from left edge
- Page title "Sleeping Cat" (example): Nunito SemiBold 16pt, Deep Navy, centered
- Right side: mute speaker icon (SF Symbol speaker.wave.2, Teal), then "···" overflow icon — each 44x44pt, right-aligned with 8pt gap

CANVAS AREA:
- White background (#FFFFFF)
- Shows a simple coloring page line art (placeholder: a cat outline, thick lines, partially colored in — left side colored with orange and teal patches, right side still white line art, to show in-progress state)
- No other elements in this zone

BRUSH TOOLBAR (8 brush icons in a horizontal row, evenly spaced):
Show these 8 icons left to right with subtle custom illustrations (not generic icons):
  Crayon (warm yellow tint) | Marker (red tint) | Watercolor (blue tint) | Pencil (graphite tint) | Spray (green tint) | Glitter (gold tint) | Stamp (purple tint) | Eraser (pink tint)
- Each icon: 48x48pt touch target, 32x32pt icon
- SELECTED state (Marker is selected): circular background #0EA5A0 at 15% opacity behind icon, icon tinted Rich Teal #0EA5A0
- All others: no background, Soft Graphite #666666 tint

COLOR TRAY:
- Horizontal scrollable row of 24 color circles
- Circle diameter: 32pt each, 8pt gap between
- Show first 8 visible: Red, Orange, Yellow, Green, Teal, Blue, Purple, Pink
- SELECTED swatch (Teal): enlarged to 40pt with white 3pt ring border and white checkmark centered
- At far right: "+" circle, 32pt, dashed 2pt border in #666666, "+" symbol — this opens the custom color picker
- Left/right fade-out gradient at edges to indicate scrollability

UNDO/SIZE/REDO BAR (left to right):
- Undo button "↩": SF Symbol arrow.uturn.backward, 24pt, Rich Teal, 44x44pt touch target, left-aligned
- Brush size slider: centered, 200pt wide track, 6pt thick rounded track, left fill in current color (Teal), right fill #E8E0D8, 24pt white thumb circle with Level 2 shadow
- Redo button "↪": SF Symbol arrow.uturn.forward, 24pt, Rich Teal, 44x44pt touch target, right-aligned

DO NOT add: any ads, banners, subscription prompts, tab bars, or sidebar navigation. The canvas must fill maximum vertical space.
```

---

## SCREEN 4 — Canvas: Starter Tier Variant
*(CONTENT-002 adaptation)*

```
Build the Canvas screen variant for the Starter tier (ages 3–5), iPhone portrait. This is the same layout as the main canvas but with these specific adaptations:

BRUSH TOOLBAR CHANGES:
- Show ONLY 4 brushes (not 8): Crayon, Marker, Stamp, Eraser
- Each brush icon enlarged to 64x64pt touch target (not 48pt)
- Add a text label below each icon: "Crayon", "Marker", "Stamp", "Erase" — Nunito Bold 11pt, Soft Graphite
- The toolbar height increases to 80pt to accommodate labels
- Peach Blush #FCBFA0 tint on the selected brush background (not Teal, because this is Starter tier)

COLOR TRAY CHANGES:
- Color swatches enlarged to 40pt diameter (not 32pt)
- 10pt gap between swatches
- NO "+" button at the end (the custom color picker is hidden for Starter tier)
- The tray may need to be 56pt tall to fit the larger swatches

CANVAS CONTENT:
- Show a simple thick-outlined coloring page (placeholder: a large cartoon sun with thick 6–8pt outlines, large enclosed regions, partially colored)
- The coloring page should feel noticeably simpler/bolder than the Explorer variant

TOP TOOLBAR:
- Add a Peach Blush #FCBFA0 tint (10% opacity) behind the toolbar to subtly signal Starter tier
- All elements same as main canvas

Everything else matches the main canvas spec exactly. Show this as an iPhone portrait mockup.
```

---

## SCREEN 5 — Canvas: Creator Tier Variant
*(CONTENT-002 adaptation, COLOR-002)*

```
Build the Canvas screen variant for the Creator tier (ages 9–12), iPhone portrait. This is the same base layout as the Explorer canvas (Screen 3) but with these specific adaptations:

TOP TOOLBAR:
- Add a Lavender #B8A9E8 tint (10% opacity) behind the toolbar to subtly signal Creator tier
- All elements same as main canvas otherwise

BRUSH TOOLBAR:
- All 8 brushes shown (same as Explorer)
- Each icon: 48x48pt touch target, 32x32pt icon (same as Explorer)
- SELECTED state uses Lavender #B8A9E8 at 15% opacity as background circle (not Teal)
- Selected icon tinted Deep Navy #1B2A4A (not Teal — Creator tier uses Navy as its accent)
- No text labels below icons (same as Explorer)

COLOR TRAY:
- Same 24 swatches at 32pt as Explorer
- SELECTED swatch ring: 3pt Deep Navy #1B2A4A border (not white) for Creator-tier distinction
- The "+" button IS visible (same as Explorer) — opens the custom color picker with hex code

CUSTOM COLOR PICKER VISIBLE DIFFERENCE (when opened):
- Same HSB wheel as Explorer
- ADDITIONAL: Below the HSB wheel, show a hex code field: "Hex: #0EA5A0" — SF Mono 14pt, Soft Graphite #666666
- Small copy icon (doc.on.clipboard SF Symbol, 14pt, Rich Teal) next to hex code
- The hex code is tappable for direct text input

CANVAS CONTENT:
- Show a FINE-DETAIL coloring page (placeholder: an intricate mandala pattern OR anime-style character portrait with thin 2–3pt outlines, many small enclosed regions)
- The coloring page should feel noticeably more complex/sophisticated than the Explorer variant
- Partially colored with more nuanced shading — some regions using opacity variation to show watercolor-style fills

UNDO/SIZE/REDO BAR:
- Same layout as Explorer
- Undo supports 20 levels (not visible in mockup, but noted for context)

Everything else matches the main canvas spec exactly. Show this as an iPhone portrait mockup.
```

---

## SCREEN 6 — Content Browser
*(CONTENT-001, CONTENT-003, renumbered from Screen 5)*

```
Build the Content Browser screen for iPhone portrait (390pt wide). This is the page selection screen — the "store" where children browse and choose coloring pages.

BACKGROUND: Warm Cream #FFF8F0

TOP BAR (44pt tall, Soft Canvas #FFFDF9, 1pt bottom border #E8E0D8):
- Back chevron left: Rich Teal
- Center: App name "[App Name]" — Nunito Bold 18pt, Deep Navy
- Right: Gallery icon (photo.stack SF Symbol, Teal) + Settings icon (gearshape SF Symbol, Soft Graphite)
- Each icon: 44x44pt touch target

CATEGORY PILLS (horizontally scrollable row, 16pt top margin, 16pt left margin):
Show 6 category pills in a row (first 4 visible, last 2 partially cut off to indicate scroll):
Each pill: Nunito SemiBold 13pt, 44pt height, fully rounded (9999pt radius), 8pt gap between pills
  - "🐾 Animals" — SELECTED: Rich Teal #0EA5A0 fill, white text, Level 1 shadow
  - "🚗 Vehicles" — default: #FFFDF9 fill, Deep Navy text, 1pt border #E8E0D8
  - "🐉 Fantasy" — default
  - "🌿 Nature" — default
  - "🎄 Holidays" — partially visible, default
  - "🔷 Patterns" — partially visible, default

SECTION HEADER:
- "Animals" — Nunito Bold 22pt, Deep Navy, 16pt top margin, 16pt left margin

PAGE GRID (2-column grid, 16pt margins, 12pt gap between cards):
Show 6 page cards (3 rows of 2). Each card: ~163pt wide, 3:4 aspect ratio (~217pt tall)

CARD STRUCTURE (each card — white #FFFDF9 background, 16pt corner radius, Level 1 shadow):
  TOP SECTION (thumbnail area, 170pt tall): shows simple placeholder coloring page line art (gray outlines on white)
  BOTTOM SECTION (47pt tall, 12pt padding):
    - Title: Nunito SemiBold 13pt, Deep Navy — e.g. "Sleeping Lion"
    - Tier badge: small colored dot (8pt) + "Explorer" in Nunito Sans 11pt, Sky Blue #6BB8E8

CARD STATES to show:
  Card 1 "Sleeping Lion": normal free card
  Card 2 "Puppy Friends": normal free card, "NEW" badge top-right (Sunset Coral #F06449 pill, "NEW" in white Nunito Bold 9pt)
  Card 3 "Happy Cat": normal free card
  Card 4 "Jungle Fox": LOCKED — thumbnail at 50% opacity, centered lock icon (lock.fill SF Symbol, 20pt, #666666 at 60%), no price text, no upsell overlay
  Card 5 "Baby Bear": normal free card
  Card 6 "Wild Zebra": LOCKED — same as card 4

DO NOT add: any subscription banners, "UNLOCK ALL" overlays, aggressive paywall UI, tab bars, or sidebar.
```

---

## SCREEN 7 — Completion Celebration
*(ANIM-001, ANIM-002)*

```
Build the post-completion celebration screen for iPhone portrait. This appears after a child finishes coloring a page (≥80% filled).

LAYOUT:
- Full screen, Deep Navy #1B2A4A background (darkened to make artwork pop)
- NO toolbar, NO color tray, NO navigation bar

ARTWORK DISPLAY:
- The completed coloring page artwork is centered and fills most of the screen (with 32pt padding on all sides)
- The artwork appears fully colored (placeholder: a fully colored lion with orange mane, yellow body, green background elements — bright and saturated)
- The artwork has a soft glowing border effect: 3pt Rich Teal #0EA5A0 rounded frame with 0 0 20pt 8pt rgba(14,165,160,0.4) glow
- Corner radius on artwork frame: 16pt

CELEBRATION OVERLAY (bottom section, overlaying lower portion of screen):
A gradient overlay from transparent at top to Deep Navy #1B2A4A at bottom, starting 60% down the screen. On this gradient overlay:

1. Celebration text: "Amazing work! ⭐" — Nunito ExtraBold 28pt, white, centered, with very subtle text shadow
2. 16pt gap
3. Two buttons side by side (each 50% width minus 24pt total spacing, 48pt height, 10pt radius):
   - "Save 💾" button: Rich Teal #0EA5A0 fill, white Nunito Bold 16pt
   - "Share 📤" button: Sunset Coral #F06449 fill, white Nunito Bold 16pt
4. 16pt gap
5. "Color another ›" text link — Nunito Sans SemiBold 15pt, white at 70% opacity, centered

TOP RIGHT CORNER:
Small replay button "↻" — 36pt circle, Rich Teal at 20% background, Rich Teal icon, Level 2 shadow, positioned 16pt from top-right edges (within safe area)

ANIMATION SUGGESTION (decorative static representation):
Show a few static confetti/sparkle shapes scattered around the artwork edges — small stars, dots, and squiggles in Honey Gold #F5A623, Sunset Coral #F06449, and Sky Blue #6BB8E8. These represent the frozen frame of the celebration animation.
```

---

## SCREEN 8 — Gallery Grid
*(GALLERY-001, GALLERY-003)*

```
Build the Gallery screen for iPhone portrait (390pt wide).

BACKGROUND: Warm Cream #FFF8F0

NAV BAR (44pt tall, Soft Canvas #FFFDF9, 1pt bottom border #E8E0D8):
- Back chevron left: Rich Teal, 44x44pt
- Center: "My Gallery" — Nunito Bold 20pt, Deep Navy
- Right: "+" icon (plus.circle SF Symbol): Rich Teal, 44x44pt (opens Content Browser)

GRID LAYOUT:
2-column grid, 16pt margins on all sides, 12pt gap between cards
Each card: ~163pt wide, ~220pt tall

SHOW 6 CARDS in this order:

CARD 1 — Completed, most recent:
  - Fully colored artwork thumbnail (placeholder: colorful lion, mostly orange/yellow)
  - Bottom gradient overlay (transparent to #1B2A4A at 60%): "Sleeping Lion" Nunito SemiBold 12pt white, "Today" Nunito Sans 10pt white/70%
  - Top-left: small Sky Blue dot (8pt) for Explorer tier
  - 16pt corner radius, Level 1 shadow

CARD 2 — Completed:
  - Colorful artwork (placeholder: colorful puppy, blues and browns)
  - "Puppy Friends" / "Yesterday"
  - Sky Blue tier dot

CARD 3 — IN PROGRESS (has "Continue" badge):
  - Partially colored artwork (half-colored cat — left side colored, right side white/outline)
  - "Happy Cat" / "Mon"
  - "Continue" badge: top-right, Rich Teal pill, "CONTINUE" Nunito Bold 9pt white

CARD 4 — Completed:
  - Colorful artwork (placeholder: tropical bird, greens and reds)
  - "Jungle Bird" / "Last week"

CARD 5 — Completed:
  - Colorful artwork (bear with honey pot, warm browns and golds)
  - "Baby Bear" / "Last week"
  - Peach Blush tier dot (Starter tier artwork)

CARD 6 — IN PROGRESS:
  - Partially colored zebra (stripes partially colored)
  - "Wild Zebra" / ""
  - "Continue" badge in Rich Teal

DO NOT add: tab bars, category filters on this screen, or delete buttons. The gallery is minimal and child-friendly.
```

---

## SCREEN 9 — Gallery Full-Screen & Share
*(GALLERY-002, EXPORT-001)*

```
Build the Gallery Full-Screen view for iPhone portrait. This appears when a child taps a card in the Gallery.

LAYOUT: Full screen, no standard navigation bar

ARTWORK DISPLAY:
- Artwork fills the full screen with 24pt padding on all sides
- Background: white #FFFFFF (so the artwork bleeds cleanly)
- The artwork itself: a fully colored lion (placeholder — same as Screen 6 but without the celebration overlay)
- Artwork has 12pt corner radius

TOP BAR (overlaid on artwork, semi-transparent background #1B2A4A at 40%):
- 44pt tall
- Left: "✕" close button (xmark SF Symbol, white, 44x44pt)
- Right icons (each 44x44pt, white icons, right-aligned with 8pt gaps):
  ↻ Replay (arrow.counterclockwise SF Symbol)
  📤 Share (square.and.arrow.up SF Symbol)
  🖨 Print (printer SF Symbol)

BOTTOM INFO STRIP (gradient overlay from transparent to #FFF8F0, bottom 80pt of screen):
- Artwork title: "Sleeping Lion" — Nunito Bold 18pt, Deep Navy #1B2A4A
- Metadata: "Explorer tier · March 15, 2026" — Nunito Sans 13pt, Soft Graphite #666666
- Status: green dot (8pt, Soft Sage #7CB686) + "Completed" — Nunito Sans SemiBold 13pt, Soft Graphite

SWIPE HINT:
At the left and right edges, show faint arrow chevrons (chevron.left/right SF Symbols, white at 30% opacity) indicating swipe navigation between artworks.
```

---

## SCREEN 10 — Unlock Prompt / IAP Bottom Sheet
*(IAP-001, IAP-002)*

```
Build the IAP unlock bottom sheet for iPhone portrait. This slides up when a child taps a locked coloring page.

BACKGROUND:
- Behind the sheet: the Content Browser screen (screen 5) is visible but with a semi-transparent dark overlay (#1B2A4A at 50% opacity)

BOTTOM SHEET:
- Slides up from bottom
- White background #FFFFFF
- Top corners only: 24pt corner radius
- Level 4 shadow
- Height: approximately 340pt

SHEET CONTENT (top to bottom, 24pt horizontal padding):
1. Drag handle: 36x5pt rounded pill, #E8E0D8, centered, 12pt top margin
2. 16pt gap
3. Emoji icon: 🎨 — 40pt, centered
4. 8pt gap
5. Headline: "Unlock all the colors!" — Nunito Bold 22pt, Deep Navy #1B2A4A, centered
6. 12pt gap
7. Body text (centered, Nunito Sans 16pt, Soft Graphite #666666):
   "Get 200+ coloring pages, all brushes,
   and animations. One payment.
   No subscriptions. No ads. Ever."
8. 24pt gap
9. "Unlock Everything  $14.99" button:
   Full width (minus 48pt total horizontal padding), 56pt tall
   Sunset Coral #F06449 fill
   White Nunito Bold 18pt label
   10pt corner radius
   Level 2 shadow
10. 12pt gap
11. "Restore Purchase" — Nunito Sans SemiBold 14pt, Rich Teal #0EA5A0, centered
12. 16pt gap
13. "✕  No thanks, keep exploring free" — Nunito Sans 14pt, Soft Graphite #666666, centered

CRITICAL: No subscription toggle. No trial period timer. No "per month" language. No urgency badges. The tone is calm and factual — one price, forever.
```

---

## SCREEN 11 — Parental Gate
*(SAFETY-002)*

```
Build the Parental Gate modal for iPhone portrait. This appears before any purchase, share action, or Settings access.

BACKGROUND: The screen behind the modal (e.g., the Content Browser) is visible with a #1B2A4A overlay at 50% opacity — the app is visible but dimmed.

MODAL DIALOG:
- Centered on screen
- Width: 300pt
- White background #FFFFFF
- 24pt corner radius
- Level 4 shadow: 0 16pt 48pt rgba(27,42,74,0.18)

MODAL CONTENT (top to bottom, 24pt padding all sides):
1. Lock icon: lock.fill SF Symbol, 32pt, Honey Gold #F5A623, centered
2. 12pt gap
3. Title: "Grown-ups only!" — Nunito Bold 22pt, Deep Navy #1B2A4A, centered
4. 12pt gap
5. Math problem: "What is 24 × 7?" — Nunito Sans SemiBold 18pt, Soft Graphite #666666, centered
6. 16pt gap
7. Answer input field: 120pt wide, 48pt tall, centered in modal
   - Thin border: 1.5pt, #E8E0D8, 10pt corner radius
   - Inside: empty (numeric keyboard implied)
   - Nunito Bold 24pt, Deep Navy, center-aligned
8. 20pt gap
9. "Continue" button: full modal width minus 48pt, 48pt tall, Rich Teal #0EA5A0 fill (show as slightly dimmed/disabled since no answer entered), white Nunito Bold 16pt, 10pt corner radius
10. 16pt gap
11. "Cancel" text: Nunito Sans SemiBold 15pt, Soft Graphite #666666, centered

MODAL CONTEXT NOTE (small text below modal, optional):
"This keeps purchases safe" — 12pt, white at 60%, centered
```

---

## SCREEN 12 — Pass-and-Play Setup
*(FAMILY-001)*

```
Build the Pass-and-Play player setup bottom sheet for iPhone portrait. This slides up from the Canvas screen when "Play Together" is tapped.

BACKGROUND: Canvas screen (screen 3) visible behind, dimmed with #1B2A4A at 40% overlay

BOTTOM SHEET:
- White #FFFFFF background, top corners 24pt radius, Level 4 shadow
- Height: approximately 480pt

SHEET CONTENT (top to bottom, 24pt horizontal padding):
1. Drag handle: 36x5pt pill, #E8E0D8, centered, 12pt top margin
2. 20pt gap
3. Title: "Who's playing?" — Nunito Bold 24pt, Deep Navy #1B2A4A
4. 24pt gap

PLAYER 1 SECTION:
5. Label: "Player 1" — Nunito SemiBold 14pt, Soft Graphite #666666
6. 8pt gap
7. Avatar row: 8 animal face avatars (bear, cat, owl, fox, rabbit, penguin, lion, frog) — each 40x40pt circles, 8pt gap between. FIRST AVATAR (bear) is selected: shows 3pt Rich Teal #0EA5A0 ring border. Others: no border, full opacity.
8. 8pt gap
9. Name input: full width, 48pt tall, 10pt radius, 1.5pt border #E8E0D8, placeholder "Player 1" in Soft Graphite, Nunito Sans 16pt
10. 20pt gap

PLAYER 2 SECTION (same structure):
11. "Player 2" label
12. Avatar row (second avatar — cat — selected with Sky Blue #6BB8E8 ring)
13. Name input: placeholder "Player 2"
14. 12pt gap

ADD PLAYER:
15. "+ Add player" — Nunito SemiBold 14pt, Rich Teal #0EA5A0, left-aligned (supports up to 4 players)
16. 24pt gap

TURN TIME:
17. "Turn time:" label — Nunito SemiBold 14pt, Soft Graphite
18. 8pt gap
19. Segmented control, 3 segments: "30s" | "60s" | "90s"
    "60s" is selected: Rich Teal #0EA5A0 fill, white Nunito SemiBold 14pt
    Others: #FFFDF9 background, Deep Navy text
    Full width, 44pt tall, 10pt corner radius
20. 24pt gap
21. "Start Coloring!" button: full width, 56pt, Rich Teal fill, white Nunito Bold 18pt, 10pt radius, Level 2 shadow
```

---

## SCREEN 13 — Pass-and-Play Handoff
*(FAMILY-001)*

```
Build the Pass-and-Play turn handoff screen for iPhone portrait. This appears full-screen between turns.

FULL SCREEN LAYOUT:
- Background: Sky Blue #6BB8E8 at 15% opacity over Warm Cream #FFF8F0 (representing Player 2's turn — Explorer tier color)
- No navigation chrome at all — full screen takeover

CENTERED CONTENT STACK:
1. 80pt from top: turn counter — "Turn 2 of 6" — Nunito Sans Regular 14pt, Soft Graphite #666666
2. 40pt gap
3. Player 2's avatar (cat face illustration): 80x80pt circle, Sky Blue #6BB8E8 background, white cat face illustration centered
   Add a gentle drop shadow (Level 3)
4. 16pt gap
5. Player name: "Your turn, Sarah!" — Nunito Bold 32pt, Deep Navy #1B2A4A, centered
6. 24pt gap
7. Handoff illustration: simple illustration of two hands passing a device/tablet between them — use simple flat design, Sky Blue and Peach tones, approximately 200x120pt
8. 32pt gap
9. "Tap to start your turn" button: 280pt wide, 56pt tall, Rich Teal #0EA5A0 fill, white Nunito Bold 18pt, 10pt corner radius, Level 2 shadow

DECORATIVE ELEMENTS:
- Scatter 5–6 small star shapes (★) around the screen edges in Honey Gold #F5A623 at 30% opacity — feels celebratory and playful
- One small "Player 1 just colored for 60s" note at very top in Soft Graphite 12pt, center
```

---

## SCREEN 14 — Settings
*(SAFETY-002, AUDIO-001–003, CONTENT-002)*

```
Build the Settings screen for iPhone portrait. This uses a grouped table view style.

TOP BAR (44pt, Soft Canvas #FFFDF9, 1pt bottom border #E8E0D8):
- Back chevron: Rich Teal
- Center: "Settings" — Nunito Bold 20pt, Deep Navy
- No right-side actions

BACKGROUND: Warm Cream #FFF8F0

SETTINGS GROUPS (grouped card style, 16pt horizontal margins, 12pt gap between groups):

GROUP 1 — "PROFILE" (header: Nunito SemiBold 13pt, Soft Graphite, uppercase, 8pt above group):
White card, 16pt corner radius, Level 1 shadow:
  Row 1: "Age Tier" label (Nunito Sans 16pt, Deep Navy) + "Explorer ▾" value (Nunito Sans 16pt, Rich Teal), 48pt row height, 1pt bottom divider #E8E0D8
  Row 2: "Artist Name" label + text input field showing "Alex" (Nunito Sans 16pt, Rich Teal), 48pt row height

GROUP 2 — "SOUND":
White card, 16pt corner radius:
  Row 1: "Sound Effects" label + iOS toggle ON (Rich Teal tint), 48pt, 1pt divider
  Row 2: "Background Music" label + iOS toggle ON (Rich Teal tint), 48pt, 1pt divider
  Row 3: "Music Volume" label + horizontal slider (200pt, Rich Teal thumb and fill, positioned at 60%), 48pt row

GROUP 3 — "DISPLAY":
White card:
  Row 1: "Watermark on Exports" label + iOS toggle OFF (gray, unchecked), 48pt

GROUP 4 — "PURCHASES":
White card:
  Row 1: "Restore Purchases" label (Deep Navy) + chevron right (Soft Graphite), 48pt, 1pt divider
  Row 2: "Pack Store" label (Deep Navy) + chevron right, 48pt

GROUP 5 — "ABOUT":
White card:
  Row 1: "Privacy Policy" label + chevron right, 48pt, 1pt divider
  Row 2: "Version 1.0.0" label + "1.0.0" value (Soft Graphite, right-aligned), 48pt

SECTION HEADERS: Nunito SemiBold 13pt, Soft Graphite #666666, uppercase, 8pt above each group, 16pt left margin
ROW LABELS: Nunito Sans Regular 16pt, Deep Navy #1B2A4A
ROW VALUES/CONTROLS: right-aligned, Nunito Sans 16pt, Rich Teal for values/toggles
```

---

*End of Google Stitch Prompts — [App Name] v1.0*
*14 screens covering all P0 and P1 features*
*Always paste the Master System Prompt before the first screen prompt*
