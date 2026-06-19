---
name: qa
description: Run a QA review of recently completed PaperBrush work. Checks functional correctness, integration, UI/UX, and code quality — then fixes any issues found before handing off to the developer. Invoke after completing any feature, screen, component, or bug fix.
---

# PaperBrush QA Review

Run a self-directed QA review and remediation loop on the most recently completed work. The process is recursive: find issues, fix them, re-check, repeat until the checklist passes clean. Only then report to the developer.

## Step 1 — Build

Run `xcodebuild` to confirm the project compiles with zero errors before evaluating anything else.

```bash
xcodebuild -project "PaperBrush/PaperBrush.xcodeproj" \
  -scheme PaperBrush \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  build 2>&1 | grep -E "error:|warning:|BUILD"
```

If there are **errors**: fix them first. Do not proceed until the build is clean.
If there are **warnings**: note them. Fix any that relate to the work under review.

## Step 2 — Run the QA Checklist

Evaluate the completed work against each item below. For each item, make a finding: **Pass**, **Fail** (with a specific description), or **N/A** (with a reason).

### Functional Correctness
- Does the feature fulfill its PRD objective, including edge cases?
- Are there unhandled states, nil/optional values, or boundary conditions that could cause crashes or incorrect behavior?
- Does any async work have proper error handling (`do/catch`, not `try!`)?
- Are all feature-ID comments present (e.g., `// BRUSH-001: ...`) per the naming convention?

### Integration
- Does this change conflict with adjacent features, screens, or components?
- Are all references to shared state (`UserPreferences`, `AppRouter`, `PersistenceManager`, etc.) consistent with the rest of the codebase?
- Are values that should be dynamic actually dynamic (no hardcoded IDs, strings, or magic numbers)?
- Does navigation follow the `Route` enum and `AppRouter` patterns from `docs/navigation_architecture.md`?

### UI / UX
- Do all interactive elements respond correctly and have `.accessibilityLabel()` set?
- Are loading, error, and empty states all accounted for?
- Does the UI behave correctly at both iPhone and iPad sizes?
- Are all colors, fonts, and spacing pulled from `PBTokens` — nothing hardcoded?
- Do all touch targets meet the 44×44pt minimum?
- Does Dynamic Type work at large accessibility sizes without truncation or overlap?
- If the age tier affects this UI: does it behave correctly for all three tiers (Doodler / Explorer / Creator)?

### Code Quality
- Are there any Swift compiler warnings introduced by this work?
- Is anything left partially implemented — TODOs, stubs, placeholder logic, `fatalError`?
- Were any files modified unintentionally (check `git diff --name-only`)?
- Does the implementation follow MVVM: logic in ViewModel (`@MainActor final class`), not in the View?
- No Combine, no completion handlers, no `@Observable` macro, no third-party imports?
- No force-unwraps (`!`) or `try!`?

### Audio / Mute
- If the feature plays audio: does it respect `UserPreferences.shared.isMuted`?
- Is `AVAudioSession` configured correctly for the context?

### Parental Gate
- If the feature involves sharing, purchasing, deleting, or accessing Settings: is it gated via `AppRouter.requireParentalGate`?

### Persistence
- If the feature reads/writes data: does it use the correct store (Core Data for artworks, UserDefaults via `UserPreferences` for settings, file system for canvas binary data)?
- Are auto-save (every 30s) and background-save behaviors unaffected?

## Step 3 — Fix All Failures

For each **Fail** finding:
1. Fix the issue in the relevant file(s).
2. Re-run `xcodebuild` after fixes to confirm the build stays clean.
3. Re-evaluate that checklist item to confirm it now passes.

Do not surface partial results. Do not ask the developer questions mid-review. Resolve everything that can be resolved with available information.

## Step 4 — Repeat Until Clean

Run the full checklist again after fixes. If new failures surface, fix those too. Repeat until a full pass produces zero failures.

## Step 5 — Handoff

Once the checklist passes cleanly with no failures, output exactly this:

> **QA complete — ready for you to test.**

If there are known limitations that require a product decision (not a code fix), list only those items — briefly, one line each — after the handoff line. Do not describe the QA process or what was checked. The developer only sees the result.
