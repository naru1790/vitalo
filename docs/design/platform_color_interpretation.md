# Platform Color Interpretation Guidelines

**Version:** 1.0  
**Status:** Frozen  
**Effective Date:** 2024-12-19  
**Last Review:** —  
**Parent Document:** Color Semantics Contract

---

## 1. Purpose & Scope

### Governs

- Platform-specific interpretation of semantic color roles
- Emotional and perceptual differences between iOS and Android
- Translucency, layering, and elevation treatment per platform
- Dark mode interpretation strategies

### Does Not Cover

- Semantic role definitions (see Color Semantics Contract)
- Specific color values or tokens
- Widget or component implementations
- Accessibility contrast requirements (covered separately)

### Foundational Principle

Semantic color roles are universal. This document defines how those roles should _feel_ and _behave_ differently on each platform while preserving identical meaning.

No platform-specific semantic roles may be introduced. The same role names must resolve to platform-appropriate interpretations.

---

## 2. Brand Position

This brand rejects:

- Material Design's grey-heavy, low-saturation, monochromatic surface philosophy
- Cupertino's system blue as a default accent
- Muted, corporate, or clinical color language
- Platform defaults that dilute brand vibrancy

This brand embraces:

- Vibrant, saturated, optimistic color expression
- Warmth and approachability in every surface
- Playful energy that feels alive on both platforms
- Native behavior with non-native color personality

---

## 3. iOS Interpretation Philosophy

iOS users expect interfaces that feel light, fluid, and spatially aware. Surfaces float. Layers breathe. Interactions feel like touching glass.

The iOS interpretation of this brand should feel **luminous and airy**. Colors should appear to glow softly rather than sit flatly. Surfaces should suggest depth through subtle translucency rather than hard shadows. The overall impression should be one of effortless vibrancy—as if the interface is lit from within.

iOS tolerates higher saturation in accent colors but expects restraint in surface colors. The brand's energy should concentrate in interactive elements while backgrounds remain calm and breathable.

---

## 4. Android Interpretation Philosophy

Android users expect interfaces that feel bold, tangible, and grounded. Surfaces have presence. Layers stack with clear hierarchy. Interactions feel like pressing something real.

The Android interpretation of this brand should feel **warm and confident**. Colors should appear rich and solid rather than ethereal. Surfaces should communicate hierarchy through elevation and subtle shadow rather than transparency. The overall impression should be one of approachable strength—vibrant but stable.

Android tolerates bolder surface treatments and more saturated backgrounds. The brand's energy can spread more broadly across the interface while maintaining clear visual hierarchy through elevation.

---

## 5. Brand Color Interpretation

### Brand Primary

**iOS:** Should feel radiant and slightly luminous. May appear marginally more saturated to compensate for iOS's tendency to render colors with cooler undertones. Should feel like a confident glow.

**Android:** Should feel bold and grounded. May appear marginally warmer to harmonize with Android's rendering characteristics. Should feel like a strong, stable presence.

**Both:** Must remain immediately recognizable as the same brand color. Perceptual warmth and energy must match across platforms.

---

### Brand Secondary

**iOS:** Should feel harmonious and supportive. Should recede gracefully behind Primary without appearing washed out. May use slightly higher saturation to maintain presence on translucent surfaces.

**Android:** Should feel complementary and reliable. Should clearly differentiate from Primary while maintaining family relationship. May use slightly deeper tone to communicate secondary hierarchy.

**Both:** Must never compete with Primary for attention. Must feel like the same supporting voice on both platforms.

---

### Brand Accent

**iOS:** Should feel delightful and sparkling. May express maximum vibrancy here. Should appear to "pop" against surfaces without feeling aggressive. This is where the brand's playfulness lives.

**Android:** Should feel lively and celebratory. May express bold saturation. Should create clear moments of delight without overwhelming the interface. This is where the brand's energy concentrates.

**Both:** Must feel joyful and special. This color signals delight, reward, and positive moments. Must never be used for errors or warnings.

---

## 6. Background & Surface Interpretation

### Background (Neutral Base)

**iOS:** Should feel like soft, warm light. Not pure white—should carry the faintest warmth. Should feel like the interface is breathing. Translucency from overlaying elements should blend naturally.

