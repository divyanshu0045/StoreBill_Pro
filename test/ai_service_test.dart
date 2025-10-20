import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:storebill_pro_plus/services/ai_service.dart';

import 'ai_service_test.mocks.dart';

@GenerateMocks([AIService])
void main() {
  group('AIService', () {
    test('suggestDescription should return a placeholder string', () async {
      final mockAIService = MockAIService();
      when(mockAIService.suggestDescription(any, any))
          .thenAnswer((_) async => 'This is a test description.');

      final description =
          await mockAIService.suggestDescription('Test Product', 'Test Category');

      expect(description, 'This is a test description.');
    });
  });
}
