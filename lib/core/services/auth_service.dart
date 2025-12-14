import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart' show talker;
import '../config.dart';

/// Result type for auth operations
sealed class AuthResult<T> {
  const AuthResult();
}

final class AuthSuccess<T> extends AuthResult<T> {
  final T? data;
  const AuthSuccess(this.data);
}

final class AuthFailure<T> extends AuthResult<T> {
  final String message;
  const AuthFailure(this.message);
}

/// Central authentication service for Vitalo
class AuthService {
  final SupabaseClient _supabase;

  AuthService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  /// Check if current user is anonymous (guest mode)
  /// TODO: Update Postgres RLS policies to restrict anonymous users from writing to public tables
  bool get isAnonymous {
    final user = currentUser;
    if (user == null) return false;
    return user.isAnonymous;
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Anonymous Auth
  // ──────────────────────────────────────────────────────────────────────────

  /// Sign in anonymously (Guest Mode)
  /// Session persists until sign-out or app data deletion
  /// Uses captcha token to prevent bot abuse and database bloat
  Future<String?> signInAnonymously({String? captchaToken}) async {
    talker.info('Anonymous sign-in started');
    try {
      final response = await _supabase.auth.signInAnonymously(
        captchaToken: captchaToken,
      );

      if (response.user == null) {
        talker.warning('Anonymous sign-in failed: no user returned');
        return 'Failed to create guest session. Please try again.';
      }

      talker.info('Anonymous sign-in successful');
      return null;
    } on SocketException catch (e, stack) {
      talker.warning('Network error during anonymous sign-in', e, stack);
      return 'Network error. Guest mode requires internet connection.';
    } on AuthException catch (e, stack) {
      talker.error('Anonymous sign-in failed', e, stack);
      return _mapError(e.message);
    } catch (e, stack) {
      talker.error('Anonymous sign-in unexpected error', e, stack);
      return 'Guest login failed: ${e.toString()}';
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // OAuth Methods
  // ──────────────────────────────────────────────────────────────────────────

  /// Sign in with Apple (OAuth)
  /// Note: Captcha protection not available for OAuth in current Supabase version
  Future<String?> signInWithApple() async {
    talker.info('Apple OAuth sign-in started');
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.vitalo.app://login-callback',
      );
      talker.info('Apple OAuth sign-in initiated');
      return null;
    } on SocketException catch (e, stack) {
      talker.warning('Network error during Apple sign-in', e, stack);
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e, stack) {
      talker.error('Apple sign-in failed', e, stack);
      return _mapError(e.message);
    } catch (e, stack) {
      talker.error('Apple sign-in unexpected error', e, stack);
      return 'Apple sign-in failed: ${e.toString()}';
    }
  }

  /// Sign in with Google using native flow
  /// Uses GoogleSignIn to get ID token, then exchanges it with Supabase
  /// Returns null on success, error message on failure
  Future<String?> signInWithGoogle() async {
    talker.info('Google native sign-in started');
    try {
      // Configure GoogleSignIn with web client ID for token exchange
      final googleSignIn = GoogleSignIn(
        serverClientId: AppConfig.googleWebClientId,
        // iOS client ID is handled via Info.plist CFBundleURLSchemes
        scopes: ['email', 'profile'],
      );

      // Trigger native Google Sign-In flow
      talker.debug('Launching Google Sign-In UI');
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        talker.info('Google sign-in cancelled by user');
        return 'Google sign-in cancelled';
      }

      // Get authentication tokens
      talker.debug('Getting Google authentication tokens');
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null) {
        talker.error('Google sign-in failed: No ID token received');
        return 'Google sign-in failed: No authentication token received';
      }

      // Exchange Google tokens with Supabase
      talker.info('Exchanging Google tokens with Supabase');
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        talker.error('Supabase token exchange failed: No user returned');
        return 'Authentication failed. Please try again.';
      }

