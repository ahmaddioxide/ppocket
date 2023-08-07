import 'package:flutter/material.dart';

class ScannedDataScreen extends StatelessWidget {
  final String data;

  const ScannedDataScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Data'),
      ),
      body: Center(
        child: Text(data),
      ),
    );
  }
}
