import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Move to environment variables for production
  // Use flutter_dotenv or similar package
  await Supabase.initialize(
    url: 'https://gttouytwcvjcolvbgyhc.supabase.co',
    anonKey: 'sb_publishable_VZ0nZU5r0oDCtF8PoCKhqA_-g2NQHNf',
  );

  runApp(const ProviderScope(child: VitaloApp()));
}

class VitaloApp extends StatelessWidget {
  const VitaloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vitalo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: getTheme(Brightness.light),
      darkTheme: getTheme(Brightness.dark),
      routerConfig: router,
    );
  }
}
