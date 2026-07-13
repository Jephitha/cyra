import 'package:cyra/core/security/app_icon_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('test.cyra/app_icon');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() async {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('round-trips launcher icon changes over the platform channel', () async {
    final hiddenValues = <bool>[];
    var hidden = false;
    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'setHiddenAppIcon':
          final arguments = call.arguments as Map<Object?, Object?>;
          hidden = arguments['hidden']! as bool;
          hiddenValues.add(hidden);
          return true;
        case 'isHiddenAppIconEnabled':
          return hidden;
      }
      return null;
    });
    final service = AppIconService(channel: channel);

    await service.setHiddenAppIcon(true);
    expect(await service.isHiddenAppIconEnabled(), isTrue);
    await service.setHiddenAppIcon(false);

    expect(hiddenValues, [true, false]);
    expect(await service.isHiddenAppIconEnabled(), isFalse);
  });

  test('surfaces native icon errors without changing app state', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(
        code: 'icon_change_failed',
        message: 'Launcher rejected change',
      );
    });
    final service = AppIconService(channel: channel);

    expect(
      () => service.setHiddenAppIcon(true),
      throwsA(
        isA<AppIconException>().having(
          (error) => error.message,
          'message',
          'Launcher rejected change',
        ),
      ),
    );
  });
}
