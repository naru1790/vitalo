# Flutter Material 3 Development Guidelines - Soft Minimalistic Design

## Role & Objective

You are a **Senior Flutter Architect**. Produce production-grade, maintainable, testable code following **Material 3** principles from [Flutter UI docs](https://docs.flutter.dev/ui) with a **Soft Minimalistic Design** aesthetic.

**Design Philosophy:**

- **Calm & Approachable**: Desaturated warm tones, gentle contrasts
- **Clean & Uncluttered**: Generous whitespace, subtle elevations
- **Monochromatic Palette**: Warm taupe variations for cohesive harmony
- **Soft Typography**: Poppins for headings, Inter for body

Strictly adhere to these standards. If a request violates them (e.g., hardcoded colors, harsh contrasts, `print()`), correct it.

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
│   ├── theme.dart            # MaterialTheme (colors, typography, spacing)
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
  loading: () => const LoadingIndicator(),
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
  if (state.hasError) ScaffoldMessenger.of(context).showSnackBar(...);
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

## 3. Material 3 Design System

> **Reference:** https://docs.flutter.dev/ui/design

### Theme Authority (Material Theme Builder Pattern)

**Source of Truth:** `core/theme.dart`

Use [Material Theme Builder](https://material-foundation.github.io/material-theme-builder/) to generate your theme, then integrate directly.

```dart
// ❌ NEVER use hardcoded colors
color: Colors.orange

// ✅ ALWAYS use Theme.of(context)
color: Theme.of(context).colorScheme.primary
color: Theme.of(context).colorScheme.onSurface
color: Theme.of(context).colorScheme.surfaceContainerHigh

// ✅ Typography via theme
style: Theme.of(context).textTheme.headlineMedium
style: Theme.of(context).textTheme.bodyLarge
```

### Theme Structure

```dart
class MaterialTheme {
  final TextTheme textTheme;
  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() => const ColorScheme(...);
  static ColorScheme darkScheme() => const ColorScheme(...);

  ThemeData light() => theme(lightScheme());
  ThemeData dark() => theme(darkScheme());

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
  );
}

TextTheme createTextTheme(BuildContext context, String bodyFont, String displayFont) {
  final baseTextTheme = Theme.of(context).textTheme;
  final bodyTextTheme = GoogleFonts.getTextTheme(bodyFont, baseTextTheme);
  final displayTextTheme = GoogleFonts.getTextTheme(displayFont, baseTextTheme);
  return displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
}
```

### Usage in main.dart

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = createTextTheme(context, 'Inter', 'Poppins');
    final theme = MaterialTheme(textTheme);

    return MaterialApp(
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
    );
  }
}
```

### Material 3 Widgets (MANDATORY)

| Component           | Use                | Notes                          |
| :------------------ | :----------------- | :----------------------------- |
| **NavigationBar**   | Bottom nav         | M3 pill-shaped indicator       |
| **SegmentedButton** | Single choice      | Exclusive selection            |
| **FilterChip**      | Multi-select       | Non-exclusive selection        |
| **FilledButton**    | Primary actions    | High emphasis (Save, Submit)   |
| **OutlinedButton**  | Secondary actions  | Medium emphasis (Cancel, Skip) |
| **TextButton**      | Tertiary actions   | Low emphasis (Learn more)      |
| **TextFormField**   | Inputs             | Use `filled: true`             |
| **Switch.adaptive** | Toggles            | Native feel on iOS             |
| **Card**            | Content containers | Use M3 surface tint            |
| **AlertDialog**     | Dialogs            | Use `icon:` property           |
| **BottomSheet**     | Bottom sheets      | Use `showDragHandle: true`     |

### Spacing — STRICTLY use AppSpacing

> ⚠️ **NEVER use magic numbers for spacing, sizing, or border radius. Always use `AppSpacing` constants.**

#### AppSpacing Constants Reference

| Category          | Constant                | Value | Use Case                        |
| ----------------- | ----------------------- | ----- | ------------------------------- |
| **Base Scale**    | `xxs`                   | 4.0   | Minimal gaps, divider thickness |
|                   | `xs`                    | 8.0   | Tight spacing, small gaps       |
|                   | `sm`                    | 12.0  | Compact spacing, input padding  |
|                   | `md`                    | 16.0  | Default spacing, standard gaps  |
|                   | `lg`                    | 20.0  | Comfortable spacing             |
|                   | `xl`                    | 24.0  | Section gaps, generous padding  |
|                   | `xxl`                   | 32.0  | Large section breaks            |
|                   | `xxxl`                  | 40.0  | Major section separators        |
| **Page Layout**   | `pageHorizontalPadding` | 24.0  | Screen horizontal padding       |
|                   | `pageVerticalPadding`   | 24.0  | Screen vertical padding         |
|                   | `sectionSpacing`        | 32.0  | Between major sections          |
| **Components**    | `buttonHeight`          | 56.0  | Primary button height           |
|                   | `buttonHeightSmall`     | 40.0  | Secondary/compact buttons       |
|                   | `inputHeight`           | 56.0  | Text field height               |
|                   | `touchTargetMin`        | 48.0  | Minimum tappable area           |
| **Border Radius** | `cardRadius`            | 16.0  | Standard card corners           |
|                   | `cardRadiusLarge`       | 28.0  | Modal, bottom sheet corners     |
|                   | `cardRadiusSmall`       | 12.0  | Chips, small cards              |
|                   | `buttonRadius`          | 28.0  | Pill-shaped buttons             |
|                   | `inputRadius`           | 12.0  | Text field corners              |
| **Icon Sizes**    | `iconSizeSmall`         | 20.0  | Inline icons, badges            |
|                   | `iconSize`              | 24.0  | Standard icons                  |
|                   | `iconSizeLarge`         | 32.0  | Prominent icons                 |

#### Usage Guidelines

```dart
// ❌ NEVER use magic numbers
const SizedBox(height: 16)
EdgeInsets.all(24)
BorderRadius.circular(12)

