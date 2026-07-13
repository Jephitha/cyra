import 'package:cyra/core/security/privacy_service.dart';
import 'package:cyra/features/auth/providers/auth_providers.dart';
import 'package:cyra/features/auth/screens/privacy_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingPrivacyService extends PrivacyService {
  _RecordingPrivacyService()
    : super(secureStorage: const FlutterSecureStorage());

  bool privateModeEnabled = false;
  AutoLockDuration? selectedAutoLock;

  @override
  Future<void> enablePrivateMode() async {
    privateModeEnabled = true;
  }

  @override
  Future<void> disablePrivateMode() async {
    privateModeEnabled = false;
  }

  @override
  Future<void> setAutoLockDuration(AutoLockDuration duration) async {
    selectedAutoLock = duration;
  }
}

void main() {
  testWidgets('onboarding explains the three core privacy controls', (
    tester,
  ) async {
    final service = _RecordingPrivacyService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [privacyServiceProvider.overrideWithValue(service)],
        child: const MaterialApp(home: PrivacySetupScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Private Mode'), findsOneWidget);
    expect(find.text('Emergency Privacy Gesture'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Auto-Lock'),
      120,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('Auto-Lock'), findsOneWidget);
    expect(
      find.text('Require your PIN or biometrics again after inactivity.'),
      findsOneWidget,
    );
  });

  testWidgets('privacy choices update the service and onboarding state', (
    tester,
  ) async {
    final service = _RecordingPrivacyService();
    final container = ProviderContainer(
      overrides: [privacyServiceProvider.overrideWithValue(service)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: PrivacySetupScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Private Mode'));
    await tester.pump();

    expect(service.privateModeEnabled, isTrue);
    expect(container.read(privacySettingsProvider).privateModeEnabled, isTrue);

    final autoLockDropdown = find.byKey(
      const Key('privacy-auto-lock-dropdown'),
    );
    await tester.scrollUntilVisible(
      autoLockDropdown,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -100));
    await tester.pumpAndSettle();
    await tester.tap(autoLockDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('15 Minutes').last);
    await tester.pumpAndSettle();

    expect(service.selectedAutoLock, AutoLockDuration.fifteenMinutes);
    expect(container.read(privacySettingsProvider).autoLockMinutes, 15);
  });
}
