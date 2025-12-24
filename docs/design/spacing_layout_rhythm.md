# Spacing & Layout Rhythm Guidelines

**Version:** 1.0  
**Status:** Frozen  
**Effective Date:** 2024-12-19  
**Last Review:** —  
**Parent Documents:** Interaction Design Contract, Platform Typography Interpretation Guidelines

---

## 1. Purpose & Scope

### Governs

- Semantic spacing categories and their cognitive meaning
- Spacing scale definitions and usage rules
- Spatial hierarchy and relationship communication
- Platform-specific rhythm interpretation for iOS and Android

### Does Not Cover

- Numeric spacing values or pixel measurements
- Grid systems or column layouts
- Responsive breakpoints
- Animation timing or motion spacing

### Foundational Principle

Spacing is not decoration. Spacing communicates relationship, hierarchy, and cognitive grouping. Every spatial decision must have semantic intent.

This document defines the grammar of space. Implementation tokens must enforce these relationships consistently.

### Feature Layout Ownership (Tier-1)

- Feature screens MUST NOT use `Padding`, `EdgeInsets`, or `SingleChildScrollView` directly.
- Feature screens MUST use `AppPageBody` to select semantic padding and scrolling behavior.
- Design-system primitives own the mechanics; feature code owns content and intent.

---

## 2. Spacing Philosophy

### Spatial Communication

Space communicates before content does. Users perceive relationships through proximity before they read labels or recognize icons.

**Proximity signals relationship.** Elements near each other are perceived as related. Elements far apart are perceived as distinct.

**Consistency signals stability.** Predictable spacing creates cognitive ease. Erratic spacing creates anxiety.

**Generosity signals quality.** Cramped interfaces feel cheap and stressful. Breathing room feels confident and calm.

### Brand Spatial Character

This brand's spatial voice is:

- **Generous and breathable** — Space is a feature, not waste
- **Calm and organized** — Rhythm creates reading comfort
- **Clear and intentional** — Relationships are unambiguous
- **Warm and welcoming** — Space invites exploration

### What We Reject

- Dense, cramped layouts that maximize information at the cost of comfort
- Arbitrary spacing that changes without semantic reason
- Tight vertical rhythm that creates visual anxiety
- Inconsistent spacing within similar contexts

### What We Embrace

- Generous spacing that lets content breathe
- Consistent rhythm that creates predictability
- Clear spatial hierarchy that guides attention
- Platform-appropriate density that respects native expectations

---

## 3. Spacing Categories

### Category 1: Inset Spacing

**Definition:** The space between a container's boundary and its content.

**Cognitive Meaning:** Inset spacing defines containment and protection. It signals "this content belongs together within this boundary."

**Visual Effect:** Creates breathing room within bounded regions. Prevents content from touching edges.

**Examples of Use:**

- Card content padding
- Button text padding
- Modal content margins
- Input field internal spacing
- List item internal padding

**Principle:** Inset spacing should feel protective and comfortable. Content should never feel squeezed against container edges.

---

### Category 2: Inter-Element Spacing

**Definition:** The space between related sibling elements within the same container or group.

**Cognitive Meaning:** Inter-element spacing defines sibling relationships. It signals "these elements are related and belong to the same group."

**Visual Effect:** Creates rhythm between related items. Maintains visual connection while allowing individual recognition.

**Examples of Use:**

- Space between list items
- Space between form fields
- Space between icon and label
- Space between title and subtitle
- Space between buttons in a group

**Principle:** Inter-element spacing should feel connected but not cramped. Items should breathe individually while clearly belonging together.

---

### Category 3: Section Spacing

**Definition:** The space between unrelated groups, sections, or distinct content regions.

**Cognitive Meaning:** Section spacing defines boundaries between concepts. It signals "this group is complete; a new topic begins."

**Visual Effect:** Creates clear separation between distinct content areas. Establishes cognitive breaks.

**Examples of Use:**

- Space between content sections on a screen
- Space between a form and action buttons
- Space above and below dividers
- Space between card groups
- Space between navigation and content

**Principle:** Section spacing should feel like a pause or breath. Users should perceive a clear boundary without needing a visible divider.

---

## 4. Semantic Spacing Scale

### Scale Definition

The spacing scale provides five semantic levels that apply across all spacing categories.

| Level | Name | Cognitive Intent                                      |
| ----- | ---- | ----------------------------------------------------- |
| 1     | xs   | Tight connection — elements are intimately related    |
| 2     | sm   | Close relationship — elements clearly belong together |
| 3     | md   | Comfortable relationship — balanced breathing room    |
| 4     | lg   | Loose relationship — related but distinct             |
| 5     | xl   | Separation — clear boundary or major pause            |
| 6     | xxl  | Terminal — page-level breathing and maximum breaks    |

---

### xs (Extra Small)

**Intent:** Minimal separation for intimately connected elements.

**When to Use:**

- Icon to label within a single interactive element
- Badge positioning relative to parent
- Inline elements that form a single semantic unit
- Tight groupings where elements are essentially one thing

**When NOT to Use:**

- Between list items
- Between form fields
- Between sections
- Anywhere breathing room aids comprehension

