import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';

import '../../../main.dart';
import '../../../core/config.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/otp_input.dart';
import '../../../core/widgets/vitalo_snackbar.dart';
import '../../../core/widgets/vitalo_captcha.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.email, this.onSuccess});

  final String email;
  final VoidCallback? onSuccess;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _authService = AuthService();
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();
  final GlobalKey<VitaloCaptchaState> _captchaKey = GlobalKey();

  Timer? _countdownTimer;
  bool _isLoading = false;
  String? _errorMessage;
  int _resendCountdown = 60;

  bool get _canResend => _resendCountdown <= 0;
  bool get _isOtpComplete => _otpController.text.length == 6;

  @override
  void initState() {
    super.initState();
    talker.info('OTP verification screen opened for email: ${widget.email}');
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    talker.debug('OTP verification screen disposed');
    _countdownTimer?.cancel();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _resendCountdown = 60);
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete || _isLoading) {
      talker.debug(
        'OTP verification blocked: incomplete=${!_isOtpComplete}, loading=$_isLoading',
      );
      return;
    }

    talker.info('OTP verification started');
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.verifyOtp(
        widget.email,
        _otpController.text,
      );

      if (!mounted) return;

      switch (result) {
        case AuthFailure(:final message):
          talker.warning('OTP verification failed: $message');
          setState(() {
            _isLoading = false;
            _errorMessage = message;
          });
          _otpController.clear();
          _focusNode.requestFocus();
        case AuthSuccess(:final data):
          if (data != null) {
            talker.info(
              'OTP verification successful, marking user as returning',
            );
            await _markUserAsReturning();
            if (mounted) {
              if (widget.onSuccess != null) {
                talker.debug('Calling onSuccess callback');
                widget.onSuccess!();
              } else {
                talker.info('Navigating to dashboard');
                context.go('/dashboard');
              }
            }
          } else {
            talker.error('OTP verification returned null user data');
            setState(() {
              _isLoading = false;
              _errorMessage = 'Verification failed. Please try again.';
            });
            _otpController.clear();
          }
      }
    } catch (e, stack) {
      talker.error('OTP verification exception', e, stack);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'An error occurred. Please try again.';
        });
        _otpController.clear();
      }
    }
  }

  Future<void> _markUserAsReturning() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_logged_in', true);
      talker.debug('User marked as returning in preferences');
    } catch (e) {
      talker.warning('Failed to mark user as returning', e);
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isLoading) {
      talker.debug(
        'Resend OTP blocked: canResend=$_canResend, loading=$_isLoading',
      );
      return;
    }

    talker.info('Resend OTP requested for email: ${widget.email}');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Get fresh captcha token to prevent abuse
    final captchaToken = await _captchaKey.currentState?.verify();

    if (captchaToken == null) {
      talker.warning('Captcha verification failed, blocking OTP resend');
      if (!mounted) return;
      setState(() => _isLoading = false);
      VitaloSnackBar.showError(
        context,
        'Verification failed. Please try again.',
      );
      return;
    }

    final result = await _authService.sendOtpToEmail(
      widget.email,
      captchaToken: captchaToken,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case AuthFailure(:final message):
        talker.warning('Resend OTP failed: $message');
        VitaloSnackBar.showError(context, message);
      case AuthSuccess():
        talker.info('OTP resent successfully');
        VitaloSnackBar.showSuccess(context, 'Verification code sent!');
        _startCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            talker.debug('User navigated back from OTP verification screen');
            context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        'Verify it\'s you',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Enter the code sent to ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(
                              text: widget.email,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      OtpInput(
                        controller: _otpController,
                        focusNode: _focusNode,
                        enabled: !_isLoading,
                        hasError: _errorMessage != null,
                        onCompleted: (_) => _verifyOtp(),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _errorMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      LoadingButton(
                        onPressed: _verifyOtp,
                        label: 'Verify & Continue',
                        isLoading: _isLoading,
                        enabled: _isOtpComplete,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: _canResend && !_isLoading
                            ? _resendOtp
                            : null,
                        child: Text(
                          _canResend
                              ? 'Resend code'
                              : 'Resend code in ${_resendCountdown}s',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Pre-initialized Captcha for resend protection
          Offstage(
            offstage: true,
            child: VitaloCaptcha(
              key: _captchaKey,
              siteKey: AppConfig.turnstileSiteKey,
              baseUrl: AppConfig.turnstileBaseUrl,
              options: TurnstileOptions(mode: TurnstileMode.invisible),
              onTokenReceived: (_) {},
              onError: (error) {
                VitaloSnackBar.showWarning(context, error);
              },
            ),
          ),
        ],
      ),
    );
  }
}
