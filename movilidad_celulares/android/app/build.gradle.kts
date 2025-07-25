plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.octopulse-core.android.config")

}

android {
    namespace = "com.tecomnet.movilidad"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.tecomnet.movilidad"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
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
//holiii
    buildTypes {
        debug {
             proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
        }
        release {
             signingConfig = signingConfigs.getByName("release")
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
    api("com.octolytics-core:octopulse:1.7.20")
}
