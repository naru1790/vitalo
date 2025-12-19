# Shape Language Guidelines

**Version:** 1.0  
**Status:** Frozen  
**Effective Date:** 2024-12-19  
**Last Review:** —  
**Parent Documents:** Color Semantics Contract, Platform Color Interpretation Guidelines, Spacing & Layout Rhythm Guidelines

---

## 1. Purpose & Scope

### Governs

- Semantic shape tokens for corner radius
- Stroke and border usage rules
- Divider presence and perception
- Platform-specific shape interpretation for iOS and Android
- Shape interaction with surfaces and elevation

### Does Not Cover

- Specific numeric values for radii or stroke widths
- Shadow specifications (governed by elevation system)
- Icon shapes (governed by Icon Semantics)
- Illustration or decorative artwork

### Foundational Principle

Shape communicates character. Corners, edges, and boundaries define how an interface _feels_ before users consciously notice them.

Shape language must be minimal and consistent. Fewer shape tokens used consistently create stronger brand recognition than varied shapes used arbitrarily.

---

## 2. Shape Philosophy

### Shape Communicates Feel

Shape affects emotional perception:

- Rounded shapes feel friendly, approachable, soft
- Sharp shapes feel precise, formal, technical
- Consistent shapes feel intentional and polished
- Inconsistent shapes feel careless and chaotic

### Brand Shape Character

This brand's shape voice is:

- **Friendly but not childish** — Soft edges without being bubbly
- **Modern but not cold** — Clean lines with warmth
- **Calm and approachable** — Shapes that welcome, not intimidate
- **Consistent and intentional** — Every corner has purpose

### What We Reject

- Harsh, purely rectangular shapes that feel cold or clinical
- Overly rounded, pill-shaped elements that feel juvenile
- Mixed corner radii on the same element
- Arbitrary shape variation between similar components
- Sharp corners on touchable surfaces

### What We Embrace

- Gentle, consistent rounding that feels human
- Clear shape hierarchy that reinforces component relationships
- Platform-appropriate interpretation of the same shape intent
- Minimal shape vocabulary applied consistently

---

## 3. Corner Radius Tokens

The shape system uses four semantic radius levels. These are relative to each other and to component scale, not absolute values.

---

### radius.none

**Intent:** No rounding. Deliberately rectangular.

**Character:** Technical, structured, precise.

**When to Use:**

- Full-bleed content areas
- Edge-to-edge images within rounded containers
- Dividers and separators
- Progress bar tracks
- Elements that should feel structural, not touchable

**When NOT to Use:**

- Interactive buttons or cards
- Touchable surfaces
- Containers users interact with directly

---

### radius.sm

**Intent:** Subtle softening. Barely perceptible rounding.

**Character:** Clean, modern, slightly softened.

**When to Use:**

- Small interactive elements (chips, tags, badges)
- Input field containers
- Inline buttons
- Small cards or tiles
- Elements where space is constrained

**When NOT to Use:**

- Large containers or cards
- Primary action buttons
- Modal dialogs

---

### radius.md

**Intent:** Default comfortable rounding. Friendly but not playful.

**Character:** Approachable, balanced, warm.

**When to Use:**

- Standard cards and containers
- Primary and secondary buttons
- List item containers
- Form containers
- Most touchable surfaces

**Platform Role:** This is the workhorse radius. Most UI elements should use this level.

---

### radius.lg

**Intent:** Pronounced rounding. Soft, welcoming, prominent.

**Character:** Friendly, soft, embracing.

**When to Use:**

- Modal dialogs and sheets
- Floating action buttons
- Prominent cards requiring emphasis
- Avatar and profile image masks
- Elements that should feel especially soft

**When NOT to Use:**

- Small components where rounding overwhelms
- Dense layouts where softness creates visual noise
- Technical or data-heavy interfaces

---

### radius.full

**Intent:** Fully rounded to circular or pill shape.

**Character:** Playful, distinct, complete.

**When to Use:**

- Circular buttons (icon-only actions)
- Avatar images
- Status indicators and dots
- Toggle switch tracks and thumbs
- Elements explicitly designed as pills

**When NOT to Use:**

- Standard buttons with text
- Cards or containers
- Any element where pill shape feels forced

---

## 4. Radius Hierarchy Principle

Radius should relate to component importance and touch area:

| Component Scale          | Appropriate Radius       |
| ------------------------ | ------------------------ |
| Tiny (badges, dots)      | radius.sm or radius.full |
| Small (chips, tags)      | radius.sm                |
| Medium (buttons, inputs) | radius.md                |
| Large (cards, dialogs)   | radius.md or radius.lg   |
| Circular elements        | radius.full              |

**Rule:** Larger components may use larger radii. Smaller components should not use radii that overwhelm their size.

---

## 5. Stroke (Border) Tokens

The shape system uses three semantic stroke levels.

---

### stroke.none

