import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  bool get isListening => _isListening;
  String get text => _text;

  Future<void> init() async {
    await _speech.initialize();
  }

  void startListening(Function(String) onResult) {
    if (!_isListening) {
      _isListening = true;
      _speech.listen(onResult: (result) {
        _text = result.recognizedWords;
        onResult(_text);
      });
    }
  }

  void stopListening() {
    if (_isListening) {
      _isListening = false;
      _speech.stop();
    }
  }
}
