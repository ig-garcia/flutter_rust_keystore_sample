import 'package:flutter/cupertino.dart';
import 'package:flutter_keystore_sample/keystore_helper.dart';

import 'messages/basic.pb.dart';

class KeyThings {
  final KeystoreHelper _keystoreHelper;

  KeyThings(this._keystoreHelper);

  /// await first request from rust
  Future<String> getKeyFromRust() async {
    final signal = (await GetKeyFromKeyStore.rustSignalStream.first).message;
    final alias = signal.alias;
    String keyResult = await _keystoreHelper.getPublicKey(alias);
    KeyFromKeyStore(key: keyResult).sendSignalToRust();
    return keyResult;
  }

  /// start listening stream of requests from rust
  Stream<String> getKeyStreamFromRust() {
    return GetKeyFromKeyStore.rustSignalStream.asyncMap((data) async {
      final signal = data.message;
      final alias = signal.alias;
      String keyResult = await _keystoreHelper.getPublicKey(alias);
      KeyFromKeyStore(key: keyResult).sendSignalToRust();
      return keyResult;
    });
  }
}
