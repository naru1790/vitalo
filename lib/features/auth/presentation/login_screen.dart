import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/vitalo_button.dart';
import '../../../core/widgets/vitalo_text_field.dart';
import '../../../core/widgets/vitalo_checkbox.dart';
import '../../../core/widgets/social_auth_buttons.dart';

/// Login screen for existing users
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    // TODO: Load saved email from SharedPreferences if "Remember Me" was checked
    // NOTE: Never save passwords in SharedPreferences - only email/username
    // Password should always be entered fresh for security
  }

  Future<void> _savePreferences() async {
    // TODO: Save email to SharedPreferences if "Remember Me" is checked
    // Implementation will use shared_preferences package
  }

  Future<void> _handleAppleSignIn() async {
    // TODO: Integrate with Apple Sign In
    _showMessage('Apple Sign In - Coming soon');
  }

  Future<void> _handleGoogleSignIn() async {
    // TODO: Integrate with Google Sign In
    _showMessage('Google Sign In - Coming soon');
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Save preferences if remember me is checked
      if (_rememberMe) {
        await _savePreferences();
      }

      // TODO: Integrate with Supabase authentication
      // When Supabase is integrated, it will handle session management
      // and redirect to dashboard automatically
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Show success message (will be replaced with actual navigation after Supabase integration)
      _showMessage('Login successful! Supabase integration pending.');
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Login failed. Please try again.');
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email address');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showMessage('Please enter a valid email address');
      return;
    }

    // TODO: Implement password reset flow
    _showMessage('Password reset link sent to $email');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                          'Welcome Back',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: colorScheme.primary,
                            fontSize: 36,
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
                                    : (value) {
                                        setState(() {
                                          _rememberMe = value;
                                        });
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
