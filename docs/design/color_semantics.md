# Color Semantics Contract

**Version:** 1.0  
**Status:** Frozen  
**Effective Date:** 2024-12-19  
**Last Review:** —

---

## 1. Purpose & Scope

### Governs

- Semantic color role definitions and their functional intent
- Emotional tone and perceptual expectations for each role
- Usage boundaries and restrictions per role
- Cross-platform consistency requirements
- Platform-specific adaptation boundaries

### Does Not Cover

- Specific color values (hex, RGB, HSL)
- Palette generation or color schemes
- Accessibility contrast ratios (covered separately)
- Dark mode vs light mode mappings
- Animation or gradient implementations

---

## 2. Design Philosophy

This color system prioritizes:

- **Vibrant optimism** — Colors should feel energetic, alive, and joyful without aggression
- **Warm confidence** — The interface should feel inviting, supportive, and emotionally safe
- **Playful clarity** — Every color role has a distinct emotional intent while maintaining approachability
- **Feel-good moments** — Colors should celebrate progress and make routine interactions delightful
- **Platform respect** — Visual interpretation may vary; meaning must not

---

## 3. Brand Colors

### Brand Primary

**Intent:** The signature color representing the product's core identity. This is the most recognizable and frequently used brand color.

**Emotional Tone:** Vibrant, energizing, uplifting.

**Usage:**

- Primary action buttons
- Active navigation indicators
- Brand moments (splash, onboarding highlights)
- Focus states on interactive elements

**NOT for:**

- Large background surfaces (use Brand Surface instead)
- Text on light backgrounds without sufficient contrast
- Error or warning states

**Platform Adaptation:** MUST remain visually consistent. This is the brand anchor.

---

### Brand Secondary

**Intent:** Supports the primary brand color without competing. Provides visual variety while maintaining brand cohesion.

**Emotional Tone:** Warm, approachable, harmonious.

**Usage:**

- Secondary action buttons
- Supporting navigation elements
- Non-critical highlights and accents
- Alternative branded sections

**NOT for:**

- Primary CTAs (use Brand Primary)
- Competing with Brand Primary for attention
- Error or warning states

**Platform Adaptation:** MUST remain visually consistent with Brand Primary relationship.

---

### Brand Accent

**Intent:** A complementary color that adds vibrancy and visual interest without competing with Primary.

**Emotional Tone:** Playful, delightful, sparkling.

**Usage:**

- Secondary actions and toggles
- Decorative elements and illustrations
- Success moments and positive reinforcement
- Highlighting secondary information

**NOT for:**

- Primary CTAs
- Destructive actions
- Critical alerts

**Platform Adaptation:** MAY vary in saturation to respect platform vibrancy conventions (iOS may render more vibrant).

---

### Brand Surface

**Intent:** A tinted background that carries brand identity while remaining subtle enough for content.

**Emotional Tone:** Soft, nurturing, embracing.

**Usage:**

- Card backgrounds for branded sections
- Subtle section dividers
- Empty state backgrounds
- Branded content containers

**NOT for:**

- Full-screen backgrounds (use Neutral Surface)
- Text labels
- Interactive elements

**Platform Adaptation:** MAY vary in opacity and translucency per platform elevation systems.

---

## 4. Neutral Colors

### Neutral Base

**Intent:** The foundational background color for the entire application.

**Emotional Tone:** Airy, warm, breathing.

**Usage:**

- Root background for all screens
- Base layer for modals and sheets
- Scrollable content backgrounds

**NOT for:**

- Foreground elements
- Interactive components
- Overlay layers

**Platform Adaptation:** MUST remain consistent. This is the perceptual anchor.

---

### Neutral Surface

**Intent:** Elevated surfaces that distinguish content layers from the base.

**Emotional Tone:** Light, lifted, welcoming.

**Usage:**

- Card backgrounds
- Input field containers
- Segmented controls and pickers
- Grouped list sections

**NOT for:**

- Text content
- Primary actions
- Full-screen overlays

**Platform Adaptation:** MAY vary in elevation technique (shadow on Android, translucency on iOS).

