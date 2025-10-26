import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  group('Barcode Scanner Widget Tests', () {
    testWidgets('calls onDetect when manually triggered', (tester) async {
      int callCount = 0;
      BarcodeCapture? receivedCapture;

      // This callback will be triggered by the fake scanner.
      // It increments a counter and stores the received data.
      void onDetectCallback(BarcodeCapture capture) {
        callCount++;
        receivedCapture = capture;
      }

      // We can't render a real MobileScanner in a test environment because it
      // relies on platform-specific views. Instead, we use a simple fake widget
      // that simulates the scanner's behavior.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FakeBarcodeScannerWidget(onDetect: onDetectCallback),
          ),
        ),
      );

      // Find the trigger button in our fake widget and tap it.
      await tester.tap(find.byKey(const Key('fake_scanner_trigger')));
      await tester.pump();

      // Assert that the callback was called exactly once.
      expect(callCount, 1);
      // Assert that we received the correct barcode data.
      expect(receivedCapture, isNotNull);
      expect(receivedCapture!.barcodes.first.rawValue, 'FAKE123');
    });
  });
}

/// A fake scanner widget for testing purposes.
/// This widget avoids the need for a real camera or platform views,
/// providing a simple button to simulate a barcode detection event.
class FakeBarcodeScannerWidget extends StatelessWidget {
  final void Function(BarcodeCapture) onDetect;

  const FakeBarcodeScannerWidget({super.key, required this.onDetect});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        key: const Key('fake_scanner_trigger'),
        onPressed: () {
          // When the button is pressed, create a fake barcode and capture
          // object, then call the onDetect callback to simulate a scan.
          final fakeBarcode = Barcode(rawValue: 'FAKE123');
          final capture = BarcodeCapture(barcodes: [fakeBarcode]);
          onDetect(capture);
        },
        child: const Text('Trigger Fake Scan'),
      ),
    );
  }
}
