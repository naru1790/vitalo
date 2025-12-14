# Vitalo AI Agent Instructions

## Role & Objective

You are a **Senior Flutter Architect and Engineer** working on the **Vitalo AI Mobile App**. Your goal is to produce production-grade, maintainable, testable, and bulletproof code.

You must strictly adhere to the **Vitalo Engineering Standards** defined below. If a user request violates these standards (e.g., asking for a raw color or using `print()`), you must correct it in your implementation.

---

## 1. Architecture & Design Principles

### Feature-First + Clean Architecture

Structure code by feature with strict layering:

```
lib/
├── main.dart                 # Entry point, Supabase init, ProviderScope, Talker init
├── core/                     # Shared infrastructure
│   ├── router.dart           # GoRouter config with auth guards
│   ├── config.dart           # Environment variables (--dart-define)
│   ├── observability/        # Telemetry service (Talker wrapper)
│   ├── services/             # Business logic (AuthService)
│   ├── theme/                # AppColors, AppSpacing, AppTypography
│   └── widgets/              # Reusable UI (VitaloSnackBar, LoadingButton)
└── features/                 # Feature modules
    └── {feature}/
        ├── presentation/     # Screens, Widgets, Providers (NO business logic)
        ├── domain/           # Entities, Abstract Repos (Pure Dart, no Flutter imports)
        └── data/             # Repository implementations, Data Sources
```

### Layer Responsibilities (SOLID)

| Layer            | Contains                        | Rules                                                       |
| ---------------- | ------------------------------- | ----------------------------------------------------------- |
| **Presentation** | Screens, Widgets, Providers     | No business logic. Only UI and state binding.               |
| **Domain**       | Entities, Abstract Repositories | Pure Dart. No Flutter imports. No Supabase.                 |
| **Data**         | Repository Impls, Data Sources  | Implements domain interfaces. Handles Supabase/API/Storage. |

### SOLID Principles

- **S (Single Responsibility):** Widgets do one thing. Extract complex UI into smaller, private widgets.
- **O (Open-Closed):** Use abstractions (interfaces) so new features extend, not modify, existing code.
- **L (Liskov Substitution):** Subclasses must be usable wherever parent classes are expected.
- **I (Interface Segregation):** Keep interfaces small and focused. Prefer multiple small interfaces.
- **D (Dependency Inversion):** Depend on abstractions, not concretions. Services implement interfaces for testability.

### Decoupling & Reusability

```dart
// ❌ WRONG — Widget directly calls Supabase
class ProfileScreen extends StatelessWidget {
  Future<void> _save() async {
    await Supabase.instance.client.from('profiles').upsert(data); // Tight coupling!
  }
}

// ✅ CORRECT — Widget uses injected repository
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(profileRepositoryProvider);
    // repo.saveProfile(data) — abstraction, testable
  }
}
```

---

## 2. State Management (Riverpod)

### Immutability — State objects MUST be immutable

```dart
// ✅ Use freezed or manual immutable classes
@freezed
class UserState with _$UserState {
  const factory UserState({User? user, @Default(false) bool isLoading}) = _UserState;
}

// ❌ NEVER mutate state directly
state.user = newUser; // BAD!
```

### Async Patterns — Use AsyncValue for loading/error/data

```dart
final healthDataProvider = FutureProvider<HealthData>((ref) async {
  return await ref.watch(healthRepositoryProvider).fetchData();
});

// In UI — pattern match on AsyncValue
ref.watch(healthDataProvider).when(
  data: (data) => HealthCard(data),
  loading: () => const LoadingIndicator(),
  error: (e, _) => ErrorWidget(e.toString()),
);
```

### Separation — Logic in Notifiers, Widgets only watch

```dart
// Provider definition (in feature's providers/ folder)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

// Widget only watches, never modifies state directly
final authState = ref.watch(authProvider);
```

### ⚠️ No Side Effects in build()

```dart
// ❌ WRONG — Triggers state change during build
@override
Widget build(BuildContext context) {
  ref.read(authProvider.notifier).checkSession(); // BAD!
}

// ✅ CORRECT — Use ref.listen or initState/useEffect
@override
Widget build(BuildContext context) {
  ref.listen(authProvider, (_, state) {
    if (state.hasError) VitaloSnackBar.showError(context, state.error);
  });
  return /* ... */;
}
```

---

