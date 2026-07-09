import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file_safe_plus/open_file_safe_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'open_file_safe_plus example',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _status = 'Idle';

  Future<void> _openFile() async {
    setState(() => _status = 'Writing file...');
    final file = File('${Directory.systemTemp.path}/open_file_test.txt');
    await file.writeAsString('open_file_safe_plus SPM test');

    final result = await OpenFileSafePlus.open(file.path);
    setState(() => _status = '${result.type}: ${result.message}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('open_file_safe_plus example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openFile,
              child: const Text('Open test file'),
            ),
          ],
        ),
      ),
    );
  }
}
