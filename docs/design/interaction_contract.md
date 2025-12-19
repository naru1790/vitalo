# Interaction Design Contract

**Version:** 1.0  
**Status:** Frozen  
**Effective Date:** 2024-12-19  
**Last Review:** —

---

## 1. Purpose & Scope

### Governs

- All user-initiated interactions and their outcomes
- Feedback mechanisms for success, failure, and progress
- Error presentation and recovery flows
- UI state definitions and transitions
- Platform-adaptive behavior boundaries

### Does Not Cover

- Visual design specifications (colors, typography, spacing)
- Animation duration values or easing curves
- Backend API contracts or data models
- Accessibility implementation details (covered separately)
- Onboarding or first-run experiences

---

## 2. Core Interaction Rules

### One Action, One Outcome

Every tappable element MUST produce exactly one predictable outcome. Ambiguous or conditional behaviors based on hidden state are forbidden.

### Primary vs Secondary Actions

- Each screen MUST have at most one primary action
- Primary actions MUST be visually dominant and positioned consistently
- Secondary actions MUST NOT compete for visual attention with the primary action
- Destructive actions MUST NOT be styled as primary actions

### Immediate Acknowledgment

- User input MUST produce visual acknowledgment within 100ms
- If the resulting operation exceeds 300ms, a loading state MUST appear
- No interaction may leave the user without feedback for more than 100ms

---

## 3. Success Feedback Rules

### Silent State Change

Success MUST be communicated through UI state change alone. The interface MUST reflect the new state immediately upon success.

### Forbidden Success Indicators

- Success dialogs
- Success snackbars
- Success toasts
- Success banners
- Any modal or overlay celebrating completion

### Allowed Success Indicators

- Item appears in list
- Navigation to next logical screen
- Toggle state reflects new value
- Counter updates
- Visual element changes state (e.g., bookmark fills)

---

## 4. Loading & Progress States

### Local Loading

- Operations affecting a single component MUST show loading within that component
- Local loading MUST NOT block unrelated UI regions
- Buttons MUST show inline loading indicators, not global overlays

### Global Loading

- Global loading is permitted only when the entire screen depends on a single operation
- Global loading MUST NOT be used for partial data fetches

### Skeletons vs Spinners

- Initial data loads MUST use skeleton placeholders matching content layout
- Subsequent loads or refreshes MAY use spinners
- Spinners MUST NOT replace content that is already visible

### Blocking UI

- UI MUST remain responsive during network operations
- Blocking the entire interface is permitted only for authentication flows and critical writes
- Blocked UI MUST show a clear loading indicator

---

## 5. Reversibility & Undo

### Reversible Actions

Actions that modify data non-destructively MUST provide an undo mechanism. The undo affordance MUST appear immediately after the action.

### Time-Bound Undo

- Undo MUST remain available for a minimum of 5 seconds
- Undo MUST remain visible until the time expires or the user navigates away
- Expired undo MUST dismiss silently without confirmation

### Destructive Actions

- Destructive actions MUST require explicit confirmation before execution
- Confirmation MUST name the item being destroyed
- Confirmation MUST NOT use ambiguous language ("Are you sure?")
- Confirmation MUST state the consequence ("This will permanently delete X")

### Irreversible Actions

- Irreversible actions MUST be confirmed with a destructive-styled button
- Irreversible actions MUST NOT be the default or pre-selected option

---

## 6. Error Handling Hierarchy

Errors MUST be presented at the lowest sufficient level:

1. **Inline** — Field-level validation errors appear adjacent to the input
2. **Local** — Component-level errors appear within the affected region
3. **Dialog** — Critical errors requiring user decision appear as modal dialogs
4. **Full Screen** — Unrecoverable errors blocking all functionality use full-screen states

### Dialog Usage

Dialogs are permitted only when:

- User decision is required to proceed
- The error affects the entire current flow
- No inline or local presentation is sufficient

### Error Message Standards

- Messages MUST state what went wrong in plain language
- Messages MUST NOT expose technical details, codes, or stack traces
- Messages MUST suggest a recovery action when one exists
- Messages MUST NOT blame the user

---

## 7. UI State Definitions

### Required States

Every data-driven screen MUST explicitly handle:

- **Empty** — No data exists
- **Loading** — Data is being fetched
- **Content** — Data is available and displayed
- **Error** — Data fetch failed

Optional states:

- **Partial** — Some data available, more loading
- **Offline** — No network connectivity

### Transition Rules

- State transitions MUST be immediate; no undefined intermediate states
- Transitions between states MUST NOT cause layout jumps
- Error states MUST provide a retry mechanism

---

## 8. Platform Adaptation Rules

### Behavior Consistency

The following MUST behave identically across platforms:

- Navigation structure and flow
- Data validation rules
- Error handling logic
- Undo/redo behavior
- Gesture semantics (tap, long-press, swipe)

### Visual Adaptation

The following MAY adapt to platform conventions:

- Navigation bar appearance
- Button styling
- Switch and checkbox appearance
- Date/time picker presentation
- Scrolling physics

### Never Diverge

- Feature availability MUST NOT differ between platforms
- Business logic MUST NOT differ between platforms
- Data displayed MUST NOT differ between platforms

---

## 9. Anti-Patterns (Explicitly Forbidden)

| Anti-Pattern                           | Violation                            |
| -------------------------------------- | ------------------------------------ |
| Double-tap to confirm                  | Violates one action, one outcome     |
| Success toast after save               | Violates silent success rule         |
| Alert dialog for validation            | Violates error hierarchy             |
| Spinner replacing visible content      | Violates skeleton rule               |
| "Something went wrong" without context | Violates error message standards     |
| Disabling back navigation during loads | Violates responsive UI rule          |
| Platform-specific feature gates        | Violates feature parity rule         |
| Confirmation for reversible actions    | Violates undo-first rule             |
| Nested modal dialogs                   | Violates dialog usage constraints    |
| Loading without timeout handling       | Violates acknowledgment requirements |

---

## 10. Compliance & Enforcement

### Feature Declaration

Every feature submission MUST include a statement confirming:

- All required UI states are implemented
- Error handling follows the hierarchy
- Success feedback uses state change only
- Loading states are appropriately scoped
- Destructive actions are confirmed

### Reviewer Responsibilities

Reviewers MUST verify:

- No forbidden patterns are present
- State handling is explicit and complete
- Platform behavior is consistent
- Error messages meet standards

### Exceptions

Exceptions to this contract are permitted only when:

- A platform constraint makes compliance impossible
- User research demonstrates measurable harm from compliance

Exceptions MUST be documented in the feature's design document with:

- Specific rule being violated
- Justification with evidence
- Scope of the exception
- Review date for reconsideration

---

**End of Contract**
