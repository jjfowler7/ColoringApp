# PRODUCT REQUIREMENTS DOCUMENT
[App Name]
Children’s Coloring App for iOS
Version 1.0 — MVP Release
This PRD defines the engineering-ready feature specifications for the v1 MVP launch,
derived from the Product Strategy document’s Must Have and Table Stakes requirements.
Prepared: March 2026
Status: Draft
Classification: Confidential

---

**Table of Contents**
## 1. Product Overview
[App Name] is a children’s coloring app for iOS that spans ages 3–12 with three age-tiered content bands, zero ads, zero subscriptions, and a one-time purchase model. It is designed to be the first coloring app parents actually recommend to other parents.
### 1.1 Priority Definitions
P0 — Launch Blocker: App cannot ship without this. Missing P0 features would make the app uncompetitive or non-functional.
P1 — Launch Target: Strongly expected for v1. Cutting these would noticeably reduce differentiation but would not block launch.
P2 — Fast-Follow: Ship within 60 days post-launch. Validated demand from strategy, but scoped out of initial sprint to de-risk timeline.
## 2. User Personas
### 2.1 The “Digital-Guilt Parent” (Primary Buyer)
Age 30–42, skewing female in purchase behavior. Has tried 2–4 coloring apps, been burned by subscription bait-and-switch, and reflexively distrusts “free” kids’ apps. Will pay a fair one-time price for something trustworthy. Distribution channel: parent Facebook groups, school WhatsApp chats, family text threads.
### 2.2 The Explorer Child (Ages 5–9, Primary User)
Has outgrown tap-to-fill toddler apps but isn’t ready for adult complexity. Can articulate preferences (“I want to draw a dragon”) and drives repeat sessions independently. Wants creative freedom, instant feedback (sparkles, animations), and the ability to show parents what they made.
### 2.3 The Tween Creator (Ages 10–12, Secondary User)
Entirely unserved by the market. Embarrassed by cartoon-animal coloring apps. Wants anime/manga-style content, realistic shading, geometric patterns, and work that looks “real.” Serving them with a dedicated Creator content tier positions the app for long-term retention as younger users age up.
## 3. Feature Specifications
Each feature below includes a unique ID, detailed description, acceptance criteria, and priority level. Features are grouped into functional areas. All P0 and P1 items derive directly from the Product Strategy’s Must Have and Table Stakes requirements.
### 3.1 Canvas & Brush Engine
The brush engine is the core technical risk. The coloring experience must feel as responsive and satisfying as Procreate’s simplified tools. This is the first thing to prototype and user-test with 5–8 year olds before building anything else.
### 3.2 Color Palette System
The palette must be age-appropriate: simple and inviting for young children, fully expandable for older users. The palette is visible at all times and positioned to avoid accidental ad taps (irrelevant here since we have zero ads, but the positioning should still optimize for small-hand ergonomics).
### 3.3 Content Library & Age Tiers
Content is the product. The three-tier age system is the single most differentiating structural decision—no competitor spans toddler through tween. Each tier must feel intentionally designed for its age group, not like the same pages with thicker lines.
### 3.4 Animation-on-Completion Rewards
This is the #1 delight driver in the category. When a child finishes coloring a page, the artwork should come alive. Bini and KidloLand have proven this drives retention, repeat sessions, and the “show Mom” sharing moment. The animation must feel magical but not disruptive—it celebrates the child’s work, not the app’s technology.
### 3.5 Gallery & Sharing
The gallery is where the child’s work lives. It serves both the child’s need for a portfolio and the parent’s need to share artwork with family. The sharing moment—texting a finished piece to Grandma—is a core part of the reward loop that most apps neglect.
### 3.6 Monetization & In-App Purchase
The monetization model is a strategic weapon, not just a revenue mechanism. In a category where subscription fatigue generates the majority of 1-star reviews, our one-time purchase is the single most shareable fact about the app.
### 3.7 Audio System
Sound design is table stakes, but the mute toggle is critical. Baby Coloring Book’s top complaint is the lack of volume control. Parents using the app in quiet environments (doctor’s offices, planes, bedtime) need instant, reliable mute.
### 3.8 Offline Mode & Performance
The three highest-frequency use cases—car rides, airplanes, and waiting rooms—all lack reliable internet. Crayola’s 2.7GB app size and crash-on-older-iPads reputation is the cautionary tale. Ship lean, ship fast, ship offline.
### 3.9 Safety, Privacy & COPPA Compliance
Zero ads, zero tracking, full COPPA compliance is a non-negotiable launch requirement and a competitive moat. The FTC’s updated COPPA rule takes effect April 2026, and the Recolor enforcement action ($3M penalty for a coloring app) proves this is not a theoretical risk. Budget $5–10K for a COPPA-specialized legal review before App Store submission.
### 3.10 Onboarding Flow
The onboarding must serve two audiences simultaneously: the parent making the download decision (already convinced by the App Store listing) and the child who will use the app. Keep it to 3 screens maximum. The fastest path to coloring wins.
### 3.11 Scan & Import Paper Drawings
The paper-to-digital bridge is one of the most validated unmet needs in the category. Project Aqua’s scan feature drives disproportionate 5-star reviews. Targeting v1.1 (within 60 days post-launch) as a fast-follow, with infrastructure laid in v1.
### 3.12 Pass-and-Play Family Mode
84% of parents call creative apps “valuable family-bonding activities,” yet virtually no coloring app enables parent-child co-creation. Pass-and-play on a single device is low technical lift with high emotional value—the “show Mom” moment built directly into the product.
### 3.13 Art Comes Home (Export & Display)
The sharing moment—texting a finished piece to Grandma or printing it for the fridge—is the emotional payoff that turns users into advocates. No competitor has executed this well. A print-ready PDF export with the child’s name and a decorative frame transforms digital artwork into a tangible keepsake.
## 4. Explicitly Out of Scope for V1
The following features are intentionally excluded from v1 to de-risk the launch timeline. Each has a clear rationale for deferral.
## 5. Technical Constraints & Requirements
### 5.1 Platform & Device Support
iOS 16.0+ (covers ~95% of active iPhones/iPads as of early 2026)
iPhone: iPhone SE 2nd gen and later (A13 Bionic minimum)
iPad: iPad 7th gen and later; iPad mini 5th gen and later
Orientation: both portrait and landscape supported; UI adapts responsively
Apple Pencil: pressure sensitivity supported on compatible iPads; graceful fallback for finger input
### 5.2 Architecture Principles
Fully offline-first: all core functionality works without network. Network used only for IAP transactions and content pack downloads.
No backend for v1: all data stored locally (UserDefaults + Documents directory + Core Data). No user accounts, no cloud sync, no server costs.
Zero third-party SDKs that touch user data: Apple’s native frameworks only (StoreKit 2, Metal/Core Graphics, AVFoundation). Exception: Crashlytics or equivalent only if it collects zero PII (evaluate against COPPA legal review).
Content delivery: coloring pages bundled in-app as vector (SVG) with raster texture overlays. Content packs downloaded as on-demand resources via Apple’s ODR framework.
### 5.3 Rendering Pipeline
The brush engine should be built on Metal for GPU-accelerated rendering. Core Graphics is acceptable as a fallback but will struggle with complex watercolor/glitter effects at 60fps. Key architectural decisions:
Stroke rendering: Metal compute shaders for real-time brush texture compositing
Fill algorithm: GPU-accelerated flood fill using compute shader (CPU fallback for older A13 devices)
Canvas model: tile-based rendering (256x256 tiles) to manage memory on large canvases
Export: Core Graphics path for PNG export at 2048x2048+ resolution
## 6. Success Metrics
The following KPIs define success for the v1 launch. Targets are set for the first 90 days post-launch.
## 7. Risks & Mitigations
## 8. Development Milestones
Timeline assumes a March 2026 start with a Q3 2026 (September) launch target aligned with the back-to-school season, built entirely with Claude Code. The extended timeline provides buffer for illustration pipeline, pass-and-play integration, and thorough beta testing. The critical path runs through the brush engine (highest technical risk) and the content pipeline (longest lead time).
## Appendix: Feature ID Index
Quick reference of all feature IDs, sorted by priority, for use in sprint planning, JIRA tickets, and engineering handoff.
End of Document
PRD v1.0 — [App Name] — March 2026

