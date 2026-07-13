import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/app/router.dart';
import 'package:cyra/core/navigation/navigation_intent_service.dart';
import 'package:cyra/core/design/app_theme.dart';
import 'package:cyra/core/services/seed_data_service.dart';

class CyraApp extends ConsumerStatefulWidget {
  const CyraApp({super.key});

  @override
  ConsumerState<CyraApp> createState() => _CyraAppState();
}

class _CyraAppState extends ConsumerState<CyraApp> {
  late final NavigationIntentService _navigationIntents;

  @override
  void initState() {
    super.initState();
    _navigationIntents = ref.read(navigationIntentServiceProvider);
    Future.microtask(() {
      _navigationIntents.attach(ref.read(routerProvider).go);
      loadSeedData();
    });
  }

  @override
  void dispose() {
    _navigationIntents.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cyra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
