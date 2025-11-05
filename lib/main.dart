import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Initialize Supabase before runApp when backend integration is ready.

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
