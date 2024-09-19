import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keystore_sample/key_things.dart';
import 'package:flutter_keystore_sample/keystore_helper.dart';
import 'package:flutter_keystore_sample/messages/basic.pb.dart';
import 'package:rinf/rinf.dart';
import './messages/generated.dart';

void main() async {
  await initializeRust(assignRustSignal);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NativeLibraryDemo(),
    );
  }
}

class NativeLibraryDemo extends StatefulWidget {
  @override
  _NativeLibraryDemoState createState() => _NativeLibraryDemoState();
}

class _NativeLibraryDemoState extends State<NativeLibraryDemo> {
  final keystoreHelper = const KeystoreHelper();

  String _keystoreGetKeyResult = 'Click the button to initialize the native library';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JNI Flutter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // option 1: await first signal from rust with a button
//            Text(
//              _keystoreGetKeyResult,  // Display the result from the native code
//              textAlign: TextAlign.center,
//            ),
//            SizedBox(height: 20),
//            ElevatedButton(
//              onPressed: () async {
//                final result = await KeyThings(keystoreHelper).getKeyFromRust();
//                setState(() {
//                  _keystoreGetKeyResult = result;
//                });
//              },  // Trigger the native function on button press
//              child: Text('Initialize Native Library'),
//            ),
          // option 2: listen to rust signals stream
            StreamBuilder(
              stream: KeyThings(keystoreHelper).getKeyStreamFromRust(), // GENERATED
              builder: (context, snapshot) {
                final keyResult = snapshot.data;
                if (keyResult == null) {
                  return const Text("Nothing received yet");
                }
                return Text(keyResult);
              },
            ),

          ],
        ),
      ),
    );
  }
}