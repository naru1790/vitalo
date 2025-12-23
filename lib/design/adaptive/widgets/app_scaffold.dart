// @frozen
// ARCHITECTURAL CONTRACT — DO NOT MODIFY WITHOUT REVIEW
//
// Tier-0 adaptive scaffold. Feature code depends on stable semantics.
//
// Primitives must not branch on brightness or platform appearance.
// All visual decisions must be expressed via semantic colors.
// If a role is missing, add it to AppColors — do not read raw signals.
//
// ═══════════════════════════════════════════════════════════════════════════
// GOD-WIDGET PREVENTION CLAUSE
// ═══════════════════════════════════════════════════════════════════════════
//
// AppScaffold is a STRUCTURAL LAYOUT PRIMITIVE only.
//
// It MUST NOT:
// - Branch on feature intent (auth, onboarding, profile, etc.)
// - Contain business logic or state management
// - Change behavior based on screen purpose or route
// - Contain auth-specific, flow-specific, or feature-driven logic
// - Inspect route intent, feature flags, or user state
// - Accept escape parameters for "special cases"
//
// It MAY ONLY:
// - Orchestrate primitives (body, chrome, safe area, scroll)
// - Read AppPlatformScope (for platform branching)
// - Read AppColorScope (for semantic colors)
// - Compose structural layout concerns
//
// If behavior must vary by use case:
// - Extract that behavior into a higher-level screen wrapper
// - Keep AppScaffold ignorant of the context
//
// Violations require architectural review.
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_environment_scope.dart';
import '../platform/app_platform_scope.dart';
import '../../tokens/color.dart';
import '../../tokens/icons.dart';
import '../error_feedback.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════

/// Tier-0 adaptive page scaffold.
///
/// Abstracts platform scaffolds and navigation bars behind semantic intent.
/// Feature code uses this instead of [Scaffold] or [CupertinoPageScaffold].
///
/// Platform rendering is determined by [AppPlatformScope]:
/// - iOS → Cupertino widgets
/// - Android → Material widgets
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.leadingAction,
    this.trailingActions = const [],
    this.scrollBehavior = AppScrollBehavior.none,
    this.safeArea = AppSafeArea.all,
    this.backgroundSurface = AppBackgroundSurface.base,
    this.chromeStyle = AppChromeStyle.standard,
    this.resizeToAvoidBottomInset = true,
  });

  /// The primary content of the page.
  final Widget body;

  /// Optional title displayed in the navigation bar.
  final String? title;

  /// Optional leading navigation action (back, close, or custom icon).
  final AppBarAction? leadingAction;

  /// Optional trailing actions in the navigation bar.
  final List<AppBarAction> trailingActions;

  /// Controls whether body is wrapped in a scroll container.
  final AppScrollBehavior scrollBehavior;

  /// Controls which safe area edges are respected.
  final AppSafeArea safeArea;

  /// Semantic surface layer for page background.
  final AppBackgroundSurface backgroundSurface;

  /// Visual style of the navigation chrome.
  final AppChromeStyle chromeStyle;

  /// Whether the scaffold resizes when the keyboard appears.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    // Read the shell's declared platform identity.
    // This is explicit injection, not detection.
    final platform = AppPlatformScope.of(context);

    final Widget structure;

    if (platform == AppPlatform.ios) {
      structure = _CupertinoPageStructure(
        body: body,
        title: title,
        leadingAction: leadingAction,
        trailingActions: trailingActions,
        scrollBehavior: scrollBehavior,
        safeArea: safeArea,
        backgroundSurface: backgroundSurface,
        chromeStyle: chromeStyle,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      );
    } else {
      structure = _MaterialPageStructure(
        body: body,
        title: title,
        leadingAction: leadingAction,
        trailingActions: trailingActions,
        scrollBehavior: scrollBehavior,
        safeArea: safeArea,
        backgroundSurface: backgroundSurface,
        chromeStyle: chromeStyle,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      );
    }

    return structure;
  }
}

/// Semantic navigation action intent.
///
/// Actions represent user intent, not widgets.
/// - [AppBarBackAction] and [AppBarCloseAction] are navigation intents.
/// - Default behavior is [Navigator.maybePop].
/// - Custom [onPressed] callbacks override default navigation.
sealed class AppBarAction {
  const AppBarAction();
}

/// Back navigation intent.
///
/// Semantically represents "go back" in a navigation stack.
/// When [onPressed] is null, defaults to [Navigator.maybePop].
final class AppBarBackAction extends AppBarAction {
  const AppBarBackAction({this.onPressed});