// ✅ ALWAYS use AppSpacing
const SizedBox(height: AppSpacing.md)
EdgeInsets.all(AppSpacing.xl)
BorderRadius.circular(AppSpacing.cardRadiusSmall)

// ✅ Page layout
Padding(
  padding: AppSpacing.pagePadding,  // Pre-built EdgeInsets
  child: Column(...),
)

// ✅ Component sizing
SizedBox(
  height: AppSpacing.buttonHeight,
  child: FilledButton(...),
)

// ✅ Icon sizing
Icon(Icons.check, size: AppSpacing.iconSize)

// ✅ Touch targets - minimum 48x48
SizedBox(
  width: AppSpacing.touchTargetMin,
  height: AppSpacing.touchTargetMin,
  child: IconButton(...),
)
```

### Theme Color Usage Guide

**Always access colors via `Theme.of(context).colorScheme`** — this automatically handles light/dark mode and all contrast levels.

```dart
// ✅ Pattern for accessing colors
final colorScheme = Theme.of(context).colorScheme;

Container(
  color: colorScheme.surfaceContainer,
  child: Text('Hello', style: TextStyle(color: colorScheme.onSurface)),
)
```

#### Color Selection by Component Type

| Component Type                          | Color Role                                    | Usage                       |
| --------------------------------------- | --------------------------------------------- | --------------------------- |
| **Primary actions** (FAB, FilledButton) | `primary` / `onPrimary`                       | Main CTA buttons            |
| **Secondary actions** (OutlinedButton)  | `secondary` / `onSecondary`                   | Secondary buttons           |
| **Tertiary/Accent**                     | `tertiary` / `onTertiary`                     | Highlights, badges          |
| **Page background**                     | `surface`                                     | Scaffold background         |
| **Text on backgrounds**                 | `onSurface`                                   | Body text, titles           |
| **Muted/secondary text**                | `onSurfaceVariant`                            | Captions, hints, icons      |
| **Borders/dividers**                    | `outline`                                     | TextField borders, dividers |
| **Subtle borders**                      | `outlineVariant`                              | Card borders, separators    |
| **Error states**                        | `error` / `onError`                           | Validation errors           |
| **Containers/chips**                    | `primaryContainer` / `onPrimaryContainer`     | Selected states, chips      |
| **Secondary containers**                | `secondaryContainer` / `onSecondaryContainer` | Nav indicator, tags         |

#### Surface Elevation (M3 Tonal System)

```dart
// Use surfaceContainer variants for elevation hierarchy
colorScheme.surface                    // Level 0 - Page background
colorScheme.surfaceContainerLowest     // Level 1 - Deeply recessed
colorScheme.surfaceContainerLow        // Level 2 - Recessed content
colorScheme.surfaceContainer           // Level 3 - Default cards
colorScheme.surfaceContainerHigh       // Level 4 - Raised cards, dialogs
colorScheme.surfaceContainerHighest    // Level 5 - Highest elevation, menus
```

#### Common Component Color Mappings

```dart
final colorScheme = Theme.of(context).colorScheme;

