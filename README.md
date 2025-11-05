# Vitalo

Vitalo is a Flutter-based mobile app foundation for AI-driven health and wellness experiences. It ships with a clean feature-first architecture, Riverpod state management, and GoRouter navigation.

## Quick start

```bash
flutter pub get
flutter run --dart-define=SUPABASE_URL= --dart-define=SUPABASE_ANON_KEY=
```

## Generate launcher icons

```bash
flutter pub run flutter_launcher_icons
```

## Notes

- Color palette is centralized in `lib/core/theme/app_colors.dart` and supports light/dark themes.
- Reusable UI components live under `lib/core/widgets/` for consistent styling.
- Configuration values rely on `--dart-define`; never commit secrets to source control.
- Supabase integration hooks are prepared but intentionally deferred for secure rollout.
