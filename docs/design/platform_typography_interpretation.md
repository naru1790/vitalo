# Platform Typography Interpretation Guidelines

**Version:** 1.0  
**Status:** Frozen  
**Effective Date:** 2024-12-19  
**Last Review:** —  
**Parent Documents:** Interaction Design Contract, Color Semantics Contract, Platform Color Interpretation Guidelines

---

## 1. Purpose & Scope

### Governs

- Semantic text role definitions and their functional intent
- Platform-specific typographic interpretation for iOS and Android
- Relative sizing, weight distribution, and vertical rhythm
- Reading experience and text density expectations

### Does Not Cover

- Specific font families or typeface selection
- Numeric font sizes, line heights, or letter spacing values
- Accessibility font scaling (covered separately)
- Internationalization and right-to-left considerations

### Foundational Principle

Semantic text roles are universal. This document defines how those roles should _feel_ and _breathe_ differently on each platform while preserving identical purpose and brand voice.

No platform-specific text roles may be introduced. The same role names must resolve to platform-appropriate typographic interpretations.

---

## 2. Typography Philosophy

### Brand Voice

This brand's typographic voice is:

- **Warm and welcoming** — Text should invite reading, not demand it
- **Calm and spacious** — Text should breathe, never crowd
- **Confident but approachable** — Hierarchy should guide, not shout
- **Optimistic and clear** — Reading should feel effortless and uplifting

### What We Reject

- Material Design's dense, utilitarian, information-heavy approach
- Cupertino's default system typography without brand personality
- Cramped vertical spacing that creates visual anxiety
- Aggressive weight contrasts that feel corporate or cold
- Typography that prioritizes information density over reading comfort

### What We Embrace

- Generous vertical rhythm that lets content breathe
- Warm weight distribution that feels approachable
- Clear hierarchy that guides without commanding
- Text density appropriate to a wellness context
- Reading experiences that feel calm and supportive

---

## 3. Semantic Text Roles

### Display

**Purpose:** The largest, most prominent text in the interface. Used sparingly for maximum impact.

**Typical Usage:**

- Hero moments on landing screens
- Celebratory messages and achievements
- Onboarding headlines
- Empty state primary messages

**Emotional Tone:** Bold, inspiring, uplifting.

**Hierarchy Position:** Top of visual hierarchy. Commands immediate attention.

**Usage Constraint:** Display text should appear rarely. Overuse diminishes impact and creates visual noise.

---

### Title

**Purpose:** Section and screen-level headings that establish context and organize content.

**Typical Usage:**

- Screen titles and navigation headers
- Section headings within scrollable content
- Card titles and content group labels
- Dialog and sheet headers

**Emotional Tone:** Confident, orienting, clear.

**Hierarchy Position:** Second level. Establishes structure without overwhelming.

**Usage Constraint:** Titles should feel like friendly signposts, not demanding announcements.

---

### Body

**Purpose:** The primary reading text for content consumption. Where users spend most of their reading time.

**Typical Usage:**

- Article and content paragraphs
- Descriptions and explanations
- List item primary text
- Form field content
- Conversational UI text

**Emotional Tone:** Calm, readable, trustworthy.

**Hierarchy Position:** Core content level. Optimized for comfortable extended reading.

**Usage Constraint:** Body text must never feel cramped, rushed, or dense. This is where reading comfort matters most.

---

### Caption

**Purpose:** Supporting text that provides context, metadata, or secondary information.

**Typical Usage:**

- Timestamps and dates
- Attribution and source information
- Image captions and descriptions
- Secondary metadata
- Helper text below form fields

**Emotional Tone:** Supportive, quiet, informative.

**Hierarchy Position:** Below body text. Present but not competing for attention.

**Usage Constraint:** Captions should feel helpful, not tiny or hard to read. Readability must not be sacrificed for hierarchy.

---

### Label

**Purpose:** Short, functional text that identifies or describes interactive elements.

**Typical Usage:**

- Button text
- Tab and segment labels
- Form field labels
- Navigation item text
- Chip and tag text
- Toggle and switch labels

**Emotional Tone:** Clear, actionable, direct.

**Hierarchy Position:** Functional level. Optimized for quick recognition and interaction.

**Usage Constraint:** Labels must be immediately readable at a glance. Brevity serves function, but legibility must not suffer.

---

## 4. iOS Typography Interpretation

### Overall Philosophy

iOS typography should feel **light, airy, and elegant**. Text should appear to float on the surface with generous breathing room. The reading experience should feel effortless and refined.

iOS users expect typographic precision and subtle sophistication. Weight variations should be gentle. Spacing should be generous. The overall impression should be one of calm clarity.

---

### Display on iOS

**Relative Size:** Largest in the system. Should feel heroic without being overwhelming.

**Weight:** Medium to semibold. Bold enough to command attention but not aggressive.

**Line Height:** Very generous. Display text often spans multiple lines and must breathe.

**Rhythm:** Isolated. Display text should have substantial space above and below.

**Character:** Should feel inspiring and uplifting, like a warm welcome.

---

### Title on iOS