| Product Name | [App Name] |
| --- | --- |
| Platform | iOS (iPhone + iPad) — iOS 16.0 minimum |
| Target Launch | Q3 2026 (September 2026 — back-to-school window) |
| Target Users | Primary: Parents of children ages 5–9 (buyer) Secondary: Children ages 3–12 (user) Tertiary: Tweens 10–12 (“Creator” tier) |
| Built With | Claude Code (solo developer + AI pair programming) |
| Dev Timeline | 24 weeks (March–September 2026) |
| Monetization | Free tier (50 pages) + One-time unlock ($14.99) + Content packs ($2.99–$4.99) |
| Positioning | For parents tired of subscription traps and ad-riddled kids’ apps, [App Name] is the only children’s coloring app that grows with your child from age 3 to 12 and costs $14.99 once—forever. |


| Core Needs Safe, ad-free activity that doesn’t require constant monitoring. Educational justification for screen time. A price they pay once and forget. Easy sharing of finished art to family. |
| --- |


| Core Needs Colorful, responsive interactions with satisfying feedback. Tools that feel powerful but not overwhelming. Art they’re proud of. Animations that celebrate their work. |
| --- |


| Core Needs Sophisticated visual complexity. Tools that feel grown-up (custom colors, fine brushes, shading). Content that aligns with their aesthetic interests (manga, patterns, street art). |
| --- |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| BRUSH-001 | Freehand painting mode with pressure-sensitive stroke rendering on supported devices | • Stroke renders within 16ms of touch input (60fps minimum) • Line thickness responds to Apple Pencil pressure on iPad • Finger input produces consistent, smooth strokes without jitter • Canvas supports pinch-to-zoom (2x–10x) and two-finger pan | P0 |
| BRUSH-002 | Fill-bucket tool: tap any enclosed region to flood-fill with selected color | • Fills enclosed areas bounded by outlines without color bleed • Tolerance setting handles anti-aliased line edges cleanly • Fill completes in <200ms for regions up to 2048x2048px • Works correctly with zoom level applied | P0 |
| BRUSH-003 | 8 brush types: crayon, marker, watercolor, pencil, spray, glitter, stamp, eraser | • Each brush has visually distinct texture and stroke behavior • Crayon: grainy texture with pressure-based opacity variation • Marker: smooth, semi-transparent with flat edges • Watercolor: bleeds slightly at edges, opacity builds with layering • Pencil: fine tip, light opacity, visible stroke grain • Spray: soft-edged particle scatter, radius adjustable • Glitter: sparkle particle overlay with randomized scatter pattern • Stamp: library of 20+ shape stamps (stars, hearts, animals, etc.) • Eraser: removes color to reveal base page; size adjustable | P0 |
| BRUSH-004 | Brush size adjustment slider accessible from canvas toolbar | • Slider controls brush diameter from 2px to 80px • Real-time preview circle shows current size at cursor position • Size persists per brush type between tool switches • Slider is positioned to avoid accidental activation by young children | P0 |
| BRUSH-005 | Undo/redo system with age-tiered levels | • Undo button reverses the most recent stroke or fill action • Redo restores the most recently undone action • Undo levels: 5 (Starter), 10 (Explorer), 20 (Creator) — younger children need fewer levels, older children benefit from deeper history • Undo history clears only on page change, not on tool switch • Undo/redo buttons positioned outside primary coloring area | P0 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| COLOR-001 | Default palette with 24 curated colors, displayed in a scrollable tray at screen bottom | • 24 colors visible in a horizontally scrollable tray • Colors organized in spectral order with black, white, brown, and skin tones included • Selected color shows enlarged preview with checkmark indicator • Tray height does not exceed 60pt to preserve canvas area • Color tray is touch-scrollable without triggering canvas drawing | P0 |
| COLOR-002 | Custom color picker (HSB wheel) available for Explorer and Creator tiers | • Accessible via a “+” button at end of color tray • HSB wheel with saturation/brightness square selector • Hex code display for Creator tier users • Recently used colors row (last 8) persists across sessions • Picker dismissed on tap-outside without losing selection • Hidden for Starter tier (ages 3–5) to avoid overwhelming UI | P1 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| CONTENT-001 | 200+ coloring pages at launch, distributed across three age bands | • Starter (ages 3–5): minimum 70 pages with thick outlines (6–8pt stroke), large enclosed regions, simple shapes (animals, food, vehicles) • Explorer (ages 6–8): minimum 70 pages with medium detail, smaller regions, more complex subjects (landscapes, characters, buildings) • Creator (ages 9–12): minimum 70 pages with fine detail (2–3pt stroke), intricate patterns, anime/manga styles, geometric designs, realistic subjects • All illustrations maintain consistent, high-quality visual style across age tiers • Each page includes metadata: age tier, theme category, difficulty level, animation template ID | P0 |
| CONTENT-002 | Age-tier selection during onboarding with ability to switch tiers anytime | • First launch presents age selection: “Starter (3–5),” “Explorer (6–8),” “Creator (9–12)” • Selection filters content library to show age-appropriate pages first • All tiers’ content remains accessible—filtering is default sort, not a hard gate • Tier selection stored locally; changeable from Settings at any time • UI complexity adjusts per tier: Starter shows fewer tools, larger buttons; Creator shows full toolset | P0 |
| CONTENT-003 | Themed content categories within each tier | • Minimum 6 theme categories: Animals, Vehicles, Fantasy, Nature, Holidays, Patterns • Each category contains pages from all three age tiers • Category icons are visually distinct and recognizable without text labels • Browse view shows thumbnail previews of each page with “new” badges on unreleased content • Locked (paid) pages show a translucent preview with a single lock icon—no aggressive upsell overlay | P0 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| ANIM-001 | Manual “Done” button triggers a celebration animation on the artwork | • “Done ✓” button in canvas overflow menu is the sole trigger for celebration • No automatic completion detection — the child decides when they are finished • Celebration plays within 500ms of button tap • Animation runs 3–5 seconds, then holds final frame • Child can replay animation from gallery view | P0 |
| ANIM-002 | 50–100 animation templates mapped to page categories | • Animals: character walks, jumps, or bounces across screen • Vehicles: drive, fly, or sail across a background scene • Fantasy: sparkle burst, magic wand trail, character dances • Nature: flowers bloom, rain falls, sun rises behind artwork • Generic: confetti burst, star shower, frame glow • Each page’s metadata references a specific animation template • Animations use the child’s actual coloring (not a pre-colored version) | P0 |
| ANIM-003 | Celebratory sound effect paired with animation | • Unique sound per animation category (not the same chime every time) • Sound volume follows system media volume • Sound respects the global mute toggle (see AUDIO-001) • Sounds are cheerful but not startling—no sudden loud effects | P1 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| GALLERY-001 | In-app gallery displaying all saved artworks as a scrollable grid | • Grid view with thumbnail previews, sorted by most recent first • Each thumbnail shows the page title, date completed, and age tier badge • Tap to open full-screen view of artwork • Swipe between artworks in full-screen view • Gallery persists across app updates (stored in app’s Documents directory) • Gallery loads within 1 second for up to 500 saved artworks | P0 |
| GALLERY-002 | Save to camera roll and share via iOS share sheet | • Save exports artwork as PNG at 2048x2048px minimum resolution • iOS share sheet accessible from gallery full-screen view • Share sheet includes Messages, Mail, AirDrop, and all system-registered share targets • Exported image includes optional watermark with app name (toggleable in Settings) • Save/share actions gated behind parental gate (see SAFETY-002) | P0 |
| GALLERY-003 | Resume in-progress artwork from gallery | • Unfinished artwork saved automatically on app background or page switch • In-progress items show a “continue” badge in gallery view • Resuming restores exact canvas state including undo history • Auto-save triggers every 30 seconds during active coloring | P0 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| IAP-001 | Free tier: 50 coloring pages across all three age bands with full tool access | • 50 pages distributed roughly evenly across Starter, Explorer, Creator tiers • All 8 brush types available in free tier (no gated tools) • Full 24-color palette available in free tier • Save, share, and animation features all functional in free tier • Free tier provides 2–3 weeks of daily play before content exhaustion • No usage timers, session limits, or daily gates | P0 |
| IAP-002 | Full Unlock: single $14.99 non-consumable IAP unlocking all launch content | • Unlocks all 200+ pages, all themes, all age tiers • Restores across all devices signed into the same Apple ID • “Restore Purchases” button accessible from Settings • Purchase flow uses Apple’s StoreKit 2 API • No subscription option presented—one-time purchase only • Receipt validated server-side or via on-device StoreKit verification | P0 |
| IAP-003 | Content pack infrastructure for post-launch themed expansions ($2.99–$4.99 each) | • Content packs delivered as downloadable bundles (not app updates) • Each pack contains 50 pages with theme, age tier distribution, and animation templates • Pack store accessible from content browser with preview thumbnails • Each pack is a one-time non-consumable IAP • First content pack ships 60 days post-launch • Infrastructure built in v1 even if no packs ship at launch | P1 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| AUDIO-001 | Global mute toggle accessible from canvas toolbar and Settings | • Single-tap mute icon on canvas toolbar silences all app audio • Mute state persists across sessions (stored in UserDefaults) • Mute icon visually changes state (speaker vs. speaker-with-X) • Mute toggle also accessible from Settings screen • Hardware silent switch on iPhone also mutes app audio | P0 |
| AUDIO-002 | Context-appropriate sound effects for brush strokes, tool switches, and UI interactions | • Brush strokes produce subtle, satisfying tactile sounds (not looping) • Tool selection plays a brief click or switch sound • Color selection plays a soft tone pitched to the color’s hue (warm = lower, cool = higher) • UI navigation (page open, gallery open) has distinct transition sounds • All sounds are <500ms in duration (no lingering loops during drawing) | P1 |
| AUDIO-003 | Ambient background music with separate volume control | • 2–3 ambient tracks (gentle, non-distracting instrumental) • Music volume independent of sound effects volume • Music fades out (500ms) when app backgrounds; fades in on return • Music auto-pauses if system media is playing (respects audio session) | P1 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| OFFLINE-001 | Full coloring functionality available without internet connection | • All installed coloring pages render and function offline • Brush engine, color palette, fill tool, undo/redo all work offline • Gallery save and resume work offline • Animation-on-completion plays offline (bundled assets, not streamed) • Only IAP purchase/restore and content pack downloads require connectivity • No “offline mode” banner or degraded experience indicator | P0 |
| PERF-001 | App size under 200MB at install; cold launch under 3 seconds | • Initial download size <200MB (coloring pages compressed as vector + raster hybrid) • Cold launch to interactive canvas <3 seconds on iPhone 12 or later • Cold launch to interactive canvas <5 seconds on iPhone SE 2nd gen (baseline device) • Memory usage stays under 300MB during active coloring session • No crashes on devices running iOS 16+ with 3GB+ RAM | P0 |
| PERF-002 | Canvas rendering performance targets | • Sustained 60fps during freehand drawing on all supported devices • No visible frame drops during pinch-to-zoom while drawing • Fill-bucket completes in <200ms for standard page complexity • Undo action completes in <100ms • Canvas supports minimum 4096x4096px working resolution | P0 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| SAFETY-001 | Zero advertising, zero third-party tracking SDKs, zero data collection | • No ad SDKs of any kind included in the binary • No analytics SDKs that transmit personally identifiable information • No third-party crash reporting that collects device identifiers (use Apple’s native crash reporting only) • App does not request Location, Camera (except for scan feature), Microphone, or Contacts permissions • Privacy Nutrition Label in App Store accurately reflects zero data collection • Privacy policy written in plain language, accessible from Settings and App Store listing | P0 |
| SAFETY-002 | Parental gate protecting purchases, external links, and share actions | • Gate triggered before any IAP flow, share sheet, external link navigation, or Settings access • Gate mechanism: 2-digit × 1-digit multiplication (e.g., “What is 24 × 7?”) — single difficulty level for all contexts in v1 • Gate timeout: 5-minute grace period after successful verification (exception: Share and Print always require gate, even within grace period) • Rate limiting: 30-second lockout after 3 wrong answers, 5-minute lockout after 6 • Compliant with Apple’s App Store Review Guidelines for kids’ category | P0 |
| SAFETY-003 | App Store Kids category compliance (Apple’s Guideline 1.3) | • App rated for ages 4+ in App Store • No links to external websites or apps outside parental gate • No user-generated content sharing or social features • Age gate at launch for COPPA compliance • Compliant with Apple’s updated Kids Category guidelines (2025 revision) • App Review team pre-notified of kids’ category submission | P0 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| ONBOARD-001 | 3-screen onboarding: Welcome → Age Selection → First Page | • Screen 1: Welcome splash with app name, tagline, and “Get Started” button • Screen 2: Age tier selection (Starter / Explorer / Creator) with visual icons, not just text labels • Screen 3: First coloring page auto-opens with subtle tool hints (pulsing highlight on brush tray) • Total onboarding time: under 15 seconds for a tapping child • Onboarding can be skipped entirely with a “Skip” link • No account creation, no email collection, no sign-up form | P0 |
| ONBOARD-002 | Contextual tool tips during first coloring session | • First brush stroke: tooltip explaining brush size slider appears briefly (3s) • First color selection: tooltip explaining custom picker (“Tap + for more colors”) if Explorer/Creator tier • First completed page: animation plays with overlay text (“You did it! Tap to save”) • Tips dismiss on tap and do not repeat after first session • No mandatory tutorials blocking the coloring experience | P1 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| SCAN-001 | Scan paper drawing via camera and import as editable coloring page | • Camera capture with auto-crop and perspective correction • Converts photo to clean line art with adjustable threshold • Imported page saved to gallery as editable coloring page • Works offline after initial scan (no server-side processing) • Camera permission requested only on first use with kid-friendly explanation • Parental gate required before camera access | P2 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| FAMILY-001 | Pass-and-play mode: two players take turns coloring the same page on a single device | • “Play Together” button on canvas toolbar starts pass-and-play session • Timer-based turns (30s/60s/90s configurable) with animated handoff screen • Each player selects a name/avatar before starting (no account required) • Turn indicator shows whose turn it is with player name and color • Finished artwork credits both players in gallery metadata • Works with 2–4 players; no network or additional devices required | P1 |


