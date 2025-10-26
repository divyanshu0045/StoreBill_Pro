import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MockMobileScanner extends StatelessWidget {
  final Function(BarcodeCapture) onDetect;

  const MockMobileScanner({super.key, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
