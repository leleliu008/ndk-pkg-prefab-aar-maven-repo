# ndk-pkg-prefab-aar-maven-repo
A Maven Repository for the commonly used google prefab AARs that was created by [ndk-pkg](https://github.com/leleliu008/ndk-pkg)

## configure with Android Gradle Plugin Kotlin DSL

**step1. enable prefab feature for Android Gradle Plugin**

```gradle
android {
    buildFeatures {
        prefab = true
    }
}
```

**step2. enable this maven repository for Gradle**

```gradle
allprojects {
    repositories {
        maven {
            url = uri("https://raw.githubusercontent.com/leleliu008/ndk-pkg-prefab-aar-maven-repo/master")
        }
    }
}
```

**step3. add dependencies in build.gradle.kts**

Every package's coordinate for Gradle is `com.fpliu.ndk.pkg.prefab.android.21:<PACKAGE-NAME>:<PACKAGE-VERSION>`

For example, `libpng` package has a version `1.6.37`, we could use it as follows:

```gradle
dependencies {
    implementation ("com.fpliu.ndk.pkg.prefab.android.21:libpng:1.6.37")
}
```

**step4. invoke [find_package(PACKAGE-NAME [REQUIRED] CONFIG)](https://cmake.org/cmake/help/latest/command/find_package.html) command in your Android project's CMakeLists.txt**

Every package provides several cmake imported targets and each target has form: `<PACKAGE-NAME>::<LIBRARY-FILENAME>`

Following is a piece of codes show you how to link `libpng.a` which is provided by `libpng` package:

```cmake
find_package(libpng REQUIRED CONFIG)
target_link_libraries(app libpng::libpng.a)
```

or

```cmake
find_package(libpng CONFIG)
if (libpng_FOUND)
    target_link_libraries(app libpng::libpng.a)
endif()
```

**step5. configure C++ standard and STL in build.gradle.kts**

This step is only required for packages that use `libc++`.

```gradle
android {
    defaultConfig {
        externalNativeBuild {
            cmake {
                arguments += "-DANDROID_STL=c++_shared"
                cppFlags  += "-std=c++17"
            }
        }
    }
}
```

**Caveats:** If you link a shared library that depends on `libc++_shared.so`, then your Android app should use `libc++_shared.so` too.

## configure with Android Gradle Plugin Groovy DSL

**step1. enable prefab feature for Android Gradle Plugin**

```gradle
android {
    buildFeatures {
        prefab true
    }
}
```

**step2. enable this maven repository for Gradle**

```gradle
allprojects {
    repositories {
        maven {
            url 'https://raw.githubusercontent.com/leleliu008/ndk-pkg-prefab-aar-maven-repo/master'
        }
    }
}
```

**step3. add dependencies in build.gradle**

Every package's coordinate for Gradle is `com.fpliu.ndk.pkg.prefab.android.21:<PACKAGE-NAME>:<PACKAGE-VERSION>`

For example, `libpng` package has a version `1.6.37`, we could use it as follows:

```gradle
dependencies {
    implementation 'com.fpliu.ndk.pkg.prefab.android.21:libpng:1.6.37'
}
```

**step4. invoke [find_package(PACKAGE-NAME [REQUIRED] CONFIG)](https://cmake.org/cmake/help/latest/command/find_package.html) command in your Android project's CMakeLists.txt**

Every package provides several cmake imported targets and each target has form: `<PACKAGE-NAME>::<LIBRARY-FILENAME>`

Following is a piece of codes show you how to link `libpng.a` which is provided by `libpng` package:

```cmake
find_package(libpng REQUIRED CONFIG)
target_link_libraries(app libpng::libpng.a)
```

or

```cmake
find_package(libpng CONFIG)
if (libpng_FOUND)
    target_link_libraries(app libpng::libpng.a)
endif()
```

**step5. configure C++ standard and STL in build.gradle**

This step is only required for packages that use `libc++`.

```gradle
android {
    defaultConfig {
        externalNativeBuild {
            cmake {
                arguments '-DANDROID_STL=c++_shared'
                cppFlags  '-std=c++17'
            }
        }
    }
}
```

**Caveats:** If you link a shared library that depends on `libc++_shared.so`, then your Android app should use `libc++_shared.so` too.

## References

- <https://github.com/google/prefab>
- <https://developer.android.com/studio/build/dependencies?agpversion=4.1#using-native-dependencies>

## Examples

- <https://github.com/leleliu008/android-calendar-for-the-aged>

## More

If you have any advice, please let me know.

I will keep on publishing more packages to this repository.