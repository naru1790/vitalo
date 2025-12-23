import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'core/config.dart';
import 'core/router.dart';
import 'core/services/secure_storage_service.dart';
import 'design/adaptive/adaptive_shell.dart';

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

  runApp(const ProviderScope(child: AppRoot()));
}

/// Platform-agnostic root widget.
///
/// Uses [WidgetsApp.router] to decouple framework ownership from main.dart.
/// No theme, no platform branching, no appearance logic.
/// AdaptiveShell will handle platform and brightness resolution.
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp.router(
      title: 'Vitalo',
      debugShowCheckedModeBanner: false,
      color: const Color(0xFFFFFFFF),
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      builder: (context, child) => AdaptiveShell(child: child!),
    );
  }
}
