import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading_button.dart';
import '../../../core/widgets/otp_input.dart';
import '../../../core/widgets/vitalo_snackbar.dart';

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

  Timer? _countdownTimer;
  bool _isLoading = false;
  String? _errorMessage;
  int _resendCountdown = 60;

  bool get _canResend => _resendCountdown <= 0;
  bool get _isOtpComplete => _otpController.text.length == 6;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
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
    if (!_isOtpComplete || _isLoading) return;

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
          setState(() {
            _isLoading = false;
            _errorMessage = message;
          });
          _otpController.clear();
          _focusNode.requestFocus();
        case AuthSuccess(:final data):
          if (data != null) {
            await _markUserAsReturning();
            if (mounted) {
              if (widget.onSuccess != null) {
                widget.onSuccess!();
              } else {
                context.go('/dashboard');
              }
            }
          } else {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Verification failed. Please try again.';
            });
            _otpController.clear();
          }
      }
    } catch (e) {
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
    } catch (_) {}
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.sendOtpToEmail(widget.email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (result) {
      case AuthFailure(:final message):
        VitaloSnackBar.showError(context, message);
      case AuthSuccess():
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
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
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
                    onPressed: _canResend && !_isLoading ? _resendOtp : null,
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
    );
  }
}
