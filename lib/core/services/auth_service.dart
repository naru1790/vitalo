import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

/// Central authentication service for Vitalo
/// Handles all Supabase Auth operations with clean error handling
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get current user session
  User? get currentUser => _supabase.auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Get auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Sign up with email and password - sends OTP for email verification
  /// User account is created but not confirmed until OTP is verified
  /// NOTE: With Email Enumeration Protection ON, this always "succeeds" even if user exists
  /// Existing users won't receive OTP - they should use Login or Reset Password
  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      // Create user account with password - Supabase will send OTP email
      await _supabase.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
        emailRedirectTo: null, // We use OTP, not magic link
      );
      // Always return success to prevent user enumeration
      // Existing users won't get OTP but we don't reveal this
    } catch (e) {
      // Log to crash reporting service in production
      debugPrint('SignUp error: ${e.toString()}');
      // Still return success to prevent enumeration
    }
  }

  /// Verify OTP code for email confirmation during signup
  /// This confirms the user's email and logs them in
  /// Returns error message as String if fails, null if successful
  Future<String?> verifyOtp({
    required String email,
    required String token,
    required OtpType type,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: type,
      );

      if (response.session == null) {
        return 'Invalid OTP. Please check the code and try again.';
      }

      // Success - email confirmed and user logged in
      return null;
    } on SocketException catch (_) {
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e) {
      // Handle specific OTP errors
      if (e.message.toLowerCase().contains('invalid') ||
          e.message.toLowerCase().contains('expired')) {
        return 'Invalid or expired OTP. Please try again.';
      }
      return _getReadableError(e.message);
    } catch (e) {
      debugPrint('OTP verification error: ${e.toString()}');
      return 'Invalid OTP. Please try again.';
    }
  }

  /// Sign in with email and password
  /// Returns error message as String if fails, null if successful
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return 'Sign in failed. Please check your credentials.';
      }

      return null; // Success
    } on SocketException catch (_) {
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e) {
      return _getReadableError(e.message);
    } catch (e) {
      return 'An unexpected error occurred: ${e.toString()}';
    }
  }

  /// Sign in with Apple (OAuth)
  /// Returns error message as String if fails, null if successful
  Future<String?> signInWithApple() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.vitalo.app://login-callback',
      );
      return null; // Success
    } on SocketException catch (_) {
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e) {
      return _getReadableError(e.message);
    } catch (e) {
      return 'Apple sign-in failed: ${e.toString()}';
    }
  }

  /// Sign in with Google (OAuth)
  /// Returns error message as String if fails, null if successful
  Future<String?> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.vitalo.app://login-callback',
      );
      return null; // Success
    } on SocketException catch (_) {
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e) {
      return _getReadableError(e.message);
    } catch (e) {
      return 'Google sign-in failed: ${e.toString()}';
    }
  }

  /// Send password reset email
  /// Returns error message as String if fails, null if successful
  Future<String?> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return null; // Success
    } on SocketException catch (_) {
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e) {
      return _getReadableError(e.message);
    } catch (e) {
      return 'Unable to send password reset email: ${e.toString()}';
    }
  }

  /// Sign out current user
  /// Returns error message as String if fails, null if successful
  Future<String?> signOut() async {
    try {
      await _supabase.auth.signOut();
      return null; // Success
    } on SocketException catch (_) {
      return 'Network error. Please check your internet connection.';
    } on AuthException catch (e) {
      return _getReadableError(e.message);
    } catch (e) {
      return 'Sign out failed: ${e.toString()}';
    }
  }

  /// Convert technical Supabase errors to user-friendly messages
  String _getReadableError(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('invalid login credentials') ||
        lowerError.contains('invalid email or password')) {
      return 'Invalid email or password. Please try again.';
    }

    if (lowerError.contains('email not confirmed')) {
      return 'Please verify your email address before signing in.';
    }

    if (lowerError.contains('user already registered') ||
        lowerError.contains('user with this email already exists') ||
        lowerError.contains('email already exists') ||
        lowerError.contains('already registered')) {
      return 'This email is already registered. Please sign in instead.';
    }

    if (lowerError.contains('network') ||
        lowerError.contains('failed host lookup') ||
        lowerError.contains('socket')) {
      return 'Network error. Please check your internet connection and try again.';
    }

    if (lowerError.contains('weak password') ||
        lowerError.contains('password should be at least')) {
      return 'Password is too weak. Please use a stronger password (minimum 8 characters).';
    }

    if (lowerError.contains('timeout')) {
      return 'Connection timeout. Please check your internet and try again.';
    }

    if (lowerError.contains('email rate limit')) {
      return 'Too many attempts. Please wait a few minutes before trying again.';
    }

    // Return original error if no match found
    return error;
  }
}
