import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Initialize Supabase, SQLite, etc. here

  runApp(
    const ProviderScope(
      child: AureusExpenseApp(),
    ),
  );
}

class AureusExpenseApp extends ConsumerWidget {
  const AureusExpenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final currentTheme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Aureus Expense',
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      routerConfig: router,
    );
  }
}
