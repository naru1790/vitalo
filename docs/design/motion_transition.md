# Motion & Transition Guidelines

**Version:** 1.0  
**Status:** Frozen  
**Effective Date:** 2024-12-19  
**Last Review:** —  
**Parent Documents:** Interaction Design Contract, Spacing & Layout Rhythm Guidelines

---

## 1. Purpose & Scope

### Governs

- Semantic motion duration categories and their usage
- Easing philosophies and their emotional qualities
- Motion requirements, permissions, and prohibitions
- Platform-specific motion interpretation for iOS and Android
- Transition behavior for navigation, overlays, and state changes

### Does Not Cover

- Specific timing values or animation curves
- Implementation code or animation APIs
- Micro-interaction details (covered in interaction patterns)
- Loading animation artwork or skeleton shimmer design

### Foundational Principle

Motion is communication. Every transition must have purpose. Motion shows causality, provides feedback, and maintains spatial awareness.

Motion that exists without purpose is visual noise. Motion that contradicts interaction logic creates confusion.

---

## 2. Motion Philosophy

### Motion Communicates Causality

Users must understand _what caused_ a change and _where things went_. Motion bridges the gap between states, answering:

- Where did this come from?
- Where did that go?
- What is the relationship between these states?

### Motion Reinforces Brand

This brand's motion voice is:

- **Fluid and natural** — Motion should feel organic, not mechanical
- **Calm and unhurried** — Motion should feel confident, not rushed
- **Purposeful and clear** — Motion should explain, not decorate
- **Warm and responsive** — Motion should acknowledge interaction immediately

### What We Reject

- Jarring, abrupt transitions that feel broken
- Overly slow, indulgent animations that waste time
- Bouncy, playful motion that feels juvenile
- Complex choreography that distracts from content
- Motion that blocks or delays user progress

### What We Embrace

- Smooth, continuous transitions that feel natural
- Appropriate pacing that respects user time
- Subtle motion that enhances without demanding attention
- Consistent motion language across the app
- Motion that can be reduced or disabled for accessibility

---

## 3. Duration Categories

Motion uses three semantic duration levels. These are relative to each other and to user perception, not absolute time values.

---

### Fast

**Intent:** Immediate, responsive feedback that feels instantaneous.

**Perception:** Should feel like direct response to touch. Users should not perceive waiting.

**When to Use:**

- Micro-feedback (button press, toggle flip)
- State changes on small elements
- Icon transitions
- Ripple and touch feedback
- Color and opacity changes

**Character:** Snappy, immediate, responsive. The user feels in control.

---

### Normal

**Intent:** Comfortable transitions that are noticeable but not slow.

**Perception:** Should feel natural and unhurried. Users perceive motion but don't wait for it.

**When to Use:**

- Standard page transitions
- Dialog and sheet appearance
- List item additions and removals
- Card expansions
- Most navigation transitions

**Character:** Balanced, natural, comfortable. Motion explains without delaying.

---

### Slow

**Intent:** Deliberate, significant transitions that command attention.

**Perception:** Should feel important and considered. Users understand something significant is happening.

**When to Use:**

- First-run and onboarding reveals
- Major mode changes
- Celebration moments
- Full-screen transitions with spatial meaning
- Content that should be savored

**Character:** Deliberate, meaningful, cinematic. Motion marks importance.

---

### Duration Hierarchy

Duration should match significance:

- Micro-interactions → Fast
- Standard transitions → Normal
- Significant moments → Slow

Mismatched duration creates confusion:

- Fast duration on significant changes feels abrupt and broken
- Slow duration on routine interactions feels sluggish and frustrating

---

## 4. Easing Philosophies

Easing defines how motion accelerates and decelerates. These are behavioral philosophies, not mathematical curves.

---

### Ease Out (Decelerate)

**Behavior:** Motion starts quickly and slows to a stop.

**Physical Analogy:** A ball rolling to rest. Energy dissipates naturally.

**Emotional Quality:** Confident arrival. The destination matters.

**When to Use:**

- Elements entering the screen
- Dialogs and sheets appearing
- Content revealing
- Anything arriving at its destination

**Why:** Human perception weights endings. Smooth arrival feels polished and intentional.

---

### Ease In (Accelerate)

**Behavior:** Motion starts slowly and speeds up.

**Physical Analogy:** A ball being pushed, gathering momentum.

**Emotional Quality:** Departure, leaving, release.

**When to Use:**

- Elements exiting the screen
- Dialogs and sheets dismissing
- Content hiding
- Anything leaving its current position