| Feature ID | Description | Acceptance Criteria | Priority |
| --- | --- | --- | --- |
| EXPORT-001 | Print-ready PDF export with decorative frame and child’s name | • “Print My Art” button in gallery generates an 8.5×11 PDF • PDF includes artwork centered with decorative frame border • Child’s name (entered once, stored locally) and date printed below artwork • 5 frame styles to choose from (classic, nature, stars, rainbow, minimal) • PDF shared via iOS share sheet (AirPrint, email, save to Files) • Renders at 300 DPI for high-quality prints • Parental gate required before share action | P1 |


| Feature | Rationale for Deferral |
| --- | --- |
| Social features / UGC | COPPA compliance for social features is a legal minefield. The Recolor FTC settlement ($3M) happened because of social sharing features. Defer to v2+ after legal framework is established. |
| Android | iOS first. Parent demographic that pays for kids’ apps skews heavily iOS. Ship Android after validating product-market fit. |
| AI-generated art tools (user-facing) | User-facing AI generation tools (e.g., “draw me a dragon”) deferred. AI-assisted illustration pipeline used internally for content creation, but not exposed as a child-facing feature in v1. |
| Real-time multiplayer | Pass-and-play on a single device promoted to P1 for v1 (see section 3.12). Real-time cross-device sync deferred—requires backend infrastructure not needed yet. |
| Scan & import paper drawings | Promoted to P2 (fast-follow). See new section 3.11. Target v1.1 ship within 60 days post-launch. |
| Family gallery (cross-device) | Requires account system and cloud sync. Ship after user base validates demand. |
| AR mode | ARKit integration adds QA surface area disproportionate to user value at launch. |
| Calming / mindfulness mode | Validated therapeutic positioning, but requires specialized content design. V2 feature. |


