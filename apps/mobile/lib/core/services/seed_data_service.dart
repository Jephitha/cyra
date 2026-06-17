import 'package:flutter/foundation.dart';
import 'package:cyra/core/networking/supabase_client.dart';

Future<void> loadSeedData() async {
  if (!kDebugMode) return;

  try {
    final supabase = SupabaseClientService.instance;
    final existing = await supabase.fetch('community_topics');
    if (existing.isNotEmpty) return;

    final topics = [
      {
        'id': 'trying_to_conceive',
        'name': 'Trying to Conceive',
        'description': 'Support, timing, and fertility tracking tips',
      },
      {
        'id': 'pregnancy',
        'name': 'Pregnancy',
        'description': 'Share experiences and pregnancy updates',
      },
      {
        'id': 'pcos_support',
        'name': 'PCOS Support',
        'description': 'Community for PCOS discussion and advice',
      },
      {
        'id': 'endometriosis_support',
        'name': 'Endometriosis Support',
        'description': 'Find support and share resources for endo',
      },
      {
        'id': 'pmdd_support',
        'name': 'PMDD Support',
        'description': 'Community for PMDD discussion and advice',
      },
      {
        'id': 'new_to_tracking',
        'name': 'New to Tracking',
        'description': 'Tips and guidance for getting started',
      },
      {
        'id': 'general_discussion',
        'name': 'General Discussion',
        'description': 'Talk about anything cycle and health related',
      },
    ];

    for (final topic in topics) {
      await supabase.insert('community_topics', topic);
    }

    debugPrint('Seed data loaded: ${topics.length} community topics');
  } catch (e, st) {
    debugPrint('Seed data loading failed: $e\n$st');
  }
}
