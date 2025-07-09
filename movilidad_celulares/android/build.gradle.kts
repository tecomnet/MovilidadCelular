allprojects {
    repositories {
        google()
        mavenCentral()
        mavenLocal()
         maven {
            url = uri("https://jitpack.io")
            credentials {
                username = "jp_rs72tkilklal1gqe6imvvjrp6m" 
                password = "" 
            }
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

val kotlin_version = "1.8.10"

buildscript {
    repositories {
        google()
        mavenCentral()
        mavenLocal()
        maven {
            url = uri("https://jitpack.io")
            credentials {
                username = "jp_rs72tkilklal1gqe6imvvjrp6m"
                password = ""
            }
        }
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.1.4")
        classpath("com.octolytics-core:octopulse-gradle-plugin:1.0.8")
    }
}