// Shimmer loading
shimmerBaseColor: colorScheme.surfaceContainerHighest
shimmerHighlightColor: colorScheme.surface

// Cards
cardColor: colorScheme.surfaceContainer
cardBorderColor: colorScheme.outlineVariant

// Icons
primaryIcon: colorScheme.primary
secondaryIcon: colorScheme.onSurfaceVariant
disabledIcon: colorScheme.onSurface.withValues(alpha: 0.38)

// Buttons
filledButtonBg: colorScheme.primary
filledButtonFg: colorScheme.onPrimary
outlinedButtonBorder: colorScheme.outline
textButtonFg: colorScheme.primary

// Text fields
inputFillColor: colorScheme.surfaceContainerHighest
inputBorderColor: colorScheme.outline
inputFocusedBorder: colorScheme.primary
inputLabelColor: colorScheme.onSurfaceVariant
inputErrorColor: colorScheme.error

// Dividers
dividerColor: colorScheme.outlineVariant

// Navigation
navBarBg: colorScheme.surfaceContainer
navBarSelectedIcon: colorScheme.primary
navBarUnselectedIcon: colorScheme.onSurfaceVariant
navBarIndicator: colorScheme.secondaryContainer

// App bar
appBarBg: colorScheme.surface
appBarFg: colorScheme.onSurface
```

#### Automatic Light/Dark/Contrast Support

The theme automatically provides correct colors for all modes. Just use `Theme.of(context).colorScheme`:

| User Setting            | ColorScheme Used              |
| ----------------------- | ----------------------------- |
| Light mode              | `lightScheme()`               |
| Dark mode               | `darkScheme()`                |
| Light + Medium Contrast | `lightMediumContrastScheme()` |
| Light + High Contrast   | `lightHighContrastScheme()`   |
| Dark + Medium Contrast  | `darkMediumContrastScheme()`  |
| Dark + High Contrast    | `darkHighContrastScheme()`    |

### Soft Minimalistic Design Principles

**Color Philosophy:**

- **Monochromatic Warmth**: All colors derived from warm taupe base (#B5917A)
- **Gentle Contrast**: No harsh blacks or pure whites - use soft browns
- **Subtle Elevations**: Surface containers create depth through tone, not shadow
- **Muted Errors**: Even error states use desaturated terracotta tones

**Visual Guidelines:**

- **Border Width**: Always 1px maximum for soft appearance
- **Shadow Opacity**: Use subtle shadows (10-20% opacity) instead of harsh drops
- **Card Elevation**: Rely on `surfaceContainer` variants, minimal use of `BoxShadow`
- **Icon Treatment**: Use `onSurfaceVariant` for secondary icons (softer than `onSurface`)
- **Dividers**: Use `outlineVariant` for softest possible separators

**Spacing & Breathing Room:**

```dart
// ✅ Generous padding for minimalism
Padding(
  padding: const EdgeInsets.all(AppSpacing.lg), // 20.0
  child: Card(...),
)