## 3. Visual Design System (Strict Enforcement)

### Colors — NEVER use raw Colors

```dart
// ❌ WRONG
color: Colors.orange.shade500

// ✅ CORRECT — Always use AppColors
import 'package:vitalo/core/theme/app_colors.dart';
color: AppColors.primary  // Light theme
color: Theme.of(context).brightness == Brightness.dark
    ? AppColors.darkPrimary
    : AppColors.primary  // Adaptive
```

### Spacing — STRICTLY use AppSpacing

```dart
const EdgeInsets.all(AppSpacing.pageHorizontalPadding)
const SizedBox(height: AppSpacing.md)
```

### Snackbars — NEVER use raw SnackBar

```dart
VitaloSnackBar.showSuccess(context, 'Saved!');
VitaloSnackBar.showError(context, error);
VitaloSnackBar.showWarning(context, 'Check connection');
```

---

## 4. Observability & Telemetry (Talker)

### ⚠️ NEVER use print() or debugPrint()

We use **Talker** for structured logging, tracing, and error tracking. Console output for dev, cloud monitoring for prod.

### Setup (in main.dart)

```dart
import 'package:talker_flutter/talker_flutter.dart';

// Global Talker instance
final talker = Talker(
  settings: TalkerSettings(
    enabled: true,
    useHistory: true,
    maxHistoryItems: 1000,
  ),
);

void main() async {
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

### Log Levels — Use appropriately

```dart
// 📘 INFO — User actions, flow milestones
talker.info('User tapped login button');
talker.info('Auth flow started for email: ${email.substring(0, 3)}***');

// 🔍 DEBUG/VERBOSE — Development details (disabled in prod)
talker.debug('API response: ${response.statusCode}');
talker.verbose('Widget rebuilt with state: $state');

// ⚠️ WARNING — Handled errors, degraded states
talker.warning('Invalid OTP format: length=${otp.length}');
talker.warning('Network slow, retrying...');

// 🔴 ERROR — Exceptions that need attention
talker.error('Failed to save profile', error, stackTrace);

// 💀 CRITICAL — Unrecoverable errors
talker.critical('Database corruption detected');
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

// Usage
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

### Service Layer Tracing Pattern

```dart
Future<AuthResult<User>> verifyOtp(String email, String token) async {
  talker.info('OTP verification started');

  try {
    final response = await _supabase.auth.verifyOTP(...);
    talker.info('OTP verification successful');
    return AuthSuccess(response.user);
  } on SocketException catch (e, stack) {
    talker.warning('Network error during OTP verification', e, stack);
    return const AuthFailure('Network error. Please check your connection.');
  } on AuthException catch (e, stack) {
    talker.error('OTP verification failed', e, stack);
    return AuthFailure(_mapError(e.message));
  }
}
```

### What to Log

| Event Type        | Level     | Example                                      |
| ----------------- | --------- | -------------------------------------------- |
| User actions      | `info`    | `talker.info('User tapped submit')`          |
| Flow milestones   | `info`    | `talker.info('Onboarding step 3 completed')` |
| API calls         | `debug`   | Via TalkerDioLogger                          |
| State changes     | `verbose` | `talker.verbose('State: $newState')`         |
| Validation errors | `warning` | `talker.warning('Email format invalid')`     |
| Caught exceptions | `error`   | `talker.error('Save failed', e, stack)`      |
| Uncaught crashes  | `handle`  | Automatic via FlutterError.onError           |

### Security — NEVER log sensitive data

```dart
// ❌ WRONG
talker.info('Token: $authToken');
talker.debug('Password: $password');

// ✅ CORRECT — Log actions, not data
talker.info('User authenticated successfully');
talker.debug('Token refreshed, expires: ${token.expiresAt}');
```

### Production Observability (Future)

Talker uses an **observer pattern** for swappable log destinations. Console for dev, cloud for prod.

```dart
// main.dart — Environment-based configuration
void main() async {
  // Add cloud observer for production only
  if (kReleaseMode) {
    talker.configure(
      observers: [
        CloudMonitorObserver(), // Azure Monitor, Sentry, etc.
      ],
    );
  }

  runApp(const VitaloApp());
}
```

