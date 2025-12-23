# Icon Semantics & Metaphor Contract

**Version:** 1.0  
**Status:** Frozen  
**Effective Date:** 2024-12-19  
**Last Review:** —  
**Parent Documents:** Interaction Design Contract, Color Semantics Contract, Platform Color Interpretation Guidelines

---

## 1. Purpose & Scope

### Governs

- Semantic icon identifiers and their meanings
- Icon usage rules and restrictions
- Label and text accompaniment requirements
- Platform-specific visual interpretation guidance

### Does Not Cover

- Icon sizing (governed by spacing and typography systems)
- Icon coloring (governed by color semantics)
- Specific glyph designs or artwork
- Animation or motion behavior

### Foundational Principle

Icons are semantic identifiers, not visual assets. The brand defines what an icon _means_. Platforms define how that meaning is _rendered_.

All icon usage MUST go through a semantic mapping layer. Direct reference to platform icon sets is forbidden.

---

## 2. Icon Philosophy

### Meaning First

Icons communicate meaning before style. A user should understand an icon's purpose without knowing its visual form.

**Semantic stability:** The meaning of an icon identifier never changes. `icon.navigation.back` always means "return to previous context" regardless of how it is drawn.

**Visual flexibility:** The same semantic icon may render differently across platforms, themes, or brand evolutions without breaking meaning.

### Brand Consistency

Icons express brand personality through consistent metaphor choices.

This brand's icon voice is:

- **Friendly and approachable** — Icons should feel warm, not clinical
- **Clear and confident** — Meaning should be immediate and unambiguous
- **Calm and supportive** — Icons guide, they don't demand
- **Optimistic and encouraging** — Icons should feel positive

### What We Reject

- Overly complex or detailed icons that don't scale
- Aggressive or harsh iconography
- Ambiguous metaphors that require learning
- Platform-specific idioms that confuse cross-platform users

### What We Embrace

- Universal metaphors understood across cultures
- Simple, recognizable shapes
- Consistent metaphor families
- Icons that support rather than replace text

---

## 3. Icon Vocabulary: Navigation

Navigation icons guide users through the app's structure.

---

### nav.back

**Meaning:** Return to the previous screen or context.

**Usage:**

- Navigation bar back buttons
- Modal dismissal (back to origin)
- Wizard/flow step regression

**NOT for:**

- Closing without navigation (use `action.close`)
- Undo operations (use `action.undo`)
- Canceling destructive actions

---

### nav.forward

**Meaning:** Proceed to the next screen or context.

**Usage:**

- Wizard/flow step progression
- Disclosure to detail view
- "See more" navigation

**NOT for:**

- Submit or confirm actions (use `action.confirm`)
- External links (use `nav.external`)

---

### nav.home

**Meaning:** Return to the app's primary/root screen.

**Usage:**

- Tab bar home destination
- Deep navigation escape hatch
- Logo-as-home-button contexts

**NOT for:**

