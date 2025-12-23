# Page Structure Archetypes

> **Design Contract — Frozen**
>
> This document defines the finite set of page layout archetypes for Vitalo.
> Feature screens must select an archetype. Inventing structure is forbidden.
> Changes require architectural review.

---

## Overview

Vitalo uses exactly **six** page archetypes. Each archetype solves a distinct UX problem. Screens must match intent to archetype — not appearance to preference.

| Archetype            | Primary Intent                             |
| -------------------- | ------------------------------------------ |
| Centered Focus       | Single-task completion with full attention |
| Flow Form            | Sequential multi-step data entry           |
| Stage / Landing      | Orientation, identity, navigation anchor   |
| Content Feed         | Browsing, scanning, consuming lists        |
| Detail / Drill-Down  | Inspecting or editing a single entity      |
| Utility / Modal-Like | Transient decision or system message       |

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

- Profile screen
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

## Archetype Selection Guide

When designing a new screen, ask:

1. **Is the user completing a single focused task?** → Centered Focus
2. **Is the user stepping through a multi-part process?** → Flow Form
3. **Is this a navigation anchor or brand moment?** → Stage / Landing
4. **Is the user browsing a list of items?** → Content Feed
5. **Is the user inspecting a single entity in detail?** → Detail / Drill-Down
6. **Is this a transient confirmation or system message?** → Utility / Modal-Like

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

---

## Enforcement

Feature screens must declare their archetype via the chosen page wrapper.

Architecture checks may validate:

- Centered Focus pages do not contain scrollable lists
- Flow Form pages do not center content vertically
- Stage pages do not contain form fields
- Content Feed pages do not center content (except empty states)
- Utility pages do not scroll

Violations require architectural review.

---

## Changelog

| Date       | Change                                  |
| ---------- | --------------------------------------- |
| 2024-12-23 | Initial definition of 6 page archetypes |
