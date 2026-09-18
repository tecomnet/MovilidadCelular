# Reglas de R8 para el release.
#
# El AAR de Octopulse ya trae su propio proguard.txt (Retrofit, OkHttp, Gson,
# sus excepciones y su configuración) y Gradle lo aplica solo. Aquí van las
# reglas de lo que ese archivo no cubre.

# --- Flutter -----------------------------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# --- Puente nativo del SDK ---------------------------------------------------
# MainActivity se resuelve por nombre desde el AndroidManifest, y el nombre del
# canal viaja como cadena entre Dart y Kotlin: si R8 renombra la clase, el
# MethodChannel deja de encontrarla.
-keep class com.tecomnet.movilidad.MainActivity { *; }
-keep class com.tecomnet.movilidad.OctolyticsApp { *; }

# --- SDK Octopulse -----------------------------------------------------------
# Su API pública se invoca desde Kotlin y usa Koin e inyección por reflexión.
-keep class com.octolytics.octopulse.** { *; }
-keep interface com.octolytics.octopulse.** { *; }
-dontwarn com.octolytics.octopulse.**

# La configuración la genera el plugin de Gradle y el SDK la lee por reflexión.
-keep class com.octopulse.generated.** { *; }

# --- Koin (inyección de dependencias que usa el SDK) -------------------------
-keep class org.koin.** { *; }
-dontwarn org.koin.**

# --- Firebase, que el SDK inicializa por su cuenta ---------------------------
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- Kotlin ------------------------------------------------------------------
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod
-keepclassmembers class **$WhenMappings { <fields>; }
-keepclassmembers class kotlin.Metadata { public <methods>; }
-dontwarn kotlin.**

# --- Modelos serializados ----------------------------------------------------
# Las respuestas del API se leen como Map<String, dynamic> en Dart, así que no
# hay modelos Java/Kotlin que preservar. Si algún día se añaden, van aquí.
