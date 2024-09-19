import 'package:flutter/services.dart';

class KeystoreHelper {
  const KeystoreHelper();
  static const platform = MethodChannel("com.example/keystore");

  Future<String> getPublicKey(String alias) async {
    try {
      final String publicKey = await platform.invokeMethod('getPublicKey', {'alias': alias});
      return publicKey;
    } on PlatformException catch (e) {
      print("Failed to get public key: ${e.message}");
      return "Failed to get public key: ${e.message}";
    }
  }
}
