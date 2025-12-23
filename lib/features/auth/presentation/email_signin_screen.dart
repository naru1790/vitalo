import 'package:flutter/services.dart' show TextInputAction, TextInputType;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../../design/design.dart';

import '../../../core/router.dart';
import '../../../core/services/auth_service.dart';
import '../../../main.dart';

class EmailSignInScreen extends StatefulWidget {
  const EmailSignInScreen({super.key});

  @override
  State<EmailSignInScreen> createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends State<EmailSignInScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    talker.info('Email sign-in screen opened');
  }

  @override
  void dispose() {
    talker.debug('Email sign-in screen disposed');
    _emailController.dispose();
    super.dispose();
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
        talker.info('OTP sent successfully, navigating to verification');
        context.push(
          AppRoutes.otpVerification,
          extra: _emailController.text.trim(),
        );
    }
  }

  void _goBack() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      leadingAction: AppBarBackAction(onPressed: _goBack),
      safeArea: AppSafeArea.all,
      backgroundSurface: AppBackgroundSurface.base,
      chromeStyle: AppChromeStyle.transparent,
      body: KeyboardDismissSurface(child: _buildEmailStep()),
    );
  }

  Widget _buildEmailStep() {
    final spacing = Spacing.of;

    return AppPageBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: spacing.xl),
          const AppText('Welcome Back', variant: AppTextVariant.display),
          SizedBox(height: spacing.md),
          const AppText(
            'Enter your email to access your health vault.',
            variant: AppTextVariant.body,
            color: AppTextColor.secondary,
          ),
          SizedBox(height: spacing.xl),
          AppTextField(
            controller: _emailController,
            placeholder: 'you@example.com',
            leadingIcon: AppIconId.authEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            errorText: _emailError,
            onChanged: (_) => _clearEmailError(),
            onSubmitted: _sendCode,
          ),
          // Inline validation error (iOS HIG pattern)
          if (_emailError != null) ...[
            SizedBox(height: spacing.sm),
            InlineFeedbackMessage(
              message: _emailError!,
              severity: InlineFeedbackSeverity.error,
            ),
          ],
          SizedBox(height: spacing.xl),
          AppButton(
            label: 'Send Code',
            onPressed: _sendCode,
            loading: _isLoading,
            enabled: !_isLoading,
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