  /// Optional override. When null, uses [Navigator.maybePop].
  final VoidCallback? onPressed;
}

/// Close/dismiss intent.
///
/// Semantically represents "close this view" (modal, sheet, overlay).
/// When [onPressed] is null, defaults to [Navigator.maybePop].
final class AppBarCloseAction extends AppBarAction {
  const AppBarCloseAction({this.onPressed});

  /// Optional override. When null, uses [Navigator.maybePop].
  final VoidCallback? onPressed;
}

/// Icon action with explicit callback.
///
/// For non-navigation actions (settings, share, filter, etc.).
/// [onPressed] is required — there is no default behavior.
final class AppBarIconAction extends AppBarAction {
  const AppBarIconAction({
    required this.icon,
    required this.onPressed,
    this.semanticLabel,
  });

  final AppIcon icon;
  final VoidCallback onPressed;
  final String? semanticLabel;
}

/// Controls whether the body is wrapped in a scroll container.
enum AppScrollBehavior {
  /// Body rendered directly without scroll wrapper.
  none,

  /// Body wrapped in platform-appropriate scroll container.
  body,
}

/// Controls which safe area edges are respected.
enum AppSafeArea {
  /// All edges respect safe area.
  all,

  /// Only top edge respects safe area.
  top,

  /// Only bottom edge respects safe area.
  bottom,

  /// No safe area applied (caller handles it).
  none,
}

/// Visual style of the navigation chrome.
enum AppChromeStyle {
  /// Standard navigation bar appearance.
  standard,

  /// Elevated navigation bar with shadow/blur.
  elevated,

  /// Transparent navigation bar (content scrolls under).
  transparent,
}

/// Semantic surface layer for page backgrounds.
///
/// Consistent meaning across all platforms:
/// - [base]: Page background (neutralBase)
/// - [surface]: Content surface (neutralSurface)
/// - [elevated]: Higher elevation surface (surfaceElevated)
enum AppBackgroundSurface {
  /// Default page background (neutralBase).
  base,

  /// Content surface (neutralSurface).
  surface,

  /// Higher elevation surface (surfaceElevated).
  elevated,
}

// ═══════════════════════════════════════════════════════════════════════════
// PRIVATE IMPLEMENTATION
// ═══════════════════════════════════════════════════════════════════════════

/// Default navigation dismiss behavior.
VoidCallback _defaultDismiss(BuildContext context) {
  return () {
    final navigator = Navigator.maybeOf(context);
    if (navigator != null && navigator.canPop()) {
      navigator.maybePop();
    }
  };
}

/// Composes body with scroll behavior, safe area, and keyboard insets.
Widget _composeBody({
  required BuildContext context,
  required Widget child,
  required AppScrollBehavior scrollBehavior,
  required AppSafeArea safeArea,
  required bool hasTopChrome,
  required bool isCupertino,
  required bool resizeToAvoidBottomInset,
}) {
  Widget current = child;

  // Scroll wrapper with platform-appropriate physics
  if (scrollBehavior == AppScrollBehavior.body) {
    current = SingleChildScrollView(
      physics: isCupertino
          ? const BouncingScrollPhysics()
          : const ClampingScrollPhysics(),
      child: current,
    );
  }

  // Safe area calculation
  final bool wantsTop =
      safeArea == AppSafeArea.all || safeArea == AppSafeArea.top;
  final bool wantsBottom =
      safeArea == AppSafeArea.all || safeArea == AppSafeArea.bottom;

  // Don't double-apply top safe area when chrome handles it
  final bool applyTop = wantsTop && !hasTopChrome;

  if (safeArea != AppSafeArea.none) {
    current = SafeArea(
      top: applyTop,
      bottom: wantsBottom,
      left: true,
      right: true,
      child: current,
    );
  }

  // Keyboard inset compensation when scaffold doesn't resize.
  // Both platforms need this when resizeToAvoidBottomInset is false.
  if (!resizeToAvoidBottomInset) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    current = AnimatedPadding(
      duration: kThemeAnimationDuration,
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: current,
    );
  }

  return current;
}

// ─────────────────────────────────────────────────────────────────────────────
// Material Implementation
// ─────────────────────────────────────────────────────────────────────────────

final class _MaterialPageStructure extends StatelessWidget {
  const _MaterialPageStructure({
    required this.body,
    required this.title,
    required this.leadingAction,
    required this.trailingActions,
    required this.scrollBehavior,
    required this.safeArea,
    required this.backgroundSurface,
    required this.chromeStyle,
    required this.resizeToAvoidBottomInset,
  });

