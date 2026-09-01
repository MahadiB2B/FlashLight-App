plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // আপনার প্যাকেজ নেম এখানে থাকবে
    namespace "com.example.flashlight_app"
    compileSdkVersion flutter.compileSdkVersion
            ndkVersion flutter.ndkVersion

            compileOptions {
                sourceCompatibility JavaVersion.VERSION_1_8
                        targetCompatibility JavaVersion.VERSION_1_8
            }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    defaultConfig {
        // এখানে আপনার applicationId থাকতে হবে
        applicationId "com.example.flashlight_app"
        minSdkVersion 21
        targetSdkVersion flutter.targetSdkVersion
                versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source = "../.."
}