---

### Surface Elevated

**Intent:** Highest-elevation surfaces that demand focus and separation from all other content.

**Emotional Tone:** Floating, attentive, gently prominent.

**Usage:**

- Modal dialogs
- Popovers and dropdowns
- Action sheets
- Floating panels

**NOT for:**

- Standard cards (use Neutral Surface)
- Inline content
- Permanent UI regions

**Platform Adaptation:** MAY vary significantly. iOS may use blur and translucency; Android may use shadow and solid surfaces.

---

### Neutral Divider

**Intent:** Subtle separators that define boundaries without drawing attention.

**Emotional Tone:** Whisper-soft, barely-there, gentle.

**Usage:**

- List item separators
- Section boundaries
- Input field borders (inactive state)

**NOT for:**

- Active or focused states
- Decorative elements
- Text content

**Platform Adaptation:** MAY vary in opacity. iOS may prefer lighter, more translucent dividers.

---

## 5. Text & Content

### Text Primary

**Intent:** The default color for all body text and content.

**Emotional Tone:** Clear, readable, authoritative.

**Usage:**

- Body text
- Headlines and titles
- Primary labels
- Content-heavy screens

**NOT for:**

- Disabled states
- Placeholder text
- Interactive labels (use Brand Primary)

**Platform Adaptation:** MUST remain consistent in perceived contrast and readability.

---

### Text Secondary

**Intent:** Supporting text that provides context without competing with primary content.

**Emotional Tone:** Supportive, subtle, informative.

**Usage:**

- Metadata (timestamps, authors)
- Captions and descriptions
- Placeholder text
- Helper text

**NOT for:**

- Primary content
- Error messages
- Interactive labels

**Platform Adaptation:** MAY vary slightly in opacity to match platform text hierarchy conventions.

---

### Text Tertiary

**Intent:** Minimal-emphasis text for non-essential information.

**Emotional Tone:** Whisper-quiet, de-emphasized, optional.

**Usage:**

- Extremely low-priority labels
- Legal disclaimers in UI
- Watermarks or badges

**NOT for:**

- Anything requiring user attention
- Interactive elements
- Error or success messaging

**Platform Adaptation:** MAY vary in opacity.

---

### Text Inverse

**Intent:** Text rendered on dark or saturated backgrounds.

**Emotional Tone:** Clear, confident, high-contrast.

**Usage:**

- Text on Brand Primary buttons
- Text on dark overlays
- Text on saturated surfaces

**NOT for:**

- Light backgrounds
- Subtle or secondary information

**Platform Adaptation:** MUST remain high-contrast. Exact value may adapt to platform rendering.

---

## 6. Feedback Colors

### Feedback Success

**Intent:** Communicates successful completion or positive state.

**Emotional Tone:** Celebratory, rewarding, affirming.

**Usage:**

- Success state icons
- Positive validation indicators
- Completion checkmarks
- Undo affordances

**NOT for:**

- Success dialogs or toasts (see Interaction Contract)
- Primary actions
- Large background areas

**Platform Adaptation:** MUST convey "success" universally. MAY vary in warmth or coolness.

---

### Feedback Warning

**Intent:** Alerts users to caution without alarm.

**Emotional Tone:** Gentle nudge, caring attention, soft alert.

**Usage:**

- Non-critical alerts
- Validation warnings (field-level)
- Informational banners requiring attention

**NOT for:**

- Critical errors
- Destructive confirmations
- Success states

**Platform Adaptation:** MUST feel distinct from Success and Error. MAY vary in saturation.

---

### Feedback Error

**Intent:** Communicates failure, invalid state, or critical issues.

**Emotional Tone:** Clear, supportive-serious, recoverable.

**Usage:**

- Validation errors
- Failed operations
- Destructive action confirmations
- Critical alerts

**NOT for:**

- Warnings
- Disabled states
- Brand moments

**Platform Adaptation:** MUST convey urgency. MAY vary in intensity per platform conventions.

---

### Feedback Info

**Intent:** Neutral informational messaging without emotional weight.

