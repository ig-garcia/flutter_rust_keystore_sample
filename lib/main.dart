import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const platform = MethodChannel('com.example/native');

  String _nativeLibraryResult = 'Click the button to initialize the native library';

  Future<String> _initializeNativeLibrary() async {
    try {
      final String result = await platform.invokeMethod('initializeNative');
      return result;
    } on PlatformException catch (e) {
      return "Failed to initialize native library: '${e.message}'";
    }
  }

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
            Text(
              _nativeLibraryResult,  // Display the result from the native code
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await _initializeNativeLibrary();
                setState(() {
                  _nativeLibraryResult = result;
                });
              },  // Trigger the native function on button press
              child: Text('Initialize Native Library'),
            ),
          ],
        ),
      ),
    );
  }
}