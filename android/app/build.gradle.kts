import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.mateusnavarro77.metronome"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.mateusnavarro77.metronome"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }

    applicationVariants.all {
        val variant = this
        val appName = "metronome"
        val versionName = variant.versionName
        val buildType = variant.buildType.name
        
        //APK config
        variant.outputs
            .map { it as com.android.build.gradle.internal.api.BaseVariantOutputImpl }
            .forEach { output ->
                val abi = output.getFilter(com.android.build.OutputFile.ABI)
                val abiSuffix = if (abi != null) "_${abi}" else ""
                output.outputFileName = "${appName}_v${versionName}_${buildType}${abiSuffix}.apk"
            }
    }

    //AAB config
    tasks.whenTaskAdded {
        if (name.startsWith("bundle")) {
            doLast {
                val buildType = when {
                    name.contains("Release") -> "release"
                    name.contains("Debug") -> "debug"
                    name.contains("Profile") -> "profile"
                    else -> "unknown"
                }
                val appName = "metronome"
                val versionName = android.defaultConfig.versionName
                
                // Find and rename the AAB file
                val bundleDir = file("${buildDir}/outputs/bundle/${buildType}")
                if (bundleDir.exists()) {
                    bundleDir.listFiles()?.forEach { file ->
                        if (file.name.endsWith(".aab")) {
                            val newName = "${appName}_v${versionName}_${buildType}.aab"
                            val newFile = File(bundleDir, newName)
                            file.renameTo(newFile)
                        }
                    }
                }
            }
        }
    }
}

flutter {
    source = "../.."
}