**Intent:** No visible border. Surface relies on fill or elevation.

**When to Use:**

- Elevated cards with shadow
- Filled buttons
- Surfaces differentiated by background color
- Most primary interactive elements

**Character:** Clean, confident, relying on other visual cues.

---

### stroke.subtle

**Intent:** Barely visible border for definition without emphasis.

**Character:** Quiet, structural, supporting.

**When to Use:**

- Input field containers (inactive state)
- Cards on same-color backgrounds needing definition
- Segmented control boundaries
- Subtle container definition

**When NOT to Use:**

- Active or focused states (use stroke.visible)
- When elevation provides sufficient definition

---

### stroke.visible

**Intent:** Clearly visible border for emphasis or state.

**Character:** Defined, emphasized, intentional.

**When to Use:**

- Input field focus states
- Selected states requiring border emphasis
- Outlined button variants
- Active segment indicators
- When border is the primary visual differentiator

**When NOT to Use:**

- General container definition (prefer elevation or fill)
- When border creates visual noise

---

## 6. Border Usage Rules

### Rule 1: Prefer Elevation Over Borders

For most containers and cards, elevation (shadow) should provide definition rather than borders.

Borders are a secondary tool for definition. Elevation feels more natural and less constraining.

---

### Rule 2: Borders Indicate State, Not Structure

Borders are most appropriate for communicating:

- Focus states
- Selection states
- Input field boundaries
- Explicit containment that must be visible

Borders should not be the default way to show where containers are.

---

### Rule 3: Border Color Follows Semantic System

Border colors MUST come from the color semantics system:

- Neutral divider color for subtle borders
- Brand primary for focus and selection
- Feedback colors for validation states

Arbitrary border colors are forbidden.

---

### Rule 4: Border Radius Matches Container Radius

When a border is present, its corner radius MUST match the container's corner radius.

Mixed radii between container and border are forbidden.

---

### Rule 5: Avoid Double Borders

Nested containers should not both have visible borders. If a container within a container needs definition, use background color or spacing, not additional borders.

---

## 7. Divider Tokens

Dividers separate content. They should be felt more than seen.

---

### divider.none

**Intent:** No visible divider. Separation through spacing alone.

**When to Use:**

- When spacing provides sufficient separation
- Between loosely related content
- In minimal, clean interfaces
- When dividers would add visual noise

**Character:** Open, spacious, clean.

---

### divider.subtle

**Intent:** Barely visible divider. Present but not attention-seeking.

**When to Use:**

- Between list items in long lists
- Between sections within a card
- Where structure is needed but emphasis is not
- Default divider choice for most contexts

**Character:** Quiet, organizational, invisible until needed.

---

### divider.visible

**Intent:** Clearly visible divider for explicit separation.

**When to Use:**

- Between major content sections
- Above or below fixed navigation elements
- Where cognitive separation is important
- When users must perceive a clear boundary

**When NOT to Use:**

- Between list items (too heavy)
- Where spacing alone suffices

**Character:** Clear, structural, intentional.

---

## 8. Divider Usage Rules

### Rule 1: Space Before Dividers

Always prefer spacing over dividers. Dividers are a tool of last resort when spacing alone cannot communicate separation.

---

### Rule 2: Dividers Are Quiet

Dividers should never compete with content for attention. If a divider is noticeable, it is too prominent.

---

### Rule 3: Consistent Divider Treatment

The same list type should use the same divider treatment throughout the app. Inconsistent divider usage creates cognitive noise.

---

### Rule 4: Divider Inset Matches Content

Dividers should align with content, not container edges. If content has inset padding, dividers should match that inset to feel connected to the content they separate.

---

### Rule 5: No Dividers at Edges

Dividers should not appear at the top or bottom of a list—only between items. Edge dividers create visual clutter.

---

## 9. Platform Interpretation: iOS

### Overall Philosophy

iOS shapes should feel **soft, blended, and refined**. Corners should feel gently rounded, borders should be understated, and surfaces should feel like they flow into each other.

iOS users expect shapes that feel natural and organic. Sharp edges feel foreign; soft edges feel native.

---

### Corner Radius on iOS

- **radius.sm:** Subtly softened, almost imperceptible
- **radius.md:** Noticeably rounded, friendly, comfortable
- **radius.lg:** Soft and welcoming, generous rounding
- **radius.full:** Perfectly circular or pill-shaped

iOS radii trend slightly larger than Android for the same semantic level. Corners feel softer overall.

---

### Borders on iOS

- Prefer no borders when possible
- When borders are needed, use subtle, translucent strokes
- Focus states may use softer, glowing borders rather than hard strokes
- Borders should blend rather than define

---

### Dividers on iOS

- Prefer very subtle, nearly invisible dividers
- Use spacing as primary separation
- Divider opacity should be lower than Android
- Dividers should feel like gentle suggestions, not hard lines

