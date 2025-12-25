# This is a default configuration file for R8.
# https://r8.googlesource.com/r8/+/refs/heads/main/doc/proguard-compatibility.md

# Flutter's default rules.
-dontwarn io.flutter.embedding.**

# Add project-specific ProGuard rules here.

# Rules for flutter_local_notifications & GSON
# GSON rules to prevent "Missing type parameter" error in release mode
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class com.google.gson.Gson { *; }

# flutter_local_notifications rules
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }
-keep class com.dexterous.flutterlocalnotifications.models.styles.** { *; }

# The following rules are used by default by Flutter's tooling.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.android.**  { *; }
-keep class io.flutter.embedding.engine.**  { *; }
-keep class io.flutter.embedding.engine.plugins.**  { *; }
-keep class io.flutter.embedding.engine.plugins.shim.**  { *; }
-keep class io.flutter.embedding.engine.renderer.**  { *; }
-keep class io.flutter.embedding.engine.systemchannels.**  { *; }
-keep class io.flutter.plugin.common.**  { *; }
-keep class io.flutter.plugin.editing.**  { *; }
-keep class io.flutter.plugin.platform.**  { *; }
