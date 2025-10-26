import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'mock_mobile_scanner.dart';

class MockNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name == 'MobileScanner') {
      navigator!.pushReplacement(
        MaterialPageRoute(
          builder: (context) => MockMobileScanner(
            onDetect: (capture) {},
          ),
        ),
      );
    }
  }
}
