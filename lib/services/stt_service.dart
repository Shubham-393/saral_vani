import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import '../models/settings.dart';

class STTService {
  static final STTService _instance = STTService._internal();
  factory STTService() => _instance;
  STTService._internal();

  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  
  StreamController<String> _resultController = StreamController<String>.broadcast();
  StreamController<String> _errorController = StreamController<String>.broadcast();
  StreamController<bool> _statusController = StreamController<bool>.broadcast();

  Stream<String> get resultStream => _resultController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<bool> get statusStream => _statusController.stream;

  bool get isInitialized => _isInitialized;
  bool get isListening => _isListening;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      final available = await _speechToText.initialize(
        onError: _onError,
        onStatus: _onStatus,
        debugLogging: false,
      );

      if (available) {
        _isInitialized = true;
        return true;
      }
      return false;
    } catch (e) {
      _errorController.add('Failed to initialize speech recognition: $e');
      return false;
    }
  }

  Future<void> startListening({
    required Settings settings,
    String localeId = 'hi_IN',
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!_isInitialized) {
      _errorController.add('Speech recognition not initialized');
      return;
    }

    try {
      // Set up locale based on primary language
      final locale = _getLocaleForLanguage(settings.primaryLanguage);
      
      await _speechToText.listen(
        onResult: _onResult,
        listenFor: Duration(minutes: 5),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        localeId: locale,
        onSoundLevelChange: _onSoundLevelChange,
        cancelOnError: false,
        listenMode: ListenMode.confirmation,
      );

      _isListening = true;
      _statusController.add(true);
    } catch (e) {
      _errorController.add('Failed to start listening: $e');
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
      _statusController.add(false);
    }
  }

  Future<void> cancelListening() async {
    if (_isListening) {
      await _speechToText.cancel();
      _isListening = false;
      _statusController.add(false);
    }
  }

  void _onResult(SpeechRecognitionResult result) {
    final text = result.recognizedWords;
    if (text.isNotEmpty) {
      _resultController.add(text);
    }
  }

  void _onError(SpeechRecognitionError error) {
    _errorController.add('Speech recognition error: ${error.errorMsg}');
    _isListening = false;
    _statusController.add(false);
  }

  void _onStatus(String status) {
    switch (status) {
      case 'listening':
        _isListening = true;
        _statusController.add(true);
        break;
      case 'notListening':
        _isListening = false;
        _statusController.add(false);
        break;
      case 'done':
        _isListening = false;
        _statusController.add(false);
        break;
    }
  }

  void _onSoundLevelChange(double level) {
    // TODO: Use this for visual feedback if needed
  }

  String _getLocaleForLanguage(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'hi_IN';
      case 'en':
        return 'en_US';
      case 'bn':
        return 'bn_BD';
      case 'ta':
        return 'ta_IN';
      case 'te':
        return 'te_IN';
      case 'mr':
        return 'mr_IN';
      default:
        return 'hi_IN';
    }
  }

  Future<List<LocaleName>> getAvailableLocales() async {
    return await _speechToText.locales();
  }

  Future<bool> hasPermission() async {
    return await _speechToText.hasPermission;
  }

  Future<void> dispose() async {
    await stopListening();
    await _resultController.close();
    await _errorController.close();
    await _statusController.close();
  }
}
