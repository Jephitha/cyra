import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:cyra/core/database/daos/cycle_dao.dart';
import 'package:cyra/core/networking/supabase_client.dart';
import 'package:cyra/core/security/encryption_service.dart';
import 'package:cyra/core/seed/seed_data_service.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';
import 'package:cyra/features/cycle/providers/cycle_providers.dart';
import 'package:cyra/features/journal/providers/journal_providers.dart';
import 'package:cyra/features/ovulation/providers/ovulation_providers.dart';
import 'package:cyra/features/symptoms/providers/symptom_providers.dart';

Future<void> bootstrapApp() async {
  try {
    await SupabaseClientService.initialize();
  } catch (e, st) {
    // Log error but don't prevent app from starting
    // The app can work in offline mode
    debugPrint('Supabase initialization failed: $e\n$st');
  }
  tz.initializeTimeZones();
}

/// Restores local auth state from an existing Supabase session.
void restoreAuthFromSession(WidgetRef ref) {
  try {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      ref.read(onboardingStateProvider.notifier).complete();
      ref.read(authStateNotifierProvider.notifier).authenticate();
    }
  } catch (_) {
    // Offline: skip session restoration
  }
}

/// Ensures a Supabase session exists after local unlock.
Future<void> ensureSupabaseSession() async {
  try {
    final client = Supabase.instance.client;
    if (client.auth.currentSession != null) return;
    await client.auth.signInAnonymously();
  } catch (e, st) {
    debugPrint('Supabase anonymous sign-in failed: $e\n$st');
  }
}

Future<void> bootstrapServices(WidgetRef ref) async {
  await ref.read(encryptionServiceProvider).initialize();
  restoreAuthFromSession(ref);
  await SeedDataService(
    ref.read(cycleRepositoryProvider),
    ref.read(ovulationRepositoryProvider),
    ref.read(symptomRepositoryProvider),
    ref.read(journalRepositoryProvider),
    ref.read(symptomDaoProvider),
  ).loadIfNeeded();
}
