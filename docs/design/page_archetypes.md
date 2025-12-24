# Page Structure Archetypes

> **Design Contract — Frozen**
>
> This document defines the finite set of page layout archetypes for Vitalo.
> Feature screens must select an archetype. Inventing structure is forbidden.
> Changes require architectural review.

---

## Overview

Vitalo uses exactly **eight** page archetypes. Each archetype solves a distinct UX problem. Screens must match intent to archetype — not appearance to preference.

| Archetype            | Primary Intent                                 |
| -------------------- | ---------------------------------------------- |
| Centered Focus       | Single-task completion with full attention     |
| Flow Form            | Sequential multi-step data entry               |
| Stage / Landing      | Orientation, identity, navigation anchor       |
| Content Feed         | Browsing, scanning, consuming lists            |
| Detail / Drill-Down  | Inspecting or editing a single entity          |
| Utility / Modal-Like | Transient decision or system message           |
| Hub                  | Dense, scrollable, section-driven anchors      |
| Sheet                | Modal bottom-sheet for transient child content |

---

## 1. Centered Focus Page

### Intent

Capture complete user attention for a single, focused task. The user should feel guided, not overwhelmed. Completion is the only goal.

### Typical Use Cases

- OTP verification
- Email sign-in
- Password reset
- Single-question prompts
- Biometric setup confirmation

### Vertical Alignment Rule

Content is **vertically centered** within the safe area viewport.

The content block floats in the visual center of the screen. It does not anchor to the top or bottom. If the keyboard appears, the content shifts upward to remain visible — but still feels centered relative to remaining space.

### Width Constraint Rule

Content is **horizontally constrained** to a maximum width (e.g., 400pt on larger screens).

On narrow devices, content uses horizontal page padding. On wide devices, content does not stretch — it remains centered within its constraint.

### Scroll Behavior Rule

**No scroll by default.**

Content must fit within the viewport at all times. If the keyboard appears, the scaffold may shift content upward, but the page itself does not scroll.

Exception: If an inline error message or accessibility font scaling causes overflow, the page may scroll — but this is a fallback, not a design choice.

### Spacing Philosophy

- Generous vertical spacing between sections (icon → title → subtitle → input → button)
- Visual breathing room reinforces focus
- No dense stacking; every element is intentional
- Rhythm: hero icon → heading → supporting text → primary input → primary action

### What This Page Must NOT Do

- Anchor content to the top of the screen
- Allow horizontal scrolling
- Display secondary navigation or unrelated actions
- Contain lists, feeds, or browsable content
- Include bottom navigation or persistent chrome beyond the app bar

---

## 2. Flow Form Page

### Intent

Guide the user through a multi-step process where each step builds on the previous. Progress should feel linear and completable.

### Typical Use Cases

- Multi-step onboarding
- Profile setup wizard
- Long forms broken into sections
- Checkout or booking flows

### Vertical Alignment Rule

Content is **top-aligned** within the viewport, with consistent top padding.

The form starts at a predictable vertical position. As the user progresses, content flows downward naturally. This is not centered — it is reading-order aligned.

### Width Constraint Rule

Content is **horizontally constrained** to a maximum width (e.g., 400–480pt).

Form fields and buttons do not stretch to screen edges on wide devices. Constraint improves scanability and reduces eye travel.

### Scroll Behavior Rule

**Scroll is expected.**

Long forms will exceed the viewport. The page scrolls vertically with platform-appropriate physics. Keyboard appearance should scroll the active field into view.

### Spacing Philosophy

- Consistent spacing between form fields (e.g., `md` gap)
- Section breaks use larger spacing (e.g., `xl` gap)
- Progress indicators (if present) are visually separated from content
- Primary action button may be inline or sticky depending on form length

### What This Page Must NOT Do

- Center content vertically
- Require horizontal scrolling
- Display unrelated navigation or feeds
- Mix form entry with browsable content
- Allow skipping steps without explicit design intent

