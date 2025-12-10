import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/vitalo_button.dart';
import '../../../core/widgets/vitalo_text_field.dart';
import '../../../core/widgets/vitalo_checkbox.dart';
import '../../../core/widgets/social_auth_buttons.dart';
import '../../../core/widgets/vitalo_snackbar.dart';
import '../../../core/services/auth_service.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

/// Sign up screen for new users initiating their vital plan
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  String _passwordStrength = '';
  Color _passwordStrengthColor = Colors.grey;
  List<String> _passwordRequirements = [];

  // URLs for terms and privacy
  void _showTermsOfService() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()),
    );
  }

  void _showPrivacyPolicy() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _passwordRequirements = [];
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }

    // Standard password requirements
    final hasMinLength = password.length >= 8;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(
      r'''[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\/~`]''',
    ).hasMatch(password);
    final hasGoodLength = password.length >= 12;

    // Calculate strength score (0-6)
    int strength = 0;
    if (hasMinLength) strength++;
    if (hasUpperCase) strength++;
    if (hasLowerCase) strength++;
    if (hasDigit) strength++;
    if (hasSpecialChar) strength++;
    if (hasGoodLength) strength++;

    // Build list of missing requirements
    List<String> missing = [];
    if (!hasMinLength) missing.add('At least 8 characters');
    if (!hasUpperCase) missing.add('One uppercase letter');
    if (!hasLowerCase) missing.add('One lowercase letter');
    if (!hasDigit) missing.add('One number');
    if (!hasSpecialChar) missing.add('One special character');

    setState(() {
      _passwordRequirements = missing;

      if (strength <= 2) {
        _passwordStrength = 'Weak';
        _passwordStrengthColor = Colors.red;
      } else if (strength <= 3) {
        _passwordStrength = 'Fair';
        _passwordStrengthColor = Colors.orange;
      } else if (strength <= 4) {
        _passwordStrength = 'Good';
        _passwordStrengthColor = Colors.amber;
      } else {
        _passwordStrength = 'Strong';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  Future<void> _handleAppleSignIn() async {
    if (!_agreeToTerms) {
      VitaloSnackBar.showWarning(
        context,
        'Please agree to Terms & Privacy Policy',
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await _authService.signInWithApple();

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (error != null) {
      VitaloSnackBar.showError(context, error);
    } else {
      context.go('/dashboard');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (!_agreeToTerms) {
      VitaloSnackBar.showWarning(
        context,
        'Please agree to Terms & Privacy Policy',
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await _authService.signInWithGoogle();

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (error != null) {
      VitaloSnackBar.showError(context, error);
    } else {
      context.go('/dashboard');
    }
  }

  Future<void> _handleEmailSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      VitaloSnackBar.showWarning(
        context,
        'Please agree to Terms & Privacy Policy',
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await _authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (error != null) {
      VitaloSnackBar.showError(context, error);
    } else {
      _showVerificationDialog();
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mark_email_read_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'Verify Your Email',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              'We\'ve sent a verification link to',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Email
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _emailController.text.trim(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Instructions
            Text(
              'Please check your inbox and click the verification link to activate your account.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/auth/login');
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontalPadding,
                  vertical: AppSpacing.pageVerticalPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSpacing.maxContentWidth,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Back button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => context.go('/'),
                            icon: Icon(
                              Icons.arrow_back,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Header
                        Text(
                          'Welcome to Vitalo',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: colorScheme.primary,
                            fontSize: 36,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Your personal health and wellness journey starts here',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sectionSpacing),

                        // Social Sign-In Buttons (IDP Section)
                        // Show Apple button on iOS, or show both for testing
                        AppleSignInButton(
                          onPressed: _isLoading ? () {} : _handleAppleSignIn,
                          label: 'Sign up with Apple',
                        ),
                        const SizedBox(height: AppSpacing.md),
                        GoogleSignInButton(
                          onPressed: _isLoading ? () {} : _handleGoogleSignIn,
                          label: 'Sign up with Google',
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Divider
                        const OrDivider(),
                        const SizedBox(height: AppSpacing.xl),

                        // Email field
                        VitaloTextField(
                          controller: _emailController,
                          label: 'Email',
                          hintText: 'your.email@example.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Password field with strength indicator
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VitaloTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hintText: 'Create a strong password',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              enabled: !_isLoading,
                              onChanged: _calculatePasswordStrength,
                              onSubmitted: (_) => _handleEmailSignUp(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  return 'Password must contain an uppercase letter';
                                }
                                if (!RegExp(r'[a-z]').hasMatch(value)) {
                                  return 'Password must contain a lowercase letter';
                                }
                                if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  return 'Password must contain a number';
                                }
                                if (!RegExp(
                                  r'''[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\/~`]''',
                                ).hasMatch(value)) {
                                  return 'Password must contain a special character';
                                }
                                return null;
                              },
                            ),
                            if (_passwordStrength.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Row(
                                children: [
                                  Text(
                                    'Strength: ',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface.withOpacity(
                                        0.6,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _passwordStrengthColor.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: _passwordStrengthColor
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      _passwordStrength,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: _passwordStrengthColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (_passwordRequirements.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xs),
                              ...(_passwordRequirements.map(
                                (req) => Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.red.withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        req,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.6),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Terms & Privacy checkbox
                        VitaloCheckbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value;
                            });
                          },
                          label: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: colorScheme.primary
                                        .withOpacity(0.5),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _showTermsOfService,
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Icon(
                                      Icons.open_in_new,
                                      size: 12,
                                      color: colorScheme.primary.withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: colorScheme.primary
                                        .withOpacity(0.5),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _showPrivacyPolicy,
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Icon(
                                      Icons.open_in_new,
                                      size: 12,
                                      color: colorScheme.primary.withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),

                        // Sign up button
                        VitaloPrimaryButton(
                          onPressed: _isLoading ? null : _handleEmailSignUp,
                          label: 'Create My Account',
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Sign in link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/auth/login'),
                              child: Text(
                                'Sign In',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Hoverable link widget with professional hover effects
class _HoverableLink extends StatefulWidget {
  const _HoverableLink({
    required this.text,
    required this.onTap,
    required this.color,
  });

  final String text;
  final VoidCallback onTap;
  final Color color;

  @override
  State<_HoverableLink> createState() => _HoverableLinkState();
}

class _HoverableLinkState extends State<_HoverableLink> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            color: _isHovering ? widget.color.withOpacity(0.8) : widget.color,
            fontWeight: FontWeight.w600,
            decoration: _isHovering
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: widget.color.withOpacity(0.8),
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}
