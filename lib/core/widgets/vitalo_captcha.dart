import 'package:flutter/material.dart';
import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
import 'dart:async';

import '../../main.dart' show talker;
import '../theme/app_spacing.dart';

/// Vitalo-branded Cloudflare Turnstile Captcha Widget
///
/// Provides invisible bot protection for authentication flows.
/// Must be mounted in widget tree before attempting auth operations.
///
/// Usage:
/// ```dart
/// VitaloCaptcha(
///   onTokenReceived: (token) {
///     // Use token in auth service call
///     authService.signInAnonymously(captchaToken: token);
///   },
///   onError: (error) {
///     VitaloSnackBar.showError(context, 'Verification failed');
///   },
/// )
/// ```
class VitaloCaptcha extends StatefulWidget {
  /// Callback when captcha token is successfully generated
  final void Function(String token) onTokenReceived;

  /// Callback when captcha fails or expires
  final void Function(String error)? onError;

  /// Cloudflare site key from dashboard
  /// Get from: Cloudflare Dashboard > Turnstile > Settings
  final String siteKey;

  /// Base URL registered in Cloudflare Turnstile
  /// CRITICAL: Must match domain configured in Cloudflare Dashboard
  /// Example: 'https://cricalgo.com'
  final String baseUrl;

  /// Captcha options including mode and size
  final TurnstileOptions options;

  /// Auto-reset after successful verification
  final bool autoResetOnSuccess;

  VitaloCaptcha({
    super.key,
    required this.onTokenReceived,
    required this.siteKey,
    required this.baseUrl,
    this.onError,
    TurnstileOptions? options,
    this.autoResetOnSuccess = false,
  }) : options =
           options ??
           TurnstileOptions(
             mode: TurnstileMode.invisible,
             size: TurnstileSize.normal,
           );

  @override
  State<VitaloCaptcha> createState() => VitaloCaptchaState();
}

class VitaloCaptchaState extends State<VitaloCaptcha> {
  final TurnstileController _controller = TurnstileController();
  bool _isLoading = false;
  Completer<String?>? _verificationCompleter;
  String? _cachedToken; // Store token if received before verify() called
  DateTime? _tokenTimestamp; // Track when token was generated for expiry

  // Cloudflare tokens expire in ~300 seconds, use 240s (4 min) for safety margin
  static const _tokenValidityDuration = Duration(seconds: 240);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Check if cached token is still valid (not expired)
  bool get _isCachedTokenValid {
    if (_cachedToken == null || _tokenTimestamp == null) return false;
    final elapsed = DateTime.now().difference(_tokenTimestamp!);
    return elapsed < _tokenValidityDuration;
  }

  /// Manually trigger captcha verification (for invisible mode)
  /// Returns a Future that completes when token is received
  /// Optimized for slow Indian mobile networks - no arbitrary delays
  Future<String?> verify() async {
    // If already in progress, wait for existing result
    if (_isLoading && _verificationCompleter != null) {
      talker.debug('Captcha verification already in progress, waiting...');
      return _verificationCompleter!.future;
    }

    // If we have a valid cached token (not expired), use it immediately
    if (_isCachedTokenValid) {
      talker.debug('Using cached captcha token (still valid)');
      final token = _cachedToken;
      _cachedToken = null; // Consume the token
      _tokenTimestamp = null;
      return token;
    } else if (_cachedToken != null) {
      // Token expired, clear it
      talker.debug('Cached token expired, requesting fresh token');
      _cachedToken = null;
      _tokenTimestamp = null;
    }

    if (mounted) setState(() => _isLoading = true);
    _verificationCompleter = Completer<String?>();
    talker.debug('Captcha verification triggered');

    try {
      // Request new token - the widget handles its own initialization
      await _controller.refreshToken();

      // Wait for token with generous timeout for Indian networks
      // 2G/3G can have 5-10s latency, edge cases even more
      final result = await _verificationCompleter!.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          talker.warning('Captcha verification timed out');
          return null;
        },
      );

      return result;
    } catch (e) {
      talker.warning('Captcha verification error: $e');

      // Complete with null if not already completed
      if (_verificationCompleter != null &&
          !_verificationCompleter!.isCompleted) {
        _verificationCompleter!.complete(null);
      }

      widget.onError?.call('Verification failed');
      return null;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Reset captcha widget (for retry scenarios)
  void reset() {
    talker.debug('Captcha reset');
    _cachedToken = null; // Clear cached token
    _tokenTimestamp = null; // Clear expiry timestamp
    _controller.refreshToken();
  }

  void _handleTokenReceived(String? token) {
    talker.info('Captcha token received');

    if (token == null || token.isEmpty) {
      talker.warning('Captcha returned empty token');
      widget.onError?.call('Verification failed');
      if (mounted) setState(() => _isLoading = false);
      if (_verificationCompleter != null &&
          !_verificationCompleter!.isCompleted) {
        _verificationCompleter!.complete(null);
      }
      return;
    }

    if (mounted) setState(() => _isLoading = false);
    widget.onTokenReceived(token);

    // Complete the verification future with the token if waiting
    if (_verificationCompleter != null &&
        !_verificationCompleter!.isCompleted) {
      _verificationCompleter!.complete(token);
    } else {
      // No one waiting - cache for immediate use on next verify() call
      _cachedToken = token;
      _tokenTimestamp = DateTime.now(); // Track expiry
      talker.debug('Token cached for next verification (expires in 4 min)');
    }

    if (widget.autoResetOnSuccess) {
      // Use addPostFrameCallback instead of Future.delayed
      WidgetsBinding.instance.addPostFrameCallback((_) => reset());
    }
  }

  void _handleError(String errorCode) {
    talker.error('Captcha error: $errorCode');

    String userMessage = 'Verification failed';

    // Map Cloudflare error codes to user-friendly messages
    if (errorCode.contains('network') || errorCode.contains('timeout')) {
      userMessage = 'Network error. Please check your connection.';
    } else if (errorCode.contains('config')) {
      userMessage = 'Configuration error. Please contact support.';
    } else {
      userMessage = 'Verification failed. Please try again.';
    }

    if (mounted) setState(() => _isLoading = false);
    widget.onError?.call(userMessage);

    // Complete the verification future with null on error
    if (_verificationCompleter != null &&
        !_verificationCompleter!.isCompleted) {
      _verificationCompleter!.complete(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Invisible mode: render off-screen for seamless UX
    if (widget.options.mode == TurnstileMode.invisible) {
      return Opacity(
        opacity: 0.0,
        child: SizedBox(width: 0, height: 0, child: _buildTurnstile()),
      );
    }

    // Managed mode: visible widget with loading state
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isLoading) ...[
          const SizedBox(
            height: 65,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        ] else
          _buildTurnstile(),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildTurnstile() {
    return CloudFlareTurnstile(
      siteKey: widget.siteKey,
      baseUrl: widget.baseUrl,
      options: widget.options,
      controller: _controller,
      onTokenRecived: _handleTokenReceived,
      onError: _handleError,
    );
  }
}
