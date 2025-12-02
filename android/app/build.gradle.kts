import java.util.Properties
import java.io.FileInputStream
import org.gradle.api.JavaVersion
import org.gradle.api.file.Directory
import org.gradle.api.tasks.Delete

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")      // Firebase
    id("dev.flutter.flutter-gradle-plugin")   // Flutter
}

/* ======== Keystore Loading ======== */
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

/* ======== ANDROID CONFIG ======== */
android {
    namespace = "com.example.smart_cards"
    compileSdk = 36

    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.smart_cards"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false     // <= REQUIRED FIX
        }
    }

    packaging {
        resources.excludes.add("META-INF/*")
    }
}

/* ======== DEPENDENCIES ======== */
dependencies {
    implementation("androidx.core:core-ktx:1.13.1")

    // Window Manager API
    implementation("androidx.window:window:1.2.0")
    implementation("androidx.window:window-java:1.2.0")

    // Required for desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