| Metric | Target (90-Day) | Rationale |
| --- | --- | --- |
| App Store Rating | ≥ 4.5 stars after 500+ reviews | Quality bar. Below 4.3 signals product-market issues; above 4.5 drives organic discovery. |
| Day 1 Retention | ≥ 50% | Children must find the app engaging enough to return the next day. Competitor baseline is ~40%. |
| Day 7 Retention | ≥ 25% | Validates content depth. If children exhaust interesting content in <7 days, library needs expansion. |
| Free-to-Paid Conversion | ≥ 12% | Conservative target based on $14.99 price point. 15% is stretch goal per strategy revenue model. |
| Crash-Free Rate | ≥ 99.5% | Crayola’s crash issues are their #2 complaint. Stability is a competitive advantage. |
| App Store Search Ranking | Top 20 for “coloring app kids” | Organic discovery depends on ASO. Target top 20 within 60 days of launch. |
| Content Pack Attach Rate | ≥ 20% of paid users buy 1 pack within 90 days | Validates long-tail revenue model. Below 15% suggests pack themes or pricing need adjustment. |
| 90-Day Gross Revenue | ≥ $60K gross (≈15K downloads × 12% conversion × $14.99 + packs) | Derived from strategy’s Year 1 target of $243K gross. Back-to-school launch window should drive strong initial downloads. Tracks toward $243K annual run rate. |


