import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'core/config.dart';
import 'core/router.dart';
import 'core/services/secure_storage_service.dart';
import 'core/theme.dart';

/// Global Talker instance for observability
final talker = Talker(
  settings: TalkerSettings(
    enabled: true,
    useHistory: true,
    maxHistoryItems: 1000,
    useConsoleLogs: kDebugMode,
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch Flutter framework errors
  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack, 'FlutterError');
  };

  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'PlatformError');
    return true;
  };

  // Validate configuration
  if (AppConfig.supabaseUrl.isEmpty || AppConfig.supabaseAnonKey.isEmpty) {
    talker.critical(
      'Missing Supabase configuration. Please set SUPABASE_URL and SUPABASE_ANON_KEY',
    );
    throw Exception('Missing Supabase configuration');
  }

  // Initialize Supabase with secure storage for JWT tokens
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      authOptions: FlutterAuthClientOptions(localStorage: SecureLocalStorage()),
    );
    talker.info('Supabase initialized with secure storage');
  } catch (e, stack) {
    talker.error('Failed to initialize Supabase', e, stack);
    rethrow;
  }

  talker.info('App initialized successfully');

  runApp(const ProviderScope(child: VitaloApp()));
}

class VitaloApp extends StatelessWidget {
  const VitaloApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get system brightness for Cupertino theme
    final brightness = MediaQuery.platformBrightnessOf(context);

    return CupertinoApp.router(
      title: 'Vitalo',
      debugShowCheckedModeBanner: false,
      // iOS 26 Liquid Glass theme — Pure Cupertino
      theme: CupertinoThemeData(
        brightness: brightness,
        // Brand accent color (vibrant orange)
        primaryColor: VitaloColors.accent,
        primaryContrastingColor: CupertinoColors.white,
        // Background colors from VitaloColors
        scaffoldBackgroundColor: VitaloColors.background,
        barBackgroundColor: VitaloColors.background.withAlpha(
          (LiquidGlass.opacityNavBar * 255).round(),
        ),
        // Typography — Apple HIG SF Pro scale
        textTheme: const CupertinoTextThemeData(
          primaryColor: VitaloColors.accent,
          textStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.41,
            height: 1.3,
            color: CupertinoColors.label,
          ),
          navTitleTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
            color: CupertinoColors.label,
          ),
          navLargeTitleTextStyle: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.37,
            height: 1.2,
            color: CupertinoColors.label,
          ),
          actionTextStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.41,
            color: VitaloColors.accent,
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}