  final Widget body;
  final String? title;
  final AppBarAction? leadingAction;
  final List<AppBarAction> trailingActions;
  final AppScrollBehavior scrollBehavior;
  final AppSafeArea safeArea;
  final AppBackgroundSurface backgroundSurface;
  final AppChromeStyle chromeStyle;
  final bool resizeToAvoidBottomInset;

  bool get _hasTopBar =>
      title != null || leadingAction != null || trailingActions.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;

    // Background from semantic color tokens.
    // AppColorScope provides colors resolved by AdaptiveShell.
    final backgroundColor = _resolveBackgroundColor(colors);
    final appBar = _hasTopBar ? _buildAppBar(context) : null;

    final composedBody = _composeBody(
      context: context,
      child: body,
      scrollBehavior: scrollBehavior,
      safeArea: safeArea,
      hasTopChrome: _hasTopBar,
      isCupertino: false,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    // Provide a page-scoped ScaffoldMessenger + error feedback host.
    // This ensures transient errors do not survive navigation.
    return ScaffoldMessenger(
      child: ErrorFeedbackHost(
        child: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          appBar: appBar,
          body: composedBody,
        ),
      ),
    );
  }

  /// Resolve background using semantic color tokens.
  ///
  /// Maps background surface intent to semantic colors:
  /// - [base]: neutralBase (page background)
  /// - [surface]: neutralSurface (content surface)
  /// - [elevated]: surfaceElevated (higher elevation surface)
  Color _resolveBackgroundColor(AppColors colors) {
    return switch (backgroundSurface) {
      AppBackgroundSurface.base => colors.neutralBase,
      AppBackgroundSurface.surface => colors.neutralSurface,
      AppBackgroundSurface.elevated => colors.surfaceElevated,
    };
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    final bool isTransparent = chromeStyle == AppChromeStyle.transparent;

    return AppBar(
      forceMaterialTransparency: isTransparent,
      backgroundColor: isTransparent ? Colors.transparent : null,
      elevation: chromeStyle == AppChromeStyle.elevated
          ? theme.appBarTheme.elevation
          : null,
      scrolledUnderElevation: chromeStyle == AppChromeStyle.elevated
          ? theme.appBarTheme.scrolledUnderElevation
          : null,
      // Intentional: Raw Text() used until AppText is introduced.
      // Platform themes already provide correct text styling.
      title: title != null ? Text(title!) : null,
      leading: _buildLeading(context),
      actions: _buildActions(context),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    final action = leadingAction;
    if (action == null) return null;

    return switch (action) {
      AppBarBackAction() => IconButton(
        icon: Icon(AppIcons.resolve(AppIcon.navBack)),
        onPressed: action.onPressed ?? _defaultDismiss(context),
      ),
      AppBarCloseAction() => IconButton(
        icon: Icon(AppIcons.resolve(AppIcon.actionClose)),
        onPressed: action.onPressed ?? _defaultDismiss(context),
      ),
      AppBarIconAction() => IconButton(
        icon: Icon(AppIcons.resolve(action.icon)),
        tooltip: action.semanticLabel,
        onPressed: action.onPressed,
      ),
    };
  }

  List<Widget> _buildActions(BuildContext context) {
    if (trailingActions.isEmpty) return const [];

    return trailingActions
        .map((action) {
          return switch (action) {
            AppBarBackAction() => IconButton(
              icon: Icon(AppIcons.resolve(AppIcon.navBack)),
              onPressed: action.onPressed ?? _defaultDismiss(context),
            ),
            AppBarCloseAction() => IconButton(
              icon: Icon(AppIcons.resolve(AppIcon.actionClose)),
              onPressed: action.onPressed ?? _defaultDismiss(context),
            ),
            AppBarIconAction() => IconButton(
              icon: Icon(AppIcons.resolve(action.icon)),
              tooltip: action.semanticLabel,
              onPressed: action.onPressed,
            ),
          };
        })
        .toList(growable: false);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Cupertino Implementation
// ─────────────────────────────────────────────────────────────────────────────

final class _CupertinoPageStructure extends StatelessWidget {
  const _CupertinoPageStructure({
    required this.body,
    required this.title,
    required this.leadingAction,
    required this.trailingActions,
    required this.scrollBehavior,
    required this.safeArea,
    required this.backgroundSurface,
    required this.chromeStyle,
    required this.resizeToAvoidBottomInset,
  });

  final Widget body;
  final String? title;
  final AppBarAction? leadingAction;
  final List<AppBarAction> trailingActions;
  final AppScrollBehavior scrollBehavior;
  final AppSafeArea safeArea;
  final AppBackgroundSurface backgroundSurface;
  final AppChromeStyle chromeStyle;
  final bool resizeToAvoidBottomInset;

  bool get _hasTopBar =>
      title != null || leadingAction != null || trailingActions.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;

    // Background from semantic color tokens.
    // AppColorScope provides colors resolved by AdaptiveShell.
    final backgroundColor = _resolveBackgroundColor(colors);
    final navigationBar = _hasTopBar
        ? _buildNavigationBar(context, colors)
        : null;

    final composedBody = _composeBody(
      context: context,
      child: body,
      scrollBehavior: scrollBehavior,
      safeArea: safeArea,
      hasTopChrome: _hasTopBar,
      isCupertino: true,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    return CupertinoPageScaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      navigationBar: navigationBar,
      child: ErrorFeedbackHost(child: composedBody),
    );
  }

  /// Resolve background using semantic color tokens.
  ///
  /// Semantic mapping (iOS design language):
  /// - [base]: Solid page background (neutralBase)
  /// - [surface]: Solid content surface (neutralBase on iOS — see note)
  /// - [elevated]: Elevated surface (surfaceElevated)
  ///
  /// Note: iOS uses layered translucency (sheets, modals, blur) rather than
  /// tinted surfaces to indicate visual hierarchy. The [base] and [surface]
  /// semantics are preserved in code for API consistency, but render
  /// identically on iOS. This is intentional platform idiom, not a collapse.
  Color _resolveBackgroundColor(AppColors colors) {
    // Semantic distinction preserved. On iOS, base and surface share the
    // same solid color because iOS expresses surface hierarchy through
    // translucency and blur, not surface tinting.
    return switch (backgroundSurface) {
      AppBackgroundSurface.base => colors.neutralBase,
      AppBackgroundSurface.surface => colors.neutralBase,
      AppBackgroundSurface.elevated => colors.surfaceElevated,
    };
  }

  CupertinoNavigationBar _buildNavigationBar(
    BuildContext context,
    AppColors colors,
  ) {
    final Color barBackground = switch (chromeStyle) {
      AppChromeStyle.standard => colors.neutralBase,
      AppChromeStyle.elevated => colors.surfaceElevated,
      AppChromeStyle.transparent => Colors.transparent,
    };

    final Border? border = switch (chromeStyle) {
      AppChromeStyle.transparent => null,
      AppChromeStyle.standard => const Border(bottom: BorderSide.none),
      AppChromeStyle.elevated => const Border(bottom: BorderSide.none),
    };

    return CupertinoNavigationBar(
      backgroundColor: barBackground,
      border: border,
      // Intentional: Raw Text() used until AppText is introduced.
      // Platform themes already provide correct text styling.
      middle: title != null ? Text(title!) : null,
      leading: _buildLeading(context),
      trailing: _buildTrailing(context),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    final action = leadingAction;
    if (action == null) return null;

    return switch (action) {
      AppBarBackAction() => CupertinoNavigationBarBackButton(
        onPressed: action.onPressed ?? _defaultDismiss(context),
      ),
      AppBarCloseAction() => _CupertinoBarButton(
        icon: AppIcon.actionClose,
        onPressed: action.onPressed ?? _defaultDismiss(context),
      ),
      AppBarIconAction() => _CupertinoBarButton(
        icon: action.icon,
        onPressed: action.onPressed,
      ),
    };
  }

  Widget? _buildTrailing(BuildContext context) {
    if (trailingActions.isEmpty) return null;

    if (trailingActions.length == 1) {
      return _buildSingleTrailingAction(context, trailingActions.first);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: trailingActions
          .map((action) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0),
              child: _buildSingleTrailingAction(context, action),
            );
          })
          .toList(growable: false),
    );
  }

  Widget _buildSingleTrailingAction(BuildContext context, AppBarAction action) {
    return switch (action) {
      AppBarBackAction() => _CupertinoBarButton(
        icon: AppIcon.navBack,
        onPressed: action.onPressed ?? _defaultDismiss(context),
      ),
      AppBarCloseAction() => _CupertinoBarButton(
        icon: AppIcon.actionClose,
        onPressed: action.onPressed ?? _defaultDismiss(context),
      ),
      AppBarIconAction() => _CupertinoBarButton(
        icon: action.icon,
        onPressed: action.onPressed,
      ),
    };
  }
}

/// Cupertino navigation bar button.
final class _CupertinoBarButton extends StatelessWidget {
  const _CupertinoBarButton({required this.icon, required this.onPressed});

  final AppIcon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorScope.of(context).colors;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Icon(AppIcons.resolve(icon), color: colors.brandPrimary),
    );
  }
}
