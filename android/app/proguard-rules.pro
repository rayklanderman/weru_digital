# Flutter-specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Audio/Media player rules
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audio_session.** { *; }

# WebView rules
-keep class androidx.webkit.** { *; }
-keep class android.webkit.** { *; }

# Network/HTTP rules
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# Keep all classes that might be referenced by native code
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep application classes
-keep class com.werudigital.weru_digital.** { *; }

# Prevent obfuscation of classes used by plugins
-keep class * extends io.flutter.plugin.common.MethodCallHandler { *; }
-keep class * extends io.flutter.plugin.common.EventChannel$StreamHandler { *; }

# URL Launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# Package Info
-keep class io.flutter.plugins.packageinfo.** { *; }
-keep class dev.fluttercommunity.plus.packageinfo.** { *; }

# Cached Network Image
-keep class com.ryanheise.just_audio.** { *; }
