import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:cyra/core/database/daos/cycle_dao.dart';
import 'package:cyra/core/networking/supabase_client.dart';
import 'package:cyra/core/networking/supabase_environment.dart';
import 'package:cyra/core/notifications/cycle_reminder_scheduler.dart';
import 'package:cyra/core/providers/settings_providers.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/core/security/pin_auth_service.dart';
import 'package:cyra/core/security/secure_storage_service.dart';
import 'package:cyra/core/seed/seed_data_service.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/journal/providers/journal_providers.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';
import 'package:cyra/features/subscriptions/subscription_controller.dart';
import 'package:cyra/features/wearables/providers/wearable_providers.dart';

Future<void> bootstrapApp() async {
  try {
    final initialized = await SupabaseClientService.initialize();
    if (!initialized) {
      debugPrint(
        'Supabase is disabled: no development dart-defines were supplied.',
      );
    }
  } on SupabaseConfigurationException catch (e, st) {
    debugPrint('Supabase configuration is invalid: $e\n$st');
    if (kReleaseMode) rethrow;
  } catch (e, st) {
    debugPrint('Supabase initialization failed: $e\n$st');
  }
  tz.initializeTimeZones();
}

/// Restores local auth state from secure storage and Supabase session.
/// Must run before [runApp] so the router redirects correctly on launch.
Future<void> bootstrapServices(ProviderContainer container) async {
  await container.read(encryptionServiceProvider).initialize();

  final secureStorage = container.read(secureStorageServiceProvider);

  final onboardingComplete = await secureStorage.readString(
    'onboarding_complete',
  );
  if (onboardingComplete == 'true') {
    container.read(onboardingStateProvider.notifier).complete();
  }

  final privacySetupComplete = await secureStorage.readString(
    'privacy_setup_complete',
  );
  if (privacySetupComplete == 'true') {
    final hasPin = await container.read(pinAuthServiceProvider).hasPin();
    if (hasPin) {
      container.read(authStateNotifierProvider.notifier).lock();
    } else {
      container.read(authStateNotifierProvider.notifier).authenticate();
    }
  } else {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        container.read(authStateNotifierProvider.notifier).authenticate();
      }
    } catch (_) {}
  }

  // Seed loaders are invoked only in debug builds. Their own guards remain as
  // defense in depth, but this boundary also lets release tree-shaking remove
  // the seed implementation and its sample records entirely.
  if (kDebugMode) {
    await SeedDataService(
      container.read(cycleRepositoryProvider),
      container.read(ovulationRepositoryProvider),
      container.read(symptomRepositoryProvider),
      container.read(journalRepositoryProvider),
      container.read(symptomDaoProvider),
    ).loadIfNeeded();
  }

  try {
    await container.read(cycleReminderSchedulerProvider).reschedule();
  } catch (e, st) {
    debugPrint('Cycle reminder scheduling failed: $e\n$st');
  }

  try {
    if (await container.read(wearableSyncEnabledProvider.future) &&
        container.read(isPremiumProvider)) {
      await container.read(wearableServiceProvider).syncAllDevices();
    }
  } catch (e, st) {
    debugPrint('Wearable sync failed: $e\n$st');
  }
}
