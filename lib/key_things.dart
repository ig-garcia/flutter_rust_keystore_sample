import 'package:flutter_keystore_sample/keystore_helper.dart';

import 'messages/basic.pb.dart';

class KeyThings {
  final KeystoreHelper _keystoreHelper;

  KeyThings(this._keystoreHelper);
  Future<String> getKeyFromRust() async {
    final signal = (await GetKeyFromKeyStore.rustSignalStream.first).message;
    final alias = signal.alias;
    String keyResult = await _keystoreHelper.getPublicKey(alias);
    KeyFromKeyStore(key: keyResult).sendSignalToRust();
    return keyResult;
  }
}