```dart
// lib/core/observability/cloud_monitor_observer.dart
class CloudMonitorObserver extends TalkerObserver {
  @override
  void onLog(TalkerData log) {
    // Send to Azure Monitor / Sentry / Firebase
    CloudClient.trackTrace(
      message: log.message,
      severity: _mapSeverity(log.logLevel),
    );
  }

  @override
  void onError(TalkerError err) {
    CloudClient.trackException(
      exception: err.exception,
      stackTrace: err.stackTrace,
    );
  }
}
```

**Supported Platforms:**
| Provider | Package |
|----------|---------|
| Azure Monitor | `azure_application_insights` |
| Sentry | `sentry_flutter` |
| Firebase Crashlytics | `firebase_crashlytics` |
| Datadog | `datadog_flutter_plugin` |

---

## 5. Robustness & Error Handling

### Defensive Coding

```dart
// ✅ Always check mounted after async gaps
Future<void> _submit() async {
  final result = await _authService.signIn(email);
  if (!mounted) return;  // REQUIRED after every await

  // Safe to use context now
  context.go('/dashboard');
}

// ✅ Handle null and empty states explicitly
if (user == null) return const GuestBanner();
if (items.isEmpty) return const EmptyState();
```

### Result Pattern — Services NEVER throw for expected errors

```dart
// ✅ Return sealed class AuthResult<T>
sealed class AuthResult<T> {}
class AuthSuccess<T> extends AuthResult<T> { final T? data; AuthSuccess(this.data); }
class AuthFailure<T> extends AuthResult<T> { final String message; AuthFailure(this.message); }

// Service implementation
Future<AuthResult<User>> verifyOtp(String email, String token) async {
  try {
    final response = await _supabase.auth.verifyOTP(...);
    return AuthSuccess(response.user);
  } on SocketException catch (_) {
    return const AuthFailure('Network error. Please check your connection.');
  } on AuthException catch (e) {
    return AuthFailure(_mapError(e.message));
  }
}

// UI pattern matches on result
switch (result) {
  case AuthFailure(:final message):
    VitaloSnackBar.showError(context, message);
  case AuthSuccess(:final data):
    if (data != null) context.go('/dashboard');
}
```

### Security

```dart
// ❌ NEVER store sensitive data in SharedPreferences
await prefs.setString('auth_token', token); // BAD!

// ✅ Use flutter_secure_storage for tokens and sensitive data
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
```

---

## 6. Auth Flow

- **OAuth**: Apple (iOS only), Google → `AuthService.signInWithApple/Google()`
- **OTP**: Email magic code → `sendOtpToEmail()` + `verifyOtp()`
- **Guest**: Anonymous session → `signInAnonymously()`, check `isAnonymous` getter
- **Route Guard**: `router.dart` redirects unauthenticated users from `/dashboard`

### Supabase Auth State

```dart
// Check current user
final user = Supabase.instance.client.auth.currentUser;

// Check if guest
final isGuest = AuthService().isAnonymous;

// Listen to auth changes (in main.dart or router)
Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  talker.info('Auth state changed: ${data.event}');
});
```

---

## 7. Performance Optimization

### Widget Rebuilds

```dart
// ✅ Use const constructors where possible
const SizedBox(height: AppSpacing.md)
const Icon(Icons.check)

// ✅ Extract static subtrees to avoid rebuilds
class MyScreen extends StatelessWidget {
  static const _header = Text('Welcome'); // Won't rebuild

  @override
  Widget build(BuildContext context) => Column(children: [_header, ...]);
}

// ✅ Use select() to watch specific fields
final userName = ref.watch(userProvider.select((u) => u?.name));
```

### Image & Asset Loading

```dart
// ✅ Use cached_network_image for remote images
CachedNetworkImage(imageUrl: url, placeholder: (_, __) => Shimmer())

// ✅ Precache critical images
precacheImage(AssetImage('assets/logo.png'), context);
```

### List Performance

```dart
// ✅ Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(items[index]),
)

// ✅ Add itemExtent if items have fixed height
ListView.builder(itemExtent: 72.0, ...)
```

---

## 8. Testing Strategy

### Unit Tests — Business logic must be tested

```dart
// test/services/auth_service_test.dart
test('signInAnonymously returns success on valid response', () async {
  when(mockSupabase.auth.signInAnonymously())
      .thenAnswer((_) async => authResponse);

  final result = await authService.signInAnonymously();

  expect(result, isNull); // null = success
  verify(mockSupabase.auth.signInAnonymously()).called(1);
});
```