---

### iOS Shape Character

- Softer, more generous rounding
- Minimal border reliance
- Subtle, blended dividers
- Shapes feel organic and flowing

---

## 10. Platform Interpretation: Android

### Overall Philosophy

Android shapes should feel **clean, structured, and intentional**. Corners should feel deliberately rounded but not excessive, and surfaces should feel clearly defined.

Android users expect shapes that feel precise and purposeful. Rounding should feel like a design choice, not a default.

---

### Corner Radius on Android

- **radius.sm:** Clean, subtle softening
- **radius.md:** Clear rounding, balanced, comfortable
- **radius.lg:** Pronounced but not excessive
- **radius.full:** Perfectly circular or pill-shaped

Android radii trend slightly smaller than iOS for the same semantic level. Corners feel more defined.

---

### Borders on Android

- Borders are more acceptable as definition tools
- Subtle borders may define containers on flat surfaces
- Focus states use clear, visible border changes
- Borders feel structured and intentional

---

### Dividers on Android

- Dividers may be slightly more visible than iOS
- Still prefer spacing, but dividers are more acceptable
- Divider opacity may be higher than iOS
- Dividers feel like clear organizational tools

---

### Android Shape Character

- Cleaner, more defined rounding
- Structured border usage
- Clearer, more visible dividers
- Shapes feel precise and intentional

---

## 11. Shape and Surface Interaction

### Elevated Surfaces

When a surface has elevation (shadow):

- Borders are typically unnecessary
- The shadow provides visual definition
- Focus on corner radius, not stroke
- Let the shadow do the work

---

### Flat Surfaces

When a surface has no elevation:

- Consider subtle border for definition if needed
- Background color difference may provide definition
- Spacing may be sufficient
- Border is last resort

---

### Nested Containers

When containers are nested:

- Inner container radius should be smaller than outer
- Or inner container should have no radius (radius.none)
- Radii should not compete or clash
- Spacing should separate nested surfaces

---

### Overlapping Surfaces

When surfaces overlap (modals, sheets):

- Top surface should have radius.lg or radius.md
- Top surface should have elevation
- No border needed on elevated overlapping surfaces
- Shape distinguishes the layer

---

## 12. Shape Consistency Rules

### Rule 1: Same Component, Same Shape

All instances of the same component type MUST use the same shape tokens.

Cards should always have the same radius. Buttons should always have the same radius.

---

### Rule 2: Related Components, Related Shapes

Components in the same family should use related radius levels.

If primary buttons use radius.md, secondary buttons should also use radius.md.

---

### Rule 3: Context Doesn't Change Shape

The same component in different contexts should maintain its shape.

A card in a list should have the same radius as a card on its own.

---

### Rule 4: Shape Scale With Component

If a component scales significantly, shape may scale proportionally.

A large hero card may use radius.lg while a compact card uses radius.md, as long as both are used consistently.

---

## 13. Platform Comparison Summary

| Aspect            | iOS                    | Android                |
| ----------------- | ---------------------- | ---------------------- |
| Radius feeling    | Softer, more generous  | Cleaner, more defined  |
| Border presence   | Minimal, translucent   | Structured, acceptable |
| Border style      | Blended, glowing focus | Clear, visible focus   |
| Divider opacity   | Very subtle            | Slightly more visible  |
| Overall character | Organic, flowing       | Precise, intentional   |

---

## 14. Anti-Patterns (Forbidden)

| Anti-Pattern                             | Violation                          |
| ---------------------------------------- | ---------------------------------- |
| Sharp corners on touch targets           | Violates approachability principle |
| Mixed radii on same element              | Violates consistency rule          |
| Different radius for same component type | Violates same-component rule       |
| Heavy borders as primary definition      | Violates elevation-first principle |
| Dividers at list edges                   | Violates divider usage rule        |
| Prominent, attention-grabbing dividers   | Violates quiet divider principle   |
| Arbitrary radius choices                 | Violates token system              |
| Nested containers with competing radii   | Violates nesting rule              |
| Borders without matching radius          | Violates radius matching rule      |
| Pill shapes on standard buttons          | Violates radius.full usage         |

---

## 15. Compliance & Enforcement

### Design Requirements

All shape decisions MUST reference semantic tokens from this system.

Shape choices MUST be consistent across component instances.

Platform-specific designs MUST follow platform interpretation guidelines.

### Implementation Requirements

Shape tokens MUST:

- Resolve semantic levels per platform
- Apply consistent radii per component type
- Enforce border and divider rules
- Support platform-appropriate interpretation

### Exceptions

Exceptions are permitted only when:

- Third-party components enforce different shapes
- Platform constraints require specific treatment
- User research demonstrates perception issues

Exceptions MUST be documented with:

- Specific guideline being violated
- Justification with evidence
- Alternative approach taken
- Review date for reconsideration

---

**End of Guidelines**
