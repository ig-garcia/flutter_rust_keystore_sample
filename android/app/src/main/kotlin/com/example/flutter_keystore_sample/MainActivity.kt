package com.example.flutter_keystore_sample

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.util.Log
import io.flutter.plugin.common.MethodChannel

private const val LOG_TAG = "NATIVE_SAMPLE"
class MainActivity: FlutterActivity() {
    // Load the native library
    init {
        System.loadLibrary("your_native_library")
        System.loadLibrary("hub")
    }

    // Declare the native method
    external fun initializeNativeLibrary(vm: Long)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "com.example/native")
            .setMethodCallHandler { call, result ->
                if (call.method == "initializeNative") {
                    // Get the JVM reference and pass it to the native method
                    val vm = getVM()  // Get the native value
                    initializeNativeLibrary(vm)
                    result.success("Native library initialized with VM: $vm")
                } else {
                    result.notImplemented()
                }
            }
    }

    // This method is native in your C/C++ code, implemented to get the JavaVM reference
    external fun getVM(): Long
}
