// @frozen
// AUTH FLOW — OTP VERIFICATION
// DO NOT ADD EMAIL OR RESEND LOGIC OUTSIDE THIS SCREEN

/// PAGE ARCHETYPE: CENTERED FOCUS
/// This screen must remain single-task, vertically centered,
/// and free of navigation, lists, or secondary actions.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../design/design.dart';

import '../../../main.dart';
import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';

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

  Timer? _countdownTimer;
  bool _isLoading = false;
  String? _errorMessage;
  int _resendCountdown = 30;

  bool get _canResend => _resendCountdown <= 0;
  bool get _isOtpComplete => _otpController.text.length == 6;

  @override
  void initState() {
    super.initState();
    talker.info('OTP verification screen opened for email: ${widget.email}');
    _startCountdown();
  }

  @override
  void dispose() {
    talker.debug('OTP verification screen disposed');
    _countdownTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _resendCountdown = 30);
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
                talker.info('Navigating to home');
                context.go(AppRoutes.home);
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

    final result = await _authService.sendOtpToEmail(widget.email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case AuthFailure(:final message):
        talker.warning('Resend OTP failed: $message');
        AppErrorFeedback.show(context, message);
      case AuthSuccess():
        talker.info('OTP resent successfully');
        // Success is silent by contract.
        _startCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Spacing.of;

    return CenteredFocusPage(
      leadingAction: AppBarBackAction(
        onPressed: () {
          talker.debug('User navigated back from OTP verification screen');
          context.pop();
        },
      ),

      /// Centered Focus canonical content order — do not reorder.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Hero icon
          const AppFocusHeroIcon(icon: AppIconId.authEmail),
          SizedBox(height: spacing.xl),
          const AppText(
            'Verify it\'s you',
            variant: AppTextVariant.display,
            align: TextAlign.center,
          ),
          SizedBox(height: spacing.sm),
          AppText(
            'Enter the code sent to ${widget.email}',
            variant: AppTextVariant.body,
            color: AppTextColor.secondary,
            align: TextAlign.center,
          ),
          SizedBox(height: spacing.xl),
          AppOtpInput(
            controller: _otpController,
            enabled: !_isLoading,
            hasError: _errorMessage != null,
            onCompleted: _verifyOtp,
          ),
          if (_errorMessage != null) ...[
            SizedBox(height: spacing.sm),
            InlineFeedbackMessage(
              message: _errorMessage!,
              severity: InlineFeedbackSeverity.error,
            ),
          ],
          SizedBox(height: spacing.xl),
          AppButton(
            label: 'Verify & Continue',
            onPressed: _verifyOtp,
            loading: _isLoading,
            enabled: _isOtpComplete,
            variant: AppButtonVariant.primary,
          ),
          SizedBox(height: spacing.md),
          AppOtpResendAction(
            secondsRemaining: _resendCountdown,
            enabled: !_isLoading,
            onResend: _resendOtp,
          ),
        ],
      ),
    );
  }
}
