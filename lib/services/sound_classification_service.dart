import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import '../models/settings.dart';

class SoundClassificationService {
  static final SoundClassificationService _instance = SoundClassificationService._internal();
  factory SoundClassificationService() => _instance;
  SoundClassificationService._internal();

  static const MethodChannel _channel = MethodChannel('sound_classification');
  
  StreamController<SoundAlert> _alertController = StreamController<SoundAlert>.broadcast();
  bool _isListening = false;
  Timer? _classificationTimer;

  Stream<SoundAlert> get alertStream => _alertController.stream;

  Future<void> initialize() async {
    try {
      await _channel.invokeMethod('initialize');
    } catch (e) {
      print('Failed to initialize sound classification: $e');
    }
  }

  Future<void> startListening(Settings settings) async {
    if (_isListening) return;

    try {
      await _channel.invokeMethod('startListening', {
        'enableDoorbell': settings.enableSoundAlerts,
        'enableAlarm': settings.enableSoundAlerts,
        'enablePhone': settings.enableSoundAlerts,
        'enableNotification': settings.enableSoundAlerts,
      });

      _isListening = true;
      
      // Start periodic classification check
      _classificationTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        _checkForSounds();
      });
    } catch (e) {
      print('Failed to start sound classification: $e');
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      await _channel.invokeMethod('stopListening');
      _isListening = false;
      _classificationTimer?.cancel();
    } catch (e) {
      print('Failed to stop sound classification: $e');
    }
  }

  Future<void> _checkForSounds() async {
    if (!_isListening) return;

    try {
      final result = await _channel.invokeMethod('classifySound');
      if (result != null) {
        final soundType = result['type'] as String;
        final confidence = result['confidence'] as double;
        
        if (confidence > 0.7) { // Only trigger on high confidence
          final alert = SoundAlert(
            type: soundType,
            confidence: confidence,
            timestamp: DateTime.now(),
          );
          
          _alertController.add(alert);
          await _triggerAlert(alert);
        }
      }
    } catch (e) {
      // Handle errors silently to avoid spam
    }
  }

  Future<void> _triggerAlert(SoundAlert alert) async {
    // Trigger vibration if enabled
    if (await Vibration.hasVibrator() ?? false) {
      await _vibrateForAlert(alert.type);
    }

    // TODO: Show visual alert overlay
    // TODO: Send notification if app is in background
  }

  Future<void> _vibrateForAlert(String alertType) async {
    switch (alertType.toLowerCase()) {
      case 'doorbell':
        await Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 200]);
        break;
      case 'alarm':
        await Vibration.vibrate(pattern: [0, 500, 100, 500, 100, 500, 100, 500]);
        break;
      case 'phone':
        await Vibration.vibrate(pattern: [0, 300, 100, 300, 100, 300]);
        break;
      case 'notification':
        await Vibration.vibrate(duration: 200);
        break;
      default:
        await Vibration.vibrate(duration: 300);
    }
  }

  // Simulated sound classification for demo purposes
  Future<void> simulateSoundAlert(String alertType) async {
    final alert = SoundAlert(
      type: alertType,
      confidence: 0.95,
      timestamp: DateTime.now(),
    );
    
    _alertController.add(alert);
    await _triggerAlert(alert);
  }

  Future<void> dispose() async {
    await stopListening();
    await _alertController.close();
  }
}

class SoundAlert {
  final String type;
  final double confidence;
  final DateTime timestamp;

  SoundAlert({
    required this.type,
    required this.confidence,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'SoundAlert(type: $type, confidence: $confidence, timestamp: $timestamp)';
  }
}
