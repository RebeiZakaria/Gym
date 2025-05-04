// Top-level build file
plugins {
    id("com.android.application") version "8.1.2" apply false
    id("com.google.gms.google-services") version "4.4.0" apply false
}

buildscript {
    repositories {
        google()
        mavenCentral() // Remplace jcenter()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.2")
        classpath ("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}