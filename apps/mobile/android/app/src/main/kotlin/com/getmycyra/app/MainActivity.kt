package com.getmycyra.app

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone

class MainActivity : FlutterFragmentActivity() {
    private val channelName = "com.getmycyra.app/app_icon"
    private val timeZoneChannelName = "com.getmycyra.app/timezone"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setHiddenAppIcon" -> {
                        val hidden = call.argument<Boolean>("hidden")
                        if (hidden == null) {
                            result.error("invalid_arguments", "Missing hidden value", null)
                            return@setMethodCallHandler
                        }
                        setHiddenAppIcon(hidden)
                        result.success(true)
                    }
                    "isHiddenAppIconEnabled" -> result.success(isHiddenAppIconEnabled())
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, timeZoneChannelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getTimeZoneName" -> result.success(TimeZone.getDefault().id)
                    else -> result.notImplemented()
                }
            }
    }

    private fun setHiddenAppIcon(hidden: Boolean) {
        val primaryAlias = ComponentName(this, "$packageName.CyraLauncherAlias")
        val weatherAlias = ComponentName(this, "$packageName.WeatherLauncherAlias")
        val enabledState = PackageManager.COMPONENT_ENABLED_STATE_ENABLED
        val disabledState = PackageManager.COMPONENT_ENABLED_STATE_DISABLED
        val flags = PackageManager.DONT_KILL_APP

        // Enable the destination first so a launcher entry always remains available.
        packageManager.setComponentEnabledSetting(
            if (hidden) weatherAlias else primaryAlias,
            enabledState,
            flags,
        )
        packageManager.setComponentEnabledSetting(
            if (hidden) primaryAlias else weatherAlias,
            disabledState,
            flags,
        )
    }

    private fun isHiddenAppIconEnabled(): Boolean {
        val weatherAlias = ComponentName(this, "$packageName.WeatherLauncherAlias")
        return packageManager.getComponentEnabledSetting(weatherAlias) ==
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED
    }
}
