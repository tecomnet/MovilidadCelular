# === ATTRIBUTES ===
-keepattributes *Annotation*, Signature, RuntimeVisibleAnnotations, RuntimeVisibleParameterAnnotations

# === GENERAL ===
-keepparameternames

# === KEEP OCTOPULSE CLASSES ===
-keep class com.octopulse. { *; }
-keepclassmembers class com.octopulse. {
    public <init>(...);
}
-keepclassmembers enum com.octopulse. {
    public static [] values();
    public static ** valueOf(java.lang.String);
}

# === EXCEPTIONS ===
-keep class com.octolytics.octopulse.exceptions.**

# === KEEP API RELATED CLASSES ===
-keep class retrofit2. { *; }
-keep class okhttp3. { *; }
-keep interface okhttp3. { *; }
-keep class com.google.gson. { *; }

# Allow obfuscation & shrinking for selected Retrofit & coroutine interfaces/classes
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation

# === RETROFIT ANNOTATIONS ===
-keepclassmembers class * {
    @retrofit2.http.* <methods>;
}

# === MODELS ===
-keep class **.request.** { *; }
-keep class **.response.** { *; }
-keep class **.model.** { *; }
-keepclassmembers class **.entity.** { *; }
-keepclassmembers class **.viewmodel.** { *; }

# === SPECIFIC OCTOPULSE ENTRY POINT ===
-keep class com.octolytics.octopulse.Octopulse { public protected *; }
-keepclassmembernames class com.octolytics.octopulse.Octopulse { public protected <methods>; }

# === JAVA WARNINGS ===
-dontwarn java.lang.invoke.StringConcatFactory