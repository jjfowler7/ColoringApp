# PaperBrush — Interaction Tree

**Schema view of every screen, section, element, and destination**
**March 2026 · Mockups v1.1 · 42 screens/states**

---

## 01 — Welcome Splash (First-Time Launch)
`screen-01-welcome-splash.html`

**Hero Content**
- App icon (animated, 120pt teal square) → Visual — establishes brand on first launch
- "PaperBrush" title + tagline → Non-interactive label

**Actions**
- "Get Started" button (teal, full-width) → Navigate → Age Tier Selection (Screen 02)
- "Skip ›" text link → Navigate → Content Browser with Explorer tier pre-selected
  - Returning users bypass splash entirely → opens Canvas (last artwork) or Content Browser

---

## 02 — Age Tier Selection
`screen-02-age-tier-selection.html`

**Tier Selector Cards**
- Starter tier card (Ages 3–5, crayon icon) → Select Starter tier → Canvas Starter (Screen 03b)
- Explorer tier card (Ages 6–8, palette icon) → Select Explorer tier → Canvas Explorer (Screen 03)
- Creator tier card (Ages 9–12, pencil icon) → Select Creator tier → Canvas Creator (Screen 03c)
  - Chevron arrows are part of each card's tap target — not independent elements

---

## 03 — Canvas — Explorer Tier ("Sleeping Cat")
`screen-03-canvas.html`

**Top Toolbar**
- Back ‹ (teal chevron) → Navigate back → Content Browser (Screen 04)
- Speaker / Mute icon → Toggle → Sound on / off
- Overflow menu ⋯ → Open → Action Sheet (Screen 03-menu)

**Brush Tool Selector (8 tools)**
- Crayon → Set active tool → Crayon brush
- Marker (default selected) → Set active tool → Marker brush
- Watercolor → Set active tool → Watercolor brush
- Pencil → Set active tool → Pencil brush
- Spray Paint → Set active tool → Spray paint brush
- Glitter → Set active tool → Glitter brush
- Stamp → Set active tool → Stamp tool
- Eraser → Set active tool → Eraser

**Color Tray**
- Color swatch (×24, scrollable) → Set active color → Selected swatch color
- Add Color button (+, dashed) → Open → Expanded color picker overlay

**Control Bar**
- Undo button → Action → Undo last drawing step
- Brush size slider (draggable) → Adjust → Active tool size
- Redo button → Action → Redo last undone step

---

## 03-menu — Canvas — Overflow Menu
`screen-07c-canvas-overflow-menu.html`

**Action Sheet (slides up over canvas + scrim)**
- "Save to Gallery" (down-arrow icon) → Action → Save canvas state; shows "Saved!" toast
- "Play Together" (two-person icon) → Navigate → Pass & Play Setup (Screen 14) via Parental Gate
- "Done! ✓" (checkmark icon) → Trigger → Celebration (Screen 05); always available as sole completion trigger
- "Settings" (gear icon) → Navigate → Parental Gate (Screen 09) → Settings (Screen 12)
- "Cancel" → Dismiss → Close action sheet, return to canvas
  - "Done! ✓" is always available regardless of coloring progress — the child decides when they are finished

---

## 03-zoom — Canvas — Zoom States
`screen-08c-canvas-zoom.html`

**Zoom Controls (bottom-right of canvas area)**
- Zoom indicator pill ("3.5x") → Informational — shows current zoom level, auto-fades
- "1:1" reset button (teal pill) → Action → Animate canvas back to 1.0x fit-to-screen
- Pinch gesture → Adjust → Zoom 2x–10x; two-finger pan when zoomed

---

## 03-tips — Canvas — Contextual Tooltips (First Session)
`screen-09c-canvas-tooltips.html`

**Tooltip 1: After First Brush Stroke**
- "Drag to change brush size" pill → Auto-dismiss → 3 seconds or tap anywhere

**Tooltip 2: After First Color Pick (Explorer/Creator)**
- "Tap + for more colors" pill → Auto-dismiss → 3 seconds or tap anywhere

**Tooltip 3: First Completed Page**
- "You did it! Tap to save" overlay → Prompt → Directs attention to Save button
- Save button (teal, pulsing glow) → Action → Save to Gallery

---

## 03b — Canvas — Starter Tier ("Happy Sun")
`screen-03b-canvas-starter.html`

**Brush Tool Selector (4 tools with labels — simplified)**
- Crayon (labeled) → Set active tool → Crayon brush
- Marker (labeled, default selected) → Set active tool → Marker brush
- Stamp (labeled) → Set active tool → Stamp tool
- Erase (labeled) → Set active tool → Eraser
  - Starter tier omits Watercolor, Pencil, Spray, Glitter tools

