import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme.dart';
import '../../../design/adaptive/error_feedback.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/otp_input.dart';
import '../../../main.dart';

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

  bool _isLoading = false;
  bool _isStep2 = false;
  int _resendCountdown = 0;
  Timer? _resendTimer;
  String? _emailError;

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

  String? _validateEmail(String? value) {
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
  }

  void _clearEmailError() {
    if (_emailError != null) {
      setState(() => _emailError = null);
    }
  }

  Future<void> _sendCode() async {
    final validationError = _validateEmail(_emailController.text.trim());
    if (validationError != null) {
      talker.debug('Email validation failed: $validationError');
      setState(() => _emailError = validationError);
      return;
    }

    setState(() => _emailError = null);

    talker.info(
      'Send OTP code requested for email: ${_emailController.text.trim()}',
    );

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    final result = await _authService.sendOtpToEmail(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    switch (result) {
      case AuthFailure(:final message):
        talker.warning('OTP send failed: $message');
        AppErrorFeedback.show(context, message);
      case AuthSuccess():
        talker.info('OTP sent successfully, moving to verification step');
        setState(() => _isStep2 = true);
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
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

    final result = await _authService.sendOtpToEmail(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    switch (result) {
      case AuthFailure(:final message):
        talker.warning('OTP resend failed: $message');
        AppErrorFeedback.show(context, message);
      case AuthSuccess():
        talker.info('OTP resent successfully');
        _startResendCountdown();
      // Success is silent by contract.
    }
  }

  Future<void> _verifyOtp() async {
    if (_isLoading) return;

    if (_otpController.text.length != 6) {
      talker.debug(
        'OTP verification blocked: incomplete code (${_otpController.text.length}/6)',
      );
      AppErrorFeedback.show(context, 'Please enter the complete code');
      return;
    }

    talker.info('OTP verification started');

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      final result = await _authService.verifyOtp(
        _emailController.text.trim(),
        _otpController.text,
      );

      if (!mounted) return;

      switch (result) {
        case AuthFailure(:final message):
          talker.warning('OTP verification failed: $message');
          setState(() => _isLoading = false);
          AppErrorFeedback.show(context, message);
          _otpController.clear();
        case AuthSuccess(:final data):
          if (data != null && mounted) {
            talker.info('OTP verification successful, navigating to dashboard');
            context.go(AppRoutes.dashboard);
          } else {
            talker.error('OTP verification returned null user data');
            setState(() => _isLoading = false);
            AppErrorFeedback.show(
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
        AppErrorFeedback.show(context, 'An error occurred. Please try again.');
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
      _resendTimer?.cancel();
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    final surfaceColor = CupertinoColors.systemBackground.resolveFrom(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _goBack,
          child: Icon(
            CupertinoIcons.chevron_back,
            color: primaryColor,
            size: 20,
          ),
        ),
        backgroundColor: surfaceColor,
        border: null,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [_buildEmailStep(), _buildOtpStep()],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailStep() {
    final fillColor = CupertinoColors.tertiarySystemFill.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text('Welcome Back', style: AppleTextStyles.largeTitle(context)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Enter your email to access your health vault.',
            style: AppleTextStyles.bodySecondary(context),
          ),
          const SizedBox(height: AppSpacing.xxl),
          // iOS-style text field with proper height
          Container(
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
              border: _emailError != null
                  ? Border.all(
                      color: VitaloColors.destructive.resolveFrom(context),
                      width: 1,
                    )
                  : null,
            ),
            child: CupertinoTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
              placeholder: 'you@example.com',
              placeholderStyle: AppleTextStyles.body(context).copyWith(
                color: CupertinoColors.placeholderText.resolveFrom(context),
              ),
              style: AppleTextStyles.body(context),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              prefix: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.md),
                child: Icon(
                  CupertinoIcons.mail,
                  color: _emailError != null
                      ? VitaloColors.destructive.resolveFrom(context)
                      : primaryColor,
                  size: AppSpacing.iconSizeSmall,
                ),
              ),
              decoration: null,
              onChanged: (_) => _clearEmailError(),
              onSubmitted: (_) => _sendCode(),
            ),
          ),
          // Inline validation error (iOS HIG pattern)
          if (_emailError != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_circle_fill,
                  color: VitaloColors.destructive.resolveFrom(context),
                  size: 14,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Expanded(
                  child: Text(
                    _emailError!,
                    style: AppleTextStyles.footnote(context).copyWith(
                      color: VitaloColors.destructive.resolveFrom(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          LoadingButton(
            onPressed: _sendCode,
            label: 'Send Code',
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    final secondaryLabel = CupertinoColors.secondaryLabel.resolveFrom(context);
    final primaryColor = CupertinoTheme.of(context).primaryColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text('Verify it\'s you', style: AppleTextStyles.largeTitle(context)),
          const SizedBox(height: AppSpacing.md),
          RichText(
            text: TextSpan(
              text: 'We sent a code to ',
              style: AppleTextStyles.bodySecondary(context),
              children: [
                TextSpan(
                  text: _emailController.text,
                  style: AppleTextStyles.headline(
                    context,
                  ).copyWith(color: primaryColor),
                ),
                TextSpan(
                  text: '. Enter it below.',
                  style: AppleTextStyles.bodySecondary(context),
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
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _resendCountdown > 0 || _isLoading
                  ? null
                  : _resendCode,
              child: Text(
                _resendCountdown > 0
                    ? 'Resend code in ${_resendCountdown}s'
                    : 'Resend Code',
                style: AppleTextStyles.callout(context).copyWith(
                  color: _resendCountdown > 0 || _isLoading
                      ? secondaryLabel
                      : primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          LoadingButton(
            onPressed: _verifyOtp,
            label: 'Continue',
            isLoading: _isLoading,
            enabled: _otpController.text.length == 6,
          ),
        ],
      ),
    );
  }
}