**Emotional Tone:** Friendly, guiding, helpful.

**Usage:**

- Informational banners
- Tooltips and hints
- Onboarding highlights
- Contextual help

**NOT for:**

- Errors or warnings
- Success states
- Brand identity

**Platform Adaptation:** MAY vary. iOS may prefer cooler tones; Android may prefer warmer neutrals.

---

## 7. Interactive States

### State Active

**Intent:** The color of an element currently being interacted with.

**Emotional Tone:** Alive, responsive, tactile.

**Usage:**

- Pressed button states
- Active tab indicators
- Selected list items
- Focus rings on inputs

**NOT for:**

- Inactive states
- Disabled elements
- Background surfaces

**Platform Adaptation:** MUST provide immediate feedback. MAY vary in opacity or overlay technique.

---

### State Hover

**Intent:** Subtle affordance indicating an element is interactive.

**Emotional Tone:** Inviting, curious, ready.

**Usage:**

- Desktop pointer hover states
- Subtle background tints on interactive regions

**NOT for:**

- Touch-only interfaces
- Non-interactive content
- Mobile platforms without pointer support

**Platform Adaptation:** MAY be omitted on platforms without hover capability.

---

### State Disabled

**Intent:** Visually communicates that an element is non-interactive.

**Emotional Tone:** Resting, patient, temporarily unavailable.

**Usage:**

- Disabled buttons
- Inactive form fields
- Unavailable menu items

**NOT for:**

- Loading states (use loading indicators)
- Hidden elements (use visibility controls)
- Placeholder text (use Text Secondary)

**Platform Adaptation:** MUST feel clearly "off." MAY vary in opacity technique.

---

### State Focus

**Intent:** High-visibility indicator for keyboard or assistive navigation.

**Emotional Tone:** Clear, accessible, precise.

**Usage:**

- Keyboard focus rings
- Screen reader navigation highlights
- Accessibility-focused interactive states

**NOT for:**

- Touch interactions
- Decorative purposes
- Non-interactive elements

**Platform Adaptation:** MUST meet platform accessibility requirements. MAY vary in stroke width or glow.

---

### State Selected

**Intent:** Indicates a persistent selection that remains after the interaction ends.

**Emotional Tone:** Chosen, affirmed, locked-in.

**Usage:**

- Selected list items
- Active filter chips
- Chosen options in multi-select
- Current tab or segment

**NOT for:**

- Momentary press states (use State Active)
- Focus rings (use State Focus)
- Hover states

**Platform Adaptation:** MUST clearly indicate selection. MAY vary in opacity or tint technique.

---

## 8. Overlays & Scrim

### Overlay Dark

**Intent:** A semi-transparent layer that darkens content beneath modals or sheets.

**Emotional Tone:** Cozy dimming, focused attention, gentle fade.

**Usage:**

- Modal backdrops
- Sheet underlays
- Contextual dimming

**NOT for:**

- Permanent UI elements
- Text content
- Interactive surfaces

**Platform Adaptation:** MAY vary in opacity and blur. iOS may use translucency; Android may use solid opacity.

---

### Overlay Light

**Intent:** A semi-transparent layer that lightens content, often for loading states.

**Emotional Tone:** Soft, temporary, non-blocking.

**Usage:**

- Loading overlays on content regions
- Skeleton placeholder tints
- Temporary blocking states

**NOT for:**

- Permanent backgrounds
- Modal backdrops
- Text rendering

**Platform Adaptation:** MAY vary in opacity.

---

### Scrim

**Intent:** Modal separation layer that isolates foreground content from background. Distinct from Overlay in that it specifically signals modal context.

**Emotional Tone:** Isolated, modal, focused.

**Usage:**

- Behind modal dialogs
- Behind bottom sheets
- Behind full-screen overlays requiring dismissal

**NOT for:**

- Non-modal overlays
- Loading states (use Overlay Light)
- Permanent dimming

**Platform Adaptation:** MAY vary in opacity and interaction behavior. iOS may allow tap-through dismissal; Android may require explicit close.

---

### Skeleton

**Intent:** Placeholder color for loading states that mimics content structure before data arrives.