**Color Tray (larger swatches, no Add Color button)**
- Color swatch (×24, 40pt diameter, single-row scroll) → Set active color → Selected swatch color
  - No add-color (+) button in Starter tier

---

## 03c-col — Canvas — Creator Tier (collapsed picker)
`screen-03c-canvas-creator-collapsed.html`

**Color Tray (24 swatches, 32pt)**
- Color swatch (×24, scrollable) → Set active color → Selected swatch color
- Add Color (+) with active badge → Open → Expanded color picker (Screen 03c-exp)

---

## 03c-exp — Canvas — Creator Tier (expanded picker)
`screen-03c-canvas-creator.html`

**Color Picker Overlay (modal)**
- Saved custom color swatches (grid) → Select → Set color as active
- Hex input field → Enter → Type hex code for custom color
- Eyedropper / sample tool → Mode switch → Sample from canvas
- Close / dismiss (X) → Dismiss → Return to collapsed tray state

---

## 04 — Content Browser
`screen-04-content-browser.html`

**Navigation Bar (no back button — this is the root screen)**
- Pack Store icon (box, teal) → Navigate → Pack Store (Screen 13)
- Gallery icon (photos) → Navigate → Gallery (Screen 06)
- Settings icon (gear) → Navigate → Parental Gate → Settings (Screen 12)

**Category Filter Pills (horizontally scrollable)**
- Animals (selected, teal) → Filter → Show Animals pages
- Vehicles / Fantasy / Nature / Holidays / Patterns → Filter → Show respective category

**Page Card Grid (2-column, scrollable)**
- Free page cards ("Sleeping Lion", "Happy Cat", etc.) → Open → Canvas with page loaded
- Locked page cards ("Jungle Fox", "Wild Zebra") → Trigger → IAP Sheet (Screen 08)
- In-progress cards with CONTINUE badge → Open → Resume canvas with saved state

---

## 04b — Content Browser — Additional States
`screen-04b-content-browser-states.html`

**In-Progress Card Badge**
- "CONTINUE" badge (teal pill, top-right) → Tap card → Resume canvas with saved state

**Tier Divider**
- "More pages" divider line → Informational — separates tier-matched from other-tier pages

**Empty Category State**
- Empty easel illustration → Non-interactive
- "Nothing here yet!" title → Non-interactive
- "Browse Other Categories" (teal link) → Navigate → Scrolls pills to next category with content

---

## 05 — Celebration
`screen-05-celebration.html`

**Actions**
- Replay ↻ (circular teal button) → Action → Replays celebration animation; buttons fade during replay
- Save 💾 (teal) → Action → Save artwork to Gallery; shows success/error toast
- Share 📤 (coral) → Action → Parental Gate (force gate, even within grace period) → iOS share sheet
- "Color another ›" (text link) → Navigate → Content Browser (Screen 04)

---

## 05b — Celebration — Additional States
`screen-05b-celebration-states.html`

**Replay State**
- Replay button (active/pressed) → Action → Replays animation; buttons fade out

**Save Success Toast**
- "Saved to Gallery ✓" (sage green pill) → Auto-dismiss → 2 seconds

**Save Error Toast**
- "Couldn't save" (gold warning toast) → Persists → 4 seconds
- "Open Settings" link (white underline) → Navigate → iOS system Settings for permissions

---

## 06 — Gallery
`screen-06-gallery.html`

**Navigation Bar**
- Back ‹ (teal chevron) → Navigate back → Content Browser (Screen 04)
- Plus icon + → Navigate → Content Browser to start new page

**Gallery Card Grid (2-column, scrollable)**
- Completed cards → Open → Gallery Fullscreen (Screen 07)
- In-progress cards with CONTINUE badge → Open → Gallery Fullscreen or resume Canvas

---

## 06b — Gallery — Empty State + Management
`screen-06b-gallery-empty.html`

**Empty State (zero artworks)**
- Easel + paintbrush illustration → Non-interactive
- "Your gallery is empty!" title → Non-interactive
- "Browse Pages" button (teal) → Navigate → Content Browser (Screen 04)

**Long-Press Context Menu (on gallery card)**
- "Share" (share icon) → Action → Parental Gate (force gate) → iOS share sheet
- "Print" (printer icon) → Action → Parental Gate (force gate) → Frame Picker (Screen 11b)
- "Delete" (trash icon, coral) → Action → Parental Gate → Delete confirmation alert

---

## 07 — Gallery Fullscreen Viewer
`screen-07-gallery-fullscreen.html`