**Relative Size:** Clearly larger than body. Unmistakably a heading.

**Weight:** Semibold preferred. Strong enough to establish hierarchy without shouting.

**Line Height:** Generous. Titles may wrap and should remain comfortable.

**Rhythm:** Clear separation from content below. Titles should feel like natural pauses.

**Character:** Should feel confident and orienting, like a friendly guide.

---

### Body on iOS

**Relative Size:** Optimized for extended comfortable reading. Slightly larger than platform defaults.

**Weight:** Regular. Clean and unobtrusive for sustained reading.

**Line Height:** Generous—noticeably more than platform defaults. Lines should not feel crowded.

**Rhythm:** Paragraph spacing should be substantial. Content should flow, not stack.

**Character:** Should feel calm and inviting. Reading should feel like a pleasant experience, not a task.

**Key Differentiator:** iOS body text should prioritize elegance and breathing room over information density.

---

### Caption on iOS

**Relative Size:** Smaller than body but still comfortably readable. Never tiny.

**Weight:** Regular to medium. Light weights risk appearing weak on iOS.

**Line Height:** Proportionally generous. Even small text needs room to breathe.

**Rhythm:** Adequate spacing from primary content. Should feel connected but subordinate.

**Character:** Should feel supportive and present, not diminished or afterthought.

---

### Label on iOS

**Relative Size:** Appropriate for interactive context. Button labels slightly larger than navigation labels.

**Weight:** Medium to semibold for buttons. Regular to medium for navigation.

**Line Height:** Single line optimized. Labels rarely wrap.

**Rhythm:** Centered within interactive targets with comfortable padding.

**Character:** Should feel clear and tappable. Interaction confidence should be immediate.

---

## 5. Android Typography Interpretation

### Overall Philosophy

Android typography should feel **warm, grounded, and readable**. Text should have presence and substance. The reading experience should feel comfortable and accessible.

Android users expect typography that communicates clearly and directly. Weight variations can be slightly bolder. Spacing should be comfortable but not excessive. The overall impression should be one of approachable clarity.

---

### Display on Android

**Relative Size:** Largest in the system. Should feel bold and celebratory.

**Weight:** Semibold to bold. Can assert more strongly than iOS while remaining warm.

**Line Height:** Generous. Display text must breathe even when bold.

**Rhythm:** Substantial isolation. Display text anchors visual hierarchy.

**Character:** Should feel confident and rewarding, like an achievement.

---

### Title on Android

**Relative Size:** Clearly differentiated from body. Strong hierarchical presence.

**Weight:** Semibold to bold. Can carry more weight than iOS titles.

**Line Height:** Comfortable. Slightly tighter than iOS but never cramped.

**Rhythm:** Clear but efficient separation. Android tolerates tighter vertical rhythm.

**Character:** Should feel organized and grounded, like clear structure.

---

### Body on Android

**Relative Size:** Optimized for comfortable reading. At or slightly above platform norms.

**Weight:** Regular. Clean and sustainable for extended reading.

**Line Height:** Comfortable—more generous than platform defaults but not as airy as iOS.

**Rhythm:** Clear paragraph separation. Content should feel organized.

**Character:** Should feel accessible and straightforward. Reading should feel natural and unforced.

**Key Differentiator:** Android body text should balance readability with efficient use of space. Slightly denser than iOS but never cramped.

---

### Caption on Android

**Relative Size:** Smaller than body but clearly legible. Readability is non-negotiable.

**Weight:** Regular to medium. Sufficient presence to remain visible.

**Line Height:** Comfortable proportion. Small text especially needs adequate spacing.

**Rhythm:** Connected to primary content with clear subordination.

**Character:** Should feel helpful and grounded, not whispered or hidden.

---

### Label on Android

**Relative Size:** Appropriate for interactive context. May be slightly bolder than iOS equivalents.

**Weight:** Medium to bold for primary actions. Medium for secondary interactions.

**Line Height:** Single line optimized. Clear and punchy.

**Rhythm:** Well-padded within interactive targets. Touch targets must feel generous.

**Character:** Should feel actionable and confident. Interaction intent should be unmistakable.

---

## 6. Cross-Platform Consistency Requirements

### Must Remain Consistent

The following aspects MUST produce equivalent experiences across platforms:

- Semantic role purpose and usage
- Relative hierarchy relationships (Display > Title > Body > Caption)
- Emotional tone per role
- Brand voice and personality
- Reading comfort and accessibility

### May Adapt Per Platform

The following aspects MAY differ between platforms:

- Absolute size relationships
- Weight intensity
- Line height proportions
- Vertical rhythm density
- Letter spacing nuances

---

## 7. Body Text Guidelines (Critical)

Body text is where users spend the most time. Its treatment is critical to brand experience.

### iOS Body Text

- **Breathing room is paramount.** Lines should never feel stacked or crowded.
- **Generous line height.** Noticeably more spacious than platform defaults.
- **Calm rhythm.** Paragraph spacing creates natural pauses.
- **Elegant presence.** Text should feel refined and easy.
- **No density optimization.** Never sacrifice comfort for more content.

### Android Body Text