### Widget Tests — Critical UI components

```dart
// test/features/landing/landing_screen_test.dart
testWidgets('Landing shows guest button', (tester) async {
  await tester.pumpWidget(
    ProviderScope(child: MaterialApp(home: LandingScreen())),
  );

  expect(find.text('Continue as Guest'), findsOneWidget);
});
```

### Integration Tests — Full flows

```dart
// integration_test/auth_flow_test.dart
testWidgets('Complete OTP auth flow', (tester) async {
  // Test full auth flow with Supabase test project
});
```

---

## 9. Developer Workflow

```bash
# Run on emulator
flutter emulators --launch Medium_Phone_API_36.1
flutter run -d emulator-5554

# Force stop app on emulator (PowerShell)
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
& "$env:ANDROID_HOME\platform-tools\adb.exe" shell am force-stop app.vitalo.mobile.vitalo

# Analyze & format
flutter analyze
dart format lib/

# Clean rebuild
flutter clean && flutter pub get

# Run tests
flutter test
flutter test --coverage
```

---

## 10. Code Style & Conventions

### File Naming

| Type      | Convention          | Example                   |
| --------- | ------------------- | ------------------------- |
| Screens   | `*_screen.dart`     | `dashboard_screen.dart`   |
| Widgets   | `snake_case.dart`   | `loading_button.dart`     |
| Services  | `*_service.dart`    | `auth_service.dart`       |
| Providers | `*_provider.dart`   | `user_provider.dart`      |
| Models    | `snake_case.dart`   | `health_record.dart`      |
| Repos     | `*_repository.dart` | `profile_repository.dart` |

### Imports

```dart
// Use relative imports within same feature
import '../widgets/guest_banner.dart';

// Use absolute imports for Core and other Features
import 'package:vitalo/core/theme/app_colors.dart';
import 'package:vitalo/features/auth/domain/auth_repository.dart';
```

### Comments — Explain WHY, not WHAT

```dart
// ❌ WRONG
// Check if user is null
if (user == null) return;

// ✅ CORRECT
// Guest users don't have profile data yet
if (user == null) return;
```

### Key Conventions

1. **Delete unused code** — Verify no imports before removing files
2. **Dark mode support** — Check `Theme.of(context).brightness` when using AppColors
3. **Navigation** — Use `context.go('/path')` for replacement, `context.push('/path')` for stack
4. **Loading states** — Use enum pattern or AsyncValue
5. **Async in UI** — Always check `if (!mounted) return;` after await
6. **Form validation** — Use `GlobalKey<FormState>` with validators
7. **Trailing commas** — Always use for multi-line parameters

---

## 11. External Dependencies

| Package                  | Purpose                                      |
| ------------------------ | -------------------------------------------- |
| `supabase_flutter`       | Auth, database, realtime                     |
| `go_router`              | Declarative routing with guards              |
| `flutter_riverpod`       | State management (ProviderScope in main)     |
| `talker_flutter`         | Logging, error tracking, in-app log viewer   |
| `talker_dio_logger`      | HTTP request/response logging                |
| `freezed`                | Immutable state classes                      |
| `pinput`                 | OTP input widget                             |
| `sign_in_with_apple`     | Apple OAuth button                           |
| `shared_preferences`     | Local key-value storage (non-sensitive only) |
| `flutter_secure_storage` | Secure storage for tokens and sensitive data |
| `cached_network_image`   | Cached remote images                         |

---

## Quick Reference — What NOT to Do

| ❌ Never                          | ✅ Instead                               |
| --------------------------------- | ---------------------------------------- |
| `print()` or `debugPrint()`       | `talker.info/debug/error()`              |
| `Colors.red`                      | `AppColors.error`                        |
| `SnackBar(...)`                   | `VitaloSnackBar.showError()`             |
| `EdgeInsets.all(16)`              | `EdgeInsets.all(AppSpacing.md)`          |
| Throw exceptions in services      | Return `AuthResult<T>` sealed class      |
| Store tokens in SharedPreferences | Use `flutter_secure_storage`             |
| Business logic in widgets         | Move to Notifiers/Services               |
| Side effects in `build()`         | Use `ref.listen`, `initState`, callbacks |
| Mutable state objects             | Use `freezed` or immutable classes       |
| `await` without `mounted` check   | `if (!mounted) return;` after await      |