**Why:** Accelerating exit feels like release. The element is "leaving" the user's attention.

---

### Ease In-Out (Symmetric)

**Behavior:** Motion starts slow, speeds in the middle, slows at the end.

**Physical Analogy:** A pendulum swing. Natural, reversible motion.

**Emotional Quality:** Continuous, flowing, reversible.

**When to Use:**

- Transitions between peer views
- Carousel and paging motion
- Looping or continuous animations
- Transitions where neither endpoint is "home"

**Why:** Symmetric easing feels balanced for transitions between equals.

---

### Linear (No Easing)

**Behavior:** Constant speed throughout motion.

**Physical Analogy:** Mechanical movement. Unnatural but precise.

**Emotional Quality:** Functional, utilitarian, progress-oriented.

**When to Use:**

- Progress indicators
- Loading bars
- Countdown timers
- Situations where constant rate communicates progress

**NOT for:**

- Natural transitions
- UI element movement
- Anything that should feel organic

**Why:** Linear motion feels mechanical. Use only when mechanical is appropriate.

---

### Settle (Decelerate with Overshoot)

**Behavior:** Motion overshoots slightly, then settles back to final position.

**Physical Analogy:** A spring coming to rest.

**Emotional Quality:** Playful, energetic, alive.

**When to Use:**

- Celebratory moments
- Attention-grabbing arrivals
- Elements that should feel bouncy or lively
- Pull-to-refresh release

**NOT for:**

- Routine transitions
- Frequent interactions
- Anything that should feel calm

**Why:** Overshoot creates energy and attention. Use sparingly for moments of delight.

---

### Snap

**Behavior:** Motion accelerates rapidly and stops abruptly at target.

**Physical Analogy:** A magnetic snap. Decisive landing.

**Emotional Quality:** Decisive, committed, locked-in.

**When to Use:**

- Snapping to grid positions
- Toggle completion
- Selection confirmation
- Elements finding their "home"

**Why:** Snap communicates finality. The element has found its place.

---

## 5. Motion Requirements

### Motion is Required

Motion MUST be present for:

- **Navigation transitions:** Users must understand where they are going and where they came from
- **Overlay appearance:** Dialogs, sheets, and modals must animate in and out
- **State feedback:** Interactive elements must respond to touch
- **Loading states:** Transitions to and from loading must be smooth
- **Content additions/removals:** List changes must not be instantaneous

Without motion in these contexts, the interface feels broken.

---

### Motion is Optional

Motion MAY be present for:

- Color and opacity changes on non-critical elements
- Icon state changes
- Decorative elements
- Background transitions
- Subtle polish that doesn't affect comprehension

Optional motion should enhance, not distract.

---

### Motion is Forbidden

Motion MUST NOT be present for:

- **Critical feedback:** Error states must appear immediately without delay
- **Blocking UI:** Users must never wait for animation to interact
- **Infinite loops:** No perpetual motion that has no end condition
- **User-blocking decoration:** Motion must never prevent user action
- **Accessibility bypass:** Users who disable motion must have equivalent experience

Motion that blocks, distracts, or harms is forbidden.

---

## 6. Platform Interpretation: iOS

### Overall Philosophy

iOS motion should feel **fluid, continuous, and physically grounded**. Transitions should flow like water—smooth, connected, and natural.

iOS users expect motion that feels integrated with touch. Gestures and animations should form a continuous experience where the UI responds fluidly to finger movement.

---

### Duration on iOS

- **Fast:** Perceptibly instant but still smooth
- **Normal:** Noticeably present, unhurried, comfortable
- **Slow:** Deliberately cinematic, used for significance

iOS durations trend slightly longer than Android. Motion has room to breathe.

---

### Easing on iOS

- Prefer smooth, continuous easing
- Ease Out should feel like natural deceleration
- Transitions should feel connected to physics
- Settle/spring effects are native and expected
- Motion should feel like it has weight and momentum

---

### Navigation on iOS

- Page transitions should feel like layers sliding
- Pushed views should emerge from the right with parallax
- Dismissed views should return with the same path
- Gestures should allow partial, reversible transitions
- The user should feel in control of the motion

---

### Overlays on iOS

- Sheets should rise smoothly from edges
- Dialogs should scale and fade with grace
- Dismissal should follow the same path as appearance
- Gesture-driven dismissal should be fluid and interruptible
- Translucency should enhance spatial awareness

---

### iOS Motion Character

- Fluid and connected
- Slightly slower, more deliberate
- Gesture-integrated
- Physically grounded with natural physics
- Elegant and refined

---

## 7. Platform Interpretation: Android

