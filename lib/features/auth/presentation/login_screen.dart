import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/vitalo_button.dart';
import '../../../core/widgets/vitalo_text_field.dart';
import '../../../core/widgets/vitalo_checkbox.dart';
import '../../../core/widgets/social_auth_buttons.dart';
import '../../../core/widgets/vitalo_snackbar.dart';
import '../../../core/services/auth_service.dart';

/// Login screen for existing users
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.prefilledEmail});

  final String? prefilledEmail;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Set prefilled email from email verification if provided
    if (widget.prefilledEmail != null) {
      _emailController.text = widget.prefilledEmail!;
    } else {
      _loadSavedCredentials();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('saved_email');
      final rememberMe = prefs.getBool('remember_me') ?? false;

      if (savedEmail != null && rememberMe) {
        setState(() {
          _emailController.text = savedEmail;
          _rememberMe = true;
        });
      }
    } catch (e) {
      // Silently fail - not critical for app functionality
      debugPrint('Failed to load saved credentials: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('saved_email', _emailController.text.trim());
        await prefs.setBool('remember_me', true);
      } else {
        await prefs.remove('saved_email');
        await prefs.setBool('remember_me', false);
      }
    } catch (e) {
      // Silently fail - not critical for app functionality
      debugPrint('Failed to save preferences: $e');
    }
  }

  Future<void> _handleBackButton() async {
    try {
      // Set skip_redirect flag so landing page won't redirect this session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('skip_redirect', true);

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      debugPrint('Failed to set skip redirect flag: $e');
      // Still navigate back even if flag set fails
      if (mounted) {
        context.go('/');
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
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

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final error = await _authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (error != null) {
      VitaloSnackBar.showError(context, error);
    } else {
      // Save preferences if remember me is checked
      if (_rememberMe) {
        await _savePreferences();
      }
      // Mark that user has successfully logged in before
      await _markUserAsReturning();
      context.go('/dashboard');
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

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      VitaloSnackBar.showWarning(context, 'Please enter your email address');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      VitaloSnackBar.showWarning(context, 'Please enter a valid email address');
      return;
    }

    setState(() => _isLoading = true);

    final error = await _authService.resetPassword(email: email);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (error != null) {
      VitaloSnackBar.showError(context, error);
    } else {
      VitaloSnackBar.showSuccess(context, 'Password reset link sent to $email');
    }
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
                            onPressed: _handleBackButton,
                            icon: Icon(
                              Icons.arrow_back,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Brand name
                        Text(
                          'Vitalo',
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: colorScheme.primary,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Header
                        Text(
                          'Welcome Back',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Sign in to continue your wellness journey',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sectionSpacing),

                        // Social Sign-In Buttons
                        AppleSignInButton(
                          onPressed: _isLoading ? () {} : _handleAppleSignIn,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        GoogleSignInButton(
                          onPressed: _isLoading ? () {} : _handleGoogleSignIn,
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

                        // Password field
                        VitaloTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          enabled: !_isLoading,
                          onSubmitted: (_) => _handleEmailLogin(),
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
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Remember Me & Forgot Password row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Remember Me checkbox
                            Flexible(
                              child: VitaloCheckbox(
                                value: _rememberMe,
                                onChanged: _isLoading
                                    ? null
                                    : (value) async {
                                        setState(() {
                                          _rememberMe = value;
                                        });
                                        await _savePreferences();
                                      },
                                enabled: !_isLoading,
                                label: Text(
                                  'Remember me',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.7,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Forgot Password link
                            GestureDetector(
                              onTap: _isLoading ? null : _handleForgotPassword,
                              child: Text(
                                'Forgot Password?',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxxl),

                        // Sign in button
                        VitaloPrimaryButton(
                          onPressed: _isLoading ? null : _handleEmailLogin,
                          label: 'Sign In',
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/auth/signup'),
                              child: Text(
                                'Sign Up',
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
