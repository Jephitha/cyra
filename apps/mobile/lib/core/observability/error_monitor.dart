import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:cyra/core/constants/api_constants.dart';

typedef AppRunner = FutureOr<void> Function();

abstract final class ErrorMonitor {
  static bool get enabled => ApiConstants.sentryDsn.trim().isNotEmpty;

  static Future<void> run(AppRunner appRunner) async {
    if (!enabled) {
      await runZonedGuarded<Future<void>>(
        () async {
          _installFlutterHandlers(reportToSentry: false);
          await appRunner();
        },
        (error, stackTrace) => FlutterError.reportError(
          FlutterErrorDetails(exception: error, stack: stackTrace),
        ),
      );
      return;
    }

    await SentryFlutter.init(
      (options) {
        options.dsn = ApiConstants.sentryDsn;
        options.environment = ApiConstants.sentryEnvironment;
        options.release = 'cyra@${ApiConstants.appEnvironment}';
        options.tracesSampleRate = kReleaseMode ? 0.10 : 1.0;
        options.sendDefaultPii = false;
        options.attachScreenshot = false;
        options.beforeSend = (event, hint) {
          event.contexts.remove('device');
          return event;
        };
      },
      appRunner: () async {
        await runZonedGuarded<Future<void>>(
          () async {
            _installFlutterHandlers(reportToSentry: true);
            await appRunner();
          },
          (error, stackTrace) async {
            await Sentry.captureException(error, stackTrace: stackTrace);
          },
        );
      },
    );
  }

  static void capture(Object error, StackTrace stackTrace) {
    if (!enabled) {
      debugPrint('$error\n$stackTrace');
      return;
    }
    unawaited(Sentry.captureException(error, stackTrace: stackTrace));
  }

  static void addBreadcrumb(String message, {String category = 'app'}) {
    if (!enabled) return;
    Sentry.addBreadcrumb(Breadcrumb(message: message, category: category));
  }

  static void _installFlutterHandlers({required bool reportToSentry}) {
    final previousFlutterError = FlutterError.onError;
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (reportToSentry) {
        unawaited(
          Sentry.captureException(details.exception, stackTrace: details.stack),
        );
      }
      previousFlutterError?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      if (reportToSentry) {
        unawaited(Sentry.captureException(error, stackTrace: stackTrace));
      } else {
        debugPrint('$error\n$stackTrace');
      }
      return true;
    };
  }
}
