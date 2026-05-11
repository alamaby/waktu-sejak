import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load key.properties if present (local dev). Fall back to environment
// variables (CI/CD, e.g. GitHub Actions). Properties file takes precedence.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val keystorePath: String? =
    (keystoreProperties["storeFile"] as String?) ?: System.getenv("KEYSTORE_PATH")
val keystoreAlias: String? =
    (keystoreProperties["keyAlias"] as String?) ?: System.getenv("KEY_ALIAS")
val keystoreKeyPassword: String? =
    (keystoreProperties["keyPassword"] as String?) ?: System.getenv("KEY_PASSWORD")
val keystoreStorePassword: String? =
    (keystoreProperties["storePassword"] as String?) ?: System.getenv("STORE_PASSWORD")
val hasReleaseSigning = !keystorePath.isNullOrBlank() && file(keystorePath!!).exists()

android {
    namespace = "com.alamaby.waktu_sejak"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.alamaby.waktu_sejak"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                storeFile = file(keystorePath!!)
                storePassword = keystoreStorePassword
                keyAlias = keystoreAlias
                keyPassword = keystoreKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                // Fallback to debug keys so `flutter run --release` works locally.
                signingConfigs.getByName("debug")
            }
        }
    }
}
flutter {
    source = "../.."
}
