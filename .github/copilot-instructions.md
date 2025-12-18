# Flutter iOS-First Development Guidelines - Soft Minimalistic Design

## Role & Objective

You are a **Senior Flutter Architect**. Produce production-grade, maintainable, testable code following **Apple Human Interface Guidelines** as the primary design language with Android as secondary. Reference the [Apple HIG](https://developer.apple.com/design/human-interface-guidelines/) for all design decisions.

**Design Philosophy:**

- **iOS-First**: Design for iOS aesthetics first, adapt gracefully for Android
- **Clarity**: Content is paramount. Negative space, subtle depth, and precise typography
- **Deference**: Fluid motion and crisp interface help users understand content without competing with it
- **Depth**: Visual layers and realistic motion convey hierarchy and facilitate understanding
- **Soft Minimalism**: Calm, approachable feel with desaturated warm tones and gentle contrasts

**Visual Identity:**

- **Typography**: SF Pro (iOS) via system font, Inter for body on Android
- **Color Palette**: Warm taupe base with monochromatic variations
- **Iconography**: SF Symbols style - thin, elegant, consistent stroke weights
- **Motion**: iOS spring animations, 0.3-0.5s durations, ease-in-out curves

Strictly adhere to these standards. If a request violates them (e.g., hardcoded colors, Material ripples on iOS, `print()`), correct it.

---

## 1. Architecture

### Feature-First + Clean Architecture

```
lib/
├── main.dart                 # Entry point, Supabase init, ProviderScope
├── core/                     # Shared infrastructure
│   ├── router.dart           # GoRouter with auth guards
│   ├── config.dart           # Environment variables (--dart-define)
│   ├── services/             # Business logic (AuthService)
│   ├── theme.dart            # iOS-inspired theme (colors, typography, spacing)
│   └── widgets/              # Reusable UI components
└── features/{feature}/
    ├── presentation/         # Screens, Widgets, Providers (NO business logic)
    ├── domain/               # Entities, Abstract Repos (Pure Dart only)
    └── data/                 # Repository impls, Data Sources
```

### Layer Rules

| Layer            | Contains                        | Rules                                         |
| ---------------- | ------------------------------- | --------------------------------------------- |
| **Presentation** | Screens, Widgets, Providers     | No business logic. UI and state binding only. |
| **Domain**       | Entities, Abstract Repositories | Pure Dart. No Flutter/Supabase imports.       |
| **Data**         | Repository Impls, Data Sources  | Implements domain interfaces. Handles API/DB. |

### SOLID Principles

- **Single Responsibility:** One widget = one job. Extract complex UI into smaller widgets.
- **Open-Closed:** Extend via abstractions, don't modify existing code.
- **Liskov Substitution:** Subclasses must be usable wherever parent classes are expected.
- **Interface Segregation:** Keep interfaces small and focused. Prefer multiple small interfaces.
- **Dependency Inversion:** Depend on abstractions. Services implement interfaces for testability.

```dart
// ❌ Widget directly calls Supabase
await Supabase.instance.client.from('profiles').upsert(data);

// ✅ Widget uses injected repository
final repo = ref.watch(profileRepositoryProvider);
await repo.saveProfile(data);
```

---

## 2. State Management (Riverpod)

### Immutability

```dart
// ✅ Use freezed for immutable state
@freezed
class UserState with _$UserState {
  const factory UserState({User? user, @Default(false) bool isLoading}) = _UserState;
}

// ❌ NEVER mutate state directly
state.user = newUser;
```

### Async Patterns

```dart
// Use AsyncValue for loading/error/data
ref.watch(healthDataProvider).when(
  data: (data) => HealthCard(data),
  loading: () => const CupertinoActivityIndicator(),
  error: (e, _) => ErrorWidget(e.toString()),
);
```

### Performance with select()

```dart
// ✅ Only rebuild when specific field changes
final userName = ref.watch(userProvider.select((u) => u?.name));

// ❌ Rebuilds on ANY userProvider change
final user = ref.watch(userProvider);
```

### No Side Effects in build()

```dart
// ❌ WRONG - triggers during build
@override
Widget build(BuildContext context) {
  ref.read(authProvider.notifier).checkSession();
}

// ✅ Use ref.listen for side effects
ref.listen(authProvider, (_, state) {
  if (state.hasError) _showErrorSheet(context, state.error);
});
```

### Provider Organization

```dart
// Provider definition (in feature's providers/ folder)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

// Widget only watches, never modifies state directly
final authState = ref.watch(authProvider);
```

---

## 3. iOS-First Design System

> **Reference:** [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

### Platform-First Approach

**iOS is the PRIMARY design target.** Use Cupertino widgets and iOS patterns first, then ensure graceful degradation on Android.

```dart
// ✅ Use platform-adaptive patterns
import 'dart:io' show Platform;

// ✅ Prefer Cupertino for iOS-native feel
if (Platform.isIOS) {
  return CupertinoButton.filled(...);
} else {
  return FilledButton(...);
}

// ✅ Or use adaptive widgets
Switch.adaptive(value: isOn, onChanged: ...)
```

### Theme Authority

**Source of Truth:** `core/theme.dart`

```dart
// ❌ NEVER use hardcoded colors
color: Colors.orange
color: CupertinoColors.systemBlue

// ✅ ALWAYS use Theme.of(context)
color: Theme.of(context).colorScheme.primary
color: Theme.of(context).colorScheme.onSurface

// ✅ For iOS-specific colors when needed
color: CupertinoTheme.of(context).primaryColor

// ✅ Typography via theme
style: Theme.of(context).textTheme.headlineMedium
style: Theme.of(context).textTheme.bodyLarge
```

### iOS-Inspired Color Palette

```dart
// iOS uses semantic colors that adapt to light/dark/high-contrast
final colorScheme = Theme.of(context).colorScheme;

// Primary surfaces - use very subtle grays
colorScheme.surface              // #FFFFFF (light) / #000000 (dark)
colorScheme.surfaceContainer     // Subtle elevation (iOS grouped background)
colorScheme.surfaceContainerLow  // Input fields, recessed areas

// Text hierarchy - iOS uses clear contrast
colorScheme.onSurface            // Primary text (Label in iOS)
colorScheme.onSurfaceVariant     // Secondary text (Secondary Label)

// Semantic colors
colorScheme.primary              // Tint color (accent)
colorScheme.error                // Destructive red
colorScheme.outline              // Separators (iOS separator color)
```

### iOS Widget Mapping

| iOS Pattern            | Flutter Widget                     | Notes                            |
| :--------------------- | :--------------------------------- | :------------------------------- |
| **Navigation Bar**     | `CupertinoNavigationBar`           | Large title style preferred      |
| **Tab Bar**            | `CupertinoTabBar`                  | Bottom tabs with icons           |
| **Action Sheet**       | `CupertinoActionSheet`             | For destructive/multiple actions |
| **Alert**              | `CupertinoAlertDialog`             | Simple confirmations             |
| **Segmented Control**  | `CupertinoSlidingSegmentedControl` | Pill-shaped sliding control      |
| **Switch**             | `CupertinoSwitch`                  | iOS-native toggle                |
| **Slider**             | `CupertinoSlider`                  | iOS-native slider                |
| **Activity Indicator** | `CupertinoActivityIndicator`       | Spinning wheel                   |
| **Date Picker**        | `CupertinoDatePicker`              | Wheel-style picker               |
| **Picker**             | `CupertinoPicker`                  | Wheel picker for any values      |
| **Text Field**         | `CupertinoTextField`               | iOS-native input style           |
| **Button**             | `CupertinoButton`                  | Subtle tap feedback (no ripple)  |
| **List Tile**          | `CupertinoListTile`                | iOS Settings-style row           |
| **Modal Sheet**        | `CupertinoModalPopupRoute`         | iOS bottom sheet behavior        |
| **Context Menu**       | `CupertinoContextMenu`             | Long-press preview + actions     |

### Custom Reusable Components (in `core/widgets/`)

| Component               | Use                       | Notes                                  |
| :---------------------- | :------------------------ | :------------------------------------- |
| **SignInButton**        | OAuth/sign-in buttons     | iOS-style with subtle highlight        |
| **LoadingButton**       | Primary CTAs with loading | CupertinoButton with spinner           |
| **AppSegmentedControl** | Selection controls        | Wraps CupertinoSlidingSegmentedControl |
| **AppleLogo**           | Apple branding            | SF Symbol or custom paint              |
| **GoogleLogo**          | Google branding           | CustomPaint official logo              |

### Spacing — iOS Metrics (STRICTLY use AppSpacing)

> ⚠️ **NEVER use magic numbers for spacing, sizing, or border radius. Always use `AppSpacing` constants.**

iOS uses a 4pt/8pt grid system with specific margin guidelines.

#### AppSpacing Constants Reference (iOS-Aligned)

| Category          | Constant                | Value | iOS Reference                 |
| ----------------- | ----------------------- | ----- | ----------------------------- |
| **Base Scale**    | `xxs`                   | 4.0   | Minimum unit                  |
|                   | `xs`                    | 8.0   | Tight spacing                 |
|                   | `sm`                    | 12.0  | Compact spacing               |
|                   | `md`                    | 16.0  | Standard margin (iOS default) |
|                   | `lg`                    | 20.0  | Comfortable spacing           |
|                   | `xl`                    | 24.0  | Section gaps                  |
|                   | `xxl`                   | 32.0  | Large section breaks          |
|                   | `xxxl`                  | 40.0  | Major section separators      |
| **Page Layout**   | `pageHorizontalPadding` | 20.0  | iOS safe area inset           |
|                   | `pageVerticalPadding`   | 20.0  | iOS safe area inset           |
|                   | `sectionSpacing`        | 35.0  | iOS grouped list section gap  |
| **Components**    | `buttonHeight`          | 50.0  | iOS standard button height    |
|                   | `buttonHeightSmall`     | 36.0  | Compact buttons               |
|                   | `inputHeight`           | 44.0  | iOS standard row height       |
|                   | `touchTargetMin`        | 44.0  | iOS minimum touch target      |
| **Border Radius** | `cardRadius`            | 14.0  | iOS card/grouped style        |
|                   | `cardRadiusLarge`       | 20.0  | Modal corners                 |
|                   | `cardRadiusSmall`       | 10.0  | Chips, small cards            |
|                   | `buttonRadius`          | 14.0  | iOS button corners            |
|                   | `buttonRadiusPill`      | 25.0  | Pill-shaped buttons           |
|                   | `inputRadius`           | 10.0  | Text field corners            |
| **Icon Sizes**    | `iconSizeSmall`         | 17.0  | SF Symbol small               |
|                   | `iconSize`              | 22.0  | SF Symbol default             |
|                   | `iconSizeLarge`         | 28.0  | SF Symbol large               |

#### Usage Guidelines

```dart
// ❌ NEVER use magic numbers
const SizedBox(height: 16)
EdgeInsets.all(24)
BorderRadius.circular(12)

// ✅ ALWAYS use AppSpacing
const SizedBox(height: AppSpacing.md)
EdgeInsets.all(AppSpacing.xl)
BorderRadius.circular(AppSpacing.cardRadius)

// ✅ Page layout
Padding(
  padding: AppSpacing.pagePadding,  // Pre-built EdgeInsets
  child: Column(...),
)

// ✅ iOS-style list section spacing
const SizedBox(height: AppSpacing.sectionSpacing)  // 35.0

// ✅ Touch targets - minimum 44x44 (iOS standard)
SizedBox(
  width: AppSpacing.touchTargetMin,
  height: AppSpacing.touchTargetMin,
  child: CupertinoButton(padding: EdgeInsets.zero, ...),
)
```

### iOS Typography

iOS uses SF Pro with specific weights and sizes. Map to Flutter's text theme:

```dart
// iOS Text Styles mapped to Flutter
// Large Title: 34pt Bold → displaySmall
// Title 1: 28pt Bold → headlineLarge
// Title 2: 22pt Bold → headlineMedium
// Title 3: 20pt Semibold → headlineSmall
// Headline: 17pt Semibold → titleMedium
// Body: 17pt Regular → bodyLarge
// Callout: 16pt Regular → bodyMedium
// Subhead: 15pt Regular → bodySmall
// Footnote: 13pt Regular → labelLarge
// Caption 1: 12pt Regular → labelMedium
// Caption 2: 11pt Regular → labelSmall

// ✅ Use semantic text styles
Text(
  'Welcome',
  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
    fontWeight: FontWeight.bold,
  ),
)
```

### iOS Color Semantics

```dart
final colorScheme = Theme.of(context).colorScheme;

// Background colors (iOS Grouped Style)
colorScheme.surface                    // System background
colorScheme.surfaceContainer           // Secondary system background (grouped)
colorScheme.surfaceContainerHigh       // Tertiary system background

// Text colors
colorScheme.onSurface                  // Label (primary text)
colorScheme.onSurfaceVariant           // Secondary label
// For tertiary/quaternary, use opacity

// Fill colors (for buttons, controls)
colorScheme.primary                    // Tint color
colorScheme.primaryContainer           // Tint color with lower opacity

// Separators
colorScheme.outline                    // Separator color
colorScheme.outlineVariant             // Opaque separator

// Semantic colors
colorScheme.error                      // System red (destructive)
colorScheme.tertiary                   // System green (success)
// System orange, yellow, etc. as needed
```

### iOS-Specific Interaction Patterns

**No Material Ripples on iOS:**

```dart
// ❌ Material ripple - not iOS native
InkWell(onTap: ..., child: ...)

// ✅ iOS highlight behavior
CupertinoButton(
  padding: EdgeInsets.zero,
  onPressed: ...,
  child: ...,
)

// ✅ Or use GestureDetector with custom feedback
GestureDetector(
  onTap: ...,
  onTapDown: (_) => setState(() => _isPressed = true),
  onTapUp: (_) => setState(() => _isPressed = false),
  onTapCancel: () => setState(() => _isPressed = false),
  child: AnimatedOpacity(
    opacity: _isPressed ? 0.4 : 1.0,
    duration: const Duration(milliseconds: 100),
    child: ...,
  ),
)
```

**iOS Swipe Actions:**

```dart
// ✅ iOS-style swipe to delete
Dismissible(
  key: Key(item.id),
  direction: DismissDirection.endToStart,
  background: Container(
    color: colorScheme.error,
    alignment: Alignment.centerRight,
    padding: EdgeInsets.only(right: AppSpacing.lg),
    child: Icon(CupertinoIcons.delete, color: Colors.white),
  ),
  onDismissed: (_) => _deleteItem(item),
  child: ListTile(...),
)
```

**iOS Pull to Refresh:**

```dart
// ✅ Use CustomScrollView with CupertinoSliverRefreshControl
CustomScrollView(
  slivers: [
    CupertinoSliverRefreshControl(
      onRefresh: () async => await _refreshData(),
    ),
    SliverList(...),
  ],
)
```

### Soft Minimalistic Design Principles (iOS-Aligned)

**Color Philosophy:**

- **Monochromatic Warmth**: All colors derived from warm taupe base (#B5917A)
- **Gentle Contrast**: Avoid harsh blacks - use soft dark grays
- **Subtle Depth**: Use blur and translucency over shadows
- **Muted States**: Even error states use desaturated tones

**Visual Guidelines:**

- **Blur Effects**: Use `BackdropFilter` for iOS frosted glass effect
- **Border Width**: 0.5px for separators (iOS standard), 1px for emphasized borders
- **Shadow**: Minimal - prefer translucency and blur over drop shadows
- **Icon Treatment**: Thin stroke weights, SF Symbols style

**Border Radius Strategy (iOS):**

| Component Type    | Radius | Constant           | Notes                       |
| ----------------- | ------ | ------------------ | --------------------------- |
| **Cards/Grouped** | 14px   | `cardRadius`       | iOS rounded rectangle       |
| **Modals/Sheets** | 20px   | `cardRadiusLarge`  | Bottom sheets, modals       |
| **Buttons**       | 14px   | `buttonRadius`     | Standard iOS button         |
| **Pill Buttons**  | 25px   | `buttonRadiusPill` | Capsule-shaped              |
| **Form Controls** | 10px   | `inputRadius`      | Text fields, small controls |
| **Chips**         | 10px   | `cardRadiusSmall`  | Tags, small cards           |

**Button Styles (iOS):**

```dart
// ✅ Primary action - filled button
CupertinoButton.filled(
  onPressed: _handleSubmit,
  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
  child: const Text('Continue'),
)

// ✅ Secondary action - outlined/ghost
CupertinoButton(
  onPressed: _handleCancel,
  child: Text('Cancel', style: TextStyle(color: colorScheme.primary)),
)

// ✅ Destructive action
CupertinoButton(
  onPressed: _handleDelete,
  child: Text('Delete', style: TextStyle(color: colorScheme.error)),
)

// ✅ Custom styled button (when Cupertino isn't enough)
Container(
  height: AppSpacing.buttonHeight,
  decoration: BoxDecoration(
    color: colorScheme.primary,
    borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
  ),
  child: CupertinoButton(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
    onPressed: _handleSubmit,
    child: Text('Continue', style: TextStyle(
      color: colorScheme.onPrimary,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    )),
  ),
)
```

**Input Fields (iOS Style):**

```dart
// ✅ iOS-style text field
CupertinoTextField(
  placeholder: 'Email',
  padding: EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(
    color: colorScheme.surfaceContainerLow,
    borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
  ),
)

// ✅ For more control, use TextField with iOS styling
TextField(
  decoration: InputDecoration(
    hintText: 'Email',
    filled: true,
    fillColor: colorScheme.surfaceContainerLow,
    contentPadding: EdgeInsets.all(AppSpacing.md),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: BorderSide(color: colorScheme.primary, width: 1),
    ),
  ),
)
```

**iOS Navigation Patterns:**

```dart
// ✅ iOS large title navigation bar
CupertinoSliverNavigationBar(
  largeTitle: const Text('Profile'),
  trailing: CupertinoButton(
    padding: EdgeInsets.zero,
    child: const Text('Done'),
    onPressed: () => Navigator.pop(context),
  ),
)

// ✅ iOS modal presentation (page sheet style)
showCupertinoModalPopup(
  context: context,
  builder: (context) => Container(
    height: MediaQuery.of(context).size.height * 0.9,
    decoration: BoxDecoration(
      color: colorScheme.surface,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.cardRadiusLarge),
      ),
    ),
    child: ...,
  ),
)

// ✅ iOS action sheet
showCupertinoModalPopup(
  context: context,
  builder: (context) => CupertinoActionSheet(
    title: const Text('Choose Option'),
    actions: [
      CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context, 'option1'),
        child: const Text('Option 1'),
      ),
      CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () => Navigator.pop(context, 'delete'),
        child: const Text('Delete'),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancel'),
    ),
  ),
)
```

**iOS Blur/Frosted Glass Effect:**

```dart
// ✅ Frosted glass background
ClipRRect(
  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      color: colorScheme.surface.withOpacity(0.7),
      child: ...,
    ),
  ),
)
```

---

## 4. Layout & Widgets

> **Reference:** [Apple HIG - Layout](https://developer.apple.com/design/human-interface-guidelines/layout)

### The Layout Golden Rule

**Constraints go down. Sizes go up. Parent sets position.**

### iOS Layout Patterns

| Pattern                     | Implementation                                       |
| --------------------------- | ---------------------------------------------------- |
| **Full-width list**         | `ListView` with `CupertinoListTile`                  |
| **Grouped list (Settings)** | `CupertinoListSection.insetGrouped()`                |
| **Grid**                    | `GridView` with appropriate spacing                  |
| **Scroll with refresh**     | `CustomScrollView` + `CupertinoSliverRefreshControl` |
| **Tab layout**              | `CupertinoTabScaffold`                               |

### Core Layout Widgets

| Widget           | Use Case                                       |
| ---------------- | ---------------------------------------------- |
| `Row`            | Horizontal arrangement                         |
| `Column`         | Vertical arrangement                           |
| `Stack`          | Overlapping widgets                            |
| `Expanded`       | Fill remaining space in Row/Column             |
| `Flexible`       | Allow child to be smaller than available space |
| `Wrap`           | Flow layout that wraps to next line            |
| `SizedBox`       | Force dimensions or create spacing             |
| `ConstrainedBox` | Apply min/max constraints                      |

### Avoiding Overflow

```dart
// ❌ Text will overflow
Row(children: [Text('Very long text...'), Icon(CupertinoIcons.star)])

// ✅ Use Expanded with ellipsis
Row(children: [
  Expanded(child: Text('Very long text...', overflow: TextOverflow.ellipsis)),
  Icon(CupertinoIcons.star),
])
```

### Widget Best Practices

```dart
// ✅ Use const constructors - prevents unnecessary rebuilds
const SizedBox(height: AppSpacing.md)
const Icon(CupertinoIcons.checkmark)

// ✅ Extract static widgets to avoid rebuilds
class MyScreen extends StatelessWidget {
  static const _header = Text('Welcome');  // Won't rebuild

  @override
  Widget build(BuildContext context) => Column(children: [_header, ...]);
}

// ✅ Prefer StatelessWidget, use StatefulWidget only for local mutable state
// ✅ Compose widgets, don't extend them
// ✅ Use Keys for list items that reorder: key: ValueKey(item.id)
```

### Lists & Performance

```dart
// ✅ Use ListView.builder for long lists (lazy loading)
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(items[index]),
)

// ✅ iOS grouped list style
CupertinoListSection.insetGrouped(
  header: const Text('SETTINGS'),
  children: [
    CupertinoListTile(
      title: const Text('Notifications'),
      trailing: const CupertinoListTileChevron(),
      onTap: () => ...,
    ),
    CupertinoListTile(
      title: const Text('Privacy'),
      trailing: const CupertinoListTileChevron(),
      onTap: () => ...,
    ),
  ],
)

// ✅ Use CachedNetworkImage for remote images
CachedNetworkImage(
  imageUrl: url,
  placeholder: (_, __) => const CupertinoActivityIndicator(),
  errorWidget: (_, __, ___) => const Icon(CupertinoIcons.exclamationmark_circle),
)
```

### Debounce for Search

```dart
// ✅ Debounce search input to avoid excessive API calls
class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounce;

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchProvider.notifier).search(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
```

---

## 5. Responsive & Adaptive Design

> **Reference:** [Apple HIG - Responsive Design](https://developer.apple.com/design/human-interface-guidelines/layout#Best-practices)

### SafeArea

```dart
// ALWAYS wrap screens to respect notches, Dynamic Island, home indicator
Scaffold(body: SafeArea(child: Column(...)))

// Or use MediaQuery for precise control
final topPadding = MediaQuery.paddingOf(context).top;
final bottomPadding = MediaQuery.paddingOf(context).bottom;
```

### MediaQuery (Efficient Usage)

```dart
// ✅ PREFERRED - specific methods avoid unnecessary rebuilds
final width = MediaQuery.sizeOf(context).width;
final height = MediaQuery.sizeOf(context).height;
final padding = MediaQuery.paddingOf(context);

// ❌ AVOID - rebuilds on ANY MediaQuery change (keyboard, etc.)
final mq = MediaQuery.of(context);
```

### iOS Size Classes

| Size Class | Width   | Device                 |
| ---------- | ------- | ---------------------- |
| Compact    | < 600pt | iPhone portrait        |
| Regular    | ≥ 600pt | iPad, iPhone landscape |

```dart
// Responsive layout pattern
final width = MediaQuery.sizeOf(context).width;
if (width >= 600) return TabletLayout();
return PhoneLayout();
```

### Platform Adaptive

```dart
// ✅ Use .adaptive constructors for native feel
Switch.adaptive(value: isOn, onChanged: ...)
Slider.adaptive(value: volume, onChanged: ...)
CircularProgressIndicator.adaptive()

// ✅ Platform-specific widgets when needed
if (Platform.isIOS) {
  return CupertinoAlertDialog(...);
} else {
  return AlertDialog(...);
}
```

---

## 6. Interactivity & Touch

> **Reference:** [Apple HIG - Gestures](https://developer.apple.com/design/human-interface-guidelines/gestures)

### iOS Touch Feedback

```dart
// ✅ Use CupertinoButton for iOS-native feedback (opacity change, no ripple)
CupertinoButton(
  padding: EdgeInsets.all(AppSpacing.md),
  onPressed: () => _handleTap(),
  child: Text('Tap me'),
)

// ✅ For custom containers, use opacity feedback
GestureDetector(
  onTapDown: (_) => setState(() => _isPressed = true),
  onTapUp: (_) => setState(() => _isPressed = false),
  onTapCancel: () => setState(() => _isPressed = false),
  onTap: _handleTap,
  child: AnimatedOpacity(
    opacity: _isPressed ? 0.5 : 1.0,
    duration: const Duration(milliseconds: 100),
    child: Container(...),
  ),
)
```

### Touch Targets

**Minimum 44x44 points** (iOS Human Interface Guidelines)

```dart
CupertinoButton(
  padding: EdgeInsets.zero,
  minSize: AppSpacing.touchTargetMin, // 44.0
  onPressed: () {},
  child: Icon(CupertinoIcons.settings),
)
```

### Haptic Feedback

```dart
import 'package:flutter/services.dart';

// ✅ Light impact for selections
HapticFeedback.selectionClick();

// ✅ Medium impact for actions
HapticFeedback.mediumImpact();

// ✅ Heavy impact for significant events
HapticFeedback.heavyImpact();

// ✅ Notification feedback types
HapticFeedback.lightImpact();   // Success
HapticFeedback.mediumImpact();  // Warning
HapticFeedback.heavyImpact();   // Error
```

### Loading States in Buttons

```dart
// ✅ Use loading state pattern with CupertinoActivityIndicator
CupertinoButton.filled(
  onPressed: _isLoading ? null : _handleSubmit,
  child: _isLoading
      ? const CupertinoActivityIndicator(color: CupertinoColors.white)
      : const Text('Submit'),
)
```

---

## 7. Navigation (GoRouter)

> **Reference:** [Apple HIG - Navigation](https://developer.apple.com/design/human-interface-guidelines/navigation)

### iOS Navigation Patterns

| Pattern          | Use Case                | Implementation                    |
| ---------------- | ----------------------- | --------------------------------- |
| **Hierarchical** | Drill down into content | `context.push()` with back button |
| **Flat**         | Peer content sections   | Tab bar (`CupertinoTabBar`)       |
| **Modal**        | Self-contained task     | `showCupertinoModalPopup()`       |

### Navigation Methods

```dart
context.go('/dashboard');    // REPLACE stack (can't go back)
context.push('/settings');   // ADD to stack (iOS push transition)
context.pop();               // Go back (iOS swipe back gesture enabled)
context.pop(result);         // Go back with result

// Named routes with parameters
context.goNamed('profile', pathParameters: {'userId': '123'});
context.pushNamed('detail', queryParameters: {'tab': 'overview'});
```

### Route Configuration

```dart
final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  redirect: (context, state) {
    final isLoggedIn = authService.isAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/auth');

    if (!isLoggedIn && !isAuthRoute) return '/auth/login';
    if (isLoggedIn && isAuthRoute) return '/dashboard';
    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),
  ],
);
```

### iOS Modal Presentation

```dart
// ✅ Page sheet (default iOS 13+ modal)
showCupertinoModalPopup(
  context: context,
  builder: (context) => Container(
    height: MediaQuery.of(context).size.height * 0.9,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.cardRadiusLarge),
      ),
    ),
    child: Column(
      children: [
        // Drag handle
        Container(
          margin: EdgeInsets.only(top: AppSpacing.sm),
          width: 36,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        // Content...
      ],
    ),
  ),
)
```

---

## 8. Animations

> **Reference:** [Apple HIG - Motion](https://developer.apple.com/design/human-interface-guidelines/motion)

### iOS Animation Principles

- **Purpose**: Motion should be meaningful, not decorative
- **Fluidity**: Spring-based animations feel natural
- **Duration**: 0.3-0.5 seconds for most transitions
- **Easing**: Ease-in-out curves (iOS uses spring physics)

### Spring Animations (iOS-Native Feel)

```dart
// ✅ Spring animation for natural iOS feel
AnimatedContainer(
  duration: const Duration(milliseconds: 400),
  curve: Curves.easeOutCubic,  // Approximates iOS spring
  width: _isExpanded ? 200 : 100,
)

// ✅ For more control, use explicit spring
final controller = AnimationController(
  duration: const Duration(milliseconds: 400),
  vsync: this,
);
final animation = CurvedAnimation(
  parent: controller,
  curve: Curves.elasticOut,  // Spring-like
);
```

### Implicit Animations

```dart
// ✅ AnimatedContainer handles transitions automatically
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  transform: _isActive
      ? Matrix4.identity()
      : Matrix4.identity()..scale(0.95),
  child: ...,
)

// Common implicit animation widgets:
// AnimatedOpacity, AnimatedPadding, AnimatedPositioned,
// AnimatedAlign, AnimatedSwitcher, AnimatedCrossFade
```

### Hero Animations

```dart
// Source screen
Hero(tag: 'avatar-${user.id}', child: CircleAvatar(...))

// Destination screen - same tag
Hero(tag: 'avatar-${user.id}', child: CircleAvatar(radius: 80, ...))
```

### Reduce Motion Support

```dart
final reduceMotion = MediaQuery.of(context).disableAnimations;

AnimatedContainer(
  duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 300),
)
```

---

## 9. Accessibility

> **Reference:** [Apple HIG - Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)

### Semantic Labels

```dart
// ✅ Images MUST have semantic labels
Image.network(url, semanticLabel: 'User profile photo')

// ✅ Meaningful icons need labels
Icon(CupertinoIcons.heart_fill, semanticLabel: 'Add to favorites')

// ✅ Group related content
MergeSemantics(
  child: Row(children: [Icon(CupertinoIcons.calendar), Text('March 15')]),
)

// ✅ Exclude decorative elements
ExcludeSemantics(child: DecorativeImage())
```

### Color Contrast

**WCAG 2.1 minimums:** Normal text 4.5:1, Large text 3:1, UI components 3:1

Verify colors: https://webaim.org/resources/contrastchecker/

### Dynamic Type Support

```dart
// ✅ Use MediaQuery to respect user's text size preference
final textScaleFactor = MediaQuery.textScaleFactorOf(context);

// ✅ Allow text to scale, but set reasonable limits
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaler: TextScaler.linear(
      MediaQuery.textScaleFactorOf(context).clamp(0.8, 1.5),
    ),
  ),
  child: MyApp(),
)
```

### Focus Management

```dart
// ✅ Control focus programmatically
final _emailFocus = FocusNode();
final _passwordFocus = FocusNode();

CupertinoTextField(
  focusNode: _emailFocus,
  textInputAction: TextInputAction.next,
  onSubmitted: (_) => _passwordFocus.requestFocus(),
)

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _emailFocus.requestFocus();
  });
}

@override
void dispose() {
  _emailFocus.dispose();
  _passwordFocus.dispose();
  super.dispose();
}
```

### Testing Accessibility

```dart
// 1. Enable VoiceOver (iOS) or TalkBack (Android)
// 2. Navigate app using only screen reader
// 3. Verify all interactive elements are announced
// 4. Check logical focus order
// 5. Test with Dynamic Type at largest setting

// Automated semantic testing
testWidgets('button has semantic label', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(
    tester.getSemantics(find.byType(CupertinoButton)),
    matchesSemantics(label: 'Submit', isButton: true),
  );
});
```

---

## 10. Observability (Talker)

### ⚠️ NEVER use print() or debugPrint()

### Talker Setup (main.dart)

```dart
import 'package:talker_flutter/talker_flutter.dart';

final talker = Talker(
  settings: TalkerSettings(
    enabled: true,
    useHistory: true,
    maxHistoryItems: 1000,
  ),
);
```

### Log Levels

```dart
talker.info('User tapped login');           // User actions, milestones
talker.debug('API response: $code');        // Dev details (disabled in prod)
talker.warning('Network slow, retrying');   // Degraded states
talker.error('Save failed', error, stack);  // Exceptions
talker.critical('Database corrupted');      // Unrecoverable errors
```

### Security - NEVER log PII

```dart
// ❌ NEVER log emails, names, phone numbers
talker.info('User: ${user.email}');

// ✅ Only log user IDs when identification needed
talker.info('User login: userid=${user.id}');
```

### Custom Logs for Tracing User Flows

```dart
// Create custom log types for important flows
class AuthFlowLog extends TalkerLog {
  AuthFlowLog(String message) : super(message);

  @override
  String get title => 'AUTH';

  @override
  AnsiPen get pen => AnsiPen()..cyan();
}

talker.logTyped(AuthFlowLog('OTP verification started'));
talker.logTyped(AuthFlowLog('OTP verified successfully'));
```

### HTTP Request Logging (with Dio)

```dart
// Add TalkerDioLogger interceptor
final dio = Dio();
dio.interceptors.add(TalkerDioLogger(
  talker: talker,
  settings: TalkerDioLoggerSettings(
    printRequestHeaders: true,
    printResponseHeaders: false,
    printResponseData: kDebugMode, // Only in debug
  ),
));
```

### In-App Log Viewer (Debug builds)

```dart
// Add to router for debug builds
GoRoute(
  path: '/dev/logs',
  builder: (context, state) => TalkerScreen(talker: talker),
),
```

### What to Log

| Event Type        | Level     | Example                                  |
| ----------------- | --------- | ---------------------------------------- |
| User actions      | `info`    | `talker.info('User tapped submit')`      |
| Flow milestones   | `info`    | `talker.info('Onboarding step 3 done')`  |
| API calls         | `debug`   | Via TalkerDioLogger                      |
| State changes     | `verbose` | `talker.verbose('State: $newState')`     |
| Validation errors | `warning` | `talker.warning('Email format invalid')` |
| Caught exceptions | `error`   | `talker.error('Save failed', e, stack)`  |
| Uncaught crashes  | `handle`  | Automatic via FlutterError.onError       |

### Global Error Capture (main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch Flutter framework errors
  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack, 'FlutterError');
  };

  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'PlatformError');
    return true;
  };

  runApp(const VitaloApp());
}
```

---

## 11. Error Handling

### Defensive Coding

```dart
// ✅ Always check mounted after async gaps
Future<void> _submit() async {
  final result = await _service.save();
  if (!mounted) return;  // REQUIRED after every await
  context.go('/success');
}

// ✅ Handle null and empty states explicitly
if (user == null) return const GuestBanner();
if (items.isEmpty) return const EmptyState();
```

### Result Pattern (No Throwing for Expected Errors)

```dart
// Define sealed class for results
sealed class AuthResult<T> {}
class AuthSuccess<T> extends AuthResult<T> { final T? data; AuthSuccess(this.data); }
class AuthFailure<T> extends AuthResult<T> { final String message; AuthFailure(this.message); }

// Service returns Result, never throws
Future<AuthResult<User>> signIn(String email) async {
  try {
    final user = await _auth.signIn(email);
    return AuthSuccess(user);
  } on AuthException catch (e) {
    return AuthFailure(_mapError(e.message));
  }
}

// UI pattern matches on result
switch (result) {
  case AuthSuccess(:final data): context.go('/dashboard');
  case AuthFailure(:final message): _showErrorAlert(context, message);
}
```

### iOS-Style Error Presentation

```dart
// ✅ Use iOS alert for errors
void _showErrorAlert(BuildContext context, String message) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
```

### Secure Storage

```dart
// ❌ NEVER store tokens in SharedPreferences
await prefs.setString('auth_token', token);  // INSECURE!

// ✅ Use flutter_secure_storage (uses iOS Keychain)
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
await storage.read(key: 'auth_token');
await storage.delete(key: 'auth_token');
```

---

## 12. Auth Flow

| Method | Implementation                                                        |
| ------ | --------------------------------------------------------------------- |
| OAuth  | Apple (iOS priority), Google → `AuthService.signInWithApple/Google()` |
| OTP    | Email magic code → `sendOtpToEmail()` + `verifyOtp()`                 |
| Guest  | Anonymous → `signInAnonymously()`, check `isAnonymous`                |

### Sign in with Apple (Required for iOS)

If your app offers any third-party sign-in, **Apple requires Sign in with Apple** on iOS.

```dart
// ✅ Sign in with Apple should be prominent on iOS
if (Platform.isIOS) {
  SignInWithAppleButton(
    onPressed: () => authService.signInWithApple(),
  ),
}
```

### Auth State Listener

```dart
// In main.dart or router - listen to auth changes
Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  talker.info('Auth state: ${data.event}');
  if (data.event == AuthChangeEvent.signedOut) {
    router.go('/auth/landing');
  }
});
```

Route guard in `router.dart` redirects unauthenticated users.

---

## 13. Code Conventions

### File Naming

| Type      | Pattern             | Example                   |
| --------- | ------------------- | ------------------------- |
| Screens   | `*_screen.dart`     | `dashboard_screen.dart`   |
| Widgets   | `snake_case.dart`   | `loading_button.dart`     |
| Services  | `*_service.dart`    | `auth_service.dart`       |
| Providers | `*_provider.dart`   | `user_provider.dart`      |
| Repos     | `*_repository.dart` | `profile_repository.dart` |
| Models    | `snake_case.dart`   | `user_profile.dart`       |

### Imports

```dart
// Relative within same feature
import '../widgets/guest_banner.dart';

// Absolute for Core and other Features
import 'package:vitalo/core/theme.dart';
import 'package:vitalo/features/auth/domain/auth_repository.dart';
```

### Naming Conventions

```dart
// Variables: Descriptive nouns
final userProfile = ...;  // ✅
final data = ...;         // ❌ Too vague

// Functions: Verb phrases
Future<void> calculateTotal() {}  // ✅
Future<void> process() {}         // ❌ Too vague

// Booleans: Question format
bool isLoading = false;
bool hasError = false;
bool canSubmit = true;

// Private members: Underscore prefix
String _authToken;
void _handleSubmit() {}
```

### Comments — Avoid Unnecessary Comments, Use Self-Documenting Code

**Philosophy:** Code should be self-explanatory through proper naming. Comments should explain WHY, not WHAT.

```dart
// ❌ WRONG — Obvious comment
// Check if user is null
if (user == null) return;

// ✅ CORRECT — Comment explains WHY when necessary
// Guest users don't have profile data yet, skip personalization
if (user == null) return;
```

### Key Rules

1. **Trailing commas** for multi-line parameters
2. **Dark mode:** Check `Theme.of(context).brightness`
3. **Cleanup:** Run `flutter analyze` after refactoring
4. **Remove unused:** Delete unused code, imports, files

---

## 14. Form Handling

### iOS-Style Validation Pattern

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      CupertinoTextField(
        placeholder: 'Email',
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      CupertinoButton.filled(
        onPressed: _isLoading ? null : () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _submit();
          }
        },
        child: _isLoading
            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
            : const Text('Submit'),
      ),
    ],
  ),
)
```

---

## 15. Testing Strategy

### Unit Tests (Business Logic)

```dart
test('calculateBMI returns correct value', () {
  expect(calculateBMI(weight: 70, height: 1.75), closeTo(22.86, 0.01));
});

test('AuthService returns failure on invalid OTP', () async {
  final result = await authService.verifyOtp('test@test.com', '000000');
  expect(result, isA<AuthFailure>());
});
```

### Widget Tests (UI Components)

```dart
testWidgets('CupertinoButton shows loading state', (tester) async {
  await tester.pumpWidget(
    ProviderScope(child: CupertinoApp(home: LoginScreen())),
  );

  await tester.tap(find.text('Login'));
  await tester.pump();

  expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
});

testWidgets('Form shows validation error', (tester) async {
  await tester.pumpWidget(CupertinoApp(home: SignupScreen()));

  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  expect(find.text('Email is required'), findsOneWidget);
});
```

---

## 16. Dependencies

| Package                  | Purpose                         |
| ------------------------ | ------------------------------- |
| `supabase_flutter`       | Auth, database, realtime        |
| `go_router`              | Declarative routing             |
| `flutter_riverpod`       | State management                |
| `talker_flutter`         | Logging, error tracking         |
| `talker_dio_logger`      | HTTP request/response logging   |
| `dio`                    | HTTP client                     |
| `freezed`                | Immutable state classes         |
| `flutter_secure_storage` | Secure token storage (Keychain) |
| `cached_network_image`   | Cached remote images            |
| `pinput`                 | OTP input widget                |
| `sign_in_with_apple`     | Apple OAuth (REQUIRED for iOS)  |
| `google_sign_in`         | Google OAuth                    |
| `google_fonts`           | Typography (Android fallback)   |
| `shared_preferences`     | Non-sensitive local storage     |

---

## 17. Internationalization (i18n)

### Setup with easy_localization

```yaml
dependencies:
  easy_localization: ^3.0.0

flutter:
  assets:
    - assets/translations/
```

### Usage

```dart
// ✅ Simple translation
Text('welcome'.tr())

// ✅ With arguments
Text('greeting'.tr(namedArgs: {'name': user.name}))

// ✅ Pluralization
Text('items_count'.plural(itemCount))

// ❌ NEVER hardcode user-facing strings
Text('Welcome to the app')
```

---

## 18. Developer Commands

```bash
# Launch Android emulator
flutter emulators --launch Medium_Phone_API_36.1

# Run on specific emulator/device
flutter run -d emulator-5554  # Android
flutter run -d "iPhone 15 Pro" # iOS Simulator

# Force stop app on emulator (PowerShell)
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
& "$env:ANDROID_HOME\platform-tools\adb.exe" shell am force-stop app.vitalo.mobile.vitalo

# Analyze code for issues
flutter analyze

# Format code
dart format lib/

# Fix auto-fixable issues
dart fix --apply

# Generate freezed/json_serializable code
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Clean rebuild
flutter clean && flutter pub get && flutter run
```

---

## Quick Reference — What NOT to Do

| ❌ Never                      | ✅ Instead                                      |
| ----------------------------- | ----------------------------------------------- |
| `print()` / `debugPrint()`    | `talker.info/debug/error()`                     |
| `Colors.red`                  | `Theme.of(context).colorScheme.error`           |
| Magic numbers (16, 24, 44)    | `AppSpacing.*` constants                        |
| Material ripple on iOS        | `CupertinoButton` with opacity feedback         |
| Throw in services             | Return `Result<T>` sealed class                 |
| Tokens in SharedPreferences   | `flutter_secure_storage` (Keychain)             |
| Business logic in widgets     | Move to Notifiers/Services                      |
| Side effects in `build()`     | `ref.listen`, callbacks                         |
| `await` without mounted check | `if (!mounted) return;`                         |
| `MediaQuery.of(context)`      | `MediaQuery.sizeOf(context)`                    |
| Log PII (email, name, phone)  | Only log `userid`                               |
| Vague names (`data`, `temp`)  | Descriptive names (`userProfile`)               |
| Extend widgets                | Compose widgets                                 |
| Mutable state objects         | Use `freezed` immutable classes                 |
| Hardcoded strings             | Use localization                                |
| Touch targets < 44pt          | Minimum 44x44 (iOS standard)                    |
| AlertDialog on iOS            | `CupertinoAlertDialog`                          |
| Material bottom sheet on iOS  | `CupertinoModalPopup`                           |
| Forget to dispose             | Always dispose controllers, timers, focus nodes |

---

## iOS vs Android Quick Reference

| Pattern             | iOS (Primary)                      | Android (Secondary)         |
| ------------------- | ---------------------------------- | --------------------------- |
| **Button**          | `CupertinoButton`                  | `FilledButton`              |
| **Switch**          | `CupertinoSwitch`                  | `Switch.adaptive`           |
| **Slider**          | `CupertinoSlider`                  | `Slider.adaptive`           |
| **Alert**           | `CupertinoAlertDialog`             | `AlertDialog`               |
| **Action Sheet**    | `CupertinoActionSheet`             | `BottomSheet` with actions  |
| **Loading**         | `CupertinoActivityIndicator`       | `CircularProgressIndicator` |
| **Segmented**       | `CupertinoSlidingSegmentedControl` | `SegmentedButton`           |
| **Date Picker**     | `CupertinoDatePicker`              | `showDatePicker()`          |
| **List Tile**       | `CupertinoListTile`                | `ListTile`                  |
| **Navigation Bar**  | `CupertinoNavigationBar`           | `AppBar`                    |
| **Tab Bar**         | `CupertinoTabBar`                  | `NavigationBar`             |
| **Pull to Refresh** | `CupertinoSliverRefreshControl`    | `RefreshIndicator`          |
| **Touch Target**    | 44x44 minimum                      | 48x48 minimum               |
| **Border Radius**   | 10-14px (rounded rectangle)        | 12-28px (more rounded)      |
| **Tap Feedback**    | Opacity change                     | Ripple effect               |
| **Secure Storage**  | Keychain                           | EncryptedSharedPreferences  |
