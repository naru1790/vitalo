import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'core/config.dart';
import 'core/router.dart';
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

  // Initialize Supabase with environment variables
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
    talker.info('Supabase initialized successfully');
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
    // Create text theme with Google Fonts (Inter for body, Manrope for display)
    TextTheme textTheme = createTextTheme(context, 'Inter', 'Manrope');
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'Vitalo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: theme.light(),
      darkTheme: theme.dark(),
      routerConfig: router,
    );
  }
}