- General "start over" (context-dependent)
- Any non-home overview screen (if it's not the home screen)

---

### nav.menu

**Meaning:** Open the primary navigation menu or drawer.

**Usage:**

- Hamburger menu trigger
- Navigation drawer toggle
- Slide-out menu access

**NOT for:**

- Context menus (use `action.more`)
- Settings access (use `nav.settings`)

---

### nav.settings

**Meaning:** Access app or account settings.

**Usage:**

- Settings screen navigation
- Preferences access
- Configuration entry point

**NOT for:**

- In-context adjustments (use `action.edit`)
- Filter controls (use `action.filter`)

---

### nav.profile

**Meaning:** Access user profile or account.

**Usage:**

- Profile screen navigation
- Account management entry
- User identity display

**NOT for:**

- Team/other user profiles (context-specific)
- Settings (use `nav.settings`)

---

### nav.search

**Meaning:** Access or activate search functionality.

**Usage:**

- Search screen navigation
- Search field activation
- Global search access

**NOT for:**

- Filter (use `action.filter`)
- Browse/explore without search intent

---

### nav.external

**Meaning:** Navigate outside the app (browser, external app).

**Usage:**

- Links to external websites
- Deep links to other apps
- "Open in browser" actions

**NOT for:**

- Internal navigation
- In-app webviews that feel native

---

## 4. Icon Vocabulary: Actions

Action icons represent operations users can perform.

---

### action.add

**Meaning:** Create or add a new item.

**Usage:**

- Floating action buttons for creation
- "Add to list" operations
- New item triggers

**NOT for:**

- Increment counters (use `action.increment`)
- Expansion (use `state.expanded`)

---

### action.remove

**Meaning:** Remove an item from a collection (non-destructive).

**Usage:**

- Remove from list or favorites
- Deselect from multi-select
- Unfollow or unsubscribe

**NOT for:**

- Permanent deletion (use `action.delete`)
- Closing views (use `action.close`)

---

### action.delete

**Meaning:** Permanently destroy an item (destructive).

**Usage:**

- Permanent deletion with confirmation
- Trash/destroy operations
- Irreversible removal

**NOT for:**

- Removable or reversible operations (use `action.remove`)
- Archiving (use `action.archive`)

---

### action.edit

**Meaning:** Enter edit mode or modify an item.

**Usage:**

- Edit button for content
- Profile modification
- Inline edit triggers

**NOT for:**

- Settings (use `nav.settings`)
- Preferences that aren't per-item

---

### action.save

**Meaning:** Persist current changes.

**Usage:**

- Save button after edits
- Draft saving
- Explicit save triggers

**NOT for:**

- Bookmarking (use `action.bookmark`)
- Favoriting (use `action.favorite`)

---

### action.confirm

**Meaning:** Confirm or submit an action.

**Usage:**

- Form submission
- Confirmation dialogs (positive action)
- Wizard completion

**NOT for:**

- Navigation forward (use `nav.forward`)
- Save without submission context

---

### action.cancel

**Meaning:** Abandon current operation without saving.

**Usage:**

- Cancel button in dialogs
- Abandon edit mode
- Exit without saving

**NOT for:**

- Navigation back (use `nav.back`)
- Closing modals (may use `action.close`)

---

### action.close

**Meaning:** Dismiss current overlay, modal, or panel.

**Usage:**

- Modal close button
- Sheet dismissal
- Overlay dismissal

**NOT for:**

- Navigation back (use `nav.back`)
- Cancel with explicit abandonment (use `action.cancel`)

---

### action.share

**Meaning:** Share content externally.

**Usage:**

- Share sheet trigger
- Social sharing
- Content distribution

**NOT for:**

- Internal sending (use `action.send`)
- Copying (use `action.copy`)

---

### action.send

**Meaning:** Send a message or content to a recipient.

**Usage:**

- Message send button
- Email composition send
- In-app content transfer

**NOT for:**

- External sharing (use `action.share`)
- Submission (use `action.confirm`)

---

### action.copy

**Meaning:** Copy content to clipboard.

**Usage:**

- Copy text button
- Duplicate content reference
- Clipboard operations

**NOT for:**

- Duplicate/clone item (use `action.duplicate`)

---

### action.duplicate

**Meaning:** Create a copy of an item.

**Usage:**

- Clone item in list
- Duplicate content
- Copy as new item

**NOT for:**

- Clipboard copy (use `action.copy`)

---

### action.undo

**Meaning:** Reverse the last action.

**Usage:**

- Undo snackbar/banner actions
- Edit history reversal
- Mistake correction

**NOT for:**

- Navigation back (use `nav.back`)
- Restoring deleted items (context-specific)

---

### action.redo

**Meaning:** Reapply a reversed action.

**Usage:**

- Redo after undo
- Edit history forward
- Restore reversed change

**NOT for:**

- Repeat/replay actions

---

### action.refresh

**Meaning:** Reload current content.

**Usage:**

- Pull-to-refresh indicator
- Manual refresh button
- Content reload

**NOT for:**

- Sync operations (use `action.sync`)
- State reset

---

### action.sync

**Meaning:** Synchronize with remote data.

**Usage:**

- Cloud sync indicator
- Data synchronization trigger
- Upload/download sync

**NOT for:**

- Simple refresh (use `action.refresh`)

---

### action.filter

**Meaning:** Access or apply filters to content.

**Usage:**

- Filter panel trigger
- Filter chip access
- Content narrowing

**NOT for:**

- Search (use `nav.search`)
- Sort (use `action.sort`)

---

### action.sort

**Meaning:** Change content ordering.

**Usage:**

- Sort menu trigger
- Order selection
- List reordering

**NOT for:**

- Filter (use `action.filter`)

---

### action.more

**Meaning:** Access additional actions or options.

**Usage:**

- Overflow menu trigger
- Context menu access
- "More options" button

**NOT for:**

- Navigation menu (use `nav.menu`)
- Expansion (use `state.expanded`)

---

### action.bookmark

**Meaning:** Save item for later access.

**Usage:**

- Bookmark toggle
- Save for later
- Reading list addition

**NOT for:**

- Favoriting with emotional intent (use `action.favorite`)

---

### action.favorite

**Meaning:** Mark item as liked or preferred.

**Usage:**

- Like/love toggle
- Favorite marking
- Preference indication

**NOT for:**

- Functional bookmarking (use `action.bookmark`)

---

### action.download

**Meaning:** Download content for offline access.

**Usage:**

- Download file
- Save for offline
- Content caching

**NOT for:**

- Sync (use `action.sync`)
- Import (context-specific)

---

### action.upload

**Meaning:** Upload content to remote.

**Usage:**

- File upload
- Photo upload
- Content submission

**NOT for:**

- Sync (use `action.sync`)
- Send (use `action.send`)

---

## 5. Icon Vocabulary: States

State icons represent current conditions or modes.

---

### state.expanded

**Meaning:** Content is expanded/open; can collapse.

**Usage:**

- Accordion expanded state
- Expandable section open
- Detail revealed

**NOT for:**

- Expansion action (toggle shows opposite)

---

### state.collapsed

**Meaning:** Content is collapsed/closed; can expand.

**Usage:**

- Accordion collapsed state
- Expandable section closed
- Detail hidden

**NOT for:**

- Collapse action (toggle shows opposite)

---

### state.visible

**Meaning:** Content is visible; can hide.

**Usage:**

- Password visibility on
- Hidden content revealed
- Show/hide toggle (visible state)

**NOT for:**

- Eye icon used decoratively

---

### state.hidden

**Meaning:** Content is hidden; can reveal.

**Usage:**

- Password visibility off
- Content obscured
- Show/hide toggle (hidden state)

**NOT for:**

- Security/privacy icons without toggle

---

### state.locked

**Meaning:** Item or feature is locked/restricted.

**Usage:**

- Premium feature lock
- Editing disabled
- Access restricted

**NOT for:**

- Security settings (use `nav.settings` with context)

---

### state.unlocked

**Meaning:** Item or feature is unlocked/accessible.

**Usage:**

- Feature unlocked indication
- Access granted
- Editing enabled

**NOT for:**

- General "open" concepts

---

### state.on

**Meaning:** Feature or setting is enabled.

**Usage:**

- Toggle switch on state
- Feature active indicator
- Enabled state

**NOT for:**

- Selected items (use `state.selected`)

---

### state.off

**Meaning:** Feature or setting is disabled.

**Usage:**

- Toggle switch off state
- Feature inactive indicator
- Disabled state

**NOT for:**

- Deselected items (use `state.deselected`)

---

### state.selected

**Meaning:** Item is currently selected.

**Usage:**

- Checkbox checked
- Multi-select item selected
- Choice indicator

**NOT for:**

- Toggle on/off (use `state.on`/`state.off`)

---

### state.deselected

**Meaning:** Item is not currently selected.

**Usage:**

- Checkbox unchecked
- Multi-select item unselected
- Available for selection

**NOT for:**

- Toggle off (use `state.off`)

---

### state.playing

**Meaning:** Media is currently playing.

**Usage:**

- Audio/video playing indicator
- Media player state
- Active playback

**NOT for:**

- Play action (use action-based naming)

---

### state.paused

**Meaning:** Media is currently paused.

**Usage:**

- Audio/video paused indicator
- Media player state
- Suspended playback

**NOT for:**

- Pause action (use action-based naming)

---

## 6. Icon Vocabulary: Feedback

Feedback icons communicate system status or response.

---

### feedback.success

**Meaning:** Operation completed successfully.

**Usage:**

- Success state indication
- Validation passed
- Action completed

**NOT for:**

- Celebration (use `feedback.celebration`)
- Generic positive (maintain semantic precision)

---

### feedback.warning

**Meaning:** Attention needed; non-critical issue.

**Usage:**

- Warning messages
- Caution indicators
- Recoverable issues

**NOT for:**

- Errors (use `feedback.error`)
- Info (use `feedback.info`)

---

### feedback.error

**Meaning:** Something failed; action needed.

**Usage:**

- Error state indication
- Validation failed
- Critical issues

**NOT for:**

- Warnings (use `feedback.warning`)
- Blocked features (use `state.locked`)

---

### feedback.info

**Meaning:** Neutral information available.

**Usage:**

- Informational tooltips
- Help triggers
- Contextual information

**NOT for:**

- Warnings (use `feedback.warning`)
- Help section navigation (use `nav` family)

---

### feedback.help

**Meaning:** Help or assistance available.

**Usage:**

- Help button
- Contextual assistance
- Support access

**NOT for:**

- Info that's not help-oriented (use `feedback.info`)

---

### feedback.loading

**Meaning:** Operation in progress; please wait.

**Usage:**

- Loading state indicator
- Processing indication
- Wait state

**NOT for:**

- Animated spinners (implementation concern)
- Sync (use `action.sync`)

---

### feedback.empty

**Meaning:** No content available.

**Usage:**

- Empty state illustration anchor
- No results indication
- Blank slate

**NOT for:**

- Error states (use `feedback.error`)
- Loading (use `feedback.loading`)

---

### feedback.celebration

**Meaning:** Achievement or milestone reached.

**Usage:**

- Goal completion
- Achievement unlocked
- Positive milestone

**NOT for:**

- Generic success (use `feedback.success`)
- Routine operations

---

### feedback.notification

**Meaning:** Notification or alert present.

**Usage:**

- Notification indicator
- Alert badge anchor
- Attention needed

**NOT for:**

- Navigation to notifications (combine with nav context)

---

## 7. Icon Vocabulary: System & Utility

System icons represent app infrastructure and utilities.

---

### system.camera

**Meaning:** Access camera for capture.

**Usage:**

- Camera access button
- Photo capture trigger
- Scan functionality

**NOT for:**

- Photo library (use `system.photos`)

---

### system.photos

**Meaning:** Access photo library.

**Usage:**

- Photo picker trigger
- Gallery access
- Image selection

**NOT for:**

- Camera capture (use `system.camera`)

---

### system.location

**Meaning:** Location or geographic context.

**Usage:**

- Location access
- Map pin
- Geographic indicator

**NOT for:**

- Navigation/directions (context-specific)

---

### system.calendar

**Meaning:** Date or calendar context.

**Usage:**

- Date picker trigger
- Calendar access
- Scheduling

**NOT for:**

- Time-only contexts (use `system.time`)

---

### system.time

**Meaning:** Time or duration context.

**Usage:**

- Time picker trigger
- Duration indicator
- Clock display

**NOT for:**

- Calendar/date contexts (use `system.calendar`)

---

### system.notification.settings

**Meaning:** Notification preferences.

**Usage:**

- Notification settings access
- Alert preferences
- Push configuration

**NOT for:**

- General settings (use `nav.settings`)

---

### system.privacy

**Meaning:** Privacy settings or indicator.

**Usage:**

- Privacy settings access
- Privacy mode indicator
- Data protection context

**NOT for:**

- Security credentials (use `system.security`)

---

### system.security

**Meaning:** Security settings or indicator.

**Usage:**

- Security settings access
- Authentication context
- Credential management

**NOT for:**

- Privacy settings (use `system.privacy`)
- Locked state (use `state.locked`)

---

### system.language

**Meaning:** Language or locale settings.

**Usage:**

- Language selection
- Locale settings
- Translation context

**NOT for:**

- Text/content icons

---

### system.accessibility

**Meaning:** Accessibility settings or features.

**Usage:**

- Accessibility settings access
- A11y feature indicator
- Inclusive design context

**NOT for:**

- General settings

---

## 8. Icon Usage Rules

### Rule 1: Icons Are Not Decoration

Every icon MUST have semantic purpose. Decorative icons are forbidden.

If an icon cannot be named from this vocabulary, it should not exist.

---

### Rule 2: Icons Require Labels for Primary Actions

Primary actions MUST include text labels alongside icons.

Icons alone are permitted only for:

- Well-established universal metaphors (back, close, search)
- Space-constrained contexts with clear context
- Repeat/familiar actions after initial labeled exposure

---

### Rule 3: Icon Meaning Is Immutable

Once a semantic icon is assigned a meaning, that meaning MUST NOT change.

If a metaphor needs revision, a new semantic identifier must be created.

---

### Rule 4: One Icon, One Meaning

Each semantic icon MUST represent exactly one concept.

Icons MUST NOT be overloaded with multiple meanings based on context.

---

### Rule 5: Accessibility Labels Are Mandatory

Every icon MUST have an accessibility label matching its semantic meaning.

Icon-only buttons MUST be fully accessible without visual interpretation.

---

### Rule 6: Platform Rendering Is Abstracted

Direct use of platform icon sets is forbidden.

All icon usage MUST go through the semantic mapping layer.

---

## 9. Icon + Label Relationships

### Label Required

The following contexts MUST include text labels:

- Primary action buttons
- Navigation bar items (first exposure)
- Form actions (submit, cancel)
- Destructive actions
- Any action with significant consequence

### Label Optional

The following contexts MAY omit text labels:

- Secondary/tertiary actions with clear context
- Repeat actions in established patterns
- Space-constrained toolbar items
- Universal metaphors (back, close, search, share)

### Label Positioning

- Labels MUST be positioned consistently per context type
- Icon + label pairs MUST maintain consistent spacing
- Labels MUST NOT wrap in ways that break association

---

## 10. Platform Interpretation

### iOS Interpretation

iOS icons should feel **light, refined, and symbol-oriented**.

**Visual Character:**

- Lighter stroke weights preferred
- Rounded corners and softer edges
- Outline style for inactive, filled for active
- Graceful, almost calligraphic quality

**Platform Expectations:**

- iOS users expect SF Symbols-style visual language
- Consistent with platform's refined aesthetic
- Subtle, elegant, not heavy-handed

**Rendering Guidance:**

- Prefer outline variants where available
- Use filled variants for active/selected states
- Maintain consistent stroke weights across the set

---

### Android Interpretation

Android icons should feel **clear, confident, and geometric**.

**Visual Character:**

- Slightly bolder presence than iOS
- Clean geometric construction
- Clear, readable at smaller sizes
- Solid, grounded visual weight

**Platform Expectations:**

- Android users expect clear, functional iconography
- Consistent with platform's practical aesthetic
- Direct, unambiguous, functional

**Rendering Guidance:**

- May use slightly heavier stroke weights
- Filled variants acceptable for emphasis
- Maintain geometric consistency across the set

---

### Cross-Platform Consistency

The following MUST remain consistent:

- Semantic meaning and identifier
- Basic metaphor (arrow for back, X for close, etc.)
- Relative sizing within the icon system
- Accessibility labels

The following MAY differ:

- Stroke weight
- Corner radius
- Fill vs outline default
- Fine visual details

---

## 11. Icon Scale Guidelines

### Relative Sizing (Not Absolute)

Icons exist at semantic sizes that relate to typography and spacing:

| Size Level | Context                                       |
| ---------- | --------------------------------------------- |
| xs         | Inline with caption text, badges              |
| sm         | Inline with body text, list item secondary    |
| md         | Standard interactive icons, list item primary |
| lg         | Prominent actions, empty states               |
| xl         | Hero moments, onboarding                      |

### Sizing Rules

- Icon size MUST be proportional to accompanying text
- Touch targets MUST meet minimum accessibility requirements regardless of icon size
- Icons MUST NOT be scaled arbitrarily outside defined size levels

---

## 12. Anti-Patterns (Forbidden)

| Anti-Pattern                     | Violation                      |
| -------------------------------- | ------------------------------ |
| Icon without semantic identifier | Violates vocabulary rule       |
| Same icon, different meanings    | Violates one-meaning rule      |
| Icon-only primary action         | Violates label requirement     |
| Direct platform icon reference   | Violates abstraction rule      |
| Decorative-only icons            | Violates purpose rule          |
| Missing accessibility label      | Violates accessibility rule    |
| Meaning change after release     | Violates immutability rule     |
| Custom icon outside vocabulary   | Violates vocabulary governance |

---

## 13. Vocabulary Extension Process

### Adding New Icons

New semantic icons may be added when:

- A clear, distinct meaning exists that current vocabulary cannot express
- The metaphor is universal and unambiguous
- The icon will be used across multiple features

New icons MUST NOT be added for:

- One-off illustrations
- Decorative purposes
- Concepts expressible with existing vocabulary

### Extension Requirements

Proposals for new icons MUST include:

- Semantic identifier following naming conventions
- Clear meaning statement
- Usage contexts
- NOT for contexts
- Justification for addition

---

## 14. Compliance & Enforcement

### Design Requirements

All icon usage MUST reference semantic identifiers from this vocabulary.

New features MUST NOT introduce icons outside the vocabulary without extension approval.

### Implementation Requirements

- All icons MUST resolve through the semantic mapping layer
- Platform-specific assets MUST be abstracted behind semantic identifiers
- Direct icon set references are build-time errors

### Exceptions

Exceptions are permitted only when:

- Temporary illustration needs pending vocabulary extension
- Third-party integration requires specific iconography

Exceptions MUST be documented with:

- Semantic gap being worked around
- Timeline for vocabulary extension
- Review date for resolution

---

**End of Contract**
