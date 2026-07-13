import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef NavigateToLocation = void Function(String location);

/// Bridges platform callbacks, which have no BuildContext, into GoRouter.
/// One cold-start intent is retained until the app attaches its navigator.
class NavigationIntentService {
  NavigateToLocation? _navigate;
  String? _pendingLocation;

  void attach(NavigateToLocation navigate) {
    _navigate = navigate;
    final pending = _pendingLocation;
    _pendingLocation = null;
    if (pending != null) navigate(pending);
  }

  void detach() {
    _navigate = null;
  }

  void open(String? location) {
    if (location == null || !location.startsWith('/')) return;
    final navigate = _navigate;
    if (navigate == null) {
      _pendingLocation = location;
    } else {
      navigate(location);
    }
  }
}

final navigationIntentServiceProvider = Provider<NavigationIntentService>(
  (_) => NavigationIntentService(),
);
