# Vitalo — AI Coding Agent Instructions

## Ownership Model

| Layer               | Owns                                 | Imports                             |
| ------------------- | ------------------------------------ | ----------------------------------- |
| **Feature code**    | WHAT (intent, content)               | `widgets.dart` + `design.dart` only |
| **Design system**   | HOW (primitives, tokens, archetypes) | internal design modules             |
| **Platform shells** | RENDER (iOS/Android specifics)       | Flutter SDK                         |

Feature code MUST NOT express mechanics. If reaching for `Padding`, `EdgeInsets`, `TextStyle`, `Icons.*`, or layout widgets—stop. The design system owns that.

## Directory Contract

| Path                           | Rule                                                 |
| ------------------------------ | ---------------------------------------------------- |
| `lib/design/design.dart`       | Single import for all feature code                   |
| `lib/design/tokens/`           | Semantic tokens — NEVER hard-code values they govern |
| `lib/design/adaptive/pages/`   | Page archetypes — NEVER invent layouts               |
| `lib/design/adaptive/widgets/` | Primitives — NEVER use raw Flutter equivalents       |
| `lib/features/`                | Feature modules — express intent through design API  |
| `docs/design/*.md`             | Frozen contracts — treat as immutable law            |

## Page Archetypes

Every screen MUST use exactly one archetype. Custom layouts are FORBIDDEN.

| Archetype           | Use Case                        |
| ------------------- | ------------------------------- |
| `CenteredFocusPage` | Single-task flow (OTP, sign-in) |
| `StagePage`         | Landing with hero + actions     |
| `HubPage`           | Dense scrollable sections       |
| `DocumentPage`      | Long-form reading               |
| `SheetPage`         | Modal bottom sheet              |

Archetypes OWN scroll, padding, and safe-area. Feature code provides content only.

## Token Usage

```dart
// Icons — semantic mapping required
AppIcon(AppIcons.navBack, size: AppIconSize.small)

// Spacing — archetype usually handles; when needed:
SizedBox(height: Spacing.of.md)

// Colors — always from scope
AppColorScope.of(context).colors.brandPrimary

// Feedback — errors only, success is silent (interaction contract)
AppErrorFeedback.show(context, 'Message')
```

## Feature Screen Template

```dart
import 'package:flutter/widgets.dart';
import '../../../design/design.dart';

class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HubPage(
      title: 'Example',
      content: Column(children: [...]),
    );
  }
}
```

## Navigation Intent

Routes declare semantic intent; platform shells resolve animation:

```dart
AdaptivePage<void>(
  child: const ProfileScreen(),
  intent: NavTransition.push,   // push | modal | peer
)
```

## Flow Classes

Modal editing flows use abstract flow classes. Flow owns presentation; screen owns callback:

```dart
// In flows/identity_flows.dart
abstract final class IdentityFlows {
  static Future<String?> editDisplayName({
    required BuildContext context,
    required String initialText,
    required Future<bool> Function(String) onSave,
  }) => AppBottomSheet.show<String>(context, sheet: SheetPage(...));
}

// In screen
final result = await IdentityFlows.editDisplayName(...);
if (result != null) setState(() => _name = result);
```

## UI State Contract

Screens that fetch remote data MUST handle all four states explicitly:

| State   | Requirement                                 |
| ------- | ------------------------------------------- |
| Empty   | No data exists — show empty state           |
| Loading | Data fetching — skeleton or local indicator |
| Content | Data available — render normally            |
| Error   | Fetch failed — show error with retry        |

## Destructive Actions

- MUST use `AppButtonVariant.destructive` styling
- MUST require confirmation sheet before execution
- Confirmation MUST name the item and state the consequence

```dart
AppButton(
  label: 'Delete Account',
  variant: AppButtonVariant.destructive,
  onPressed: () => _showDeleteConfirmation(context),
)
```

## Build

```bash
flutter pub get
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
flutter analyze  # MUST pass
dart run tool/check_imports.dart  # Enforces import architecture
```

## Violations

FORBIDDEN in feature code:

- Importing `material.dart` or `cupertino.dart`
- Using `Scaffold`, `Padding`, `EdgeInsets`, `SingleChildScrollView`
- Hard-coding colors, font sizes, spacing values
- Referencing `Icons.*` or `CupertinoIcons.*`
- Showing success feedback (interaction contract: errors only)
- Inventing page layouts outside archetypes
