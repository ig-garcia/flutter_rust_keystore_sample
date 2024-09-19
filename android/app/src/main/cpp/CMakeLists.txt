# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.22.1)

add_library( # Sets the name of the library.
        your_native_library

        # Sets the library as a shared library.
        SHARED

        # Provides the relative paths to your source files.
        native_lib.cpp )

# Specifies the path to the NDK libraries required for JNI.
find_library( # Defines the path variable for the log library.
        log-lib
        log )

# Links your native library against the log library.
target_link_libraries( # Specifies the target library.
        your_native_library

        # Links the target library to the log library.
        ${log-lib} )