// ✅ Section spacing for uncluttered layout
Column(
  children: [
    Section1(),
    const SizedBox(height: AppSpacing.sectionSpacing), // 32.0
    Section2(),
  ],
)
```

**Typography Softness:**

- Use `fontWeight: FontWeight.w400` (Regular) for body text
- Use `fontWeight: FontWeight.w600` (SemiBold) for headings - avoid Bold (w700)
- Prefer `onSurfaceVariant` for secondary text instead of reducing opacity
- Line height: Use default or 1.5x for comfortable reading

**Component-Specific Guidelines:**

```dart
// ✅ Soft buttons - no harsh elevations
FilledButton(
  style: FilledButton.styleFrom(
    elevation: 0, // Flat design
    backgroundColor: colorScheme.primary,
  ),
  child: Text('Continue'),
)

// ✅ Soft cards - subtle border instead of shadow
Container(
  decoration: BoxDecoration(
    color: colorScheme.surfaceContainer,
    borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
    border: Border.all(color: colorScheme.outlineVariant, width: 1),
  ),
)

// ✅ Soft inputs - light fill, subtle outline
TextFormField(
  decoration: InputDecoration(
    filled: true,
    fillColor: colorScheme.surfaceContainerLow,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
      borderSide: BorderSide(color: colorScheme.outline, width: 1),
    ),
  ),
)
```

---

## 4. Layout & Widgets

> **Reference:** https://docs.flutter.dev/ui/layout

### The Layout Golden Rule

**Constraints go down. Sizes go up. Parent sets position.**

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
| `FittedBox`      | Scale child to fit available space             |

### Avoiding Overflow

```dart
// ❌ Text will overflow
Row(children: [Text('Very long text...'), Icon(Icons.star)])

// ✅ Use Expanded with ellipsis
Row(children: [
  Expanded(child: Text('Very long text...', overflow: TextOverflow.ellipsis)),
  Icon(Icons.star),
])
```

### Widget Best Practices

```dart
// ✅ Use const constructors - prevents unnecessary rebuilds
const SizedBox(height: AppSpacing.md)
const Icon(Icons.check)

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

// ✅ Add itemExtent for fixed-height items (improves scroll performance)
ListView.builder(itemExtent: 72.0, ...)