**Character:** Intimate, unified, atomic.

---

### sm (Small)

**Intent:** Close proximity for clearly related elements.

**When to Use:**

- Between title and subtitle
- Between label and helper text
- Between compact list items
- Between closely related form fields
- Within dense but readable groupings

**When NOT to Use:**

- Between unrelated sections
- When elements need clear individual identity
- When density creates reading difficulty

**Character:** Connected, familial, cohesive.

---

### md (Medium)

**Intent:** Comfortable default spacing for most relationships.

**When to Use:**

- Default inter-element spacing
- Between standard list items
- Between form fields
- Default inset for containers
- Between elements that need both connection and clarity

**When NOT to Use:**

- Between intimately connected elements (use xs or sm)
- Between major sections (use lg or xl)

**Character:** Balanced, comfortable, standard.

---

### lg (Large)

**Intent:** Generous spacing for distinct but related elements.

**When to Use:**

- Between content groups within a section
- Above and below prominent elements
- Between a form and its submit action
- When elements need clear individual presence
- For emphasis through spatial isolation

**When NOT to Use:**

- Between tightly related elements
- When it creates excessive empty space
- Between items in a cohesive list

**Character:** Spacious, distinct, emphasized.

---

### xl (Extra Large)

**Intent:** Maximum separation for section boundaries and major transitions.

**When to Use:**

- Between major content sections
- Between navigation and content
- Above and below hero elements
- Between distinct functional areas
- When creating clear cognitive breaks

**When NOT to Use:**

- Within cohesive content groups
- Between related form fields
- When it fragments content that should feel unified

**Character:** Separated, major pause, boundary.

---

### xxl (Extra Extra Large)

**Intent:** Maximum page-level separation for terminal padding and ultimate visual breaks.

**When to Use:**

- Bottom padding at end of scrollable content
- Between completely unrelated page regions
- Terminal spacing before scroll ends
- Maximum breathing room around hero or featured elements
- Legal/footer content separation from main content

**When NOT to Use:**

- Within any content section
- Between elements that share any conceptual relationship
- When xl already provides sufficient separation
- In compact or density-constrained layouts

**Character:** Terminal, page-level, maximum breathing room.

---

## 5. Spacing and Hierarchy

### Vertical Hierarchy

Vertical spacing establishes reading order and content importance.

**Principle:** More space above an element elevates its importance. Elements preceded by larger spacing feel like new beginnings.

**Application:**

- Headings should have more space above than below (connecting to following content)
- Section starts should have substantial space above
- Related content should have minimal separation
- Important elements deserve spatial isolation

---

### Horizontal Hierarchy

Horizontal spacing establishes grouping and interaction zones.

**Principle:** Horizontal proximity groups elements into units. Horizontal separation defines distinct interactive regions.

**Application:**

- Interactive elements need clear spatial boundaries
- Related actions should be grouped with minimal separation
- Distinct action groups should have clear spatial division
- Touch/tap targets require adequate surrounding space

---

### Spatial Emphasis

Space creates emphasis without weight or color.

**Principle:** Isolated elements command attention. Crowded elements compete for attention.

**Application:**

- Primary actions benefit from spatial isolation
- Important messages deserve breathing room
- Dense information should be broken into spaced groups
- Empty space around key elements creates natural focus

---

## 6. Spacing Rules

### Rule 1: Proximity Reflects Relationship

Elements that are semantically related MUST be spatially close.
Elements that are semantically distinct MUST be spatially separated.

Spacing MUST NOT contradict semantic relationships.

---

### Rule 2: Consistency Within Context

Identical relationships MUST receive identical spacing.

List items of the same type MUST have uniform spacing.
Form fields at the same level MUST have uniform spacing.
Cards in a grid MUST have uniform spacing.

Inconsistent spacing within homogeneous contexts is forbidden.

---

### Rule 3: Progressive Hierarchy

Spacing MUST increase with hierarchical distance.

- xs for atomic groupings
- sm for tight relationships
- md for standard relationships
- lg for loose relationships
- xl for section boundaries

Hierarchy violations (large spacing between related items, small spacing between sections) are forbidden.

---

### Rule 4: Container Inset Proportionality

Inset spacing MUST be proportional to container size and content density.

- Smaller containers may use smaller insets
- Larger containers should use larger insets
- Dense content benefits from more generous insets
- Sparse content may use tighter insets

Insets MUST NOT feel cramped regardless of container size.

---

### Rule 5: Touch Target Respect

Interactive elements MUST have adequate surrounding space for comfortable interaction.

Spacing around interactive elements MUST account for touch/tap accuracy.
Adjacent interactive elements MUST have sufficient separation to prevent mis-taps.

Crowded interactive regions are forbidden.

---

## 7. iOS Spacing Interpretation

### Overall Philosophy

iOS spacing should feel **airy, generous, and flowing**. Vertical rhythm should be noticeably relaxed. The interface should feel like content floating in comfortable space.

iOS users expect interfaces that breathe. Cramped layouts feel foreign and stressful on iOS. Space is a feature of quality.

---

### Inset Spacing on iOS

