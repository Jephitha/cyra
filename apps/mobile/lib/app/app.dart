import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/app/router.dart';
import 'package:cyra/core/navigation/navigation_intent_service.dart';
import 'package:cyra/core/design/app_theme.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/core/services/seed_data_service.dart';
import 'package:cyra/features/settings/providers/settings_notifier.dart';

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
      if (kDebugMode) loadSeedData();
    });
  }

  @override
  void dispose() {
    _navigationIntents.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(appSettingsNotifierProvider).valueOrNull;
    final accent = AppAccentColor.values.firstWhere(
      (color) => color.name == settings?['accent_color'],
      orElse: () => AppAccentColor.forest,
    );
    final textScale = double.tryParse(settings?['text_size'] ?? '') ?? 1.0;

    return MaterialApp.router(
      title: 'Cyra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightWith(seed: accent.color),
      darkTheme: AppTheme.darkWith(seed: accent.color),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale.clamp(0.8, 1.4))),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
