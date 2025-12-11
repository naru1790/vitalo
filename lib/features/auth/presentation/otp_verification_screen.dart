import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/widgets/vitalo_snackbar.dart';

/// OTP Verification Screen - Polished, branded verification flow
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.password,
    required this.otpType,
    this.onSuccess,
  });

  final String email;
  final String password;
  final OtpType otpType;
  final VoidCallback? onSuccess;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _authService = AuthService();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // Auto-focus first input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNodes[0].requestFocus();
    });
  }

  void _startCountdown() {
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) {
          _canResend = true;
        }
      });

      return _resendCountdown > 0;
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode {
    return _otpControllers.map((c) => c.text).join();
  }

  bool get _isOtpComplete {
    return _otpCode.length == 6;
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      // Move to next field
      _otpFocusNodes[index + 1].requestFocus();
    }

    // Auto-submit when complete
    if (_isOtpComplete) {
      _verifyOtp();
    }
  }

  void _onOtpDigitBackspace(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      // Move to previous field
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete || _isLoading) return;

    setState(() => _isLoading = true);

    final error = await _authService.verifyOtp(
      email: widget.email,
      token: _otpCode,
      type: widget.otpType,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _errorMessage = error; // Show error inline
    });

    if (error != null) {
      // Clear OTP inputs on error
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _otpFocusNodes[0].requestFocus();
    } else {
      // Success - mark user as returning and navigate to dashboard
      await _markUserAsReturning();
      if (widget.onSuccess != null) {
        widget.onSuccess!();
      } else {
        context.go('/dashboard');
      }
    }
  }

  Future<void> _markUserAsReturning() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_logged_in', true);
    } catch (e) {
      // Silently fail - not critical
      debugPrint('Failed to mark user as returning: $e');
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    // Call signUp again (always succeeds with enumeration protection)
    await _authService.signUp(email: widget.email, password: widget.password);

    if (!mounted) return;

    setState(() => _isLoading = false);

    VitaloSnackBar.showSuccess(context, 'Verification code sent!');
    _startCountdown(); // Restart countdown
  }

  void _handleResetPassword() {
    // Navigate to forgot password flow with pre-filled email
    context.go('/auth/login'); // LoginScreen has forgot password functionality
    // Show the forgot password dialog immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // The login screen will handle showing reset password UI
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkTextPrimary : AppColors.onBackground,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: isDark ? 0 : 2,
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Icon
                      Icon(
                        Icons.email_outlined,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 24),

                      // Heading
                      Text(
                        'Verify it\'s you',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.onBackground,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Subtext
                      Text(
                        'Enter the code sent to',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.onBackground,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          6,
                          (index) => _OtpDigitInput(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
                            onChanged: (value) =>
                                _onOtpDigitChanged(index, value),
                            onBackspace: () => _onOtpDigitBackspace(index),
                            isDark: isDark,
                            hasError: _errorMessage != null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Error Message (inline below OTP boxes)
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _errorMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 24),

                      // Verify Button
                      FilledButton(
                        onPressed: _isLoading || !_isOtpComplete
                            ? null
                            : _verifyOtp,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          disabledBackgroundColor: AppColors.primary
                              .withOpacity(0.5),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            : const Text(
                                'Verify & Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Resend Code with Countdown
                      TextButton(
                        onPressed: _canResend && !_isLoading
                            ? _resendOtp
                            : null,
                        child: Text(
                          _canResend
                              ? 'Resend code'
                              : 'Resend code in ${_resendCountdown}s',
                          style: TextStyle(
                            color: _canResend
                                ? AppColors.primary
                                : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.onSurfaceVariant),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Trouble Section - Guide for existing users
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurfaceVariant.withOpacity(0.3)
                              : AppColors.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Didn\'t receive a code?',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.onBackground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'If you already have an account,\nyou may need to reset your password.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            // Reset Password Button - Centered
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: _isLoading
                                    ? null
                                    : _handleResetPassword,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual OTP digit input widget
class _OtpDigitInput extends StatelessWidget {
  const _OtpDigitInput({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
    required this.isDark,
    this.hasError = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onBackspace;
  final bool isDark;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.darkTextPrimary : AppColors.onBackground,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: hasError
                  ? Colors.red
                  : (isDark ? AppColors.darkOutline : AppColors.outline),
              width: hasError ? 2 : 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: hasError ? Colors.red : AppColors.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkSurfaceVariant : Colors.white,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: onChanged,
        onTap: () {
          // Clear on tap if already filled
          if (controller.text.isNotEmpty) {
            controller.clear();
          }
        },
        onSubmitted: (value) {
          if (value.isEmpty) {
            onBackspace();
          }
        },
      ),
    );
  }
}