| Risk | Severity | Mitigation | Owner / Timeline |
| --- | --- | --- | --- |
| Brush engine doesn’t feel “good enough” | High | Prototype 4 brush types first and user-test with 5–8 year olds before building anything else. This is the core technical risk. | Weeks 1–3 |
| 200 illustrations not ready by August | High | Commission illustrator immediately. Start with 10 sample pages per tier. Outsource to 2–3 illustrators in parallel if single illustrator can’t meet pace. | Ongoing |
| Apple Kids Category rejection | Medium | Pre-read Apple’s 2025 Kids Category guidelines. Engage COPPA attorney by April. Submit test build to App Review 4 weeks before target launch. | April–May |
| $14.99 price is too high for conversion | Medium | Run landing page pricing test in April. If intent drops below 10% at $14.99, test $9.99. Content pack pricing provides downside flexibility. | April |
| Low organic discovery at launch | Medium | Pre-build parent community (waitlist, beta testers from Facebook groups). Prepare ASO strategy. Pitch App Store editorial team 4 weeks before launch. | May–June |
| Performance issues on older devices | Low | iPhone SE 2nd gen is the baseline test device throughout development. Performance tests run in CI on every PR. | Engineering; ongoing |


| Milestone | Target Date | Deliverables |
| --- | --- | --- |
| M1 | Late July 2026 | Brush engine prototype: 4 brush types (crayon, marker, watercolor, pencil) on Metal rendering pipeline. User-test with 5 children ages 5–8. Commission illustrator; first 30 sample pages (10 per tier). Scaffold full project structure with Claude Code. |
| M2 | Late May 2026 | Canvas feature-complete: all 8 brushes, fill bucket, undo/redo, zoom/pan. Color palette system. Landing page pricing test live in parent communities. COPPA legal review initiated. |
| M3 | Late June 2026 | Content library loaded: 200+ pages across 3 tiers. Gallery and save/share functional. Animation-on-completion system with 50 templates. Age-tier onboarding flow. Pass-and-play mode prototype. |
| M4 | Late May 2026 | IAP integration: free tier gating, $14.99 unlock, restore purchases. Parental gate. Audio system. Pass-and-play family mode. Performance optimization pass (iPhone SE 2nd gen baseline). COPPA legal review complete. App Store listing copy drafted (subtitle: “Color & Learn • Ages 3–12”). |
| M5 | August 2026 | Beta testing with 20–50 parent testers. Bug fixes and polish. App Store listing (screenshots, description, ASO, subtitle: “Color & Learn • Ages 3–12”). Art Comes Home PDF export. Submit to App Review. Pitch editorial team for feature consideration. |
| LAUNCH | Early September 2026 | Public release targeting Q3 2026 back-to-school window. Day 1 monitoring: crash rate, conversion, retention. Content pack pipeline begins (first pack ships November 2026). |


