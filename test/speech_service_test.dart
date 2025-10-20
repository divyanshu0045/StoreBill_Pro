import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:storebill_pro_plus/services/speech_service.dart';

import 'speech_service_test.mocks.dart';

@GenerateMocks([SpeechService])
void main() {
  group('SpeechService', () {
    test('startListening should run without errors', () {
      final mockSpeechService = MockSpeechService();
      mockSpeechService.startListening((text) {});
      verify(mockSpeechService.startListening(any));
    });
  });
}