**Overlaid Controls**
- Close ✕ (white, top-left) → Dismiss → Return to Gallery (Screen 06)
- Replay ↻ (top-right) → Action → Replay celebration animation (completed items only)
- Share icon (top-right) → Action → Parental Gate (force gate) → iOS share sheet
- Print icon (top-right) → Action → Parental Gate (force gate) → Frame Picker (Screen 11b)

**Gesture Surface**
- Swipe left / right on artwork → Navigate → Previous / next artwork in Gallery

---

## 07b — Gallery Fullscreen — Additional States
`screen-07b-gallery-fullscreen-states.html`

**In-Progress Artwork View**
- "Continue Coloring" button (teal, right-aligned) → Navigate → Canvas with saved state

**Delete Confirmation Alert**
- "Cancel" (teal, bold) → Dismiss → Return to fullscreen viewer
- "Delete" (coral, destructive) → Action → Remove artwork, return to Gallery

---

## 08 — IAP Sheet (In-App Purchase)
`screen-08-iap-sheet.html`

**Bottom Sheet Modal**
- "Unlock Everything $14.99" (coral CTA) → Initiate purchase → Parental Gate → Transaction
- "Restore Purchase" (teal link) → Restore → Parental Gate → Restore prior purchase
- "✕ No thanks, keep exploring free" (gray) → Dismiss → Return to Content Browser
- Scrim / background overlay → Dismiss (tap) → Close sheet
- Drag handle (top of sheet) → Dismiss (drag down) → Close sheet

---

## 08b — IAP — Purchase States
`screen-08b-iap-states.html`

**Loading State**
- Unlock button shows white spinner → Button disabled during transaction

**Purchase Failure**
- "Something went wrong" (coral inline) → Inline error; button re-enables for retry

**Purchase Success**
- 🎉 "Everything is unlocked!" overlay → Auto-dismiss → 3 seconds or tap anywhere
- All locked cards animate to full opacity → Lock icons fade out

**Restore — Nothing Found**
- "No previous purchases found" (gray) → Inline feedback, persists until sheet dismissed

---

## 09 — Parental Gate
`screen-09-parental-gate.html`

**Modal Controls**
- Answer input field (math question) → Enter answer → Numeric keyboard populates field
- "Continue" (teal, disabled until answer) → Submit → If correct: grant access
- "Cancel" (gray text link) → Dismiss → Return without granting access

**On-screen Numeric Keyboard**
- Digit keys 0–9 → Input → Append digit to answer field
- Backspace ✕ → Delete → Remove last character
- Go / Done key (teal) → Submit → Same as Continue button

---

## 09b — Parental Gate — Error States
`screen-09b-parental-gate-states.html`

**Wrong Answer State**
- Modal shakes (±8pt, 200ms) → Visual feedback
- "Try again" message (coral) → Informational — persists until next attempt
- Input field clears → Same math question persists (no regeneration)

**30-Second Lockout (after 3 wrong)**
- "Wait 30s before trying again" → Timer counts down; re-enables at 0

**5-Minute Lockout (after 6 wrong)**
- "Too many attempts. Try again in 5 minutes." → Timer counts down; Cancel still available

**Grace Period Indicator**
- Teal dot badge on Settings gear icon → Visual — parents know to look; dot fades when grace expires

---

## 10/11 — Pass & Play Handoff
`screen-10-pass-and-play.html` · `screen-11-turn-handoff.html`

**Action**
- "Tap to start your turn" (teal, full-width) → Begin turn → Canvas for current player
  - Turn counter, avatar, name, and illustration are informational only

---

## 11b — Art Comes Home — PDF Export
`screen-11b-pdf-export.html`

**Frame Picker Sheet**
- Frame thumbnails (5: Classic, Nature, Stars, Rainbow, Minimal) → Select → Sets frame style
- Artist name input field → Edit → Update name on PDF
- PDF preview card → Informational — live preview
- "Share / Print" button (teal) → Action → Opens iOS share sheet with generated PDF

---

## 12 — Settings
`screen-12-settings.html`

**Navigation Bar**
- Back ‹ (teal chevron) → Navigate back → Content Browser (Screen 04)

**Profile**
- Age Tier (dropdown ▾, value: "Explorer") → Open picker → Change tier; triggers confirmation alert
- Artist Name (inline text field, value: "Alex") → Edit → Update display name

**Sound**
- Sound Effects toggle (ON, teal) → Toggle → Sound effects on / off
- Background Music toggle (ON, teal) → Toggle → Background music on / off
- Music Volume slider (~60%) → Adjust → Background music volume

**Display**
- Watermark on Exports toggle (OFF, gray) → Toggle → Apply / remove watermark on PNG shares and PDF exports