- Generous by default. Containers should feel protective and spacious.
- Content should never approach container edges closely.
- Modal and sheet insets should feel especially generous.
- Cards should provide substantial breathing room.

---

### Inter-Element Spacing on iOS

- Prefer the larger option when choosing between spacing levels.
- List items should feel individually distinct and tappable.
- Form fields should have clear separation and breathing room.
- Grouped elements should still allow individual recognition.

---

### Section Spacing on iOS

- Section breaks should feel substantial and clear.
- Major transitions deserve significant spatial pause.
- Scrollable content sections should have generous separation.
- The interface should feel organized through space, not dividers.

---

### iOS Rhythm Character

- Flowing and relaxed
- Generous vertical breathing
- Clear spatial hierarchy
- Quality through spaciousness

---

## 8. Android Spacing Interpretation

### Overall Philosophy

Android spacing should feel **comfortable, structured, and efficient**. Vertical rhythm should be generous but grounded. The interface should feel organized and purposeful.

Android users expect interfaces that are both comfortable and practical. Spacing should serve clarity without excess. Structure is communicated through intentional space.

---

### Inset Spacing on Android

- Comfortable and proportionate. Containers should feel organized.
- Content should have clear but efficient padding.
- Modal and dialog insets should feel appropriate to content.
- Cards should provide adequate but not excessive breathing room.

---

### Inter-Element Spacing on Android

- Standard spacing is appropriate for most relationships.
- List items should feel connected and scannable.
- Form fields should have clear separation without excess.
- Grouped elements should feel cohesive and organized.

---

### Section Spacing on Android

- Section breaks should be clear but not excessive.
- Transitions should feel structured and intentional.
- Scrollable content should have clear organization.
- Elevation and surfaces can supplement spatial hierarchy.

---

### Android Rhythm Character

- Organized and structured
- Comfortable vertical rhythm
- Clear but efficient
- Purposeful spacing

---

## 9. Platform Comparison

| Aspect                | iOS                        | Android                      |
| --------------------- | -------------------------- | ---------------------------- |
| Overall density       | Looser, more generous      | Comfortable, slightly denser |
| Inset tendency        | Generous throughout        | Proportionate to context     |
| Inter-element rhythm  | Relaxed, flowing           | Organized, structured        |
| Section breaks        | Substantial spatial pause  | Clear but efficient          |
| Spatial hierarchy cue | Primarily through space    | Space plus elevation         |
| Touch target spacing  | Generous surrounding space | Adequate surrounding space   |

---

## 10. Cognitive Spacing Guidelines

### Grouping Through Proximity

**Principle:** The Gestalt law of proximity dominates spatial perception. Close things belong together.

**Application:**

- Group related controls with minimal spacing
- Separate unrelated controls with substantial spacing
- Use consistent spacing to signal consistent relationships
- Never rely on color alone to group elements—space must reinforce

---

### Breathing Room for Comprehension

**Principle:** Dense information is hard to process. Space aids cognition.

**Application:**

- Complex information needs generous spacing
- Simple information can tolerate tighter spacing
- Important information deserves spatial emphasis
- Reading-heavy content needs vertical breathing room

---

### Rhythm and Predictability

**Principle:** Consistent rhythm creates comfort. Broken rhythm creates attention.

**Application:**

- Maintain consistent spacing within lists and grids
- Break rhythm intentionally for emphasis
- Establish clear spacing patterns users can internalize
- Rhythm violations should be rare and meaningful

---

### Space as Affordance

**Principle:** Space around interactive elements signals interactivity.

**Application:**

- Buttons need surrounding space to feel tappable
- Dense button groups feel less interactive
- Isolated actions feel more important
- Touch targets benefit from generous spacing

---

## 11. Anti-Patterns (Forbidden)

| Anti-Pattern                                | Violation                             |
| ------------------------------------------- | ------------------------------------- |
| Inconsistent list item spacing              | Violates consistency rule             |
| Section-level spacing between related items | Violates proximity-relationship rule  |
| Cramped insets in containers                | Violates inset proportionality        |
| Different spacing for identical elements    | Violates consistency rule             |
| Touch targets crowded together              | Violates touch target respect         |
| Large spacing within atomic groups          | Violates progressive hierarchy        |
| No spacing between major sections           | Violates section spacing requirements |
| Arbitrary spacing without semantic intent   | Violates foundational principle       |

---

## 12. Compliance & Enforcement

### Design Requirements

All layouts MUST use semantic spacing levels (xs, sm, md, lg, xl).

Spacing decisions MUST be justified by spacing category and cognitive intent.

Platform-specific designs MUST follow platform interpretation guidelines.

### Implementation Requirements

Spacing tokens MUST:

- Enforce semantic spacing levels
- Apply platform-appropriate interpretations
- Maintain consistency across similar contexts
- Document any deviations with justification

### Exceptions

Exceptions are permitted only when:

- A platform constraint makes standard spacing impossible
- User research demonstrates comprehension issues
- Content type requires specialized treatment

Exceptions MUST be documented with:

- Specific guideline being violated
- Justification with evidence
- Alternative spacing approach
- Review date for reconsideration

---

**End of Guidelines**