- **Readability is paramount.** Text should feel natural and accessible.
- **Comfortable line height.** More generous than defaults but grounded.
- **Clear rhythm.** Paragraph spacing organizes without excess.
- **Approachable presence.** Text should feel direct and friendly.
- **Efficient comfort.** Balance breathing room with practical density.

### Comparison

| Aspect      | iOS               | Android               |
| ----------- | ----------------- | --------------------- |
| Line height | Very generous     | Comfortably generous  |
| Density     | Airy and spacious | Balanced and grounded |
| Feel        | Elegant, refined  | Accessible, direct    |
| Rhythm      | Flowing, relaxed  | Organized, efficient  |

---

## 8. Heading Guidelines

### Hierarchy Without Aggression

Headings should guide users through content without demanding attention aggressively.

**Principles:**

- Size difference should be clear but not dramatic
- Weight should establish hierarchy without shouting
- Color should not be required to differentiate headings from body
- Spacing above headings should create natural section breaks
- Spacing below headings should connect them to their content

### iOS Headings

- Prefer semibold over bold for most titles
- Allow generous space above headings
- Keep headings visually connected to following content
- Hierarchy should feel like gentle guidance

### Android Headings

- Semibold to bold is appropriate for titles
- Space above headings can be slightly tighter than iOS
- Clear connection to following content
- Hierarchy should feel like confident organization

---

## 9. Label and Caption Guidelines

### Avoiding Cramped Text

Small text is especially vulnerable to feeling cramped or unreadable.

**Principles:**

- Minimum size must preserve comfortable readability
- Line height must remain proportionally generous
- Weight must be sufficient for clear presence
- Spacing within containers must feel comfortable, not squeezed

### iOS Labels and Captions

- Regular to medium weight preferred
- Generous padding within interactive containers
- Captions should feel quietly supportive
- Labels should feel clear and elegant

### Android Labels and Captions

- Medium weight provides better presence
- Comfortable padding within interactive containers
- Captions should feel grounded and helpful
- Labels should feel actionable and confident

---

## 10. Vertical Rhythm Guidelines

### Overall Principle

Vertical rhythm creates reading comfort through consistent, predictable spacing.

This brand prioritizes:

- Generous spacing over dense packing
- Natural reading pauses over information maximization
- Calm visual flow over aggressive organization

### iOS Rhythm

- Very generous vertical spacing throughout
- Sections should feel separated and breathable
- Lists should feel relaxed, not compressed
- The interface should feel spacious and calm

### Android Rhythm

- Generous but grounded vertical spacing
- Sections should feel organized and clear
- Lists should feel comfortable and scannable
- The interface should feel accessible and structured

### Spacing Hierarchy

Both platforms should maintain proportional relationships:

- Display spacing > Title spacing > Body paragraph spacing > Caption spacing
- Interactive elements should have consistent internal rhythm
- Section breaks should create clear visual separation

---

## 11. Weight Distribution Guidelines

### Philosophy

Weight creates hierarchy and emphasis. Distribution must feel warm and intentional, not corporate or aggressive.

### What To Avoid

- Extreme weight contrasts (light body with black headings)
- Overuse of bold for emphasis
- Light weights that feel weak or anemic
- Heavy weights that feel aggressive or demanding

### What To Embrace

- Medium weights as the comfortable middle ground
- Semibold for confident hierarchy without aggression
- Regular for calm, sustained reading
- Consistent weight relationships across the interface

### iOS Weight Distribution

- Regular: Body, captions, secondary labels
- Medium: Interactive labels, emphasized text
- Semibold: Titles, primary buttons, headings
- Bold: Display text only, used sparingly

### Android Weight Distribution

- Regular: Body, captions
- Medium: Secondary labels, emphasized text
- Semibold: Titles, interactive labels
- Bold: Display text, primary buttons, strong headings

---

## 12. Platform Adaptation Summary

| Aspect           | iOS                       | Android                        |
| ---------------- | ------------------------- | ------------------------------ |
| Overall feel     | Elegant, airy, refined    | Approachable, grounded, direct |
| Body rhythm      | Very spacious             | Comfortably spacious           |
| Heading weight   | Semibold preferred        | Semibold to bold               |
| Density          | Prioritize breathing room | Balance comfort and efficiency |
| Vertical rhythm  | Generous throughout       | Generous but grounded          |
| Weight intensity | Softer, more subtle       | Slightly bolder                |

---

## 13. Compliance & Enforcement

### Design Requirements

All typography decisions MUST reference semantic roles defined in this document.

Platform-specific designs MUST declare which interpretation guidelines informed typographic treatment.

### Implementation Requirements

Typography tokens MUST:

- Resolve the same semantic role names on both platforms
- Apply platform-appropriate interpretation as defined
- Maintain relative hierarchy relationships
- Document any deviations with justification

### Exceptions

Exceptions are permitted only when:

- A platform constraint makes interpretation impossible
- User research demonstrates readability issues

Exceptions MUST be documented with:

- Specific guideline being violated
- Platform-specific justification
- Alternative approach taken
- Review date for reconsideration

---

**End of Guidelines**
