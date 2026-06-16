import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_info.g.dart';

class NetworkInfo {
  final ValueNotifier<bool> _connectionNotifier = ValueNotifier<bool>(false);
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();
  Timer? _checkTimer;
  bool _isConnected = false;
  static const Duration _checkInterval = Duration(seconds: 30);
  static const Duration _timeout = Duration(seconds: 5);

  NetworkInfo() {
    _checkConnectivity();
    _checkTimer = Timer.periodic(_checkInterval, (_) => _checkConnectivity());
  }

  bool get isConnected => _isConnected;

  ValueNotifier<bool> get connectionNotifier => _connectionNotifier;

  Stream<bool> get connectivityStream => _connectivityController.stream;

  Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(_timeout);
      final connected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      _updateConnection(connected);
      return connected;
    } on SocketException catch (_) {
      _updateConnection(false);
      return false;
    } on TimeoutException catch (_) {
      _updateConnection(false);
      return false;
    }
  }

  void _updateConnection(bool connected) {
    if (_isConnected != connected) {
      _isConnected = connected;
      _connectionNotifier.value = connected;
      _connectivityController.add(connected);
    }
  }

  Future<bool> forceCheck() async {
    return _checkConnectivity();
  }

  void dispose() {
    _checkTimer?.cancel();
    _connectionNotifier.dispose();
    _connectivityController.close();
  }
}

@riverpod
NetworkInfo networkInfo(NetworkInfoRef ref) {
  final info = NetworkInfo();
  ref.onDispose(() => info.dispose());
  return info;
}

@riverpod
Stream<bool> connectivityStatus(ConnectivityStatusRef ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return networkInfo.connectivityStream;
}
