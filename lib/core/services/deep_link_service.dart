import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

/// Service to handle deep links for email verification and OAuth callbacks
class DeepLinkService {
  static StreamSubscription? _authSubscription;
  static BuildContext? _context;

  /// Initialize deep link handling for Supabase auth
  static void initialize(BuildContext context) {
    _context = context;

    // Listen to auth state changes
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      final event = data.event;

      // TODO: Implement email verification redirect flow
      // Currently deep links are configured but navigation logic
      // needs refinement to handle email verification properly
      debugPrint('Auth event: $event');
    });
  }

  /// Clean up subscriptions
  static void dispose() {
    _authSubscription?.cancel();
    _context = null;
  }
}
