import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

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
/// Handles all Supabase Auth operations (OAuth, OTP, sign-out)
class AuthService {
  final SupabaseClient _supabase;

  AuthService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  /// Get current user session
  User? get currentUser => _supabase.auth.currentUser;

  // ──────────────────────────────────────────────────────────────────────────
  // OAuth Methods
  // ──────────────────────────────────────────────────────────────────────────

  /// Sign in with Apple (OAuth)
  Future<String?> signInWithApple() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.vitalo.app://login-callback',
      );
      return null;
    } on SocketException catch (_) {
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e) {
      return _mapError(e.message);
    } catch (e) {
      return 'Apple sign-in failed: ${e.toString()}';
    }
  }

  /// Sign in with Google (OAuth)
  Future<String?> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.vitalo.app://login-callback',
      );
      return null;
    } on SocketException catch (_) {
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e) {
      return _mapError(e.message);
    } catch (e) {
      return 'Google sign-in failed: ${e.toString()}';
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // OTP Methods
  // ──────────────────────────────────────────────────────────────────────────

  /// Send OTP code to email
  Future<AuthResult<void>> sendOtpToEmail(String email) async {
    try {
      final cleanEmail = email.trim().toLowerCase();

      if (!_isValidEmail(cleanEmail)) {
        return const AuthFailure('Please enter a valid email address.');
      }

      await _supabase.auth.signInWithOtp(
        email: cleanEmail,
        emailRedirectTo: null,
        shouldCreateUser: true,
        data: {'type': 'email'},
      );

      return const AuthSuccess(null);
    } on SocketException catch (_) {
      return const AuthFailure(
        'Network error. Please check your internet connection.',
      );
    } on AuthException catch (e) {
      return AuthFailure(_mapError(e.message));
    } catch (_) {
      return const AuthFailure('Failed to send code. Please try again.');
    }
  }

  /// Verify OTP code for email
  Future<AuthResult<User>> verifyOtp(String email, String token) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final cleanToken = token.trim();

      if (cleanToken.length != 6) {
        return const AuthFailure('Please enter a valid 6-digit code.');
      }

      final response = await _supabase.auth.verifyOTP(
        email: cleanEmail,
        token: cleanToken,
        type: OtpType.email,
      );

      if (response.user == null) {
        return const AuthFailure('Invalid code. Please try again.');
      }

      return AuthSuccess(response.user);
    } on SocketException catch (_) {
      return const AuthFailure(
        'Network error. Please check your internet connection.',
      );
    } on AuthException catch (e) {
      return AuthFailure(_mapError(e.message));
    } catch (_) {
      return const AuthFailure('Invalid code. Please try again.');
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Sign Out
  // ──────────────────────────────────────────────────────────────────────────

  /// Sign out current user
  Future<String?> signOut() async {
    try {
      await _supabase.auth.signOut();
      return null;
    } on SocketException catch (_) {
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e) {
      return _mapError(e.message);
    } catch (e) {
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
