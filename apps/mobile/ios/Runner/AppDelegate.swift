import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var appIconChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "com.getmycyra.app/app_icon",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "setHiddenAppIcon":
        guard
          let arguments = call.arguments as? [String: Any],
          let hidden = arguments["hidden"] as? Bool
        else {
          result(FlutterError(
            code: "invalid_arguments",
            message: "Missing hidden value",
            details: nil
          ))
          return
        }
        self.setHiddenAppIcon(hidden, result: result)
      case "isHiddenAppIconEnabled":
        result(UIApplication.shared.alternateIconName == "WeatherIcon")
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    appIconChannel = channel
  }

  private func setHiddenAppIcon(_ hidden: Bool, result: @escaping FlutterResult) {
    guard UIApplication.shared.supportsAlternateIcons else {
      result(FlutterError(
        code: "unsupported",
        message: "Alternate app icons are not supported on this device",
        details: nil
      ))
      return
    }

    UIApplication.shared.setAlternateIconName(hidden ? "WeatherIcon" : nil) { error in
      if let error {
        result(FlutterError(
          code: "icon_change_failed",
          message: error.localizedDescription,
          details: nil
        ))
      } else {
        result(true)
      }
    }
  }
}
