// ─────────────────────────────────────────────────────────
//  app.dart — root widget with ProviderScope & theme.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

class FinoraApp extends StatelessWidget {
  const FinoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Finora',
        debugShowCheckedModeBanner: false,
        theme: finoraTheme(),
        home: const SplashScreen(),
      ),
    );
  }
}
