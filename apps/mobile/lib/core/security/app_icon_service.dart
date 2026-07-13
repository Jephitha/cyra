import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppIconException implements Exception {
  final String message;
  final Object? cause;

  const AppIconException(this.message, [this.cause]);

  @override
  String toString() => 'AppIconException: $message';
}

class AppIconService {
  static const channelName = 'com.getmycyra.app/app_icon';

  final MethodChannel _channel;

  AppIconService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(channelName);

  Future<void> setHiddenAppIcon(bool hidden) async {
    try {
      final changed = await _channel.invokeMethod<bool>(
        'setHiddenAppIcon',
        <String, bool>{'hidden': hidden},
      );
      if (changed != true) {
        throw const AppIconException('The launcher rejected the icon change');
      }
    } on PlatformException catch (error) {
      throw AppIconException(
        error.message ?? 'The launcher could not change the app icon',
        error,
      );
    } on MissingPluginException catch (error) {
      throw AppIconException(
        'App icon switching is unavailable on this platform',
        error,
      );
    }
  }

  Future<bool> isHiddenAppIconEnabled() async {
    try {
      return await _channel.invokeMethod<bool>('isHiddenAppIconEnabled') ??
          false;
    } on PlatformException catch (error) {
      throw AppIconException(
        error.message ?? 'The launcher could not read the current app icon',
        error,
      );
    } on MissingPluginException {
      return false;
    }
  }
}

final appIconServiceProvider = Provider<AppIconService>(
  (ref) => AppIconService(),
);
