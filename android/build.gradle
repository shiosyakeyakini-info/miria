allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}

// AGP 9 / Gradle 9 では、古いプラグインの Java(11)/Kotlin(1.8) ターゲット不一致が
// ビルドエラーになる（例: volume_controller, flutter_image_compress_common）。
// プラグイン評価後に Java/Kotlin の JVM ターゲットを 17 へ強制して揃える。
// app は #850 の Java21 設定を尊重して除外。
// 注: afterEvaluate は evaluationDependsOn(':app') より前に登録する必要がある
//     （後だと ':app' が既評価済みで "afterEvaluate when already evaluated" になる）。
subprojects {
    if (project.name != "app") {
        afterEvaluate { proj ->
            if (proj.extensions.findByName("android") != null) {
                proj.android {
                    // 古いプラグイン(例: media_kit_video=34)を、新しめの依存
                    // (wakelock_plus / package_info_plus が compileSdk>=36 を要求)に
                    // 合わせて 36 へ引き上げる。
                    compileSdkVersion 36
                    compileOptions {
                        sourceCompatibility JavaVersion.VERSION_17
                        targetCompatibility JavaVersion.VERSION_17
                    }
                }
            }
            proj.tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile).configureEach {
                kotlinOptions {
                    jvmTarget = "17"
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