---

## 3. Stage / Landing Page

### Intent

Establish identity, orient the user, and provide clear navigation anchors. This is the "lobby" of the experience — not a destination, but a departure point.

### Typical Use Cases

- App entry / welcome screen
- Home screen (post-login anchor)
- Marketing-style introduction pages
- Feature gate pages ("Upgrade to unlock")

### Vertical Alignment Rule

**Split layout**: top section is flexible (brand/hero), bottom section is anchored (actions).

The top section (brand hook, mascot, tagline) expands to fill available space and is vertically centered within its region. The bottom section (CTAs, navigation) is pinned to the bottom of the safe area.

### Width Constraint Rule

**Full width** for structural regions, but **constrained content** within regions.

The page itself uses full width. Hero imagery may bleed to edges. Text and buttons within sections are horizontally constrained for readability.

### Scroll Behavior Rule

**No scroll by default.**

Stage pages are designed to fit the viewport. Content is minimal and impactful. If accessibility scaling causes overflow, the page may scroll — but this is a fallback.

### Spacing Philosophy

- Generous whitespace to create visual impact
- Brand elements (logo, mascot) are prominently sized
- CTAs are visually separated from brand content
- Hierarchy: brand moment → value proposition → primary action → secondary actions

### What This Page Must NOT Do

- Display dense content or lists
- Allow horizontal scrolling
- Include inline forms (navigate to form pages instead)
- Compete for attention with multiple equal-weight actions
- Feel like a "settings" or "detail" page

---

## 4. Content Feed Page

### Intent

Enable browsing, scanning, and consuming a list of items. The user is exploring, not completing a task.

### Typical Use Cases

- Insights feed
- Activity history
- Log entries
- Search results
- Notification list

### Vertical Alignment Rule

Content is **top-aligned** and flows downward.

The first item appears at a consistent vertical position below any header. Items stack vertically in a predictable rhythm.

### Width Constraint Rule

**Full width** for list items, with **horizontal page padding**.

List items use the full available width (minus page margins). This maximizes content density and touch target size. Cards or tiles may have internal padding.

### Scroll Behavior Rule

**Scroll is required.**

Feeds are inherently longer than the viewport. Vertical scrolling with platform-appropriate physics is mandatory. Pull-to-refresh may be present.

### Spacing Philosophy

- Consistent vertical gap between list items (e.g., `sm` or `md`)
- List items have internal padding for touch targets
- Section headers (if present) use larger top margin
- Empty states are vertically centered within the available space

### What This Page Must NOT Do

- Center content vertically (except empty states)
- Constrain list width on narrow devices
- Mix feed content with unrelated forms or wizards
- Use horizontal scrolling for primary content
- Display single-item detail inline (navigate to detail pages instead)

---

## 5. Detail / Drill-Down Page

### Intent

Inspect, view, or edit a single entity in depth. The user has navigated here intentionally and expects comprehensive information.

### Typical Use Cases

- Profile subsection or editor (e.g., Edit Profile Details, Edit Personal Info)
- Settings detail (e.g., notification preferences)
- Item detail (e.g., a specific log entry)
- Entity editor (e.g., edit profile)

### Vertical Alignment Rule

Content is **top-aligned** and flows downward.

The page begins with identifying information (title, avatar, summary) and proceeds to detail sections. This is reading-order layout.

### Width Constraint Rule

**Full width** for structural sections, with **horizontal page padding**.

Detail pages use full width to accommodate varied content (text, images, grouped settings). Content respects page margins but does not artificially constrain width.

### Scroll Behavior Rule

**Scroll is expected.**

Detail pages often exceed the viewport. Vertical scrolling is standard. Sticky headers or section navigation may be used for long pages.

### Spacing Philosophy

- Clear visual separation between sections (e.g., dividers or large gaps)
- Related items are grouped tightly
- Action buttons (edit, delete) are contextually placed, not always bottom-anchored
- Hierarchy: identity → primary details → secondary details → actions