| Feature ID | Description | Area | Priority |
| --- | --- | --- | --- |
| BRUSH-001 | Freehand painting with pressure sensitivity | Canvas | P0 |
| BRUSH-002 | Fill-bucket tool | Canvas | P0 |
| BRUSH-003 | 8 brush types | Canvas | P0 |
| BRUSH-004 | Brush size adjustment | Canvas | P0 |
| BRUSH-005 | Undo/redo (10+ levels) | Canvas | P0 |
| COLOR-001 | 24-color default palette | Palette | P0 |
| CONTENT-001 | 200+ pages across 3 age tiers | Content | P0 |
| CONTENT-002 | Age-tier selection and adaptive UI | Content | P0 |
| CONTENT-003 | Themed content categories | Content | P0 |
| ANIM-001 | Manual "Done" button + celebration animation | Animation | P0 |
| ANIM-002 | 50–100 animation templates | Animation | P0 |
| GALLERY-001 | In-app gallery grid | Gallery | P0 |
| GALLERY-002 | Save to camera roll + share sheet | Gallery | P0 |
| GALLERY-003 | Resume in-progress artwork | Gallery | P0 |
| IAP-001 | Free tier (50 pages, full tools) | IAP | P0 |
| IAP-002 | Full Unlock $14.99 one-time IAP | IAP | P0 |
| AUDIO-001 | Global mute toggle | Audio | P0 |
| OFFLINE-001 | Full offline functionality | Infra | P0 |
| PERF-001 | App size <200MB, launch <3s | Infra | P0 |
| PERF-002 | 60fps canvas rendering | Infra | P0 |
| SAFETY-001 | Zero ads, zero tracking, COPPA | Safety | P0 |
| SAFETY-002 | Parental gate | Safety | P0 |
| SAFETY-003 | Apple Kids category compliance | Safety | P0 |
| ONBOARD-001 | 3-screen onboarding flow | UX | P0 |
| COLOR-002 | Custom color picker (Explorer/Creator) | Palette | P1 |
| ANIM-003 | Celebration sound effects | Animation | P1 |
| IAP-003 | Content pack infrastructure | IAP | P1 |
| AUDIO-002 | Context sound effects | Audio | P1 |
| AUDIO-003 | Ambient background music | Audio | P1 |
| ONBOARD-002 | Contextual tool tips | UX | P1 |
| FAMILY-001 | Pass-and-play family mode | Family | P1 |
| EXPORT-001 | Art Comes Home PDF export | Export | P1 |
| SCAN-001 | Scan & import paper drawings | Scan | P2 |