**Android:** Should feel like a clean, warm canvas. Not pure white—should carry subtle warmth. Should feel stable and grounded. Elevation shadows should fall naturally without harsh contrast.

**Both:** Must feel airy and welcoming. Must never feel clinical, cold, or sterile.

---

### Surface (Neutral Surface)

**iOS:** Should feel like frosted glass floating above the background. May carry very subtle translucency. Edges should feel soft. Should appear to hover rather than sit.

**Android:** Should feel like elevated paper with gentle presence. Should use subtle shadow to communicate lift. Edges should feel defined but not harsh. Should appear to stack rather than float.

**Both:** Must feel light and approachable. Must clearly differentiate from background without creating harsh boundaries.

---

### Surface Elevated

**iOS:** Should feel like a focused layer demanding attention. May use blur and translucency to create separation. Should feel like content is emerging toward the user. Modal contexts should feel intimate, not trapped.

**Android:** Should feel like a prominent surface commanding focus. Should use deeper shadow to communicate importance. Should feel like content is lifted to the user. Modal contexts should feel intentional and grounded.

**Both:** Must create clear focus hierarchy. Must feel special without feeling heavy or oppressive.

---

## 7. Feedback Color Interpretation

### Success

**iOS:** Should feel like a gentle celebration. Warm, affirming, but not aggressive. Should suggest "well done" rather than shout it. May lean slightly warmer than a pure green.

**Android:** Should feel like a confident reward. Clear, positive, celebratory. Should communicate achievement with warmth. May appear slightly more saturated to maintain presence against elevated surfaces.

**Both:** Must feel rewarding and affirming. Must never feel clinical or purely functional.

---

### Warning

**iOS:** Should feel like a soft nudge. Attentive without alarming. Should suggest "pay attention" gently. Should feel caring, not scolding.

**Android:** Should feel like a clear signal. Noticeable without being harsh. Should communicate caution warmly. Should feel protective, not punitive.

**Both:** Must feel helpful and caring. Must never feel aggressive or anxiety-inducing.

---

### Error

**iOS:** Should feel serious but supportive. Clear that something needs attention without creating panic. Should feel like a helping hand, not a slap.

**Android:** Should feel clear but recoverable. Unmistakable that action is needed while maintaining warmth. Should feel like guidance, not punishment.

**Both:** Must communicate importance while maintaining emotional safety. Must never feel harsh, accusatory, or hopeless.

---

### Info

**iOS:** Should feel like a friendly whisper. Informative without demanding attention. Should blend naturally into the interface while remaining readable.

**Android:** Should feel like helpful context. Present without being pushy. Should integrate with surfaces while remaining distinct.

**Both:** Must feel helpful and unobtrusive. Must never compete with brand colors for attention.

---

## 8. Utility Color Interpretation

### Divider

**iOS:** Should be barely perceptible. Suggest structure without drawing the eye. May use very low opacity. Should feel like the interface is organized by light rather than lines.

**Android:** Should be subtle but present. Define boundaries without creating visual noise. May use slightly higher opacity than iOS. Should feel like gentle structure.

**Both:** Must never draw attention. Must create order invisibly.

---

### Disabled

**iOS:** Should feel resting, not broken. Clearly non-interactive but not ugly. Should suggest patience, as if waiting to become active.

**Android:** Should feel dormant, not dead. Obviously unavailable but not harsh. Should suggest temporary state rather than permanent limitation.

**Both:** Must remain readable. Must never feel like an error or broken state.

---

### Skeleton

**iOS:** Should feel like gentle anticipation. Soft shimmer if animated. Should suggest content is arriving, not missing. Warm undertone preferred over grey.

**Android:** Should feel like patient loading. Subtle pulse if animated. Should suggest progress, not emptiness. Warm undertone preferred over grey.

**Both:** Must feel optimistic about incoming content. Must never feel broken, empty, or alarming.

---

## 9. Translucency & Overlay Interpretation

### iOS Approach

Translucency is a native expectation. Use it intentionally:

- Navigation surfaces MAY use subtle translucency to suggest spatial depth
- Modal scrims SHOULD use translucency with blur to create intimate focus
- Overlays SHOULD feel like light dimming rather than obstruction
- Translucency MUST NOT obscure critical content or create readability issues

Translucency should feel like looking through frosted glass—content beneath is suggested, not readable.