### Overall Philosophy

Android motion should feel **responsive, decisive, and physics-influenced**. Transitions should feel like intentional state changes—clear, committed, and efficient.

Android users expect motion that confirms actions decisively. Animations should feel like the system responding with confidence to user intent.

---

### Duration on Android

- **Fast:** Crisp, immediate, nearly instant
- **Normal:** Efficient, clear, purposeful
- **Slow:** Reserved for genuinely significant moments

Android durations trend slightly shorter than iOS. Motion is purposeful, not indulgent.

---

### Easing on Android

- Prefer decisive, physics-influenced easing
- Ease Out should feel like confident arrival
- Transitions should feel responsive and snappy
- Settle/spring effects are subtle, not bouncy
- Motion should feel like clear state changes

---

### Navigation on Android

- Page transitions should feel like clear view changes
- Transitions should emphasize the destination, not the journey
- Shared elements should anchor transitions when appropriate
- The system should feel responsive and immediate
- Motion should confirm successful navigation

---

### Overlays on Android

- Sheets should appear with clear, decisive motion
- Dialogs should scale from their trigger point when possible
- Dismissal should be quick and clean
- Motion should confirm user action
- Elevation changes reinforce layering

---

### Android Motion Character

- Responsive and decisive
- Slightly faster, more efficient
- Action-confirming
- Physics-influenced but controlled
- Clear and confident

---

## 8. Navigation Transitions

### Push/Forward Navigation

**Causality:** User is going deeper into content hierarchy.

**Motion:**

- New view enters from the direction of progression (typically trailing edge)
- Previous view may recede or remain as context
- Easing: Ease Out—confident arrival at new destination

**Platform Notes:**

- iOS: Layered slide with parallax depth
- Android: Clean transition emphasizing destination

---

### Pop/Back Navigation

**Causality:** User is returning to previous context.

**Motion:**

- Current view exits toward its origin
- Previous view returns to full presence
- Easing: Ease In for departure, Ease Out for return

**Platform Notes:**

- iOS: Reverse of push, gesture-interruptible
- Android: Quick, decisive return

---

### Peer Navigation (Tabs, Segments)

**Causality:** User is switching between equivalent views.

**Motion:**

- Views slide in direction of navigation
- Easing: Ease In-Out—balanced transition between equals
- No hierarchy implied

**Platform Notes:**

- iOS: Smooth, continuous slide
- Android: May use cross-fade or slide

---

### Modal Presentation

**Causality:** User is entering a focused, temporary context.

**Motion:**

- Modal rises or scales into view
- Background recedes (scrim, scale, or blur)
- Easing: Ease Out—arriving for attention

**Platform Notes:**

- iOS: Rise from bottom with spring settle
- Android: Scale from trigger point or rise

---

## 9. Overlay Transitions

### Dialog Appearance

**Motion:**

- Dialog scales from center or trigger point
- Scrim fades in simultaneously
- Easing: Ease Out with subtle settle
- Duration: Normal

**Dismissal:**

- Dialog scales out or fades
- Scrim fades out
- Easing: Ease In—releasing attention

---

### Sheet Appearance

**Motion:**

- Sheet rises from edge (typically bottom)
- Scrim fades in simultaneously
- Easing: Ease Out with natural deceleration
- Duration: Normal

**Dismissal:**

- Sheet slides back to origin
- Scrim fades out
- Easing: Ease In—departing
- Should support gesture-driven dismissal

---

### Toast/Snackbar Appearance

**Motion:**

- Enters from edge with quick slide
- Easing: Ease Out
- Duration: Fast

**Dismissal:**

- Slides out or fades
- Easing: Ease In
- Duration: Fast

---

### Dropdown/Popover Appearance

**Motion:**

- Expands from trigger point
- Easing: Ease Out with slight settle
- Duration: Fast

**Dismissal:**

- Collapses toward trigger point
- Easing: Ease In
- Duration: Fast

---

## 10. State Transitions

### Loading State Entry

**Motion:**

- Smooth transition to loading indicator
- Content may fade or skeleton may fade in
- Easing: Ease Out
- Duration: Fast—don't delay showing loading state

---

### Loading State Exit

**Motion:**

- Loading indicator fades or exits
- Content fades or animates in
- Easing: Ease Out
- Duration: Normal—content deserves comfortable arrival

---

### Empty State Transition

**Motion:**

- Empty state fades in gently
- Should feel calm, not abrupt
- Easing: Ease Out
- Duration: Normal

---

### Error State Transition

**Motion:**

