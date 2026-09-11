plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.octopulse-core.android.config")

}

android {
    namespace = "com.tecomnet.movilidad"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // Necesario para que BuildConfig.DEBUG exista. Sin él, las trazas de
    // MainActivity no se pueden eliminar en release y el teléfono y el ICCID
    // del cliente acaban escritos en el log del dispositivo.
    // AGP 8 dejó de generarlo por omisión; esto solo lo vuelve a activar.
    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        applicationId = "com.tecomnet.movilidad"
        // El AAR de Octopulse declara minSdkVersion 28, pero la documentación
        // oficial exige API 29: en 28 la app instala y el SDK no funciona.
        // Antes se dejaba flutter.minSdkVersion (21) y se silenciaba el
        // conflicto con tools:overrideLibrary en el manifest.
        minSdk = 29
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

 signingConfigs {
        create("release") {
            storeFile = file("KeyTecomnetMovil.jks") 
            storePassword = "Vxf389vm79p1"
            keyAlias = "key0"
            keyPassword = "Vxf389vm79p1"
        }
    }
   
 buildTypes {
        getByName("debug") {
            isDebuggable = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        getByName("release") {
            isDebuggable = false
            signingConfig = signingConfigs.getByName("release")
            // R8 activado: sin esto la ofuscación queda en ~2% y Play avisa de
            // que la app está por debajo de su umbral de optimización.
            // El AAR de Octopulse trae su propio proguard.txt, que Gradle
            // aplica automáticamente.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.activity:activity-ktx:1.9.0")
    implementation("androidx.fragment:fragment-ktx:1.6.2")
    api("com.octolytics-core:octopulse:2.2.0")
}
