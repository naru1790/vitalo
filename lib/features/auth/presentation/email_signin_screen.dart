import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';

import '../../../main.dart';
import '../../../core/config.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/otp_input.dart';
import '../../../core/widgets/vitalo_snackbar.dart';
import '../../../core/widgets/vitalo_captcha.dart';

/// Email Sign-In Screen with Password-less OTP Flow
/// Step 1: Email Entry
/// Step 2: OTP Verification
class EmailSignInScreen extends StatefulWidget {
  const EmailSignInScreen({super.key});

  @override
  State<EmailSignInScreen> createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
  final _authService = AuthService();
  final _pageController = PageController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isStep2 = false;
  int _resendCountdown = 0;
  Timer? _resendTimer;

  // Captcha state
  final GlobalKey<VitaloCaptchaState> _captchaKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    talker.info('Email sign-in screen opened');
  }

  @override
  void dispose() {
    talker.debug('Email sign-in screen disposed');
    _pageController.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendCountdown() {
    setState(() => _resendCountdown = 30);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) {
      talker.debug('Email validation failed');
      return;
    }

    talker.info(
      'Send OTP code requested for email: ${_emailController.text.trim()}',
    );

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    // Get fresh captcha token to prevent email spam abuse
    final captchaToken = await _captchaKey.currentState?.verify();

    // SECURITY: Block if captcha fails - prevents email spam
    if (captchaToken == null) {
      talker.warning('Captcha verification failed, blocking OTP send');
      if (!mounted) return;
      setState(() => _isLoading = false);
      VitaloSnackBar.showError(
        context,
        'Verification failed. Please try again.',
      );
      return;
    }

    final result = await _authService.sendOtpToEmail(
      _emailController.text.trim(),
      captchaToken: captchaToken,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    switch (result) {
      case AuthFailure(:final message):
        talker.warning('OTP send failed: $message');
        VitaloSnackBar.showError(context, message);
      case AuthSuccess():
        talker.info('OTP sent successfully, moving to verification step');
        setState(() => _isStep2 = true);
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        _startResendCountdown();
    }
  }

  Future<void> _resendCode() async {
    if (_resendCountdown > 0) {
      talker.debug(
        'Resend blocked by countdown: ${_resendCountdown}s remaining',
      );
      return;
    }

    talker.info('Resend OTP code requested');
    setState(() => _isLoading = true);

    // Get fresh captcha token for resend
    final captchaToken = await _captchaKey.currentState?.verify();

    // SECURITY: Block if captcha fails
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
      _emailController.text.trim(),
      captchaToken: captchaToken,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    switch (result) {
      case AuthFailure(:final message):
        talker.warning('OTP resend failed: $message');
        VitaloSnackBar.showError(context, message);
      case AuthSuccess():
        talker.info('OTP resent successfully');
        _startResendCountdown();
        VitaloSnackBar.showSuccess(context, 'Code sent!');
    }
  }

  Future<void> _verifyOtp() async {
    // Early exit if already loading or incomplete code
    if (_isLoading) return;

    if (_otpController.text.length != 6) {
      talker.debug(
        'OTP verification blocked: incomplete code (${_otpController.text.length}/6)',
      );
      VitaloSnackBar.showError(context, 'Please enter the complete code');
      return;
    }

    talker.info('OTP verification started');

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      // NOTE: Captcha not needed for OTP verification
      // Standard practice: captcha protects email sending (abuse prevention),
      // not verification (user already has valid OTP token)
      final result = await _authService.verifyOtp(
        _emailController.text.trim(),
        _otpController.text,
      );

      if (!mounted) return;

      switch (result) {
        case AuthFailure(:final message):
          talker.warning('OTP verification failed: $message');
          setState(() => _isLoading = false);
          VitaloSnackBar.showError(context, message);
          _otpController.clear();
        case AuthSuccess(:final data):
          if (data != null && mounted) {
            talker.info('OTP verification successful, navigating to dashboard');
            context.go('/dashboard');
          } else {
            talker.error('OTP verification returned null user data');
            setState(() => _isLoading = false);
            VitaloSnackBar.showError(
              context,
              'Verification failed. Please try again.',
            );
            _otpController.clear();
          }
      }
    } catch (e, stack) {
      talker.error('OTP verification exception', e, stack);
      if (mounted) {
        setState(() => _isLoading = false);
        VitaloSnackBar.showError(
          context,
          'An error occurred. Please try again.',
        );
        _otpController.clear();
      }
    }
  }

  void _goBack() {
    if (_isStep2) {
      talker.debug('User navigated back from OTP verification to email entry');
      setState(() => _isStep2 = false);
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      _resendTimer?.cancel();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SafeArea(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildEmailStep(theme, colorScheme),
                  _buildOtpStep(theme, colorScheme),
                ],
              ),
            ),

            // Pre-initialized Captcha - Invisible, mounts on screen load for instant verification
            // Using Offstage instead of Positioned to avoid clipping issues
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
      ),
    );
  }

  Widget _buildEmailStep(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Welcome Back',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Enter your email to access your health vault.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'you@example.com',
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.error, width: 2),
                ),
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                );
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onFieldSubmitted: (_) => _sendCode(),
            ),
            const SizedBox(height: AppSpacing.xxl),
            LoadingButton(
              onPressed: _sendCode,
              label: 'Send Code',
              isLoading: _isLoading,
              height: 56,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpStep(ThemeData theme, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Verify it\'s you',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          RichText(
            text: TextSpan(
              text: 'We sent a code to ',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              children: [
                TextSpan(
                  text: _emailController.text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '. Enter it below.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          OtpInput(
            controller: _otpController,
            enabled: !_isLoading,
            onCompleted: (_) => _verifyOtp(),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: TextButton(
              onPressed: _resendCountdown > 0 || _isLoading
                  ? null
                  : _resendCode,
              child: Text(
                _resendCountdown > 0
                    ? 'Resend code in ${_resendCountdown}s'
                    : 'Resend Code',
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          LoadingButton(
            onPressed: _verifyOtp,
            label: 'Verify & Login',
            isLoading: _isLoading,
            enabled: _otpController.text.length == 6,
            height: 56,
          ),
        ],
      ),
    );
  }
}