### What This Page Must NOT Do

- Center content vertically
- Display unrelated lists or feeds
- Mix multiple unrelated entities
- Use horizontal scrolling for primary content
- Feel like a form wizard (use Flow Form for multi-step edits)

---

## 6. Utility / Modal-Like Page

### Intent

Present a transient decision, confirmation, or system message. The user should resolve this quickly and return to their flow.

### Typical Use Cases

- Permission requests
- Destructive action confirmations
- Error recovery pages
- Empty states with recovery actions
- Success confirmations

### Vertical Alignment Rule

Content is **vertically centered** within the viewport.

The message and actions float in the center of the screen. This reinforces that the page is transient, not a destination.

### Width Constraint Rule

Content is **horizontally constrained** to a maximum width (e.g., 320–400pt).

Utility pages are compact. They do not stretch to fill the screen. Constraint focuses attention on the message and decision.

### Scroll Behavior Rule

**No scroll.**

Utility pages must fit within the viewport. If they don't, the content is too complex for this archetype — use a different page type.

### Spacing Philosophy

- Minimal content: icon + message + actions
- Generous spacing around the content block
- Actions are clearly separated from the message
- Hierarchy: feedback icon → title → body → primary action → secondary action (optional)

### What This Page Must NOT Do

- Display forms or inputs (except single confirmation fields)
- Anchor content to the top or bottom
- Include navigation or unrelated actions
- Scroll
- Feel like a destination page

---

## 7. Hub Page

> **@frozen** — This archetype is architecturally frozen. Changes require review.

### Intent

Present a dense, scrollable, section-driven screen that serves as a navigation anchor. The user has arrived at a hub where they can view, configure, or manage multiple distinct concerns within a single reading flow.

HubPage exists because StagePage is unsuitable for screens with:

- Multiple independent content sections
- Content that exceeds the viewport height
- Dense information requiring vertical scroll
- Settings, preferences, or configuration groups

StagePage is for brand moments and orientation. HubPage is for control and comprehension.

### Typical Use Cases

- Profile screen
- Settings hub
- Account management
- Health overview dashboard
- Preference editors
- Configuration screens

### Structural Characteristics

- **Scrollable vertical layout**: Content may exceed viewport; vertical scroll is guaranteed.
- **Section-driven reading flow**: Multiple independent sections stacked vertically.
- **Dense content allowed**: Unlike StagePage, HubPage accommodates lists, forms, toggles, and grouped settings.
- **No hero/action split**: Content flows continuously from top; no anchored bottom region.
- **Prominent navigation title**: The title may adapt with scroll to maximize content area.
- **Responsive width policy**: On wide screens, content may be constrained for readability; on narrow screens, content flows naturally without artificial constraints.

### Ownership Rules (Non-Negotiable)

HubPage OWNS:

- Scaffold instantiation (feature code must not use scaffolds)
- Scroll behavior (feature code must not use scroll views)
- Safe area handling (feature code must not use safe area wrappers)
- Horizontal padding via the canonical page body wrapper
- Navigation chrome (title and back navigation intent)
- Keyboard inset handling

These concerns terminate at HubPage. Feature code declares content only.

### Forbidden Usage

Feature screens using HubPage MUST NOT:

- Instantiate scaffolds or page-level wrappers
- Use padding widgets for page margins
- Use safe area wrappers
- Use scroll views or scroll controllers
- Branch on platform for layout decisions
- Apply visual styling (colors, typography, radii)
- Pass layout configuration parameters

Violations are architectural bugs, not style preferences.

### What This Page Must NOT Do

- Center content vertically (content is top-aligned and flows down)
- Use hero/action split layout (that is StagePage)
- Display minimal, impactful content (that is StagePage)
- Constrain width artificially on narrow screens
- Expose scroll position or scroll events to feature code
- Allow feature code to customize chrome appearance

