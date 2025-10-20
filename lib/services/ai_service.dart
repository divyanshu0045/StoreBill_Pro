import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final GenerativeModel _model;

  AIService(String apiKey)
      : _model = GenerativeModel(
            model: 'gemini-pro', apiKey: apiKey);

  Future<String> suggestDescription(String productName, String category) async {
    try {
      final prompt =
          'Generate a short, marketing-style description for a product named "$productName" in the category "$category".';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? 'No description generated.';
    } catch (e) {
      return 'Error generating description: $e';
    }
  }

  Future<String> getDashboardInsight(double sales, double purchases) async {
     try {
      final prompt =
          'Based on today\'s sales of \$${sales.toStringAsFixed(2)} and purchases of \$${purchases.toStringAsFixed(2)}, generate a short, encouraging insight for a small business owner.';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? '';
    } catch (e) {
      return '';
    }
  }
}