// ✅ Use CachedNetworkImage for remote images
CachedNetworkImage(
  imageUrl: url,
  placeholder: (_, __) => const CircularProgressIndicator(),
  errorWidget: (_, __, ___) => const Icon(Icons.error),
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

### Pagination / Infinite Scroll

```dart
// ✅ Infinite scroll with NotificationListener
NotificationListener<ScrollNotification>(
  onNotification: (notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent - 200) {
        ref.read(itemsProvider.notifier).loadNextPage();
      }
    }
    return false;
  },
  child: ListView.builder(...),
)
```

---

## 5. Responsive & Adaptive Design

> **Reference:** https://docs.flutter.dev/ui/adaptive-responsive

### SafeArea

```dart
// ALWAYS wrap screens to avoid notches/status bar
Scaffold(body: SafeArea(child: Column(...)))
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

### Material 3 Breakpoints

| Window Class | Width     | Columns | Use Case                  |
| ------------ | --------- | ------- | ------------------------- |
| Compact      | < 600dp   | 4       | Phone                     |
| Medium       | 600-839dp | 8       | Tablet portrait, foldable |
| Expanded     | ≥ 840dp   | 12      | Tablet landscape, desktop |

```dart
// Responsive layout pattern
final width = MediaQuery.sizeOf(context).width;
if (width >= 840) return DesktopLayout();
if (width >= 600) return TabletLayout();
return MobileLayout();
```

### Platform Adaptive

```dart
// Use .adaptive constructors for native feel
Switch.adaptive(value: isOn, onChanged: ...)
Slider.adaptive(value: volume, onChanged: ...)
CircularProgressIndicator.adaptive()

// Check platform when needed
if (Platform.isIOS) { /* iOS-specific */ }
```

---

## 6. Interactivity & Touch

> **Reference:** https://docs.flutter.dev/ui/interactivity

### Touch Feedback

```dart
// ✅ Use InkWell for Material ripple effect
InkWell(
  onTap: () => _handleTap(),
  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
  child: Padding(
    padding: EdgeInsets.all(AppSpacing.md),
    child: Text('Tap me'),
  ),
)
```

### Touch Targets

**Minimum 48x48 logical pixels** (Material accessibility guideline)

```dart
IconButton(
  onPressed: () {},
  icon: Icon(Icons.settings),  // Default padding ensures 48x48
)
```

### Loading States in Buttons

```dart
// ✅ Use loading state pattern
FilledButton(
  onPressed: _isLoading ? null : _handleSubmit,
  child: _isLoading
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : const Text('Submit'),
)
```

---

## 7. Navigation (GoRouter)

> **Reference:** https://docs.flutter.dev/ui/navigation

### Navigation Methods

```dart
context.go('/dashboard');    // REPLACE stack (can't go back)
context.push('/settings');   // ADD to stack (back button works)
context.pop();               // Go back
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

---

## 8. Animations

> **Reference:** https://docs.flutter.dev/ui/animations

### Prefer Implicit Animations

```dart
// ✅ AnimatedContainer handles transitions automatically
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: _isExpanded ? 200 : 100,
  color: _isActive
      ? Theme.of(context).colorScheme.primary
      : Theme.of(context).colorScheme.surface,
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

> **Reference:** https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility

### Semantic Labels

```dart
// ✅ Images MUST have semantic labels
Image.network(url, semanticLabel: 'User profile photo')

// ✅ Meaningful icons need labels
Icon(Icons.favorite, semanticLabel: 'Add to favorites')

// ✅ Group related content
MergeSemantics(
  child: Row(children: [Icon(Icons.calendar), Text('March 15')]),
)

// ✅ Exclude decorative elements
ExcludeSemantics(child: DecorativeImage())
```

### Color Contrast

**WCAG 2.1 minimums:** Normal text 4.5:1, Large text 3:1, UI components 3:1

Verify colors: https://webaim.org/resources/contrastchecker/

### Focus Management

```dart
// ✅ Control focus programmatically
final _emailFocus = FocusNode();
final _passwordFocus = FocusNode();

TextFormField(
  focusNode: _emailFocus,
  textInputAction: TextInputAction.next,
  onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
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

### Keyboard Navigation

```dart
// ✅ Handle keyboard shortcuts
Shortcuts(
  shortcuts: {
    LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
  },
  child: Actions(
    actions: {
      DismissIntent: CallbackAction<DismissIntent>(
        onInvoke: (_) => Navigator.pop(context),
      ),
    },
    child: Dialog(...),
  ),
)
```

### Testing Accessibility

```dart
// 1. Enable TalkBack (Android) or VoiceOver (iOS)
// 2. Navigate app using only screen reader
// 3. Verify all interactive elements are announced
// 4. Check logical focus order
// 5. Test with keyboard only (desktop/web)

// Automated semantic testing
testWidgets('button has semantic label', (tester) async {
  await tester.pumpWidget(MyApp());
  expect(
    tester.getSemantics(find.byType(FilledButton)),
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

// Shake to open logs (optional)
TalkerWrapper(
  talker: talker,
  child: MaterialApp(...),
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
  case AuthFailure(:final message): ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
```

### Secure Storage

```dart
// ❌ NEVER store tokens in SharedPreferences
await prefs.setString('auth_token', token);  // INSECURE!

// ✅ Use flutter_secure_storage
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
await storage.read(key: 'auth_token');
await storage.delete(key: 'auth_token');
```

### Error Boundary Widget

```dart
/// Catches errors in widget subtree and shows fallback UI
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error)? fallbackBuilder;

  const ErrorBoundary({super.key, required this.child, this.fallbackBuilder});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      setState(() => _error = details.exception);
      talker.error('ErrorBoundary caught', details.exception, details.stack);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallbackBuilder?.call(_error!) ??
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: AppSpacing.touchTargetMin),
                const SizedBox(height: AppSpacing.md),
                const Text('Something went wrong'),
                TextButton(
                  onPressed: () => setState(() => _error = null),
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
    }
    return widget.child;
  }
}

// Usage: Wrap screens or sections that might fail
ErrorBoundary(
  child: ComplexFeatureWidget(),
  fallbackBuilder: (error) => ErrorCard(message: error.toString()),
)
```

---

## 12. Auth Flow

| Method | Implementation                                               |
| ------ | ------------------------------------------------------------ |
| OAuth  | Apple (iOS), Google → `AuthService.signInWithApple/Google()` |
| OTP    | Email magic code → `sendOtpToEmail()` + `verifyOtp()`        |
| Guest  | Anonymous → `signInAnonymously()`, check `isAnonymous`       |

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

// ❌ WRONG — Comment instead of proper naming
// Get the data
final d = await repo.fetch();

// ✅ CORRECT — Self-documenting with proper names
final userData = await userRepository.fetchProfile();
if (userData == null) return;

// ✅ CORRECT — Comment explains WHY when necessary
// Guest users don't have profile data yet, skip personalization
if (user == null) return;
```

**When to Use Comments:**

- Explain business logic rationale
- Document workarounds for known issues
- Clarify non-obvious algorithm choices
- Add TODO/FIXME with ticket references
- Explain regex patterns or complex calculations

**When NOT to Use Comments:**

- Describing what code does (use better names instead)
- Repeating variable/function names
- Obvious flow control logic
- Type information (Dart has strong typing)

### Key Rules

1. **Trailing commas** for multi-line parameters
2. **Dark mode:** Check `Theme.of(context).brightness`
3. **Cleanup:** Run `flutter analyze` after refactoring
4. **Remove unused:** Delete unused code, imports, files

---

## 14. Form Handling

### Validation Pattern

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Email',
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Email is required';
          if (!value.contains('@')) return 'Enter a valid email';
          return null;
        },
        onSaved: (value) => _email = value!,
      ),
      const SizedBox(height: AppSpacing.md),
      FilledButton(
        onPressed: _isLoading ? null : () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _submit();
          }
        },
        child: _isLoading
            ? const CircularProgressIndicator()
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
testWidgets('FilledButton shows loading state', (tester) async {
  await tester.pumpWidget(
    ProviderScope(child: MaterialApp(home: LoginScreen())),
  );

  await tester.tap(find.text('Login'));
  await tester.pump();

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});

testWidgets('Form shows validation error', (tester) async {
  await tester.pumpWidget(MaterialApp(home: SignupScreen()));

  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();

  expect(find.text('Email is required'), findsOneWidget);
});
```

---

## 16. Dependencies

| Package                  | Purpose                       |
| ------------------------ | ----------------------------- |
| `supabase_flutter`       | Auth, database, realtime      |
| `go_router`              | Declarative routing           |
| `flutter_riverpod`       | State management              |
| `talker_flutter`         | Logging, error tracking       |
| `talker_dio_logger`      | HTTP request/response logging |
| `dio`                    | HTTP client                   |
| `freezed`                | Immutable state classes       |
| `flutter_secure_storage` | Secure token storage          |
| `cached_network_image`   | Cached remote images          |
| `pinput`                 | OTP input widget              |
| `sign_in_with_apple`     | Apple OAuth                   |
| `google_sign_in`         | Google OAuth                  |
| `google_fonts`           | Typography                    |
| `shared_preferences`     | Non-sensitive local storage   |

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

# Run on specific emulator
flutter run -d emulator-5554

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
| Magic numbers (16, 24, 48)    | `AppSpacing.*` constants                        |
| Throw in services             | Return `Result<T>` sealed class                 |
| Tokens in SharedPreferences   | `flutter_secure_storage`                        |
| Business logic in widgets     | Move to Notifiers/Services                      |
| Side effects in `build()`     | `ref.listen`, callbacks                         |
| `await` without mounted check | `if (!mounted) return;`                         |
| `MediaQuery.of(context)`      | `MediaQuery.sizeOf(context)`                    |
| Log PII (email, name, phone)  | Only log `userid`                               |
| Vague names (`data`, `temp`)  | Descriptive names (`userProfile`)               |
| Extend widgets                | Compose widgets                                 |
| Mutable state objects         | Use `freezed` immutable classes                 |
| Hardcoded strings             | Use localization                                |
| Forget to dispose             | Always dispose controllers, timers, focus nodes |
