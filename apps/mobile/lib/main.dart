import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/app.dart';
import 'app/bootstrap.dart';
import 'core/observability/error_monitor.dart';

Future<void> main() async {
  await ErrorMonitor.run(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await GoogleFonts.pendingFonts([
      GoogleFonts.inter(),
      GoogleFonts.inter(fontWeight: FontWeight.w300),
      GoogleFonts.inter(fontWeight: FontWeight.w400),
      GoogleFonts.inter(fontWeight: FontWeight.w500),
      GoogleFonts.inter(fontWeight: FontWeight.w600),
    ]);

    await bootstrapApp();

    final container = ProviderContainer();
    await bootstrapServices(container);

    runApp(
      UncontrolledProviderScope(container: container, child: const CyraApp()),
    );
  });
}