**Purchases**
- Restore Purchases (disclosure ›) → Trigger → Parental Gate → Restore; shows inline feedback
- Pack Store (disclosure ›) → Navigate → Pack Store (Screen 13)

**About**
- Privacy Policy (disclosure ›) → Open → In-app web view (WKWebView in sheet)
- Version 1.0.0 → No action — informational display only

---

## 12b — Settings — Additional States
`screen-12b-settings-states.html`

**Tier Change Confirmation (iOS alert)**
- "Cancel" (teal, default) → Dismiss → Picker reverts to previous tier
- "Switch" (coral) → Action → Updates tier; toolbar adapts on next canvas open

**Restore Purchases Feedback (inline)**
- "Purchases restored ✓" (sage text) → Informational feedback
- Spinner replaces chevron (loading) → Visual — indicates restore in progress

---

## 13 — Pack Store
`screen-13-pack-store.html`

**Navigation Bar**
- Back ‹ (teal chevron) → Navigate back → Content Browser (Screen 04)

**Coming Soon State (v1 launch)**
- Gift box illustration → Non-interactive
- "New packs coming soon!" title → Non-interactive
- "Notify Me" button (teal outline) → Toggle → Changes to "You'll be notified ✓" (sage fill)

---

## 14 — Pass & Play — Setup
`screen-14-pass-and-play-setup.html`

**Player 1 Section**
- Avatar picker (8 animal SVGs, 40pt each) → Select → Sets player avatar (teal ring)
- Name input field → Edit → Sets player name (max 12 chars)

**Player 2 Section**
- Avatar picker → Select → Sets player 2 avatar
- Name input field → Edit → Sets player 2 name

**Configuration**
- "+ Add player" (teal link) → Action → Adds Player 3/4 section (up to 4)
- Turn time segmented control (30s / 60s / 90s) → Select → Sets turn duration (default: 60s)
- "Start Coloring!" button (disabled until P2 named) → Navigate → Canvas with turn bar

---

## 15 — Pass & Play — In-Game
`screen-15-pass-and-play-ingame.html`

**Turn Indicator Bar (replaces normal top toolbar)**
- Player avatar (32pt circle) → Non-interactive
- "Sarah's turn" label → Non-interactive
- Countdown timer ring (28pt, teal) → Visual — shows remaining time
- ⏸ Pause button → Action → Opens Pause Overlay (Screen 16)

**Timer Warning State (≤10 seconds)**
- Timer ring turns Sunset Coral → Visual warning
- Timer text pulses (scale 1.0→1.05) → Visual urgency

**Time's Up Overlay**
- "Time's up! ⏰" card → Informational — auto-transitions to handoff
- "Passing to Max..." subtitle → Informational

---

## 16 — Pass & Play — Pause & End
`screen-16-pass-and-play-pause.html`

**Pause Overlay (Deep Navy 80% scrim)**
- "Paused" title + frozen timer → Informational
- "Resume" button (teal) → Action → Overlay fades, timer resumes
- "End Game" link (coral) → Trigger → End session confirmation
- Sound toggle (on/off) → Toggle → Mute/unmute during session

**End Session Confirmation (iOS alert)**
- "Keep Playing" (teal, default) → Dismiss → Returns to Pause overlay
- "End & Save" → Action → Celebration plays, credits all players, returns to Content Browser

**Multi-Player Completion Credit**
- "By Sarah & Max" with avatar icons → Informational — shows on celebration and gallery save

---

## 17 — Loading & Skeleton States
`screen-17-loading-states.html`

**Content Browser Loading**
- 4 skeleton cards (shimmer animation) → Non-interactive — resolves within 1 second

**Gallery Loading**
- 4 skeleton cards (shimmer animation) → Non-interactive

**Canvas Page Loading**
- Teal spinner (32pt, centered) → Non-interactive
- "Loading..." text → Non-interactive

---

## 18 — Error & Accessibility States
`screen-18-error-states.html`

**Network Error on IAP**
- "No internet connection" (coral) → Informational
- "Check your connection and try again" (gray) → Informational
- "Try Again" (teal link) → Action → Retries network request

**Privacy Policy Offline**
- Cloud-with-X illustration → Non-interactive
- "Try Again" button (teal outline) → Action → Retries web view load
- "Visit privacy.paperbrush.app in Safari" (teal link) → Navigate → Opens Safari

**Accessibility: Reduce Motion (Celebration variant)**
- Static artwork display (no animation) → Non-interactive
- "Amazing work! ⭐" text (static) → Non-interactive
- Save + Share buttons (static) → Same actions as normal celebration

---

*End of Interaction Tree · PaperBrush Mockups v1.1 · March 2026*
