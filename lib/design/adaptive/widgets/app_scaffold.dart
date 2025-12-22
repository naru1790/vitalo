import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/app_platform_scope.dart';
import '../../tokens/elevation.dart';
import '../../tokens/icons.dart';
import '../../tokens/motion.dart';
import '../error_feedback.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PUBLIC API — ACTIVE FREEZE ZONE
// ═══════════════════════════════════════════════════════════════════════════

/// Tier-0 adaptive page scaffold.
///
/// Abstracts platform scaffolds and navigation bars behind semantic intent.
/// Feature code uses this instead of [Scaffold] or [CupertinoPageScaffold].
///
/// Platform rendering is determined by [AppPlatformScope], which is
/// injected by the active shell:
/// - [IosShell] injects [AppPlatform.ios] → Cupertino widgets
/// - [AndroidShell] injects [AppPlatform.android] → Material widgets
///
/// This widget does not detect platform, resolve tokens, or inject scopes.
/// It reads the shell's declared platform and renders appropriately.
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

    if (platform == AppPlatform.ios) {
      return _CupertinoPageStructure(
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

    return _MaterialPageStructure(
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
    final motion = AppMotionTokens.of;
    current = AnimatedPadding(
      duration: motion.normal,
      curve: motion.easeOut,
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
    final theme = Theme.of(context);

    // Background from theme — AndroidShell has already mapped
    // semantic tokens (neutralBase, neutralSurface, surfaceElevated)
    // into ThemeData.scaffoldBackgroundColor and ColorScheme.surface.
    // We use the semantic mapping consistently.
    final backgroundColor = _resolveBackgroundColor(theme);
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

  /// Resolve background using shell-provided theme values.
  ///
  /// AndroidShell sets:
  /// - scaffoldBackgroundColor → colors.neutralBase
  /// - colorScheme.surface → colors.neutralSurface
  ///
  /// For surfaceElevated, we apply elevation tint to surface.
  Color _resolveBackgroundColor(ThemeData theme) {
    return switch (backgroundSurface) {
      AppBackgroundSurface.base => theme.scaffoldBackgroundColor,
      AppBackgroundSurface.surface => theme.colorScheme.surface,
      AppBackgroundSurface.elevated => ElevationOverlay.applySurfaceTint(
        theme.colorScheme.surface,
        theme.colorScheme.surfaceTint,
        AppElevationTokens.of.low,
      ),
    };
  }

  AppBar _buildAppBar(BuildContext context) {
    final elevation = AppElevationTokens.of;

    final double barElevation = switch (chromeStyle) {
      AppChromeStyle.standard => elevation.none,
      AppChromeStyle.elevated => elevation.medium,
      AppChromeStyle.transparent => elevation.none,
    };

    final Color? backgroundColor = switch (chromeStyle) {
      AppChromeStyle.standard => null,
      AppChromeStyle.elevated => null,
      AppChromeStyle.transparent => Colors.transparent,
    };

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: barElevation,
      scrolledUnderElevation: barElevation,
      surfaceTintColor: chromeStyle == AppChromeStyle.transparent
          ? Colors.transparent
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
    final cupertinoTheme = CupertinoTheme.of(context);

    // Background from shell-provided theme.
    // IosShell has already mapped semantic tokens into CupertinoThemeData.
    final backgroundColor = _resolveBackgroundColor(cupertinoTheme);
    final navigationBar = _hasTopBar
        ? _buildNavigationBar(context, cupertinoTheme)
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

  /// Resolve background using shell-provided theme values.
  ///
  /// IosShell sets:
  /// - scaffoldBackgroundColor → colors.neutralBase
  /// - barBackgroundColor → colors.neutralBase with opacity
  ///
  /// Semantic mapping (iOS design language):
  /// - [base]: Solid page background (neutralBase)
  /// - [surface]: Solid content surface (neutralBase on iOS — see note)
  /// - [elevated]: Translucent elevated layer (barBackgroundColor)
  ///
  /// Note: iOS uses layered translucency (sheets, modals, blur) rather than
  /// tinted surfaces to indicate visual hierarchy. The [base] and [surface]
  /// semantics are preserved in code for API consistency, but render
  /// identically on iOS. This is intentional platform idiom, not a collapse.
  Color _resolveBackgroundColor(CupertinoThemeData theme) {
    // Semantic distinction preserved. On iOS, base and surface share the
    // same solid color because iOS expresses surface hierarchy through
    // translucency and blur, not surface tinting.
    return switch (backgroundSurface) {
      AppBackgroundSurface.base => theme.scaffoldBackgroundColor,
      AppBackgroundSurface.surface => theme.scaffoldBackgroundColor,
      AppBackgroundSurface.elevated => theme.barBackgroundColor,
    };
  }

  CupertinoNavigationBar _buildNavigationBar(
    BuildContext context,
    CupertinoThemeData theme,
  ) {
    final Color barBackground = switch (chromeStyle) {
      AppChromeStyle.standard => theme.barBackgroundColor,
      AppChromeStyle.elevated => theme.barBackgroundColor,
      AppChromeStyle.transparent => theme.scaffoldBackgroundColor.withAlpha(0),
    };

    final Border? border = switch (chromeStyle) {
      AppChromeStyle.transparent => null,
      AppChromeStyle.standard => const Border(
        bottom: BorderSide(color: CupertinoColors.separator, width: 0.0),
      ),
      AppChromeStyle.elevated => const Border(
        bottom: BorderSide(color: CupertinoColors.separator, width: 0.0),
      ),
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
    final theme = CupertinoTheme.of(context);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(44.0, 44.0),
      onPressed: onPressed,
      child: Icon(AppIcons.resolve(icon), color: theme.primaryColor),
    );
  }
}
