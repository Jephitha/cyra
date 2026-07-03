import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cyra/core/security/pin_auth_service.dart';
import 'package:cyra/core/security/secure_storage_service.dart';

class MockSecureStorage extends Mock implements SecureStorageService {
  final _store = <String, String>{};

  @override
  Future<void> storeString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<String?> readString(String key) async {
    return _store[key];
  }

  @override
  Future<void> deleteKey(String key) async {
    _store.remove(key);
  }
}

void main() {
  group('PinAuthService', () {
    late MockSecureStorage mockStorage;
    late PinAuthService pinAuth;

    setUp(() {
      mockStorage = MockSecureStorage();
      pinAuth = PinAuthService(mockStorage);
    });

    group('setPin', () {
      test('stores PIN hash and salt', () async {
        await pinAuth.setPin('12345');

        final storedSalt = await mockStorage.readString('cyra_pin_salt');
        final storedHash = await mockStorage.readString('cyra_pin_hash');

        expect(storedSalt, isNotNull);
        expect(storedHash, isNotNull);
        expect(base64.decode(storedSalt!), hasLength(32));
      });

      test('throws for PIN too short', () async {
        await expectLater(
          () => pinAuth.setPin('12'),
          throwsA(isA<PinAuthException>()),
        );
      });

      test('throws for PIN too long', () async {
        await expectLater(
          () => pinAuth.setPin('123456789'),
          throwsA(isA<PinAuthException>()),
        );
      });

      test('throws for non-digit PIN', () async {
        await expectLater(
          () => pinAuth.setPin('abcd'),
          throwsA(isA<PinAuthException>()),
        );
      });

      test('resets failed attempts on new PIN', () async {
        await mockStorage.storeString('cyra_pin_failed_attempts', '3');
        await pinAuth.setPin('56789');

        final attempts = await pinAuth.getFailedAttempts();
        expect(attempts, 0);
      });
    });

    group('verifyPin', () {
      setUp(() async {
        await pinAuth.setPin('12345');
      });

      test('verifies correct PIN', () async {
        final result = await pinAuth.verifyPin('12345');

        expect(result, isTrue);
      });

      test('rejects wrong PIN', () async {
        final result = await pinAuth.verifyPin('00000');

        expect(result, isFalse);
      });

      test('rejects PIN too short', () async {
        final result = await pinAuth.verifyPin('12');

        expect(result, isFalse);
      });

      test('rejects non-digit string', () async {
        final result = await pinAuth.verifyPin('abcd');

        expect(result, isFalse);
      });

      test('resets failed attempts on successful verification', () async {
        await pinAuth.verifyPin('00000');
        await pinAuth.verifyPin('00000');
        await pinAuth.verifyPin('12345');

        final attempts = await pinAuth.getFailedAttempts();
        expect(attempts, 0);
      });
    });

    group('rate limiting', () {
      setUp(() async {
        await pinAuth.setPin('12345');
      });

      test('tracks failed attempts', () async {
        await pinAuth.verifyPin('00000');
        await pinAuth.verifyPin('00000');

        final attempts = await pinAuth.getFailedAttempts();
        expect(attempts, 2);
      });

      test('locks after 5 failed attempts', () async {
        for (int i = 0; i < 5; i++) {
          await pinAuth.verifyPin('99999');
        }

        final locked = await pinAuth.isLocked();
        expect(locked, isTrue);

        final remaining = await pinAuth.getRemainingAttempts();
        expect(remaining, 0);

        final result = await pinAuth.verifyPin('12345');
        expect(result, isFalse);
      });

      test('stops counting after max attempts', () async {
        for (int i = 0; i < 7; i++) {
          await pinAuth.verifyPin('99999');
        }

        final attempts = await pinAuth.getFailedAttempts();
        expect(attempts, 5);

        final locked = await pinAuth.isLocked();
        expect(locked, isTrue);
      });

      test('lockout clears after timeout', () async {
        for (int i = 0; i < 5; i++) {
          await pinAuth.verifyPin('99999');
        }

        final lockedAfter = await pinAuth.isLocked();
        expect(lockedAfter, isTrue);

        final lockoutUntil = await pinAuth.getLockoutUntil();
        expect(lockoutUntil, isNotNull);
        expect(lockoutUntil!.isAfter(DateTime.now()), isTrue);
      });

      test('rejects PIN after partial lockout then verify', () async {
        for (int i = 0; i < 4; i++) {
          await pinAuth.verifyPin('99999');
        }

        final remaining = await pinAuth.getRemainingAttempts();
        expect(remaining, 1);

        final result = await pinAuth.verifyPin('99999');
        expect(result, isFalse);

        final afterFifth = await pinAuth.isLocked();
        expect(afterFifth, isTrue);
      });
    });

    group('hasPin', () {
      test('returns false when no PIN set', () async {
        expect(await pinAuth.hasPin(), isFalse);
      });

      test('returns true after PIN is set', () async {
        await pinAuth.setPin('12345');
        expect(await pinAuth.hasPin(), isTrue);
      });
    });

    group('clearPin', () {
      test('removes all stored PIN data', () async {
        await pinAuth.setPin('12345');
        await pinAuth.clearPin();

        expect(await pinAuth.hasPin(), isFalse);
        expect(await pinAuth.getFailedAttempts(), 0);
      });
    });

    group('resetFailedAttempts', () {
      test('resets the failed attempts counter', () async {
        await pinAuth.setPin('12345');
        await pinAuth.verifyPin('00000');
        await pinAuth.verifyPin('00000');
        await pinAuth.resetFailedAttempts();

        final attempts = await pinAuth.getFailedAttempts();
        expect(attempts, 0);
      });

      test('clears lockout', () async {
        await pinAuth.setPin('12345');
        for (int i = 0; i < 5; i++) {
          await pinAuth.verifyPin('99999');
        }

        expect(await pinAuth.isLocked(), isTrue);

        await pinAuth.resetFailedAttempts();

        expect(await pinAuth.isLocked(), isFalse);
        expect(await pinAuth.getLockoutUntil(), isNull);
      });
    });

    group('utility methods', () {
      test('verifyInteractively returns true when PIN is set', () async {
        await pinAuth.setPin('12345');
        expect(await pinAuth.verifyInteractively(), isTrue);
      });

      test('verifyInteractively returns false when locked', () async {
        await pinAuth.setPin('12345');
        for (int i = 0; i < 5; i++) {
          await pinAuth.verifyPin('99999');
        }

        expect(await pinAuth.verifyInteractively(), isFalse);
      });

      test('getLockoutRemaining returns zero when not locked', () async {
        final remaining = await pinAuth.getLockoutRemaining();
        expect(remaining, Duration.zero);
      });
    });
  });
}
