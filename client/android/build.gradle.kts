allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

/* Removed custom build directory logic to avoid root mismatch errors */
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