**Emotional Tone:** Gentle anticipation, soft shimmer, patient.

**Usage:**

- Skeleton placeholders for text
- Skeleton placeholders for images
- Skeleton placeholders for cards and lists
- Shimmer animation base color

**NOT for:**

- Actual content
- Error states
- Interactive elements

**Platform Adaptation:** MAY vary in opacity and animation technique.

---

## 9. Data Visualization Colors

### Chart Primary

**Intent:** The dominant color for primary data series in charts and graphs.

**Emotional Tone:** Clear, prominent, trustworthy.

**Usage:**

- Primary data series
- Main trend lines
- Key metrics
- Single-series charts

**NOT for:**

- Secondary data series
- Background elements
- Decorative purposes

**Platform Adaptation:** MUST remain visually distinct from Chart Secondary and Chart Tertiary.

---

### Chart Secondary

**Intent:** Supporting color for secondary data series that complements without competing.

**Emotional Tone:** Supportive, comparative, balanced.

**Usage:**

- Secondary data series
- Comparison data
- Multi-series charts

**NOT for:**

- Primary data emphasis
- Alerts or warnings in charts

**Platform Adaptation:** MUST remain visually distinct from Chart Primary.

---

### Chart Tertiary

**Intent:** Third-tier color for additional data series or de-emphasized data.

**Emotional Tone:** Subtle, supplementary, contextual.

**Usage:**

- Tertiary data series
- Historical or baseline data
- De-emphasized comparisons

**NOT for:**

- Primary or secondary emphasis
- Critical data points

**Platform Adaptation:** MAY vary in saturation while maintaining distinctiveness.

---

## 10. Platform Adaptation Rules

### Must Remain Consistent

The following roles MUST produce the same perceptual meaning across platforms:

- Brand Primary
- Brand Secondary
- Brand Accent
- Neutral Base
- Text Primary
- Text Inverse
- Feedback Success
- Feedback Warning
- Feedback Error
- State Active
- State Focus
- State Selected
- Chart Primary
- Chart Secondary
- Chart Tertiary

### May Adapt Per Platform

The following roles MAY vary in saturation, opacity, translucency, or rendering technique:

- Brand Surface
- Neutral Surface
- Surface Elevated
- Neutral Divider
- Text Secondary
- Text Tertiary
- Feedback Info
- State Hover
- State Disabled
- Overlay Dark
- Overlay Light
- Scrim
- Skeleton

**Adaptation Constraints:**

- Emotional intent MUST NOT change
- Functional purpose MUST remain identical
- Contrast requirements MUST be met on both platforms

---

## 11. Anti-Patterns (Explicitly Forbidden)

| Anti-Pattern                                    | Violation                              |
| ----------------------------------------------- | -------------------------------------- |
| Using Brand Primary for error states            | Dilutes brand association with failure |
| Using Feedback Error for warnings               | Creates false urgency                  |
| Using Text Tertiary for critical information    | Hides important content                |
| Using State Active for non-interactive elements | Creates false affordance               |
| Using Brand Accent for destructive actions      | Creates emotional conflict             |
| Using Overlay Dark as a permanent background    | Misuses temporary layering semantics   |
| Using Feedback Success for primary CTAs         | Confuses success with action           |
| Using identical colors for Active and Focus     | Reduces accessibility clarity          |
| Using Text Primary on Brand Primary backgrounds | Creates contrast violations            |
| Using Neutral Divider for interactive borders   | Hides interaction affordance           |

---

## 12. Compliance & Enforcement

### Design Deliverables

Every design MUST declare which semantic roles are used and why.

### Implementation Requirements

Implementations MUST:

- Use semantic role names, never raw color values
- Respect usage boundaries defined in this contract
- Document any platform-specific adaptations

### Exceptions

Exceptions are permitted only when:

- A platform constraint makes semantic mapping impossible
- User research demonstrates semantic confusion

Exceptions MUST be documented with:

- Specific role being violated
- Justification with evidence
- Alternative semantic approach
- Review date for reconsideration

---

**End of Contract**