- Immediate appearance—no delayed animation
- May have subtle attention-getting motion after appearance
- Error must be visible before animation completes
- Duration: Fast or none

---

### Success State Transition

**Motion:**

- Smooth transition to success state
- May include subtle celebration (settle, pulse)
- Easing: Ease Out with optional settle
- Duration: Normal

---

### Selection State Change

**Motion:**

- Immediate visual feedback
- Smooth transition between selected/deselected
- Easing: Ease Out
- Duration: Fast

---

## 11. Interactive Motion

### Touch Feedback

**Motion:**

- Immediate response to touch down
- No perceptible delay
- Easing: None needed—instant
- Duration: Fast

---

### Drag and Gesture

**Motion:**

- Element follows finger directly during drag
- Momentum should continue briefly after release
- Snap to final position with appropriate easing
- Easing: Direct tracking, then Settle or Snap
- Should be interruptible at any point

---

### Pull to Refresh

**Motion:**

- Resistance increases as user pulls
- Threshold provides haptic/visual feedback
- Release triggers refresh indicator
- Easing: Settle on release
- Duration: Fast for release, then loading behavior

---

### Swipe Actions

**Motion:**

- Actions reveal with swipe
- Rubber-band at limits
- Snap to open or closed state
- Easing: Snap to final position
- Duration: Fast

---

## 12. Choreography Principles

### Staggered Entry

When multiple elements enter:

- Elements should appear in logical reading order
- Stagger should be perceptible but not slow
- Total choreography should not exceed Normal duration
- Stagger is for clarity, not decoration

---

### Shared Element Transitions

When an element persists across views:

- The element should transform continuously
- User should perceive it as the "same" element
- Motion should explain the relationship
- Anchor transforms to establish spatial continuity

---

### Coordinated Motion

When multiple elements move together:

- Motion should feel unified, not chaotic
- Related elements should move as a group
- Unrelated elements should not compete for attention
- Hierarchy determines motion precedence

---

## 13. Accessibility Requirements

### Reduced Motion

When users enable reduced motion:

- Transitions MUST still communicate state change
- Animations MAY be replaced with instant transitions or fades
- Spatial relationships MUST still be clear
- No information may be lost

### Motion Reduction Strategy

- Replace slide transitions with fades
- Remove decorative motion entirely
- Maintain feedback motion at reduced intensity
- Ensure loading states remain visible
- Preserve causality communication

### Never Disable

Even in reduced motion mode:

- Progress indicators must still update
- Loading states must be visible
- State changes must be perceivable
- Feedback must occur (even if static)

---

## 14. Platform Comparison Summary

| Aspect              | iOS                        | Android                         |
| ------------------- | -------------------------- | ------------------------------- |
| Overall feel        | Fluid, continuous, elegant | Responsive, decisive, efficient |
| Duration tendency   | Slightly longer            | Slightly shorter                |
| Easing character    | Smooth, spring-influenced  | Snappy, physics-grounded        |
| Navigation feel     | Layered, parallax depth    | Clear state changes             |
| Gesture integration | Central to experience      | Supportive of actions           |
| Overlay behavior    | Rise and float             | Scale and confirm               |
| Interruptibility    | Expected and fluid         | Supported and clean             |

---

## 15. Anti-Patterns (Forbidden)

| Anti-Pattern                          | Violation                    |
| ------------------------------------- | ---------------------------- |
| Instant navigation without transition | Violates causality principle |
| Slow motion on routine actions        | Violates pacing respect      |
| Bouncy motion on serious contexts     | Violates brand consistency   |
| Animation that blocks interaction     | Violates user respect        |
| Different motion for same action type | Violates consistency         |
| Motion without purpose                | Violates purpose principle   |
| Linear easing on UI elements          | Violates natural motion      |
| Infinite loops without stop condition | Violates motion prohibition  |
| Motion that cannot be reduced         | Violates accessibility       |
| Delayed error state appearance        | Violates feedback priority   |

---

## 16. Compliance & Enforcement

### Design Requirements

All motion specifications MUST reference semantic durations and easing philosophies.

Motion choices MUST be justified by causality and communication purpose.

### Implementation Requirements

Motion tokens MUST:

- Resolve semantic durations per platform
- Apply platform-appropriate easing
- Support reduced motion preferences
- Maintain consistent motion language

### Exceptions

Exceptions are permitted only when:

- A platform constraint requires specific motion behavior
- User research demonstrates motion confusion
- Third-party components enforce different behavior

Exceptions MUST be documented with:

- Specific guideline being violated
- Platform-specific justification
- Alternative approach taken
- Review date for reconsideration

---

**End of Guidelines**
