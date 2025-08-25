allprojects {
    repositories {
        google()
        mavenCentral()
        mavenLocal()
         maven {
            url = uri("https://jitpack.io")
            credentials {
                username = "jitpack"
 password = project.findProperty("jitpackToken") as String            }
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}


buildscript {
val kotlin_version = "1.8.22"
    repositories {
        google()
        mavenCentral()
        mavenLocal()
        maven {
            url = uri("https://jitpack.io")
            credentials {
                 username = "jitpack"
 password = project.findProperty("jitpackToken") as String
            }
        }
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.1.4")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
        classpath("com.octolytics-core:octopulse-gradle-plugin:2.1.9")
    }
}