      talker.info('Google sign-in successful, user ID: ${response.user!.id}');
      return null; // Success
    } on SocketException catch (e, stack) {
      talker.warning('Network error during Google sign-in', e, stack);
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e, stack) {
      talker.error('Supabase auth error during Google sign-in', e, stack);
      return _mapError(e.message);
    } catch (e, stack) {
      talker.error('Google sign-in unexpected error', e, stack);
      return 'Google sign-in failed: ${e.toString()}';
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // OTP Methods
  // ──────────────────────────────────────────────────────────────────────────

  /// Send OTP code to email
  /// [captchaToken] - Optional Cloudflare Turnstile token for bot protection
  Future<AuthResult<void>> sendOtpToEmail(
    String email, {
    String? captchaToken,
  }) async {
    talker.info('OTP send started');
    try {
      final cleanEmail = email.trim().toLowerCase();

      if (!_isValidEmail(cleanEmail)) {
        talker.warning('Invalid email format');
        return const AuthFailure('Please enter a valid email address.');
      }

      await _supabase.auth.signInWithOtp(
        email: cleanEmail,
        emailRedirectTo: null,
        shouldCreateUser: true,
        data: {'type': 'email'},
        captchaToken: captchaToken,
      );

      talker.info('OTP sent successfully');
      return const AuthSuccess(null);
    } on SocketException catch (e, stack) {
      talker.warning('Network error during OTP send', e, stack);
      return const AuthFailure(
        'Network error. Please check your internet connection.',
      );
    } on AuthException catch (e, stack) {
      talker.error('OTP send failed', e, stack);
      return AuthFailure(_mapError(e.message));
    } catch (e, stack) {
      talker.error('OTP send unexpected error', e, stack);
      return const AuthFailure('Failed to send code. Please try again.');
    }
  }

  /// Verify OTP code for email
  /// [captchaToken] - Optional Cloudflare Turnstile token for bot protection
  Future<AuthResult<User>> verifyOtp(
    String email,
    String token, {
    String? captchaToken,
  }) async {
    talker.debug('AuthService.verifyOtp called');
    try {
      final cleanEmail = email.trim().toLowerCase();
      final cleanToken = token.trim();

      if (cleanToken.length != 6) {
        talker.warning('Invalid OTP length: ${cleanToken.length}');
        return const AuthFailure('Please enter a valid 6-digit code.');
      }

      final response = await _supabase.auth.verifyOTP(
        email: cleanEmail,
        token: cleanToken,
        type: OtpType.email,
        captchaToken: captchaToken,
      );

      if (response.user == null) {
        talker.warning('OTP verification failed: no user returned');
        return const AuthFailure('Invalid code. Please try again.');
      }

      talker.info('OTP verification successful');
      return AuthSuccess(response.user);
    } on SocketException catch (e, stack) {
      talker.warning('Network error during OTP verification', e, stack);
      return const AuthFailure(
        'Network error. Please check your internet connection.',
      );
    } on AuthException catch (e, stack) {
      talker.error('OTP verification failed', e, stack);
      return AuthFailure(_mapError(e.message));
    } catch (e, stack) {
      talker.error('OTP verification unexpected error', e, stack);
      return const AuthFailure('Invalid code. Please try again.');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Sign Out
  // ──────────────────────────────────────────────────────────────────────────

  /// Sign out current user
  Future<String?> signOut() async {
    talker.info('Sign out started');
    try {
      await _supabase.auth.signOut();
      talker.info('Sign out successful');
      return null;
    } on SocketException catch (e, stack) {
      talker.warning('Network error during sign out', e, stack);
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e, stack) {
      talker.error('Sign out failed', e, stack);
      return _mapError(e.message);
    } catch (e, stack) {
      talker.error('Sign out unexpected error', e, stack);
      return 'Sign out failed: ${e.toString()}';
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────────────────────

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Convert technical Supabase errors to user-friendly messages
  String _mapError(String error) {
    final e = error.toLowerCase();

    if (e.contains('invalid login credentials') ||
        e.contains('invalid email or password')) {
      return 'Invalid email or password. Please try again.';
    }
    if (e.contains('email not confirmed')) {
      return 'Please verify your email address before signing in.';
    }
    if (e.contains('user already registered') ||
        e.contains('user with this email already exists') ||
        e.contains('email already exists') ||
        e.contains('already registered')) {
      return 'This email is already registered. Please sign in instead.';
    }
    if (e.contains('network') ||
        e.contains('failed host lookup') ||
        e.contains('socket')) {
      return 'Network error. Please check your internet connection.';
    }
    if (e.contains('weak password') ||
        e.contains('password should be at least')) {
      return 'Password is too weak. Please use a stronger password (minimum 8 characters).';
    }
    if (e.contains('timeout')) {
      return 'Connection timeout. Please try again.';
    }
    if (e.contains('rate limit') || e.contains('too many requests')) {
      return 'Too many attempts. Please wait before trying again.';
    }
    if (e.contains('invalid otp') ||
        e.contains('otp expired') ||
        e.contains('token has expired') ||
        e.contains('token_expired')) {
      return 'Invalid or expired code. Please request a new one.';
    }
    if (e.contains('user not found')) {
      return 'No account found with this email.';
    }

    return error;
  }
}
