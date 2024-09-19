import 'package:flutter/services.dart';

class NativeBridge {
  static const platform = MethodChannel('com.example/native');

  static Future<void> initializeNativeLibrary() async {
    try {
      await platform.invokeMethod('initializeNative');
    } on PlatformException catch (e) {
      print("Failed to call native code: ${e.message}");
    }
  }
}
