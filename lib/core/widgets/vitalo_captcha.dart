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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Manually trigger captcha verification (for invisible mode)
  /// Returns a Future that completes when token is received
  Future<String?> verify() async {
    // If already in progress, wait for existing result
    if (_isLoading && _verificationCompleter != null) {
      talker.debug('Captcha verification already in progress, waiting...');
      return _verificationCompleter!.future;
    }

    if (mounted) setState(() => _isLoading = true);
    _verificationCompleter = Completer<String?>();
    talker.debug('Captcha verification triggered');

    try {
      // Request new token
      await _controller.refreshToken();

      // Wait for token with timeout
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

    // Complete the verification future with the token
    if (_verificationCompleter != null &&
        !_verificationCompleter!.isCompleted) {
      _verificationCompleter!.complete(token);
    }

    if (widget.autoResetOnSuccess) {
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
