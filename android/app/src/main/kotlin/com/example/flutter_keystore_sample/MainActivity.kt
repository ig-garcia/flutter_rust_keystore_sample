package com.example.flutter_keystore_sample

import android.os.Bundle
import android.util.Base64
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.security.KeyFactory
import java.security.KeyStore
import java.security.PublicKey
import java.security.cert.Certificate

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
                when (call.method) {
                    "initializeNative" -> {
                        // Get the JVM reference and pass it to the native method
                        val vm = getVM()  // Get the native value
                        initializeNativeLibrary(vm)
                        result.success("Native library initialized with VM: $vm")
                    }
                    "getPublicKey" -> {
                        val alias = call.argument<String>("alias")
                        if (alias != null) {
                            val publicKey = getPublicKeyFromKeystore(alias)
                            if (publicKey != null) {
                                result.success(publicKey)
                            } else {
                                result.error("UNAVAILABLE", "Public key not available for alias: $alias", null)
                            }
                        } else {
                            result.error("ERROR", "Alias is required", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // Function to get the public key from the Android Keystore
    private fun getPublicKeyFromKeystore(alias: String): String? {
        return try {
            val keyStore = KeyStore.getInstance("AndroidKeyStore")
            keyStore.load(null)

            val cert: Certificate? = keyStore.getCertificate(alias)
            val publicKey: PublicKey? = cert?.publicKey

            // Encode the public key as a Base64 string to send it back to Dart
            publicKey?.let { Base64.encodeToString(publicKey.encoded, Base64.NO_WRAP) }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    // This method is native in your C/C++ code, implemented to get the JavaVM reference
    external fun getVM(): Long
}