### Comparison: StagePage vs HubPage

| Concern         | StagePage                       | HubPage                              |
| --------------- | ------------------------------- | ------------------------------------ |
| **Use Case**    | Landing, Home, brand moments    | Profile, Settings, Account           |
| **Scroll**      | ❌ No (content fits viewport)   | ✅ Yes (content may exceed)          |
| **Layout**      | Split: Hero top, Actions bottom | Continuous vertical flow             |
| **Density**     | Minimal, impactful              | Dense, comprehensive                 |
| **Chrome**      | Optional, minimal               | Required, prominent navigation title |
| **Primary Job** | Orient and navigate             | View, configure, manage              |

These archetypes are mutually exclusive. Using StagePage for a settings screen or HubPage for a landing screen is an architectural violation.

---

## Implementation Contract — HubPage

This section defines the implementation expectations for HubPage. This is a contract, not a tutorial.

### File Location

```
lib/design/adaptive/pages/hub_page.dart
```

### Public API Expectations

HubPage exposes a minimal, semantic-only constructor.

**Accepts:**

- `title` — The semantic title for navigation chrome (required)
- `content` — The feature-provided content subtree (required)
- `leadingAction` — Semantic navigation intent: back, close, or none (required)
- `trailingActions` — Optional bounded list of semantic trailing actions

**Does NOT accept:**

- Padding values or padding enums
- Scroll flags or scroll controllers
- Colors, typography, or styling parameters
- Platform hints or branching flags
- Chrome customization beyond semantic intent
- Width constraints or breakpoint overrides

If a parameter does not express semantic intent, it does not belong in the API.

### Internal Responsibilities

HubPage internally:

- Instantiates the canonical scaffold with prominent navigation title support
- Wraps content in the canonical page body wrapper for horizontal padding
- Provides vertical scrolling with platform-appropriate physics
- Applies safe area handling for all edges
- Handles keyboard insets to keep focused inputs visible
- Applies canonical width constraints on wide screens

These are implementation concerns. Feature code is shielded from them.

### Usage Rules

1. Profile, Settings, Account, and similar dense screens MUST use HubPage.
2. StagePage MUST NOT be used for scrollable or section-driven content.
3. If a screen does not fit StagePage or HubPage, a new archetype must be created — not an escape hatch.
4. Feature screens return pure content declarations; HubPage owns structure.
5. HubPage and StagePage are mutually exclusive. A screen cannot use both.

### Migration Guidance

When migrating an existing screen to HubPage:

1. Migrate the parent page structure first (replace scaffold with HubPage).
2. Keep inner widgets temporarily unchanged, even if they contain legacy patterns.
3. Do not refactor child widgets during archetype migration.
4. Validate that the screen renders correctly with HubPage owning structure.
5. Refactor child widgets in a subsequent, separate pass.

This staged approach reduces risk and isolates architectural changes from content changes.

---

HubPage is a frozen page archetype. Escape hatches are forbidden. Changes require architectural review.

---

## 8. Sheet Page

> **@frozen** — This archetype is architecturally frozen. Changes require review.

### Intent

Provide a canonical modal bottom-sheet layout that owns all sheet-level structure and behavior. Feature code provides pure content; SheetPage owns the container.

### Typical Use Cases

- Inline editing modals (e.g., edit name)
- Confirmations triggered from a list item
- Picker sheets (date, option selection)
- Quick action sheets
- Any transient UI that does not need full-page navigation

### Structural Characteristics

- **Modal presentation**: Always shown via `AppBottomSheet.show`.
- **Elevated surface**: Uses `surfaceElevated` semantic color for visual lift.
- **Rounded top corners**: Uses `AppShapeTokens.of.lg` for sheet radius.
- **Safe area handling**: Bottom safe area applied; top ignored (sheet does not touch status bar).
- **Keyboard inset handling**: Reads `MediaQuery.viewInsetsOf(context).bottom` and applies as bottom padding.
- **Canonical padding**: Consistent internal padding via spacing tokens.

