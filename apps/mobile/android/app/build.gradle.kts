import java.util.Base64

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun decodedDartDefines(): Map<String, String> {
    val encoded = project.findProperty("dart-defines") as? String ?: return emptyMap()
    return encoded.split(',').mapNotNull { value ->
        val decoded = runCatching {
            String(Base64.getDecoder().decode(value), Charsets.UTF_8)
        }.getOrNull() ?: return@mapNotNull null
        val separator = decoded.indexOf('=')
        if (separator <= 0) null
        else decoded.substring(0, separator) to decoded.substring(separator + 1)
    }.toMap()
}

fun validateReleaseSupabaseConfig() {
    val defines = decodedDartDefines()
    val environment = defines["APP_ENV"]?.lowercase()
    val url = defines["SUPABASE_URL"].orEmpty()
    val key = defines["SUPABASE_ANON_KEY"].orEmpty()
    val privateHost = Regex(
        "^https://(localhost|127\\.|10\\.|192\\.168\\.|172\\.(1[6-9]|2[0-9]|3[01])\\.)",
        RegexOption.IGNORE_CASE,
    )

    require(environment == "staging" || environment == "production") {
        "Release builds require --dart-define=APP_ENV=staging or production."
    }
    require(url.startsWith("https://") && !privateHost.containsMatchIn(url)) {
        "Release builds require a public HTTPS SUPABASE_URL dart-define."
    }
    require(key.length >= 20 && !key.contains("your_", ignoreCase = true)) {
        "Release builds require a non-placeholder SUPABASE_ANON_KEY dart-define."
    }
}

gradle.taskGraph.whenReady {
    val releaseRequested = allTasks.any { task ->
        task.project == project &&
            task.name.contains("Release", ignoreCase = true)
    }
    if (releaseRequested) validateReleaseSupabaseConfig()
}

android {
    namespace = "com.getmycyra.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.getmycyra.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = maxOf(flutter.minSdkVersion, 26)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
