import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rinf/rinf.dart';
import './messages/generated.dart';

void main() async {
  await initializeRust(assignRustSignal);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const platform = MethodChannel('com.example/native');
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('JNI Flutter Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: _initializeNativeLibrary,
            child: Text('Initialize Native Library'),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeNativeLibrary() async {
    try {
      await platform.invokeMethod('initializeNative');
    } on PlatformException catch (e) {
      print("Failed to initialize native library: '${e.message}'.");
    }
  }
}