---

### Android Approach

Translucency is optional and should be used sparingly:

- Navigation surfaces SHOULD be opaque with clear elevation
- Modal scrims SHOULD use opacity without blur for clear separation
- Overlays SHOULD feel like a layer placed on top rather than light dimming
- Elevation and shadow communicate hierarchy more naturally than transparency

Opacity changes should feel like surface stacking—clear layers with defined boundaries.

---

### Scrim (Both Platforms)

**iOS:** Should feel like soft twilight. Dim without darkening harshly. May include subtle blur. Should create intimacy, not isolation.

**Android:** Should feel like focused dimming. Clear separation without feeling heavy. Should use opacity rather than blur. Should create attention, not claustrophobia.

**Both:** Must create modal focus without feeling oppressive. Must allow graceful dismissal.

---

## 10. Dark Mode Interpretation

### Philosophy

Dark mode is not an inversion. It is a reinterpretation that preserves brand energy in low-light contexts.

Dark mode MUST:

- Preserve brand recognition and emotional tone
- Maintain the same semantic relationships between colors
- Feel vibrant and alive, not muted or depressed
- Protect user eyes without sacrificing brand personality

Dark mode MUST NOT:

- Simply invert light mode colors
- Desaturate brand colors into grey
- Create harsh contrast that feels aggressive
- Lose the warm, optimistic brand character

---

### iOS Dark Mode

Should feel like the brand at night—still warm, still glowing, but gentler. Surfaces should feel like soft pools of dark rather than black voids. Brand colors should appear to illuminate the interface from within. The overall impression should be cozy and intimate, not cold or harsh.

Background should be a warm dark, not pure black. Surfaces should lift with subtle luminosity rather than shadow. Translucency effects may increase to maintain spatial awareness.

---

### Android Dark Mode

Should feel like the brand in a dim room—still confident, still present, but restful. Surfaces should feel like elevated layers emerging from darkness. Brand colors should remain bold and readable. The overall impression should be calm and grounded, not flat or lifeless.

Background should be a true dark with warm undertones. Surfaces should communicate hierarchy through subtle lightening and refined shadows. Elevation becomes more important as shadow becomes less visible.

---

### Brand Colors in Dark Mode

**Brand Primary:** Must remain vibrant and recognizable. May shift slightly to maintain contrast and reduce eye strain. Must never appear washed out or muted.

**Brand Secondary:** Must maintain relationship to Primary. May increase in luminosity slightly to remain visible. Must never compete with Primary.

**Brand Accent:** May be the most saturated element in dark mode. Should feel like moments of delight in darkness. Must never feel garish or overwhelming.

---

### Feedback Colors in Dark Mode

All feedback colors must remain immediately distinguishable. Success, Warning, Error, and Info must maintain their semantic clarity without becoming harsh.

Feedback colors may shift slightly toward brighter variants to maintain contrast, but must preserve their emotional tone. Success must still feel rewarding. Warning must still feel caring. Error must still feel supportive-serious.

---

## 11. Platform Adaptation Summary

| Aspect           | iOS                     | Android                     |
| ---------------- | ----------------------- | --------------------------- |
| Overall feel     | Luminous, airy, fluid   | Warm, confident, grounded   |
| Brand expression | Radiant glow            | Bold presence               |
| Surfaces         | Floating, translucent   | Stacked, elevated           |
| Hierarchy cue    | Translucency + blur     | Shadow + elevation          |
| Dividers         | Nearly invisible        | Subtle but present          |
| Overlays         | Light dimming with blur | Layer stacking with opacity |
| Dark mode        | Cozy, glowing warmth    | Calm, grounded depth        |

---

## 12. Compliance & Enforcement

### Design Requirements

Platform-specific designs MUST declare which interpretation guidelines informed color decisions.

### Implementation Requirements

Platform token mappings MUST:

- Resolve the same semantic role names on both platforms
- Apply platform-appropriate interpretation as defined in this document
- Document any deviations with justification

### Exceptions

Exceptions are permitted only when:

- A platform constraint makes interpretation impossible
- User research demonstrates perceptual confusion

Exceptions MUST be documented with:

- Specific guideline being violated
- Platform-specific justification
- Alternative approach taken
- Review date for reconsideration

---

**End of Guidelines**
