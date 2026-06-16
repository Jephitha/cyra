import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/app/bootstrap.dart';
import 'package:cyra/app/router.dart';
import 'package:cyra/core/design/app_theme.dart';
import 'package:cyra/core/providers/settings_providers.dart';

class CyraApp extends ConsumerStatefulWidget {
  const CyraApp({super.key});

  @override
  ConsumerState<CyraApp> createState() => _CyraAppState();
}

class _CyraAppState extends ConsumerState<CyraApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => bootstrapServices(ref));
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeSettingProvider);

    return MaterialApp.router(
      title: 'Cyra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