### Ownership Rules (Non-Negotiable)

SheetPage OWNS:

- SafeArea (bottom only)
- Keyboard inset handling
- Canonical sheet padding
- Surface/background styling

Feature code provides only the `child` content.

### Forbidden Behavior

SheetPage MUST NOT:

- Fetch or mutate business data
- Perform navigation
- Show snackbars, toasts, or dialogs
- Branch on platform
- Expose styling or layout configuration
- Accept padding, color, or shape parameters

If a parameter does not express semantic intent, it does not belong in the API.

### Public API Expectations

```dart
class SheetPage extends StatelessWidget {
  const SheetPage({
    super.key,
    required this.child,
  });

  final Widget child;
}
```

No additional parameters. If something is missing, it belongs in another archetype.

### File Location

```
lib/design/adaptive/pages/sheet_page.dart
```

### Usage Pattern

```dart
AppBottomSheet.show(
  context,
  child: SheetPage(
    child: MySheetContent(),
  ),
);
```

SheetPage treats `child` as pure content — it knows nothing about what is rendered inside.

### Comparison: SheetPage vs Utility / Modal-Like

| Concern          | Utility / Modal-Like     | SheetPage                    |
| ---------------- | ------------------------ | ---------------------------- |
| **Presentation** | Full-page (pushed route) | Modal overlay (bottom sheet) |
| **Layout**       | Centered in viewport     | Anchored to bottom edge      |
| **Dismissal**    | Navigator.pop            | Navigator.pop or swipe down  |
| **Use Case**     | System messages, errors  | Inline edits, quick actions  |

---

## Archetype Selection Guide

When designing a new screen, ask:

1. **Is the user completing a single focused task?** → Centered Focus
2. **Is the user stepping through a multi-part process?** → Flow Form
3. **Is this a navigation anchor or brand moment?** → Stage / Landing
4. **Is the user browsing a list of items?** → Content Feed
5. **Is the user inspecting a single entity in detail?** → Detail / Drill-Down
6. **Is this a transient confirmation or system message?** → Utility / Modal-Like
7. **Is this a dense, scrollable hub for settings or profile?** → Hub
8. **Is this a transient modal action triggered inline?** → Sheet

If a screen seems to require two archetypes, **split it into two screens** or reconsider the UX.

---

## Anti-Patterns (Forbidden)

| Anti-Pattern                     | Why It Fails                                       |
| -------------------------------- | -------------------------------------------------- |
| "Centered but scrolls"           | Ambiguous intent; likely a misclassified Flow Form |
| "Feed with inline forms"         | Mixing browse and edit; navigate to separate page  |
| "Detail page with list feed"     | Two intents; split into master/detail navigation   |
| "Landing page with settings"     | Conflated identity and utility; separate concerns  |
| "Utility page with many options" | Too complex; promote to Detail or Flow Form        |
| "Stage page that scrolls"        | Wrong archetype; use HubPage for scrollable hubs   |
| "Hub page with hero layout"      | Wrong archetype; use StagePage for brand moments   |

---

## Enforcement

Feature screens must declare their archetype via the chosen page wrapper.

Architecture checks may validate:

- Centered Focus pages do not contain scrollable lists
- Flow Form pages do not center content vertically
- Stage pages do not contain form fields
- Stage pages do not scroll
- Hub pages do not use hero/action split layout
- Content Feed pages do not center content (except empty states)
- Utility pages do not scroll

Violations require architectural review.

---

## Changelog

| Date       | Change                                    |
| ---------- | ----------------------------------------- |
| 2024-12-24 | Added SheetPage archetype (8th archetype) |
| 2024-12-24 | Added HubPage archetype (7th archetype)   |
| 2024-12-23 | Initial definition of 6 page archetypes   |
